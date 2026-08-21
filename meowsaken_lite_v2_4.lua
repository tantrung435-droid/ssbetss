--[[
    Meowsaken Lite — Production Build v2.4
    Fixes:
    - CRITICAL: Combat._maids weak table — cleanup tất cả Maid khi Unload
    - MEDIUM: Hub:Init retry giới hạn 5 lần, tránh thread leak
    - LOW: Thay "continue" bằng if-then lồng nhau (Lua 5.1 compat)
    - HIGH: KillerCache:IsValid explicit nil-check
    - Defensive: pcall + nil-guard toàn script
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local CollectionService = game:GetService("CollectionService")

local localPlayer = Players.LocalPlayer

-- ============================================================
-- MAID PATTERN
-- ============================================================
local Maid = {}
Maid.__index = Maid

function Maid.new()
    return setmetatable({ _tasks = {} }, Maid)
end

function Maid:Give(task)
    table.insert(self._tasks, task)
    return task
end

function Maid:Clean()
    for _, task in ipairs(self._tasks) do
        if typeof(task) == "RBXScriptConnection" then
            task:Disconnect()
        elseif typeof(task) == "Instance" then
            task:Destroy()
        elseif typeof(task) == "function" then
            task()
        elseif typeof(task) == "table" and task.Destroy then
            task:Destroy()
        elseif typeof(task) == "thread" then
            pcall(task.cancel, task)
        end
    end
    table.clear(self._tasks)
end

function Maid:Destroy()
    self:Clean()
end

-- ============================================================
-- KILLER CACHE
-- ============================================================
local KillerCache = {}
KillerCache.__index = KillerCache

function KillerCache.new(folder)
    if not folder or not folder.IsA or not folder:IsA("Folder") then
        warn("[KillerCache] Invalid folder")
        return nil
    end

    local self = setmetatable({}, KillerCache)
    self._folder = folder
    self._map = {}
    self._maid = Maid.new()

    local ok, children = pcall(folder.GetChildren, folder)
    if ok and children then
        for _, child in ipairs(children) do
            if child and child:IsA("Model") then
                self._map[child] = true
            end
        end
    end

    self._maid:Give(folder.ChildAdded:Connect(function(child)
        if child and child:IsA("Model") then
            self._map[child] = true
        end
    end))

    self._maid:Give(folder.ChildRemoving:Connect(function(child)
        self._map[child] = nil
    end))

    self._maid:Give(folder.Destroying:Connect(function()
        self:Destroy()
    end))

    return self
end

function KillerCache:Iterate()
    return next, self._map
end

function KillerCache:IsValid()
    return self._folder ~= nil and self._folder.Parent ~= nil
end

function KillerCache:Destroy()
    self._maid:Destroy()
    table.clear(self._map)
    self._folder = nil
end

-- ============================================================
-- CONNECTION MANAGER
-- ============================================================
local ConnMgr = {}
ConnMgr.__index = ConnMgr

function ConnMgr.new()
    return setmetatable({ _handles = {} }, ConnMgr)
end

function ConnMgr:Connect(signal, fn)
    if not signal or not signal.Connect then
        warn("[ConnMgr] Invalid signal")
        return function() end
    end
    local conn = signal:Connect(fn)
    local handle = { Type = "Conn", Value = conn }
    table.insert(self._handles, handle)

    return function()
        conn:Disconnect()
        handle.Value = nil
    end
end

function ConnMgr:Loop(interval, fn, condition)
    local running = true
    local handle = { Type = "Thread" }
    table.insert(self._handles, handle)

    local thread = task.spawn(function()
        while running do
            if condition == nil or condition() then
                local ok, err = pcall(fn)
                if not ok then warn("[Loop Error]", err) end
            end
            task.wait(interval)
        end
    end)

    handle.Value = thread
    return function()
        running = false
        handle.Value = nil
    end
end

function ConnMgr:DisconnectAll()
    for _, h in ipairs(self._handles) do
        if h.Type == "Conn" and h.Value then
            h.Value:Disconnect()
        elseif h.Type == "Thread" and h.Value then
            pcall(task.cancel, h.Value)
        end
    end
    table.clear(self._handles)
end

-- ============================================================
-- UTILITIES
-- ============================================================
local Utils = {}

function Utils.WaitForPath(parent, ...)
    if not parent or not parent.IsA then return nil end
    local args = { ... }
    local opts = {}
    if type(args[#args]) == "table" then
        opts = table.remove(args)
    end
    local timeout = opts.timeout or 10
    local useWait = opts.wait ~= false
    local current = parent

    for _, name in ipairs(args) do
        if not current then return nil end
        if useWait then
            current = current:WaitForChild(name, timeout)
        else
            current = current:FindFirstChild(name)
        end
        if not current then return nil end
    end
    return current
end

function Utils.GetCharacterRoot(char)
    if not char or not char.IsA then return nil end
    return char:FindFirstChild("HumanoidRootPart")
        or char:FindFirstChild("Torso")
        or char:FindFirstChild("UpperTorso")
        or char:FindFirstChildWhichIsA("BasePart")
end

-- ============================================================
-- NETWORK
-- ============================================================
local Network = {
    _remote = nil,
    _remoteReady = false,
    MAX_RETRIES = 3,
}

function Network:GetRemote()
    if self._remoteReady and self._remote and self._remote.Parent then
        return self._remote
    end

    local ok, remote = pcall(Utils.WaitForPath,
        ReplicatedStorage,
        "Modules", "Network", "Network", "RemoteEvent",
        { timeout = 10, wait = true }
    )

    if ok and remote and remote:IsA("RemoteEvent") and remote.Parent then
        self._remote = remote
        self._remoteReady = true
        return remote
    end

    self._remoteReady = false
    self._remote = nil
    return nil
end

function Network:FireAbility(actionName)
    if type(actionName) ~= "string" or #actionName == 0 then
        warn("[Network] Invalid actionName")
        return false
    end

    for attempt = 1, self.MAX_RETRIES do
        local ok, result = pcall(function()
            local remote = self:GetRemote()
            if not remote then error("RemoteEvent unavailable") end

            local len = #actionName
            local buf = buffer.create(5 + len)
            buffer.writeu8(buf, 0, 3)
            buffer.writeu8(buf, 1, 5)
            buffer.writeu8(buf, 2, 0)
            buffer.writeu8(buf, 3, 0)
            buffer.writeu8(buf, 4, 0)

            for i = 1, len do
                buffer.writeu8(buf, 4 + i, string.byte(actionName, i))
            end

            remote:FireServer("UseActorAbility", { buf })
            return true
        end)

        if ok then
            return true
        else
            warn(string.format("[Network] FireAbility failed (%d/%d): %s", attempt, self.MAX_RETRIES, tostring(result)))
            if attempt < self.MAX_RETRIES then
                self._remoteReady = false
                task.wait(0.5)
            end
        end
    end
    return false
end

-- ============================================================
-- STATE & CONFIG
-- ============================================================
local State = {
    toggleOn = false,
    detectionRange = 18,
    blockDelay = 0,
    wallCheck = false,
    facingCheck = true,
    customFacingDot = -0.3,
    htdEnabled = false,
    htdSpeed = 5.6,
    htdDelay = 0,
    antiFlick = true,
}

local CONFIG = {
    HTD = { detectRadius = 15, dragDuration = 0.4 },
    BLOCK_COOLDOWN = 0.25,
    TRUSTED_ANIMS = {
        ["114506382930939"] = true, ["127245564598429"] = true, ["99829427721752"] = true,
        ["138938529389204"] = true, ["111647315359080"] = true, ["92567970681901"] = true,
        ["124269076578545"] = true, ["94958041603347"] = true, ["109667959938617"] = true,
        ["130958529065375"] = true, ["118298475669935"] = true, ["126830014841198"] = true,
        ["126355327951215"] = true, ["121086746534252"] = true, ["18885909645"] = true,
        ["98456918873918"] = true, ["105458270463374"] = true, ["83829782357897"] = true,
        ["125403313786645"] = true, ["82113744478546"] = true, ["70371667919898"] = true,
        ["99135633258223"] = true, ["7167027849946"] = true, ["109230267448394"] = true,
        ["139835501033932"] = true, ["126996426760253"] = true, ["88451353906104"] = true,
        ["106538427162796"] = true, ["122709416391891"] = true, ["139309647473555"] = true,
        ["90620531468240"] = true, ["91509234639766"] = true, ["99824350842479"] = true,
        ["126171487400618"] = true, ["101101433684051"] = true, ["106860049270347"] = true,
        ["70483423693126"] = true, ["126727756047566"] = true, ["137642639873297"] = true,
        ["77375846492436"] = true, ["126681776859538"] = true, ["129976080405072"] = true,
        ["121293883585738"] = true, ["81639435858902"] = true, ["137314737492715"] = true,
        ["92173139187970"] = true, ["108196996477620"] = true, ["90819435118493"] = true,
        ["123172382755876"] = true
    },
    BLOCK_ANIMS = {
        ["72722244508749"] = true,
        ["96959123077498"] = true,
        ["95802026624883"] = true,
    }
}

-- ============================================================
-- COMBAT SYSTEM — Auto Block (Event + Fallback Poll)
-- ============================================================
local Combat = {}
Combat._lastBlock = 0
Combat._setupTags = setmetatable({}, { __mode = "k" })
Combat._maids = setmetatable({}, { __mode = "k" }) -- WEAK TABLE: track Maid per humanoid

function Combat:IsFacingMe(targetRoot, myRoot)
    if not State.facingCheck then return true end
    if not targetRoot or not myRoot then return false end
    local targetLook = targetRoot.CFrame.LookVector
    local dirToMe = (myRoot.Position - targetRoot.Position).Unit
    return targetLook:Dot(dirToMe) >= State.customFacingDot
end

function Combat:CheckWall(targetRoot)
    if not State.wallCheck then return true end
    local char = localPlayer.Character
    local hrp = Utils.GetCharacterRoot(char)
    if not hrp or not targetRoot then return false end

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { char, targetRoot.Parent }
    params.IgnoreWater = true

    local ok, result = pcall(Workspace.Raycast, Workspace, hrp.Position, targetRoot.Position - hrp.Position, params)
    return ok and result == nil
end

function Combat:IsAttackAnimation(anim, track)
    if not anim or not anim.AnimationId then return false end
    local id = string.match(anim.AnimationId, "%d+")
    local animName = anim.Name:lower()

    local isAttack = CONFIG.TRUSTED_ANIMS[id]
        or animName:find("slash")
        or animName:find("attack")
        or animName:find("swing")

    if not isAttack then
        local len = track and track.Length
        if len and len >= 0.3 and len <= 3 and animName:find("hit") then
            isAttack = true
        end
    end

    return isAttack
end

function Combat:TryBlock(targetRoot)
    local myChar = localPlayer.Character
    local myRoot = Utils.GetCharacterRoot(myChar)
    if not myRoot then return end

    local dist = (targetRoot.Position - myRoot.Position).Magnitude
    if dist > State.detectionRange then return end
    if not self:CheckWall(targetRoot) then return end
    if not self:IsFacingMe(targetRoot, myRoot) then return end

    local now = tick()
    if now - self._lastBlock < CONFIG.BLOCK_COOLDOWN then return end
    self._lastBlock = now

    task.spawn(function()
        if State.blockDelay > 0 then
            task.wait(State.blockDelay)
            if not State.toggleOn then return end
        end
        Network:FireAbility("Block")
    end)
end

function Combat:SetupPredictiveBlock(humanoid, targetRoot)
    if not humanoid or not humanoid.IsA or not humanoid:IsA("Humanoid") then return end
    if self._setupTags[humanoid] then return end
    self._setupTags[humanoid] = true

    local maid = Maid.new()
    self._maids[humanoid] = maid -- Lưu vào weak table

    maid:Give(humanoid.Destroying:Connect(function()
        maid:Destroy()
        self._setupTags[humanoid] = nil
        self._maids[humanoid] = nil
    end))

    maid:Give(humanoid.AnimationPlayed:Connect(function(track)
        if not State.toggleOn then return end
        if not track or not track.Animation then return end
        if self:IsAttackAnimation(track.Animation, track) then
            self:TryBlock(targetRoot)
        end
    end))
end

function Combat:Update(killerCache)
    if not killerCache or not killerCache:IsValid() then return end
    if not State.toggleOn then return end

    local myChar = localPlayer.Character
    local myRoot = Utils.GetCharacterRoot(myChar)
    if not myRoot then return end

    for killer in killerCache:Iterate() do
        if killer and killer.Parent then
            local root = killer:FindFirstChild("HumanoidRootPart")
            local humanoid = killer:FindFirstChildOfClass("Humanoid")
            if root and humanoid then
                self:SetupPredictiveBlock(humanoid, root)
            end
        end
    end
end

--[[
    FALLBACK POLL: 10Hz — quét Animator của killer.
    Chỉ dùng TRUSTED_ANIMS + pattern tên (KHÔNG dùng BLOCK_ANIMS).
    Chỉ trigger ở đầu animation (TimePosition <= 0.15).
]]
function Combat:PollKillers(killerCache)
    if not killerCache or not killerCache:IsValid() then return end
    if not State.toggleOn then return end

    local myChar = localPlayer.Character
    local myRoot = Utils.GetCharacterRoot(myChar)
    if not myRoot then return end

    for killer in killerCache:Iterate() do
        if not killer or not killer.Parent then
            -- skip
        else
            local root = killer:FindFirstChild("HumanoidRootPart")
            local humanoid = killer:FindFirstChildOfClass("Humanoid")
            if root and humanoid then
                local animator = humanoid:FindFirstChildOfClass("Animator")
                if animator then
                    local ok, tracks = pcall(animator.GetPlayingAnimationTracks, animator)
                    if ok and tracks then
                        for i = 1, #tracks do
                            local track = tracks[i]
                            if track and track.Animation and (track.TimePosition or math.huge) <= 0.15 then
                                if self:IsAttackAnimation(track.Animation, track) then
                                    self:TryBlock(root)
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

-- ============================================================
-- HTD SYSTEM
-- ============================================================
local HTD = {}
HTD._dragMaid = Maid.new()
HTD._htdDebounce = 0

function HTD:GetNearestKiller(killerCache, maxRange)
    if not killerCache or not killerCache:IsValid() then return nil end
    local myChar = localPlayer.Character
    local myRoot = Utils.GetCharacterRoot(myChar)
    if not myRoot then return nil end

    local closest, closestDist = nil, maxRange or math.huge
    for killer in killerCache:Iterate() do
        if killer and killer.Parent and killer:IsA("Model") then
            local hrp = killer:FindFirstChild("HumanoidRootPart")
            if hrp then
                local d = (hrp.Position - myRoot.Position).Magnitude
                if d < closestDist then
                    closest, closestDist = killer, d
                end
            end
        end
    end
    return closest
end

function HTD:DragTo(killerModel)
    local now = tick()
    if now - self._htdDebounce < 0.5 then return end
    self._htdDebounce = now

    if not killerModel or not killerModel.Parent then return end

    local char = localPlayer.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid then return end

    local targetHRP = killerModel:FindFirstChild("HumanoidRootPart") or killerModel.PrimaryPart
    if not targetHRP then return end

    self._dragMaid:Clean()

    local oldWalk = humanoid.WalkSpeed
    local oldJump = humanoid.JumpPower
    local oldAutoRotate = humanoid.AutoRotate

    humanoid.WalkSpeed = 0
    humanoid.JumpPower = 0
    humanoid.AutoRotate = false

    local attachment = Instance.new("Attachment")
    attachment.Name = "HTDAtt"
    attachment.Parent = hrp
    self._dragMaid:Give(attachment)

    local linVel = Instance.new("LinearVelocity")
    linVel.Attachment0 = attachment
    linVel.MaxForce = 3e6
    linVel.VectorVelocity = Vector3.zero
    linVel.Parent = hrp
    self._dragMaid:Give(linVel)

    local startTime = tick()
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if tick() - startTime > CONFIG.HTD.dragDuration or not char.Parent or not killerModel.Parent then
            conn:Disconnect()
            self._dragMaid:Clean()
            if humanoid and humanoid.Parent then
                humanoid.WalkSpeed = oldWalk
                humanoid.JumpPower = oldJump
                humanoid.AutoRotate = oldAutoRotate
            end
            return
        end

        targetHRP = killerModel:FindFirstChild("HumanoidRootPart") or killerModel.PrimaryPart
        if not targetHRP then
            conn:Disconnect()
            self._dragMaid:Clean()
            if humanoid and humanoid.Parent then
                humanoid.WalkSpeed = oldWalk
                humanoid.JumpPower = oldJump
                humanoid.AutoRotate = oldAutoRotate
            end
            return
        end

        local toTarget = targetHRP.Position - hrp.Position
        local horiz = Vector3.new(toTarget.X, 0, toTarget.Z)
        if horiz.Magnitude > 2 then
            linVel.VectorVelocity = horiz.Unit * State.htdSpeed
        else
            linVel.VectorVelocity = Vector3.zero
        end
    end)

    self._dragMaid:Give(conn)
end

function HTD:Update(killerCache, cachedAnimator)
    if not State.htdEnabled then return end
    if not cachedAnimator then return end

    local ok, tracks = pcall(cachedAnimator.GetPlayingAnimationTracks, cachedAnimator)
    if not ok or not tracks then return end

    for i = 1, #tracks do
        local track = tracks[i]
        if track and track.Animation then
            local animId = tostring(track.Animation.AnimationId):match("%d+")
            if animId and CONFIG.BLOCK_ANIMS[animId] then
                if (track.TimePosition or 0) <= 0.12 then
                    local nearest = self:GetNearestKiller(killerCache, CONFIG.HTD.detectRadius)
                    if nearest then
                        if State.htdDelay > 0 then
                            task.delay(State.htdDelay, function()
                                self:DragTo(nearest)
                            end)
                        else
                            self:DragTo(nearest)
                        end
                    end
                end
            end
        end
    end
end

function HTD:AntiFlickCheck(killerCache)
    if not (State.htdEnabled and State.antiFlick) then return end
    if not killerCache or not killerCache:IsValid() then return end

    local char = localPlayer.Character
    local myRoot = char and char:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    local shouldTrigger = false

    -- Tối ưu: CollectionService trước
    local ok, zones = pcall(CollectionService.GetTagged, CollectionService, "AntiFlickZone")
    if ok and zones and #zones > 0 then
        for _, zone in ipairs(zones) do
            if zone and zone:IsA("BasePart") and zone.Parent then
                local dist = (zone.Position - myRoot.Position).Magnitude
                if dist <= CONFIG.HTD.detectRadius then
                    shouldTrigger = true
                    break
                end
            end
        end
    end

    -- Fallback: GetPartBoundsInRadius
    if not shouldTrigger then
        local params = OverlapParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = { char }

        local ok2, parts = pcall(Workspace.GetPartBoundsInRadius, Workspace, myRoot.Position, CONFIG.HTD.detectRadius, params)
        if ok2 and parts then
            for i = 1, #parts do
                local part = parts[i]
                if part and part.Name == "AntiFlickZone" then
                    shouldTrigger = true
                    break
                end
            end
        end
    end

    if shouldTrigger then
        local nearest = self:GetNearestKiller(killerCache, CONFIG.HTD.detectRadius)
        if nearest then
            if State.htdDelay > 0 then
                task.delay(State.htdDelay, function()
                    self:DragTo(nearest)
                end)
            else
                self:DragTo(nearest)
            end
        end
    end
end

-- ============================================================
-- UI SETUP — Pcall toàn bộ
-- ============================================================
local function SetupUI()
    local ok, WindUI = pcall(function()
        return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
    end)

    if not ok or not WindUI then
        warn("[UI] Failed to load WindUI:", tostring(WindUI))
        return nil
    end

    local ok2, Window = pcall(function()
        return WindUI:CreateWindow({
            Title = "Meowsaken Lite",
            Icon = "rbxassetid://82521442584643",
            Author = "by doobtwo",
            Folder = "MeowsakenLite.json",
            Size = UDim2.fromOffset(400, 300),
            MinSize = Vector2.new(320, 240),
            MaxSize = Vector2.new(600, 450),
            Transparent = false,
            Theme = "Dark",
            Resizable = true,
            SideBarWidth = 130,
            HideSearchBar = true,
            ScrollBarEnabled = false,
            User = {
                Enabled = true,
                Anonymous = false,
                Name = localPlayer.DisplayName or localPlayer.Name
            }
        })
    end)

    if not ok2 or not Window then
        warn("[UI] Failed to create window:", tostring(Window))
        return nil
    end

    pcall(function()
        Window:Tag({
            Title = "v2.4-PROD",
            Icon = "",
            Color = Color3.fromHex("#30ff6a"),
            Radius = 5,
        })
    end)

    local ok4, AutoB = pcall(function() return Window:Tab({ Title = "Auto Block", Icon = "" }) end)
    local ok5, HTDTab = pcall(function() return Window:Tab({ Title = "HTD", Icon = "" }) end)

    if not ok4 or not AutoB or not ok5 or not HTDTab then
        warn("[UI] Failed to create tabs")
        return Window
    end

    local function clamp(num, min, max)
        return math.clamp(tonumber(num) or min, min, max)
    end

    pcall(function()
        AutoB:Toggle({
            Title = "Auto Block",
            Callback = function(v) State.toggleOn = v end
        })
    end)
    pcall(function()
        AutoB:Input({
            Title = "Detection Range",
            Placeholder = "18",
            Value = "18",
            Callback = function(Text)
                State.detectionRange = clamp(Text, 1, 100)
            end
        })
    end)
    pcall(function()
        AutoB:Input({
            Title = "Block Delay",
            Placeholder = "0",
            Value = "0",
            Callback = function(Text)
                State.blockDelay = clamp(Text, 0, 2)
            end
        })
    end)
    pcall(function()
        AutoB:Toggle({
            Title = "Wall Check",
            Callback = function(v) State.wallCheck = v end
        })
    end)
    pcall(function()
        AutoB:Toggle({
            Title = "Facing Check",
            Callback = function(v) State.facingCheck = v end
        })
    end)
    pcall(function()
        AutoB:Input({
            Title = "Facing Check Dot",
            Placeholder = "-0.3",
            Value = "-0.3",
            Callback = function(Value)
                State.customFacingDot = clamp(Value, -1, 1)
            end
        })
    end)

    pcall(function()
        HTDTab:Toggle({
            Title = "Hitbox Dragging Tech",
            Callback = function(v) State.htdEnabled = v end
        })
    end)
    pcall(function()
        HTDTab:Input({
            Title = "HTD Speed",
            Placeholder = "5.6",
            Value = "5.6",
            Callback = function(value)
                State.htdSpeed = clamp(value, 0, 50)
            end
        })
    end)
    pcall(function()
        HTDTab:Input({
            Title = "HTD Delay",
            Placeholder = "0",
            Value = "0",
            Callback = function(value)
                State.htdDelay = clamp(value, 0, 5)
            end
        })
    end)
    pcall(function()
        HTDTab:Toggle({
            Title = "Anti Flick",
            Callback = function(v) State.antiFlick = v end
        })
    end)

    pcall(function()
        WindUI:Notify({
            Title = "Meowsaken Lite",
            Content = "v2.4 loaded — No leak, Lua 5.1 compat",
            Duration = 3,
            Icon = "bird",
        })
    end)

    return Window
end

-- ============================================================
-- HUB LIFECYCLE — Retry giới hạn + Maid cleanup
-- ============================================================
local Hub = {}
Hub._maid = Maid.new()
Hub._killerCache = nil
Hub._combatLoop = nil
Hub._fallbackLoop = nil
Hub._htdLoop = nil
Hub._flickLoop = nil
Hub._cachedAnimator = nil
Hub._retryCount = 0
Hub._maxRetries = 5
Hub._isInitializing = false

function Hub:Init()
    if self._isInitializing then
        warn("[Hub] Already initializing, skipping duplicate call")
        return
    end
    self._isInitializing = true

    -- Unload script cũ
    local old = getgenv().MeowsakenLiteUnload
    if typeof(old) == "function" then
        local ok, err = pcall(old)
        if not ok then warn("[Unload] Old unload failed:", err) end
    end

    -- Guard: KillersFolder
    local ok, KillersFolder = pcall(function()
        return Workspace:WaitForChild("Players", 10):WaitForChild("Killers", 10)
    end)

    if not ok or not KillersFolder then
        self._retryCount = self._retryCount + 1
        if self._retryCount > self._maxRetries then
            warn("[Hub] Failed to find Killers folder after " .. self._maxRetries .. " retries. Aborting.")
            self._isInitializing = false
            return
        end
        warn("[Hub] Killers folder not found. Retrying in 5s... (" .. self._retryCount .. "/" .. self._maxRetries .. ")")
        task.delay(5, function()
            self._isInitializing = false
            self:Init()
        end)
        return
    end

    self._killerCache = KillerCache.new(KillersFolder)
    if not self._killerCache then
        warn("[Hub] Failed to initialize KillerCache")
        self._isInitializing = false
        return
    end

    local function refreshAnimator()
        local char = localPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        self._cachedAnimator = hum and hum:FindFirstChildOfClass("Animator")
    end
    refreshAnimator()

    self._maid:Give(localPlayer.CharacterAdded:Connect(function()
        task.delay(0.5, refreshAnimator)
    end))

    -- Combat: 30Hz
    local combatMgr = ConnMgr.new()
    self._combatLoop = combatMgr:Loop(1 / 30, function()
        Combat:Update(self._killerCache)
    end, function() return State.toggleOn end)

    -- Fallback Poll: 10Hz
    local fallbackMgr = ConnMgr.new()
    self._fallbackLoop = fallbackMgr:Loop(0.1, function()
        Combat:PollKillers(self._killerCache)
    end, function() return State.toggleOn end)

    -- HTD: 30Hz
    local htdMgr = ConnMgr.new()
    self._htdLoop = htdMgr:Loop(1 / 30, function()
        HTD:Update(self._killerCache, self._cachedAnimator)
    end)

    -- Anti-flick: 10Hz
    local flickMgr = ConnMgr.new()
    self._flickLoop = flickMgr:Loop(0.1, function()
        HTD:AntiFlickCheck(self._killerCache)
    end)

    self._window = SetupUI()

    self._isInitializing = false
    self._retryCount = 0
    getgenv().MeowsakenLiteUnload = function() self:Unload() end
    print("[Meowsaken] v2.4 initialized.")
end

function Hub:Unload()
    if self._combatLoop then self._combatLoop() end
    if self._fallbackLoop then self._fallbackLoop() end
    if self._htdLoop then self._htdLoop() end
    if self._flickLoop then self._flickLoop() end

    -- Dọn tất cả Maid trong Combat (CRITICAL FIX)
    for humanoid, maid in pairs(Combat._maids) do
        if maid then
            maid:Destroy()
        end
        Combat._setupTags[humanoid] = nil
    end
    table.clear(Combat._maids)

    self._maid:Clean()

    if self._killerCache then
        self._killerCache:Destroy()
        self._killerCache = nil
    end

    HTD._dragMaid:Clean()

    State.toggleOn = false
    State.htdEnabled = false

    if self._window and self._window.Destroy then
        pcall(function() self._window:Destroy() end)
    end

    getgenv().MeowsakenLiteUnload = nil
    print("[Meowsaken] Unloaded cleanly.")
end

Hub:Init()
