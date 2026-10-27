-- LPH_NO_VIRTUALIZE: khi-obf(Lunar/LPH) danh-dau-ham-nhot-chay-native;
-- chua-obf/obf-khac: stub=no-op (mau-Catsaken)
if not LPH_OBFUSCATED then
	loadstring([[
		function LPH_NO_VIRTUALIZE(f) return f end;
	]])();
end

print('[A693] BOOT') print('[A693] BOOT') print('[A693] BOOT')

if rawget(_G, "__NERG_BOOT_N") then
  print("[NERG] duplicate boot blocked — current build stays up")
  return
end
_G.__NERG_BOOT_N = 1

local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local workspaceService = game:GetService("Workspace")
local statsService = game:GetService("Stats")
local debris = game:GetService("Debris")
local tweenService = game:GetService("TweenService")
local soundService = game:GetService("SoundService")
local httpService = game:GetService("HttpService")
local players = game:GetService("Players")
local userInputService = game:GetService("UserInputService")
local localPlayer = players.LocalPlayer
local waitForChild = localPlayer:WaitForChild("PlayerGui", 10)

_G.__NERG_KILLED = nil
local __PLUS_GEN_ALIVE = true
do
  local prevUnload = rawget(_G, "__NERG_UNLOAD") or rawget(_G, "__NERG_PLUS_SHUTDOWN") or rawget(_G, "NERG_KILLALL")
  if type(prevUnload) == "function" then
    pcall(prevUnload, "replaced by new instance")
    _G.__NERG_KILLED = nil
  end
  local uirRoots = { (gethui and gethui()), game:GetService("CoreGui"), localPlayer and localPlayer:FindFirstChild("PlayerGui") }
  local nergGuis = {
    ["NergFK_TextTags"] = true, ["NergMobileAB"] = true, ["NergABToggle"] = true,
    ["CinematicText"] = true, ["ForsakenDeviceESP"] = true, ["ForsakenAbilityESP"] = true,
    ["NergAbsGui"] = true, ["NergDodgeGui"] = true, ["NergStaminaView"] = true, ["NergStatusHUD"] = true,
  }
  for _, r in ipairs(uirRoots) do
    if r then
      for _, g in ipairs(r:GetChildren()) do
        pcall(function()
          if (g:IsA("ScreenGui") or g:IsA("Folder")) and (g.Name:find("WindUI") or nergGuis[g.Name]) then
            g:Destroy()
          end
        end)
      end
    end
  end
  pcall(function()
    local oldV = workspaceService:FindFirstChild("PlusVis_DLCHUB")
    if oldV then oldV:Destroy() end
    local oldB = workspaceService:FindFirstChild("NergABBoxes")
    if oldB then oldB:Destroy() end
  end)
  rawset(_G, "__NERG_BOOT_N", nil)
end

local v2 = {}
local V2_FOLDER = "NergBlock"
local V2_FILE = "NergBlock/plus_config.json"

function v2.load()
  pcall(function()
    if isfile and readfile and isfile(V2_FILE) then
      local rawJson = readfile(V2_FILE)
      if type(rawJson) == "string" and #rawJson > 2 then
        local decoded = httpService:JSONDecode(rawJson)
        if type(decoded) == "table" then
          for k, val in pairs(decoded) do
            v2._data[k] = val
          end
        end
      end
    end
  end)
end

function v2.save()
  pcall(function()
    if writefile then
      if isfolder and makefolder and not isfolder(V2_FOLDER) then
        pcall(makefolder, V2_FOLDER)
      end
      local encoded = httpService:JSONEncode(v2._data)
      if type(encoded) == "string" then
        writefile(V2_FILE, encoded)
      end
    end
  end)
end

function v2.get(key2, p1)
  local v7 = v2._data[key2]

  if v7 == nil then
    return p1
  end

  return v7
end

function v2.set(key3, p2)
  v2._data[key3] = p2
  v2.save()
end

v2._data = {}
v2.load()

local windUI = (function()
  local ok, lib = pcall(function() return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/7dd8a34a6bb59635c7b5f18ce9d46558a8cde138/dist/main.lua"))() end)
  if ok and lib then return lib end
  return nil
end)()

if not windUI then
  rawset(_G, "__NERG_BOOT_N", nil)
  warn("[NERG] WindUI failed to load — aborting boot safely")
  return
end

pcall(function()
  windUI:AddTheme({
    Name = "DeepBlue",
    Accent = Color3.fromHex("#FF6B00"),
    Background = Color3.fromHex("#0F0D12"),
    Outline = Color3.fromHex("#33293A"),
    Text = Color3.fromHex("#eaf6ff"),
    Placeholder = Color3.fromHex("#5e8db0"),
    Button = Color3.fromHex("#FF6B00"),
    Icon = Color3.fromHex("#FF8833"),
  })
end)
local CFG_UI = {}
local uiBoot = true
local v1PRBLOCKWindow = windUI:CreateWindow({
  Title = "PLUS-MASTER",
  Icon = "waves",
  Author = "NergPlus — Release · lowkey cracked",
  Folder = "NergBlock",
  Size = UDim2.fromOffset(500, 420),
  Transparent = true,
  Theme = "DeepBlue",
  Resizable = true,
  HideSearchBar = true,
  ToggleKey = Enum.KeyCode.K,
})
pcall(function() v1PRBLOCKWindow:Tag({ Title = "NergPlus", Icon = "waves", Color = Color3.fromHex("#FF6B00"), Radius = 13 }) end)
pcall(function()
  v1PRBLOCKWindow:EditOpenButton({
    Title = "", Icon = "monitor",
    CornerRadius = UDim.new(0, 16), StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromHex("#FF8833"), Color3.fromHex("#FF6B00")),
    OnlyMobile = false, Enabled = true, Draggable = true,
  })
end)

local autoBlock = v2.get("guestAutoBlockAudioOn", true)
local autoPunch = v2.get("guestAutoPunchOn", true)
local v8 = v2.get("guestVerifyFacingCheckOn", true)
local default = v2.get("guestShowVisionRange", false)

local visionRange = v2.get("guestVisionRange", 13.5)
local visionAngle = v2.get("guestVisionAngle", 85)
local aimPunch = v2.get("guestAimPunchActive", true)
local punchPrediction = v2.get("guestPunchPrediction", 2.3)
local v10 = v2.get("guestAimPunchDuration", 0.5)
local v11 = v2.get("guestBlockCooldown", 0.35)
local blockDelay = v2.get("guestBlockDelay", 0)
local v12 = v2.get("guestAutoPunchDelay", 0.3)
local v16 = v2.get("guestCinematicTextEnabled", false)
local textContent = v2.get("guestCinematicText", "PARRY!")
local v17 = v2.get("noHDTCooldown", false)
local default5 = v2.get("hdtCooldownChecker", false)
local v19 = v2.get("customPunchSoundId", 0)
a742pHitboxMode = v2.get("a742pHitboxMode", false)
local v30 = setmetatable({}, { __mode = "k" })

local v32 = {
  ["87259391926321"] = true,
  ["140703210927645"] = true,
  ["136007065400978"] = true,
  ["129843313690921"] = true,
  ["86709774283672"] = true,
  ["108807732150251"] = true,
  ["138040001965654"] = true,
  ["86096387000557"] = true,
  ["81905101227053"] = true,
  ["127777649118195"] = true,
  ["99100240941590"] = true,
  ["92831180929659"] = true,
  ["112081768119093"] = true,
  ["117587689359268"] = true,
  ["91830732867282"] = true,
  ["91730605416216"] = true,
  ["100184164753080"] = true,
  ["108911997126897"] = true,
  ["138936949998619"] = true,
  ["116427323741607"] = true,
  ["72007882634344"] = true,
  ["91522546229765"] = true,
  ["111270184603402"] = true,
  ["82137285150006"] = true,
  ["119850211147676"] = true,
}

HDT_BLOCK_LOOKUP = {
  ["98105697395689"] = true, ["100926346851492"] = true, ["140671644163156"] = true,
  ["72182155407310"] = true, ["72722244508749"] = true, ["95802026624883"] = true,
  ["88557287105521"] = true, ["123548100869928"] = true, ["82605295530067"] = true,
  ["120748030255574"] = true, ["88287038085804"] = true, ["96959123077498"] = true,
  ["115706752305794"] = true, ["82036084568393"] = true, ["127040663332045"] = true,
  ["138407964761603"] = true, ["102517104852347"] = true, ["133292581373127"] = true,
  ["113899931890882"] = true, ["90970641235403"] = true,
}

rawset(_G, "GUEST_CHARGE_ANIMS", rawget(_G, "GUEST_CHARGE_ANIMS") or {})
do
  local function doGuestHarvest()
    pcall(function()
      local rs = game:GetService("ReplicatedStorage")
      local assets = rs:FindFirstChild("Assets")
      if not assets then return end

      local function extractAnimIds(val, outLookup)
        if type(val) == "string" or type(val) == "number" then
          local num = tostring(val):match("%d+")
          if num then outLookup[num] = true end
        elseif type(val) == "table" then
          for _, subv in pairs(val) do extractAnimIds(subv, outLookup) end
        elseif typeof(val) == "Instance" and val:IsA("Animation") then
          local num = tostring(val.AnimationId):match("%d+")
          if num then outLookup[num] = true end
        end
      end

      local GUEST_CHARGE_ANIMS = _G.GUEST_CHARGE_ANIMS
      local function harvest(cfgMod)
        if not (cfgMod and cfgMod:IsA("ModuleScript")) then return end
        local ok, mod = pcall(require, cfgMod)
        if not (ok and type(mod) == "table" and type(mod.Animations) == "table") then return end
        for k, v in pairs(mod.Animations) do
          local klow = tostring(k):lower()
          if k == "Block" or klow:find("block") then
            extractAnimIds(v, HDT_BLOCK_LOOKUP)
          elseif k:find("Punch") or k:find("Parry") or klow:find("punch") or klow:find("parry") then
            extractAnimIds(v, v32)
          elseif k:find("Charge") or k:find("Dash") or klow:find("charge") or klow:find("dash") then
            extractAnimIds(v, GUEST_CHARGE_ANIMS)
          end
        end
      end

      local surv = assets:FindFirstChild("Survivors")
      local guest = surv and surv:FindFirstChild("Guest1337")
      if guest and guest:FindFirstChild("Config") then harvest(guest.Config) end

      local skins = assets:FindFirstChild("Skins")
      local sSurv = skins and skins:FindFirstChild("Survivors")
      local gSkins = sSurv and sSurv:FindFirstChild("Guest1337")
      if gSkins then
        for _, c in ipairs(gSkins:GetChildren()) do
          if c:FindFirstChild("Config") then harvest(c.Config) end
        end
      end
    end)
  end
  doGuestHarvest()
  task.delay(1.5, function() if __PLUS_GEN_ALIVE and not _G.__NERG_KILLED then doGuestHarvest() end end)
  task.delay(4, function() if __PLUS_GEN_ALIVE and not _G.__NERG_KILLED then doGuestHarvest() end end)
  local harvestCharConn, harvestSkinConn
  local function bindSkinHarvest(chr)
    if harvestSkinConn then pcall(function() harvestSkinConn:Disconnect() end) harvestSkinConn = nil end
    if not chr then return end
    harvestSkinConn = chr:GetAttributeChangedSignal("SkinName"):Connect(function()
      if not __PLUS_GEN_ALIVE or _G.__NERG_KILLED then return end
      task.delay(0.2, function()
        if __PLUS_GEN_ALIVE and not _G.__NERG_KILLED then doGuestHarvest() end
      end)
    end)
  end
  local lp = game:GetService("Players").LocalPlayer
  if lp then
    harvestCharConn = lp.CharacterAdded:Connect(function(chr)
      if not __PLUS_GEN_ALIVE or _G.__NERG_KILLED then return end
      task.delay(0.5, function()
        if __PLUS_GEN_ALIVE and not _G.__NERG_KILLED then doGuestHarvest() end
      end)
      bindSkinHarvest(chr)
    end)
    if lp.Character then
      bindSkinHarvest(lp.Character)
    end
  end
  rawset(_G, "__NERG_HARVEST_STOP", function()
    if harvestCharConn then pcall(function() harvestCharConn:Disconnect() end) harvestCharConn = nil end
    if harvestSkinConn then pcall(function() harvestSkinConn:Disconnect() end) harvestSkinConn = nil end
  end)
end

local v33 = false
local v34 = 0

local a724RotLocked = false
local a724RotLocks = {}
local function a724RotLock(hum, tag)
	a724RotLocks[tag or "default"] = true
	a724RotLocked = true
	hum = hum or (localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid"))
	if hum and hum.Parent then hum.AutoRotate = false end
end
local function a724RotUnlock(hum, tag)
	if tag then
		a724RotLocks[tag] = nil
	else
		table.clear(a724RotLocks)
	end
	if next(a724RotLocks) ~= nil then return end
	hum = hum or (localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid"))
	if not a724RotLocked and tag ~= nil then return end
	a724RotLocked = false
	if hum and hum.Parent then hum.AutoRotate = true end
end
local v36 = setmetatable({}, { __mode = "k" })
local v37 = 0
local remoteEvent = replicatedStorage.Modules.Network.Network:FindFirstChild("RemoteEvent")

if not remoteEvent then
  remoteEvent = replicatedStorage.Modules.Network.Network:WaitForChild("RemoteEvent", 10)
end

local function f3()
  if not remoteEvent then
    return
  end

  remoteEvent:FireServer("UseActorAbility", { [1] = buffer.fromstring("\3\5\0\0\0Block") })
end

local v44

local function makeTextLabel()
  if not v16 then
    return
  else
    if v44 then
      v44:Destroy()
      v44 = nil
    end

    local cinematicText = Instance.new("ScreenGui")
    cinematicText.Name = "CinematicText"
    cinematicText.Parent = waitForChild
    cinematicText.IgnoreGuiInset = true
    cinematicText.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    cinematicText.DisplayOrder = 10000

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 0, 100)
    textLabel.Position = UDim2.new(0, 0, 0.4, -50)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = textContent
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.TextStrokeTransparency = 0.3
    textLabel.TextSize = 60
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextScaled = true
    textLabel.RichText = true
    textLabel.Parent = cinematicText

    v44 = cinematicText

    task.delay(1.5, function()
      if v44 then
        v44:Destroy()
        v44 = nil
      end
    end)

    return
  end
end

local humanoid, v45, connect

local function a724AnimUnlock()
	if not v33 then return end
	v33 = false
	if a724AimConn then pcall(function() a724AimConn:Disconnect() end) a724AimConn = nil end
	a724RotUnlock(humanoid, "punch")
	walkSpeed3, jumpPower, autoRotate2 = nil, nil, nil
end

local hdtKeo = v2.get("guestHDTKeoThan", true)
local hdtSpeed = v2.get("guestHDTSpeed", 12)
local HDT_InProgress = false
local hdtCdPer = setmetatable({}, { __mode = "k" })

local function startHDT(killerModel)
  if HDT_InProgress or not hdtKeo then return end
  local c = localPlayer.Character
  local hrp = c and c:FindFirstChild("HumanoidRootPart")
  local hum = c and c:FindFirstChildOfClass("Humanoid")
  local tr = killerModel and killerModel:FindFirstChild("HumanoidRootPart")
  if not (hrp and hum and tr) or hum.Health <= 0 then return end
  HDT_InProgress = true
  if v2.get("a720Telemetry", false) then print("[NERG] ★ HDT fired (pull " .. tostring(killerModel.Name) .. " · 0.8s)") end
  a724RotLock(hum, "hdt")
  hum.AutoRotate = false
  local bv = Instance.new("BodyVelocity")
  bv.MaxForce = Vector3.new(1e5, 0, 1e5)
  bv.P = 1e4
  bv.Velocity = Vector3.zero
  bv.Parent = hrp
  debris:AddItem(bv, 1.2)
  local conn
  conn = runService.Heartbeat:Connect(function()
    if not hdtKeo or not HDT_InProgress
      or not (c and c.Parent and killerModel and killerModel.Parent) or (hum and hum.Health <= 0) then
      if conn then conn:Disconnect() end
      if bv and bv.Parent then pcall(function() bv:Destroy() end) end
      a724RotUnlock(hum, "hdt")
      HDT_InProgress = false
      return
    end
    local t2 = killerModel:FindFirstChild("HumanoidRootPart")
    if not t2 then HDT_InProgress = false return end
    local off = t2.Position - hrp.Position
    local hz = Vector3.new(off.X, 0, off.Z)
    if hz.Magnitude > 0.01 then
      local dir = hz.Unit
      local spd = math.clamp(hdtSpeed, 5, 20)
      bv.Velocity = Vector3.new(dir.X * spd, 0, dir.Z * spd)
      hrp.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(t2.Position.X, hrp.Position.Y, t2.Position.Z))
    else
      bv.Velocity = Vector3.zero
    end
    if off.Magnitude <= 2.0 then HDT_InProgress = false end
  end)
  task.delay(0.8, function() HDT_InProgress = false end)
end

local function f4(character2)
  local findFirstChild = character2.FindFirstChild
  humanoid = character2:FindFirstChild("Humanoid")
  v45 = findFirstChild(character2, "HumanoidRootPart")

  if connect then
    connect:Disconnect()
    connect = nil
  end

  local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
  if not animator then return end

  connect = animator.AnimationPlayed:Connect(function(p3)
    local animId = p3.Animation and tostring(p3.Animation.AnimationId):match("%d+")
    local animName = (p3.Animation and p3.Animation.Name:lower()) or p3.Name:lower()

    -- 1. HDT Body Pull on Block (Frame 0, Zero-Delay) + AutoPunch Parry Window Arm
    local isBlock = (animId and HDT_BLOCK_LOOKUP[animId]) or animName:find("block")
    if isBlock and _G.__NERG_PARRY_POKE then
      task.defer(_G.__NERG_PARRY_POKE, "block-anim")
    end
    if hdtKeo and not HDT_InProgress and isBlock then
      if v2.get("a720Telemetry", false) then
        print("[NERG] block-anim detected: " .. tostring(animId or animName) .. " (HDT trigger)")
      end
      local myRoot = v45 or (character2 and character2:FindFirstChild("HumanoidRootPart"))
      local pf = workspaceService:FindFirstChild("Players")
      local kf = pf and pf:FindFirstChild("Killers")
      local nearest, nd = nil, math.huge
      if kf and myRoot then
        for _, k in ipairs(kf:GetChildren()) do
          local kr = k:FindFirstChild("HumanoidRootPart")
          if kr and players:GetPlayerFromCharacter(k) then
            local d = (kr.Position - myRoot.Position).Magnitude
            if d < nd then nd, nearest = d, k end
          end
        end
      end
      if nearest then
        local nowc = os.clock()
        if not (hdtCdPer[nearest] and nowc - hdtCdPer[nearest] < 2.5) then
          hdtCdPer[nearest] = nowc
          task.spawn(function() startHDT(nearest) end)
        end
      end
    end

    -- 2. Aim Punch on Parry / Punch (Multi-anim support with Track protection)
    local isPunch = (animId and v32[animId]) or animName:find("punch") or animName:find("parry")
    if aimPunch and isPunch then
      v34 = tick()
      v33 = true
      if a724StartAimLoop then a724StartAimLoop() end
      currentAimTrack = p3
      pcall(function()
        p3.Ended:Once(function()
          if currentAimTrack == p3 then a724AnimUnlock() end
        end)
        p3.Stopped:Once(function()
          if currentAimTrack == p3 then a724AnimUnlock() end
        end)
      end)
    end

    -- 3. AutoCharge / ChargeAim (Immediate Frame 0 Activation via _G.NERG_CHARGE)
    local gChargeLookup = _G.GUEST_CHARGE_ANIMS
    local isCharge = (animId and gChargeLookup and gChargeLookup[animId]) or animName:find("charge") or animName:find("dash")
    if isCharge and chargeAim and _G.NERG_CHARGE and _G.NERG_CHARGE.aim then
      task.spawn(function()
        pcall(_G.NERG_CHARGE.aim, nil, "anim-charge")
      end)
    end
  end)
end

local function f7(p5)
  if not p5 then
    return nil
  else
    local queryHitbox = p5:FindFirstChild("QueryHitbox")

    if queryHitbox and queryHitbox:IsA("BasePart") then
      return queryHitbox
    end

    for index, value2 in ipairs(p5:GetChildren()) do
      local queryHitbox2 = value2:FindFirstChild("QueryHitbox")

      if queryHitbox2 and queryHitbox2:IsA("BasePart") then
        return queryHitbox2
      end
    end

    return nil
  end
end

local function makeSound()
  if not remoteEvent then
    return
  end

  if v19 and v19 ~= 0 then
    pcall(function()
      local sound = Instance.new("Sound")
      sound.SoundId = "rbxassetid://" .. tostring(v19)
      sound.Volume = 1
      sound.Parent = soundService
      sound:Play()

      debris:AddItem(sound, 3)
    end)
  end

  remoteEvent:FireServer("UseActorAbility", { [1] = buffer.fromstring("\3\5\0\0\0Punch") })
end

local function f12()
  if v17 then
    return true
  else
    local mainUI = waitForChild:FindFirstChild("MainUI")

    if mainUI then
      local abilityContainer = mainUI:FindFirstChild("AbilityContainer")

      if abilityContainer then
        local block = abilityContainer:FindFirstChild("Block")

        if block then
          local cooldownTime = block:FindFirstChild("CooldownTime")

          if cooldownTime and cooldownTime:IsA("TextLabel") then
            local d2 = cooldownTime.Text:match("[%d%.]+")

            if d2 then
              local v52 = tonumber(d2)
              return not v52 or v52 <= 0
            end

            return true
          end
        end
      end

      return tick() - v37 >= v11
    end

    return tick() - v37 >= v11
  end
end

local function f14(p9)
  if not p9 then
    return nil
  else
    local v55 = f7(p9)

    if v55 then
      return v55.Position, v55
    else
      local humanoidRootPart = p9:FindFirstChild("HumanoidRootPart")

      if humanoidRootPart then
        return humanoidRootPart.Position, humanoidRootPart
      end

      return nil, nil
    end
  end
end

autoCharge = v2.get("guestAutoChargeOn", false)
chargeAim = v2.get("chargeAimOn", v2.get("guestChargeAimOn", true))
chargeMaxRange = v2.get("chargeMaxRangeVal", 20)

do
  local cachedChargeBtn, cachedChargeCdLabel = nil, nil
  local chargeAimConn = nil
  local chargeUiConn, chargeCharConn, chargeSmConn = nil, nil, nil
  local lastChargeAt = 0
  local chargeFireCount = 0
  local chargeDetachCount = 0
  local lastDetachReason = "none"

  local function resolveChargeUI()
    local pg = localPlayer and localPlayer:FindFirstChild("PlayerGui")
    local mu = pg and pg:FindFirstChild("MainUI")
    local ac = mu and mu:FindFirstChild("AbilityContainer")
    local chg = ac and ac:FindFirstChild("Charge")
    cachedChargeBtn = chg
    local cd = chg and chg:FindFirstChild("CooldownTime")
    cachedChargeCdLabel = (cd and cd:IsA("TextLabel")) and cd or nil
  end

  chargeReady = function()
    if not (cachedChargeCdLabel and cachedChargeCdLabel.Parent) then
      resolveChargeUI()
    end
    if not cachedChargeCdLabel then
      return true
    end
    local txt = cachedChargeCdLabel.Text
    return txt == "" or txt == "0"
  end

  local CHARGE_STEP_NAME = "NergChargeAim"

  local function stopChargeAim(reason)
    pcall(function() runService:UnbindFromRenderStep(CHARGE_STEP_NAME) end)
    local hadConn = (chargeAimConn ~= nil)
    if chargeAimConn then
      local oldConn = chargeAimConn
      chargeAimConn = nil
      pcall(function() oldConn:Disconnect() end)
      chargeDetachCount += 1
      lastDetachReason = tostring(reason or "stopped")
    end
    if hadConn or a724RotLocks["charge"] then
      pcall(function()
        local c = localPlayer.Character
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        a724RotUnlock(hum, "charge")
        if hum then
          hum:Move(Vector3.zero)
        end
      end)
      if hadConn and v2.get("a720Telemetry", false) then
        print("[NERG] ★ ChargeAim detached (" .. lastDetachReason .. ")")
      end
    end
  end

  local function findNearestKiller(maxDist)
    local c = localPlayer.Character
    local myHrp = c and c:FindFirstChild("HumanoidRootPart")
    local pf = workspaceService:FindFirstChild("Players")
    local kf = pf and pf:FindFirstChild("Killers")
    if not (myHrp and kf) then return nil end
    local bestK, bestD = nil, maxDist or 35
    for _, k in ipairs(kf:GetChildren()) do
      local kh = k:FindFirstChild("HumanoidRootPart")
      if kh then
        local d = (kh.Position - myHrp.Position).Magnitude
        if d <= bestD then
          bestD = d
          bestK = k
        end
      end
    end
    return bestK
  end

  local function startChargeAim(targetKiller, srcTag)
    if not chargeAim or not __PLUS_GEN_ALIVE or _G.__NERG_KILLED then return end
    local c = localPlayer.Character
    local myHrp = c and c:FindFirstChild("HumanoidRootPart")
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    local target = (targetKiller and targetKiller.Parent and targetKiller:FindFirstChild("HumanoidRootPart")) and targetKiller or findNearestKiller((chargeMaxRange or 20) * 1.5)
    if not (c and myHrp and hum and target) or hum.Health <= 0 then return end

    pcall(function() runService:UnbindFromRenderStep(CHARGE_STEP_NAME) end)
    if chargeAimConn then
      local prev = chargeAimConn
      chargeAimConn = nil
      pcall(function() prev:Disconnect() end)
    end

    local startT = os.clock()
    local graceWindow = (srcTag == "anim-charge") and 0.65 or 0.45
    local sm = c:FindFirstChild("SpeedMultipliers")
    local sawMult = (sm and sm:FindFirstChild("Guest1337Charge") ~= nil) or false
    local lastMoveDir = nil
    a724RotLock(hum, "charge")

    -- Ghi đè unbind ngay lúc bắt đầu aim để giải phóng giới hạn 2 rad/s của game gốc
    pcall(function() runService:UnbindFromRenderStep("GuestCharging") end)

    -- Frame-0 Pre-Snap: bẻ hướng và khóa vector di chuyển ngay tại frame gọi
    local kHrp0 = target:FindFirstChild("HumanoidRootPart")
    if kHrp0 then
      local flat0 = Vector3.new(kHrp0.Position.X - myHrp.Position.X, 0, kHrp0.Position.Z - myHrp.Position.Z)
      if flat0.Magnitude > 0.01 then
        lastMoveDir = flat0.Unit
        local lookAtPos0 = Vector3.new(kHrp0.Position.X, myHrp.Position.Y, kHrp0.Position.Z)
        myHrp.CFrame = CFrame.lookAt(myHrp.Position, lookAtPos0)
        hum:Move(lastMoveDir)
      end
    end

    if v2.get("a720Telemetry", false) then
      print("[NERG] ★ ChargeAim locked -> " .. tostring(target.Name) .. " (" .. tostring(srcTag or "charge") .. ")")
    end

    local function chargeAimStep()
      if not __PLUS_GEN_ALIVE or _G.__NERG_KILLED or not chargeAim then
        stopChargeAim("disabled")
        return
      end
      -- Unbind liên tục mỗi frame đề phòng game re-bind lại
      pcall(function() runService:UnbindFromRenderStep("GuestCharging") end)

      local elapsed = os.clock() - startT
      if elapsed >= 1.25 then
        stopChargeAim("timeout-1.2s")
        return
      end
      if not (c and c.Parent and myHrp and myHrp.Parent and hum and hum.Health > 0) then
        stopChargeAim("char-invalid")
        return
      end
      sm = sm or c:FindFirstChild("SpeedMultipliers")
      local hasMult = (sm and sm:FindFirstChild("Guest1337Charge") ~= nil) or false
      if hasMult then
        sawMult = true
      elseif sawMult or elapsed > graceWindow then
        stopChargeAim("mult-ended")
        return
      end

      local kHrp = target and target.Parent and target:FindFirstChild("HumanoidRootPart")
      if not kHrp then
        stopChargeAim("target-lost")
        return
      end

      local offset = kHrp.Position - myHrp.Position
      if offset.Magnitude <= 3.5 then
        stopChargeAim("hit-3.5m")
        return
      end

      local kVel = kHrp.AssemblyLinearVelocity
      local flatVel = Vector3.new(kVel.X, 0, kVel.Z)
      local leadT = math.clamp(offset.Magnitude / 42, 0.02, 0.18)
      local aimPos = kHrp.Position + flatVel * leadT
      local flat = Vector3.new(aimPos.X - myHrp.Position.X, 0, aimPos.Z - myHrp.Position.Z)
      local flatDirect = Vector3.new(offset.X, 0, offset.Z)
      local moveDir = (flat.Magnitude > 0.01 and flat.Unit)
        or (flatDirect.Magnitude > 0.01 and flatDirect.Unit)
        or lastMoveDir
      if moveDir then
        lastMoveDir = moveDir
        a724RotLock(hum, "charge")
        pcall(function() myHrp.AssemblyAngularVelocity = Vector3.zero end)
        myHrp.CFrame = CFrame.lookAt(myHrp.Position, myHrp.Position + moveDir)
        hum:Move(moveDir)
      end
    end

    chargeAimConn = {
      Disconnect = function()
        pcall(function() runService:UnbindFromRenderStep(CHARGE_STEP_NAME) end)
      end,
    }
    pcall(function()
      runService:BindToRenderStep(CHARGE_STEP_NAME, Enum.RenderPriority.Character.Value + 25, chargeAimStep)
    end)
  end

  fireCharge = function(killerModel)
    if not __PLUS_GEN_ALIVE or _G.__NERG_KILLED or not autoCharge then return false end
    local nowT = os.clock()
    if nowT - lastChargeAt < 0.75 then return false end
    if not chargeReady() then return false end

    local c = localPlayer.Character
    local myHrp = c and c:FindFirstChild("HumanoidRootPart")
    local target = killerModel or findNearestKiller(chargeMaxRange or 20)
    local kHrp = target and target:FindFirstChild("HumanoidRootPart")
    if not (myHrp and kHrp) then return false end

    local dist = (kHrp.Position - myHrp.Position).Magnitude
    if dist > (chargeMaxRange or 20) then return false end

    lastChargeAt = nowT
    chargeFireCount += 1

    -- Pre-Snap Frame 0: Xoay thẳng mặt và bẻ hướng chạy trực diện vào Killer NGAY TRƯỚC KHI bắn RemoteEvent
    local lookAtPos = Vector3.new(kHrp.Position.X, myHrp.Position.Y, kHrp.Position.Z)
    myHrp.CFrame = CFrame.lookAt(myHrp.Position, lookAtPos)
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then
      a724RotLock(hum, "charge")
      hum:Move((lookAtPos - myHrp.Position).Unit)
    end
    pcall(function() runService:UnbindFromRenderStep("GuestCharging") end)

    if remoteEvent then
      remoteEvent:FireServer("UseActorAbility", { [1] = buffer.fromstring("\3\6\0\0\0Charge") })
    elseif cachedChargeBtn and firesignal then
      pcall(function() firesignal(cachedChargeBtn.MouseButton1Click) end)
    end

    if v2.get("a720Telemetry", false) then
      print(string.format("[NERG] ★ AutoCharge fired -> %s (dist=%.1f <= %d)", tostring(target.Name), dist, chargeMaxRange or 20))
    end

    if chargeAim then
      startChargeAim(target, "auto-charge")
    else
      task.delay(0.85, function()
        if not chargeAimConn then
          a724RotUnlock(hum, "charge")
          if hum and hum.Parent then pcall(function() hum:Move(Vector3.zero) end) end
        end
      end)
    end
    return true
  end

  local chargeSmSeq, chargeSmThread = 0, nil
  local function clearChargeSm()
    chargeSmSeq += 1
    if chargeSmThread then
      local th = chargeSmThread
      chargeSmThread = nil
      if coroutine.running() ~= th then
        pcall(task.cancel, th)
      end
    end
    if chargeSmConn then
      local c = chargeSmConn
      chargeSmConn = nil
      pcall(function() c:Disconnect() end)
    end
  end

  local function bindSpeedMultipliers(ch)
    clearChargeSm()
    if not ch then return end
    local mySeq = chargeSmSeq
    chargeSmThread = task.spawn(function()
      local sm = ch:FindFirstChild("SpeedMultipliers") or ch:WaitForChild("SpeedMultipliers", 5)
      if chargeSmSeq ~= mySeq then return end
      chargeSmThread = nil
      if not (sm and ch.Parent and localPlayer.Character == ch and __PLUS_GEN_ALIVE and not _G.__NERG_KILLED) then return end
      if chargeSmConn then
        pcall(function() chargeSmConn:Disconnect() end)
        chargeSmConn = nil
      end
      local cAdded, cAnc
      cAdded = sm.ChildAdded:Connect(function(child)
        if child.Name == "Guest1337Charge" and chargeAim and not chargeAimConn then
          local nearK = findNearestKiller((chargeMaxRange or 20) * 1.5)
          if nearK then
            startChargeAim(nearK, "manual-charge")
          end
        end
      end)
      cAnc = sm.AncestryChanged:Connect(function(_, parent)
        if not parent and chargeSmSeq == mySeq then
          clearChargeSm()
        end
      end)
      chargeSmConn = {
        Disconnect = function()
          if cAdded then pcall(function() cAdded:Disconnect() end) cAdded = nil end
          if cAnc then pcall(function() cAnc:Disconnect() end) cAnc = nil end
        end,
      }
    end)
  end

  resolveChargeUI()
  task.delay(1, resolveChargeUI)
  if localPlayer.Character then bindSpeedMultipliers(localPlayer.Character) end

  local pg0 = localPlayer and localPlayer:FindFirstChild("PlayerGui")
  if pg0 then
    chargeUiConn = pg0.DescendantAdded:Connect(function(desc)
      if desc.Name == "Charge" and desc.Parent and desc.Parent.Name == "AbilityContainer" then
        task.defer(resolveChargeUI)
      end
    end)
  end
  chargeCharConn = localPlayer.CharacterAdded:Connect(function(ch)
    stopChargeAim("respawn")
    cachedChargeBtn, cachedChargeCdLabel = nil, nil
    task.delay(0.5, resolveChargeUI)
    bindSpeedMultipliers(ch)
  end)

  rawset(_G, "NERG_CHARGE", {
    ready = chargeReady,
    fire = fireCharge,
    aim = startChargeAim,
    stopAim = stopChargeAim,
    setAuto = function(v) autoCharge = (v == true) end,
    setAim = function(v) chargeAim = (v == true) end,
    status = function()
      return {
        autoCharge = autoCharge,
        chargeAim = chargeAim,
        chargeMaxRange = chargeMaxRange,
        ready = chargeReady(),
        aimActive = (chargeAimConn ~= nil),
        fires = chargeFireCount,
        detaches = chargeDetachCount,
        lastDetach = lastDetachReason,
        hasBtn = (cachedChargeBtn ~= nil),
        hasCdLabel = (cachedChargeCdLabel ~= nil),
      }
    end,
    stop = function()
      stopChargeAim("unload")
      if chargeUiConn then chargeUiConn:Disconnect() chargeUiConn = nil end
      if chargeCharConn then chargeCharConn:Disconnect() chargeCharConn = nil end
      clearChargeSm()
    end,
  })
end

local function f17(p10)
  if not __PLUS_GEN_ALIVE or _G.__NERG_KILLED or not autoBlock then
    return
  elseif not f12() then
    if autoCharge and chargeReady() then
      fireCharge(p10)
    end
    return
  else
    local character5 = localPlayer.Character
    local humanoidRootPart6 = character5 and character5:FindFirstChild("HumanoidRootPart")
    local hum5 = character5 and character5:FindFirstChildOfClass("Humanoid")

    if not (humanoidRootPart6 and humanoidRootPart6:IsDescendantOf(workspaceService) and hum5 and hum5.Health > 0) then
      return
    end

    if not (p10 and p10.Parent and p10:IsDescendantOf(workspaceService) and p10:FindFirstChild("HumanoidRootPart")) then
      return
    end

    if (blockDelay or 0) <= 0 then
      local v89 = f14(p10)
      if not v89 then return end
      if not a742pHitboxMode then
        local magnitude = (v89 - humanoidRootPart6.Position).Magnitude
        if magnitude > (visionRange or 13.5) * 1.18 then return end
      end
      f3()
      v37 = tick()
      makeTextLabel()
    else
      task.delay(blockDelay, function()
        if not __PLUS_GEN_ALIVE or _G.__NERG_KILLED or not autoBlock then
          return
        end
        local curChar = localPlayer.Character
        local curHrp = curChar and curChar:FindFirstChild("HumanoidRootPart")
        local curHum = curChar and curChar:FindFirstChildOfClass("Humanoid")
        if not (curChar and curChar == character5 and curHrp and curHrp:IsDescendantOf(workspaceService) and curHum and curHum.Health > 0) then
          return
        elseif not (p10 and p10.Parent and p10:IsDescendantOf(workspaceService) and p10:FindFirstChild("HumanoidRootPart")) then
          return
        elseif not f12() then
          if autoCharge and chargeReady() then
            fireCharge(p10)
          end
          return
        else
          local v89 = f14(p10)
          if not v89 then return end
          if not a742pHitboxMode then
            local magnitude = (v89 - curHrp.Position).Magnitude
            if magnitude > (visionRange or 13.5) * 1.18 then return end
          end
          f3()
          v37 = tick()
          makeTextLabel()
        end
      end)
    end

    return
  end
end

-- HDT body pull: startHDT & variables relocated before f4 for proper lexical scoping

task.spawn(function()
  local cachedBtn, cachedName, cachedCd, cachedIcon
  local parryConns = {}
  local lastPunchAt = 0
  local transientWatcher = nil

  local function clearParryConns()
    for i = #parryConns, 1, -1 do
      local c = parryConns[i]
      parryConns[i] = nil
      pcall(function() c:Disconnect() end)
    end
  end

  local function stopTransientWatcher()
    if transientWatcher then
      pcall(function() transientWatcher:Disconnect() end)
      transientWatcher = nil
    end
  end

  local function isYellowColor(col)
    if typeof(col) ~= "Color3" then return false end
    return col.R >= 0.75 and col.G >= 0.55 and col.B <= 0.45 and (col.R - col.B) >= 0.35
  end

  local function isParryState()
    if not (cachedBtn and cachedBtn.Parent and cachedName and cachedCd) then return false end
    local cdTxt = cachedCd.Text
    if cdTxt ~= "" and cdTxt ~= "0" and cdTxt ~= "0.0" then return false end
    if cachedBtn:GetAttribute("Parry") == true or cachedName:GetAttribute("Parry") == true then
      return true
    end
    if cachedBtn:IsA("GuiButton") or cachedBtn:IsA("GuiObject") then
      if isYellowColor(cachedBtn.BackgroundColor3) then return true end
      if cachedBtn:IsA("ImageButton") and isYellowColor(cachedBtn.ImageColor3) then return true end
    end
    if cachedIcon and cachedIcon.Parent and cachedIcon:IsA("ImageLabel") then
      if isYellowColor(cachedIcon.ImageColor3) then return true end
    end
    if cachedName:IsA("TextLabel") and isYellowColor(cachedName.TextColor3) then
      return true
    end
    local sName = cachedName:FindFirstChildOfClass("UIStroke")
    if sName and sName.Enabled and sName.Transparency < 0.9 then
      if isYellowColor(sName.Color) or (sName.Color.R + sName.Color.G > 1.2 and sName.Color.B < 0.5) then
        return true
      end
    end
    local sBtn = cachedBtn:FindFirstChildOfClass("UIStroke")
    if sBtn and sBtn.Enabled and sBtn.Transparency < 0.9 and isYellowColor(sBtn.Color) then
      return true
    end
    return false
  end

  local function tryFireParryPunch(srcTag)
    if not __PLUS_GEN_ALIVE or not autoPunch then return end
    local nowT = os.clock()
    if nowT - lastPunchAt < 0.65 then return end
    local c = localPlayer.Character
    if not (c and c.Parent) then return end
    if not isParryState() then return end
    local myRoot = c:FindFirstChild("HumanoidRootPart")
    local pf = workspaceService:FindFirstChild("Players")
    local kf = pf and pf:FindFirstChild("Killers")
    local ckRoot, bd = nil, 15.5
    if kf and myRoot then
      for _, k in ipairs(kf:GetChildren()) do
        local r = k:FindFirstChild("HumanoidRootPart")
        if r and players:GetPlayerFromCharacter(k) then
          local d = (r.Position - myRoot.Position).Magnitude
          if d < bd then bd, ckRoot = d, r end
        end
      end
    end
    if ckRoot and myRoot then
      lastPunchAt = nowT
      stopTransientWatcher()
      local pDelay = tonumber(v12) or 0
      if pDelay <= 0 then
        if v2.get("a720Telemetry", false) then
          print("[NERG] ★ punch fired (" .. tostring(srcTag or "parry") .. " + range)")
        end
        makeSound()
      else
        task.delay(pDelay, function()
          if not __PLUS_GEN_ALIVE or _G.__NERG_KILLED or not autoPunch then return end
          local c2 = localPlayer.Character
          local r2 = c2 and c2:FindFirstChild("HumanoidRootPart")
          local h2 = c2 and c2:FindFirstChildOfClass("Humanoid")
          if not (r2 and h2 and h2.Health > 0) then return end
          if v2.get("a720Telemetry", false) then
            print("[NERG] ★ punch fired (" .. tostring(srcTag or "parry") .. " + delay=" .. tostring(pDelay) .. ")")
          end
          makeSound()
        end)
      end
    end
  end

  local watcherStartT = 0
  local function onParrySignal(srcTag)
    if not __PLUS_GEN_ALIVE or not autoPunch then return end
    if isParryState() then
      tryFireParryPunch(srcTag)
      if os.clock() - lastPunchAt < 0.1 then return end
    end
    watcherStartT = os.clock()
    if not transientWatcher then
      transientWatcher = runService.Heartbeat:Connect(function()
        if not __PLUS_GEN_ALIVE or not autoPunch or os.clock() - watcherStartT > 1.35 then
          stopTransientWatcher()
          return
        end
        if isParryState() then
          tryFireParryPunch("transient")
        end
      end)
    end
  end
  rawset(_G, "__NERG_PARRY_POKE", onParrySignal)

  local function hookStroke(st)
    if not (st and st:IsA("UIStroke")) then return end
    parryConns[#parryConns + 1] = st:GetPropertyChangedSignal("Color"):Connect(function()
      onParrySignal("stroke-color")
    end)
    parryConns[#parryConns + 1] = st:GetPropertyChangedSignal("Enabled"):Connect(function()
      onParrySignal("stroke-enabled")
    end)
    parryConns[#parryConns + 1] = st:GetPropertyChangedSignal("Transparency"):Connect(function()
      onParrySignal("stroke-trans")
    end)
  end

  local function bindPunchButton(btn, nameLbl, cdLbl)
    clearParryConns()
    cachedBtn, cachedName, cachedCd = btn, nameLbl, cdLbl
    cachedIcon = btn:FindFirstChild("Icon") or btn:FindFirstChildWhichIsA("ImageLabel")
    pcall(function()
      parryConns[#parryConns + 1] = btn:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        onParrySignal("btn-bg")
      end)
      parryConns[#parryConns + 1] = btn.AttributeChanged:Connect(function()
        onParrySignal("btn-attr")
      end)
      if btn:IsA("ImageButton") then
        parryConns[#parryConns + 1] = btn:GetPropertyChangedSignal("ImageColor3"):Connect(function()
          onParrySignal("btn-img")
        end)
      end
      if cachedIcon and cachedIcon:IsA("ImageLabel") then
        parryConns[#parryConns + 1] = cachedIcon:GetPropertyChangedSignal("ImageColor3"):Connect(function()
          onParrySignal("icon-img")
        end)
      end
      if nameLbl and nameLbl:IsA("TextLabel") then
        parryConns[#parryConns + 1] = nameLbl:GetPropertyChangedSignal("TextColor3"):Connect(function()
          onParrySignal("name-col")
        end)
        parryConns[#parryConns + 1] = nameLbl.AttributeChanged:Connect(function()
          onParrySignal("name-attr")
        end)
      end
      if cdLbl and cdLbl:IsA("TextLabel") then
        parryConns[#parryConns + 1] = cdLbl:GetPropertyChangedSignal("Text"):Connect(function()
          if cdLbl.Text == "" or cdLbl.Text == "0" then
            onParrySignal("cd-ready")
          end
        end)
      end
      for _, ch in ipairs(btn:GetDescendants()) do
        if ch:IsA("UIStroke") then hookStroke(ch) end
      end
      parryConns[#parryConns + 1] = btn.DescendantAdded:Connect(function(desc)
        if desc:IsA("UIStroke") then
          hookStroke(desc)
          onParrySignal("stroke-added")
        end
      end)
    end)
  end

  local function resolveAndBindPunch()
    if not __PLUS_GEN_ALIVE then return end
    if cachedBtn and cachedBtn.Parent then return end
    local pg = localPlayer:FindFirstChild("PlayerGui")
    local mu = pg and pg:FindFirstChild("MainUI")
    local ac = mu and mu:FindFirstChild("AbilityContainer")
    local b = ac and ac:FindFirstChild("Punch")
    local n = b and b:FindFirstChild("AbilityName")
    local cd = b and b:FindFirstChild("CooldownTime")
    if b and n and cd then
      bindPunchButton(b, n, cd)
    end
  end

  resolveAndBindPunch()
  task.delay(1, resolveAndBindPunch)

  local apPgConn, apCharConn
  local pg = localPlayer:WaitForChild("PlayerGui", 10)
  if pg then
    apPgConn = pg.DescendantAdded:Connect(function(desc)
      if not __PLUS_GEN_ALIVE or _G.__NERG_KILLED then return end
      if desc.Name == "Punch" and desc.Parent and desc.Parent.Name == "AbilityContainer" then
        task.defer(resolveAndBindPunch)
      end
    end)
  end

  apCharConn = localPlayer.CharacterAdded:Connect(function()
    if not __PLUS_GEN_ALIVE or _G.__NERG_KILLED then return end
    task.delay(0.5, resolveAndBindPunch)
    task.delay(1.5, resolveAndBindPunch)
  end)

  rawset(_G, "__NERG_AUTOPUNCH_STOP", function()
    stopTransientWatcher()
    clearParryConns()
    if apPgConn then pcall(function() apPgConn:Disconnect() end) apPgConn = nil end
    if apCharConn then pcall(function() apCharConn:Disconnect() end) apCharConn = nil end
    cachedBtn, cachedName, cachedCd, cachedIcon = nil, nil, nil, nil
  end)

  rawset(_G, "__NERG_AUTOPUNCH_DIAG", function()
    return {
      alive = __PLUS_GEN_ALIVE,
      autoPunch = autoPunch,
      bound = (cachedBtn ~= nil and cachedBtn.Parent ~= nil),
      conns = #parryConns,
      parryReady = isParryState(),
      transient = (transientWatcher ~= nil),
    }
  end)

  rawset(_G, "__NERG_HDT_DIAG", function()
    local lc = 0
    if HDT_BLOCK_LOOKUP then for _ in pairs(HDT_BLOCK_LOOKUP) do lc += 1 end end
    return {
      alive = __PLUS_GEN_ALIVE,
      hdtKeo = hdtKeo,
      hdtSpeed = hdtSpeed,
      inProgress = HDT_InProgress,
      has_startHDT = (type(startHDT) == "function"),
      lookupCount = lc,
    }
  end)
end)

local visFolder = Instance.new("Folder")
visFolder.Name = "PlusVis_DLCHUB"
visFolder.Parent = workspaceService
local visPool, visUsed = {}, 0
local function getVisPart(n)
  local p = visPool[n]
  if not p then
    p = Instance.new("Part")
    p.Anchored, p.CanCollide, p.CanQuery, p.CanTouch, p.CastShadow = true, false, false, false, false
    p.Material = Enum.Material.Neon
    p.Parent = visFolder
    visPool[n] = p
  end
  return p
end
local function visHideAll()
  for n = 1, visUsed do
    visPool[n].Transparency = 1
  end
  visUsed = 0
end
local function f18() visHideAll() end
local function placeLine(a, b, color, trans, thick)
  local mag = (b - a).Magnitude
  local p = getVisPart(visUsed + 1)
  visUsed += 1
  if mag < 0.05 then
    p.Transparency = 1
    return
  end
  p.Size = Vector3.new(thick, thick, mag)
  p.CFrame = CFrame.lookAt((a + b) / 2, b)
  p.Color = color
  p.Transparency = trans
end
local function placeDot(pos, color, trans, size)
  local p = getVisPart(visUsed + 1)
  visUsed += 1
  p.Size = Vector3.new(size, size, size)
  p.CFrame = CFrame.new(pos)
  p.Color = color
  p.Transparency = trans
end
RAD_SEGMENTS = 24
radCircleLUT = {}
for m = 0, RAD_SEGMENTS do
  radCircleLUT[m] = Vector2.new(math.cos(m / RAD_SEGMENTS * 2 * math.pi), math.sin(m / RAD_SEGMENTS * 2 * math.pi))
end
visRayParams = RaycastParams.new()
visRayParams.FilterType = Enum.RaycastFilterType.Exclude
visRayParams.FilterDescendantsInstances = { visFolder }
local function getFloorY(pos)
  local hit = workspaceService:Raycast(pos, Vector3.new(0, -50, 0), visRayParams)
  if hit then
    return hit.Position.Y + 0.05
  end
  return pos.Y - 3
end
VIS_PURPLE = Color3.fromRGB(160, 80, 255)
VIS_RED = Color3.fromRGB(255, 80, 80)
VIS_GREEN = Color3.fromRGB(50, 255, 100)
VIS_GRAY = Color3.fromRGB(150, 150, 150)
local function visRotY(v, ang)
  local c, s = math.cos(ang), math.sin(ang)
  return Vector3.new(v.X * c + v.Z * s, 0, -v.X * s + v.Z * c)
end
local a742uVisAcc = 0
local setVisLoop
local a742uVisStep = function(delta930)
  if not __PLUS_GEN_ALIVE or _G.__NERG_KILLED then
    if a742uVisConn then a742uVisConn:Disconnect() a742uVisConn = nil end
    return
  end
  if not default then
    if visUsed > 0 then visHideAll() end
    if setVisLoop then setVisLoop(false) end
    return
  end
  if not localPlayer.Character then
    if visUsed > 0 then visHideAll() end
    return
  end
  a742uVisAcc += (delta930 or 0.016)
  if a742uVisAcc < 0.05 then return end
  a742uVisAcc = 0
  local myHRP = localPlayer.Character:FindFirstChild("HumanoidRootPart")
  if not myHRP then
    if visUsed > 0 then visHideAll() end
    return
  end
  local pf4 = workspaceService:FindFirstChild("Players")
  local killers4 = pf4 and pf4:FindFirstChild("Killers")
  if not killers4 then
    if visUsed > 0 then visHideAll() end
    return
  end
  visHideAll()
  local myPos = myHRP.Position
  for _, k in ipairs(killers4:GetChildren()) do
    local hrp9 = k:FindFirstChild("HumanoidRootPart")
    if hrp9 then
      local kpos = hrp9.Position
      local flatDist = Vector3.new(kpos.X - myPos.X, 0, kpos.Z - myPos.Z).Magnitude
      local inRange = (kpos - myPos).Magnitude <= (visionRange or 13.5) * 1.18
      local lookFlat = hrp9.CFrame.LookVector
      lookFlat = Vector3.new(lookFlat.X, 0, lookFlat.Z)
      lookFlat = (lookFlat.Magnitude > 0.01 and lookFlat.Unit) or Vector3.new(0, 0, -1)

      local inCone = false
      if v8 then
      if flatDist <= (visionRange or 13.5) * 1.18 then
        local cosA = flatDist > 0.01 and lookFlat:Dot(-Vector3.new(kpos.X - myPos.X, 0, kpos.Z - myPos.Z).Unit) or -1
        if cosA >= 0 and math.acos(math.clamp(cosA, -1, 1)) <= math.rad((visionAngle or 85) / 2) then
          local ch2 = localPlayer.Character
          if ch2 then
            local coneR = math.rad((visionAngle or 85) / 2)
            for _, pp in ipairs(ch2:GetChildren()) do
              if pp:IsA("BasePart") then
                local dp = Vector3.new(pp.Position.X - kpos.X, 0, pp.Position.Z - kpos.Z)
                local dm = dp.Magnitude
                if dm <= (visionRange or 13.5) * 1.18 and dm > 0.01 then
                  if math.acos(math.clamp(lookFlat:Dot(dp / dm), -1, 1)) <= coneR then
                    inCone = true
                    break
                  end
                end
              end
            end
          end
        end
      end
      end
      local rColor = inRange and VIS_RED or VIS_PURPLE
      local rTrans = inRange and 0.08 or 0.2
      local cColor = (not v8) and VIS_GRAY or (inCone and VIS_GREEN or VIS_PURPLE)
      local cTrans = inCone and 0.05 or 0.2
      local dotTrans = inCone and 0 or 0.1
      local dotSize = inCone and 0.55 or 0.35
      local floorY = getFloorY(kpos)
      local cy = Vector3.new(kpos.X, floorY + 0.1, kpos.Z)
      for m = 0, RAD_SEGMENTS - 1 do
        local a = radCircleLUT[m]
        local b = radCircleLUT[m + 1]
        placeLine(cy + Vector3.new(a.X, 0, a.Y) * (visionRange or 13.5) * 1.18, cy + Vector3.new(b.X, 0, b.Y) * (visionRange or 13.5) * 1.18, rColor, rTrans, 0.12)
      end
      local apex = kpos + lookFlat * 0.8
      local half = math.rad((visionAngle or 85) / 2)
      local wingL = visRotY(lookFlat, half) * (visionRange or 13.5)
      local wingR = visRotY(lookFlat, -half) * (visionRange or 13.5)
      local arc = (wingL + wingR)
      arc = (arc.Magnitude > 0.01 and arc.Unit or wingL.Unit) * (visionRange or 13.5) * 1.18
      placeLine(apex, apex + wingL, cColor, cTrans, 0.12)
      placeLine(apex, apex + wingR, cColor, cTrans, 0.12)
      placeLine(apex + wingL, apex + arc, cColor, cTrans, 0.12)
      placeLine(apex + wingR, apex + arc, cColor, cTrans, 0.12)
      placeDot(apex, cColor, dotTrans, dotSize)
      placeDot(apex + wingL, cColor, dotTrans, dotSize)
      placeDot(apex + wingR, cColor, dotTrans, dotSize)
      placeDot(apex + arc, cColor, dotTrans, dotSize)
    end
  end
end
setVisLoop = function(on)
  if on and not a742uVisConn then
    a742uVisAcc = 0
    a742uVisConn = runService.RenderStepped:Connect(a742uVisStep)
  elseif not on and a742uVisConn then
    a742uVisConn:Disconnect()
    a742uVisConn = nil
    if visUsed > 0 then visHideAll() end
  end
end
if default then setVisLoop(true) end

BLOCKABLE_ATTACKS = { "slash", "enragedslash", "stab", "attack", "punch", "swing", "golemslash" }
local function f19(animType3, p11)
  if not autoBlock then
    return
  end

  if not animType3 or not table.find(BLOCKABLE_ATTACKS, tostring(animType3):lower()) then
    return
  end

  if not p11 or not p11.Parent then
    return
  end

  local blockReadyNow = f12()
  if not blockReadyNow and not (autoCharge and chargeReady()) then
    return
  end

  if v36[p11] and tick() < v36[p11] then
    return
  end

  local character6 = localPlayer.Character
  local humanoidRootPart7 = character6 and character6:FindFirstChild("HumanoidRootPart")

  if not humanoidRootPart7 then
    return
  end

  local v97 = p11

  v30[v97] = tick()

  task.delay(0.35, function()
    if v30[v97] and tick() - v30[v97] >= 0.35 then
      v30[v97] = nil
    end
  end)

  local humanoidRootPart8 = v97:FindFirstChild("HumanoidRootPart")

  if not humanoidRootPart8 then
    return
  end

  if not a742pHitboxMode or not blockReadyNow then
    local v98 = ((f14(v97) or humanoidRootPart8.Position) - humanoidRootPart7.Position).Magnitude ^ 2

    local v102 = blockReadyNow and ((visionRange or 13.5) * 1.2) or (chargeMaxRange or 20)

    if v98 > v102 * v102 then
      return
    elseif v8 then
      local toPlayer = humanoidRootPart7.Position - humanoidRootPart8.Position
      local flatUnit = toPlayer.Magnitude > 0.001 and toPlayer.Unit or humanoidRootPart8.CFrame.LookVector
      local dot3 = humanoidRootPart8.CFrame.LookVector:Dot(flatUnit)
      local v105 = math.cos(math.rad(visionAngle / 2))
      if not (v98 < 25 or dot3 >= v105) then
        return
      end
    end
  end

  f17(v97)

  v36[p11] = tick() + 0.5
end

A655_SWING = {}

local M1_ROLES_BY_KILLER = {
  Azure = { "SlashWindup", "SmashWindup", "Slash", "Smash" },
  Nosferatu = { "SlashGround", "Swing", "Bite", "Slash" },
  ["#Nosferatwo"] = { "SlashGround", "Swing", "Bite", "Slash" },
  Sixer = { "Swing", "Chomp", "Bite", "Slash" },
}

local function a655ExtractIds(val, roleName, out, depth)
  if (depth or 0) > 3 or val == nil then return end
  if type(val) == "string" or type(val) == "number" then
    local id = tostring(val):match("%d+")
    if id and not out[id] then out[id] = roleName end
  elseif typeof(val) == "Instance" and val:IsA("Sound") then
    local id = tostring(val.SoundId):match("%d+")
    if id and not out[id] then out[id] = roleName end
  elseif type(val) == "table" then
    for _, subv in pairs(val) do
      a655ExtractIds(subv, roleName, out, (depth or 0) + 1)
    end
  end
end

local function a655ScanM1(kname)
  local as = replicatedStorage:FindFirstChild("Assets")
  local ks = as and as:FindFirstChild("Killers")
  local base = (kname or ""):gsub("^[!#]", "")
  local dir = ks and (ks:FindFirstChild(kname or "") or ks:FindFirstChild(base))
  local cfg = dir and dir:FindFirstChild("Config")
  if not cfg then return nil end
  local ok, tab = pcall(function() return require(cfg) end)
  if not ok or type(tab) ~= "table" then return nil end
  local so = (type(tab.Sounds) == "table" and tab.Sounds) or tab
  local order = M1_ROLES_BY_KILLER[kname] or M1_ROLES_BY_KILLER[base] or { "Swing", "Bite", "Slash", "SlashGround" }
  local out = {}
  for _, role in ipairs(order) do
    a655ExtractIds(so[role], role, out, 0)
  end
  if next(out) then return out end
  return nil
end

local function a655SkinM1(basename, skin)
  local sd = replicatedStorage:FindFirstChild("Assets") and replicatedStorage.Assets:FindFirstChild("Skins")
  local kk2 = sd and sd:FindFirstChild("Killers")
  local kd = kk2 and kk2:FindFirstChild(basename)
  local sdir = kd and kd:FindFirstChild(skin)
  local scfg = sdir and sdir:FindFirstChild("Config")
  if not scfg then return nil end
  local ok2, stab = pcall(function() return require(scfg) end)
  local sso = (ok2 and type(stab) == "table" and type(stab.Sounds) == "table") and stab.Sounds or nil
  if not sso then return nil end
  local order = M1_ROLES_BY_KILLER[basename] or { "Swing", "Bite", "Slash", "SlashGround" }
  local out = {}
  for _, role2 in ipairs(order) do
    a655ExtractIds(sso[role2], role2, out, 0)
  end
  if next(out) then return out end
  return nil
end
local function a742oAnimIdsFromConfig(cfgInst, order)
	local out = {}
	if not cfgInst then return out end
	local ok, tab = pcall(require, cfgInst)
	if not ok or type(tab) ~= "table" or type(tab.Animations) ~= "table" then return out end
	for _, role in ipairs(order) do
		local v = tab.Animations[role]
		local function push(x, depth)
			if type(x) == "string" then
				local id = x:match("%d+")
				if id then out[#out + 1] = id end
			elseif type(x) == "table" and (depth or 0) < 3 then
				for _, vv in pairs(x) do push(vv, (depth or 0) + 1) end
			end
		end
		push(v, 0)
	end
	return out
end
local function a742oCollectAnimIds(kname, skin)
	local order = { "Attack", "Slash", "SlashAir", "EnragedSlash", "Bite", "Stab", "SlashGround", "GolemSlash" }
	local as = replicatedStorage:FindFirstChild("Assets")
	local ks = as and as:FindFirstChild("Killers")
	local base = (kname or ""):gsub("^[!#]", "")
	local dir = ks and (ks:FindFirstChild(kname or "") or ks:FindFirstChild(base))
	local out = a742oAnimIdsFromConfig(dir and dir:FindFirstChild("Config"), order)
	if skin and skin ~= "" then
		local sd = as and as:FindFirstChild("Skins")
		local kd = sd and sd:FindFirstChild("Killers")
		local sdir = kd and kd:FindFirstChild(base)
		local skinDir = sdir and sdir:FindFirstChild(skin)
		local so = a742oAnimIdsFromConfig(skinDir and skinDir:FindFirstChild("Config"), order)
		if #so > 0 then
			for _, sid in ipairs(so) do out[#out + 1] = sid end
		end
	end
	return out
end
local function a655ScanRound()
  local newMap = {}
  A655_SKINS = {}
  local pf = workspaceService:FindFirstChild("Players")
  local kf = pf and pf:FindFirstChild("Killers")
  if not kf then return end
  for _, m in ipairs(kf:GetChildren()) do
    local baseIds = a655ScanM1(m.Name)
    local skin = m:GetAttribute("SkinName")
    local hasAny = false
    if baseIds then
      for id, role in pairs(baseIds) do
        newMap[id] = m.Name
        if skin and skin ~= "" then A655_SKINS[id] = skin end
        A663_LOG("SCAN", id, m.Name, role)
        hasAny = true
      end
    end
    if skin and skin ~= "" then
      local basename = m.Name:gsub("^[!#]", "")
      local skinIds = a655SkinM1(basename, skin)
      if skinIds then
        for sid, srole in pairs(skinIds) do
          newMap[sid] = m.Name
          A655_SKINS[sid] = skin
          hasAny = true
          if v2.get("a720Telemetry", false) then print("[NERG] scan-skin: killer=" .. m.Name .. " skin=" .. skin .. " role=" .. tostring(srole) .. " m1-id=" .. sid) end
        end
      end
    end
    if not hasAny then
      if v2.get("a720Telemetry", false) then print("[NERG] scan-miss: " .. m.Name .. " — no M1 voice, no block (skill-friendly)") end
    end
  end
  A655_SWING = newMap
  local animMap = {}
  for _, m in ipairs(kf:GetChildren()) do
    local okA, idsA = pcall(a742oCollectAnimIds, m.Name, m:GetAttribute("SkinName"))
    if okA and type(idsA) == "table" then
      for _, aid in ipairs(idsA) do animMap[tostring(aid)] = m.Name end
      if v2.get("a720Telemetry", false) and #idsA > 0 then print("[NERG] anim-scan: " .. m.Name .. " m1-anims=" .. #idsA) end
    end
  end
  A742o_ANIM = animMap
end
local function a655ResolveKiller(inst)
  local pf = workspaceService:FindFirstChild("Players")
  local ks = pf and pf:FindFirstChild("Killers")
  if not ks then return nil end
  local cur = inst
  while cur and cur ~= workspaceService do
    if cur.Parent == ks then return cur end
    cur = cur.Parent
  end
  return nil
end

A663_LOG = function(kind, sId, killerName, roleName)
  if not v2.get("a720Telemetry", false) then return end
  local skin = (A655_SKINS and sId and A655_SKINS[tostring(sId)]) or "none"
  local base = "?"
  if killerName then
    base = tostring(killerName)
  end
  print("[NERG] " .. tostring(kind) .. " · id=" .. tostring(sId) .. " · role=" .. tostring(roleName) .. " · killer=" .. base .. " · skin=" .. skin)
end
a663Seen = {}
a655EarConn = nil
A655_SKINS = nil
a665UiKey = nil
a742oAnimM1 = v2.get("a742oAnimM1", false)
A742o_ANIM = nil
a742jConn = nil
a742jGui = nil
a742jPaint = nil
killerSoundConns = {}

a655FolderConns = {}

clearKillerSoundConns = function()
  for k, v in pairs(killerSoundConns) do
    killerSoundConns[k] = nil
    if type(v) == "function" then
      pcall(v)
    else
      pcall(function() v:Disconnect() end)
    end
  end
  pcall(function()
    local pf = workspaceService:FindFirstChild("Players")
    local kf = pf and pf:FindFirstChild("Killers")
    if kf then
      for _, d in ipairs(kf:GetDescendants()) do
        if d:IsA("Sound") then
          d:SetAttribute("__A655_ARMED", nil)
          d:SetAttribute("__A655_WAIT_ID", nil)
        end
      end
    end
  end)
end

a655ArmSound = function(d)
  if not __PLUS_GEN_ALIVE or _G.__NERG_KILLED then return end
  if not (d and d:IsA("Sound") and d.Parent) then return end
  local id = tostring(d.SoundId):match("%d+")
  if not id then
    if not d:GetAttribute("__A655_WAIT_ID") then
      d:SetAttribute("__A655_WAIT_ID", true)
      local waitConn, waitAnc
      local function dropWait()
        killerSoundConns[d] = nil
        if waitConn then pcall(function() waitConn:Disconnect() end) waitConn = nil end
        if waitAnc then pcall(function() waitAnc:Disconnect() end) waitAnc = nil end
        if d and d.Parent then pcall(function() d:SetAttribute("__A655_WAIT_ID", nil) end) end
      end
      killerSoundConns[d] = dropWait
      waitConn = d:GetPropertyChangedSignal("SoundId"):Connect(function()
        local nextId = tostring(d.SoundId):match("%d+")
        if nextId then
          dropWait()
          a655ArmSound(d)
        end
      end)
      waitAnc = d.AncestryChanged:Connect(function(_, parent)
        if not parent then dropWait() end
      end)
    end
    return
  end
  if not A655_SWING[id] then return end
  if not a663Seen[id] then a663Seen[id] = true A663_LOG("FIRST", id, A655_SWING[id], "swing") end
  if d:GetAttribute("__A655_ARMED") then return end
  A663_LOG("ARM", id, A655_SWING[id], "swing")
  d:SetAttribute("__A655_ARMED", true)
  local lastStrikeAt = 0
  local function strike663(nhan)
    if not __PLUS_GEN_ALIVE or _G.__NERG_KILLED or a742oAnimM1 then return end
    local curId = tostring(d.SoundId):match("%d+") or id
    if not (curId and A655_SWING[curId]) then return end
    local nowS = os.clock()
    if nowS - lastStrikeAt < 0.08 then return end
    lastStrikeAt = nowS
    local km663 = a655ResolveKiller(d)
    A663_LOG(nhan or (autoBlock and "FIRE" or "NGAT(AB-off)"), curId, km663 and km663.Name or A655_SWING[curId], "swing")
    if not autoBlock then return end

    if km663 then
      if a742pHitboxMode and f12() then a742pSpawnBox(km663) else task.spawn(f19, "swing", km663) end
    end
  end
  local sig, sigPlayed, sigAnc
  local function dropArmed()
    killerSoundConns[d] = nil
    if sig then pcall(function() sig:Disconnect() end) sig = nil end
    if sigPlayed then pcall(function() sigPlayed:Disconnect() end) sigPlayed = nil end
    if sigAnc then pcall(function() sigAnc:Disconnect() end) sigAnc = nil end
    if d and d.Parent then
      pcall(function()
        d:SetAttribute("__A655_ARMED", nil)
        d:SetAttribute("__A655_WAIT_ID", nil)
      end)
    end
  end
  killerSoundConns[d] = dropArmed
  sig = d:GetPropertyChangedSignal("IsPlaying"):Connect(function()
    if d.IsPlaying then strike663(nil) end
  end)
  sigPlayed = d.Played:Connect(function()
    strike663("PLAYED")
  end)
  sigAnc = d.AncestryChanged:Connect(function(_, parent)
    if not parent then dropArmed() end
  end)
  if d.IsPlaying then strike663(nil) end
end

a655MountEar = function()
  if a655EarConn then a655EarConn:Disconnect() a655EarConn = nil end
  if not __PLUS_GEN_ALIVE or _G.__NERG_KILLED then return end
  local pf = workspaceService:FindFirstChild("Players")
  local kf = pf and pf:FindFirstChild("Killers")
  if kf then
    a655EarConn = kf.DescendantAdded:Connect(function(d)
      if not __PLUS_GEN_ALIVE or _G.__NERG_KILLED then return end
      if d:IsA("Sound") then task.spawn(a655ArmSound, d) end
    end)
    for _, d in ipairs(kf:GetDescendants()) do
      if d:IsA("Sound") then task.spawn(a655ArmSound, d) end
    end
  end
end

do
  local curKillerFolder = nil
  local b14SubConns = {}
  local function dropB14SubConns()
    for i = #b14SubConns, 1, -1 do
      local c = b14SubConns[i]
      b14SubConns[i] = nil
      pcall(function() c:Disconnect() end)
    end
  end
  local function hookKiller(k)
    if k == curKillerFolder and k and k.Parent and k:IsDescendantOf(workspaceService) then return end
    dropB14SubConns()
    curKillerFolder = k
    clearKillerSoundConns()
    if not (k and k.Parent and k:IsDescendantOf(workspaceService)) then
      a655ScanRound()
      return
    end
    a655ScanRound()
    a655MountEar()
    b14SubConns[#b14SubConns + 1] = k.ChildAdded:Connect(function()
      if not __PLUS_GEN_ALIVE or _G.__NERG_KILLED then return end
      a655ScanRound()
      task.delay(0.2, function()
        if __PLUS_GEN_ALIVE and not _G.__NERG_KILLED then a655MountEar() end
      end)
      task.delay(1, function()
        if __PLUS_GEN_ALIVE and not _G.__NERG_KILLED then a655ScanRound() end
      end)
    end)
    b14SubConns[#b14SubConns + 1] = k.ChildRemoved:Connect(function(removedChild)
      if not __PLUS_GEN_ALIVE or _G.__NERG_KILLED then return end
      if #k:GetChildren() == 0 then
        clearKillerSoundConns()
      else
        for s, dropFn in pairs(killerSoundConns) do
          if not (s and s.Parent and s:IsDescendantOf(workspaceService)) or (removedChild and s:IsDescendantOf(removedChild)) then
            killerSoundConns[s] = nil
            if type(dropFn) == "function" then
              pcall(dropFn)
            else
              pcall(function() dropFn:Disconnect() end)
            end
          end
        end
      end
      a655ScanRound()
    end)
    b14SubConns[#b14SubConns + 1] = k.AncestryChanged:Connect(function(_, parent)
      if not parent or not k:IsDescendantOf(workspaceService) then
        if curKillerFolder == k then
          dropB14SubConns()
          curKillerFolder = nil
          clearKillerSoundConns()
          a655ScanRound()
        end
      end
    end)
  end
  local curPlayersFolder = nil
  local b14PfConns = {}
  local function dropB14PfConns()
    for i = #b14PfConns, 1, -1 do
      local c = b14PfConns[i]
      b14PfConns[i] = nil
      pcall(function() c:Disconnect() end)
    end
  end
  local function bindPlayersFolder(pf)
    if pf == curPlayersFolder and pf and pf.Parent then return end
    dropB14PfConns()
    curPlayersFolder = pf
    if not (pf and pf.Parent) then return end
    local kf = pf:FindFirstChild("Killers")
    if kf then hookKiller(kf) end
    b14PfConns[#b14PfConns + 1] = pf.ChildAdded:Connect(function(c)
      if not __PLUS_GEN_ALIVE or _G.__NERG_KILLED then return end
      if c.Name == "Killers" then
        hookKiller(c)
        task.delay(0.5, function()
          if not __PLUS_GEN_ALIVE or _G.__NERG_KILLED then return end
          local k2 = pf:FindFirstChild("Killers")
          if k2 then
            a655ScanRound()
            a655MountEar()
          end
        end)
      end
    end)
    b14PfConns[#b14PfConns + 1] = pf.ChildRemoved:Connect(function(c)
      if not __PLUS_GEN_ALIVE or _G.__NERG_KILLED then return end
      if c == curKillerFolder or c.Name == "Killers" then
        hookKiller(pf:FindFirstChild("Killers"))
      end
    end)
  end
  local pf0 = workspaceService:FindFirstChild("Players")
  if pf0 then bindPlayersFolder(pf0) end
  local wsConn = workspaceService.ChildAdded:Connect(function(c)
    if not __PLUS_GEN_ALIVE or _G.__NERG_KILLED then return end
    if c.Name == "Players" then
      task.defer(bindPlayersFolder, c)
    end
  end)
  a655FolderConns[#a655FolderConns + 1] = {
    Disconnect = function()
      if wsConn then pcall(function() wsConn:Disconnect() end) wsConn = nil end
      dropB14PfConns()
      dropB14SubConns()
      curPlayersFolder = nil
      curKillerFolder = nil
    end,
  }
  local n = 0
  for _ in pairs(A655_SWING) do n += 1 end
  if v2.get("a720Telemetry", false) then print("[NERG] m1-round ear: scoped to Killers (" .. n .. " M1 ids) · zero-leak · telemetry=ON") end
end

AllAnimations = { ["Default Roblox"] = { ["Idle"] = "http://www.roblox.com/asset/?id=180435571",
  ["Walk"] = "http://www.roblox.com/asset/?id=180426354", ["Run"] = "http://www.roblox.com/asset/?id=180426354" } }
do
  local RS = game:GetService("ReplicatedStorage")
  local AssetsFolder = RS:FindFirstChild("Assets")
  for _ = 1, 30 do if AssetsFolder then break end task.wait(0.3) AssetsFolder = RS:FindFirstChild("Assets") end
  local sets = {}
  for _, fname in ipairs({ "Killers", "Survivors", "Skins" }) do
    local f = AssetsFolder and AssetsFolder:FindFirstChild(fname)
    if f then for _, d in ipairs(f:GetDescendants()) do
      if d:IsA("ModuleScript") and d.Name == "Config" then sets[#sets + 1] = d end
    end end
  end
  for _, m in ipairs(sets) do
    if not m.Parent:IsA("Model") then
      local ok, cfg = pcall(require, m)
      local anims = ok and cfg and cfg.Animations
      if anims then AllAnimations[m.Parent.Name] = anims end
    end
  end
end
animEarConns = setmetatable({}, { __mode = "k" })
a742pSndTouch = setmetatable({}, { __mode = "k" })
a742pSndConns = setmetatable({}, { __mode = "k" })
a742pCharConns = setmetatable({}, { __mode = "k" })
do
  local animEarMounting = setmetatable({}, { __mode = "k" })

  local function unhookAnimSound(s)
    local c0 = a742pSndConns[s]
    if c0 then pcall(function() c0:Disconnect() end) a742pSndConns[s] = nil end
    a742pSndTouch[s] = nil
  end

  local function hookAnimSound(s)
    if s and s:IsA("Sound") and s.Parent and s:IsDescendantOf(workspaceService) and not a742pSndConns[s] then
      a742pSndTouch[s] = 0
      local cId = s:GetPropertyChangedSignal("SoundId"):Connect(function()
        a742pSndTouch[s] = os.clock()
      end)
      local cAnc
      cAnc = s.AncestryChanged:Connect(function(_, parent)
        if not parent or not s:IsDescendantOf(workspaceService) then
          unhookAnimSound(s)
        end
      end)
      a742pSndConns[s] = {
        Disconnect = function()
          if cId then pcall(function() cId:Disconnect() end) cId = nil end
          if cAnc then pcall(function() cAnc:Disconnect() end) cAnc = nil end
        end,
      }
    end
  end

  local function unmountAnimEar(k)
    local pf = workspaceService:FindFirstChild("Players")
    local kf = pf and pf:FindFirstChild("Killers")
    if k then
      animEarMounting[k] = nil
      pcall(function() k:SetAttribute("__A641_ANIM_EAR", nil) end)
      if animEarConns[k] then pcall(function() animEarConns[k]:Disconnect() end) animEarConns[k] = nil end
      if a742pCharConns[k] then pcall(function() a742pCharConns[k]:Disconnect() end) a742pCharConns[k] = nil end
    end
    for k0, cA in pairs(animEarConns) do
      if not (k0 and k0.Parent and kf and k0:IsDescendantOf(kf)) then
        animEarMounting[k0] = nil
        pcall(function() k0:SetAttribute("__A641_ANIM_EAR", nil) end)
        pcall(function() cA:Disconnect() end)
        animEarConns[k0] = nil
      end
    end
    for k0, cC in pairs(a742pCharConns) do
      if not (k0 and k0.Parent and kf and k0:IsDescendantOf(kf)) then
        animEarMounting[k0] = nil
        pcall(function() k0:SetAttribute("__A641_ANIM_EAR", nil) end)
        pcall(function() cC:Disconnect() end)
        a742pCharConns[k0] = nil
      end
    end
    for s in pairs(a742pSndConns) do
      if not (s and s.Parent and kf and s:IsDescendantOf(kf)) or (k and s:IsDescendantOf(k)) then
        unhookAnimSound(s)
      end
    end
  end

  local function mountAnimEar(k)
    if not (k and k.Parent) or k:GetAttribute("__A641_ANIM_EAR") or animEarMounting[k] then return end
    animEarMounting[k] = true
    local hum = k:FindFirstChildOfClass("Humanoid") or k:WaitForChild("Humanoid", 5)
    local an = hum and (hum:FindFirstChildOfClass("Animator") or hum:WaitForChild("Animator", 5))
    if not animEarMounting[k] then return end
    animEarMounting[k] = nil
    local pf = workspaceService:FindFirstChild("Players")
    local kf = pf and pf:FindFirstChild("Killers")
    if not (hum and an and k.Parent and kf and k:IsDescendantOf(kf) and __PLUS_GEN_ALIVE and not _G.__NERG_KILLED) then return end
    if k:GetAttribute("__A641_ANIM_EAR") then return end
    if animEarConns[k] then pcall(function() animEarConns[k]:Disconnect() end) animEarConns[k] = nil end
    if a742pCharConns[k] then pcall(function() a742pCharConns[k]:Disconnect() end) a742pCharConns[k] = nil end
    k:SetAttribute("__A641_ANIM_EAR", true)
    animEarConns[k] = an.AnimationPlayed:Connect(function(Track)
      if not a742oAnimM1 then return end
      local aid = Track and Track.Animation and tostring(Track.Animation.AnimationId):match("%d+")
      if aid and A742o_ANIM and A742o_ANIM[aid] and autoBlock then
        A663_LOG("ANIM-FIRE", aid, k.Name, "anim-m1")
        local nowL = os.clock()
        for s, t0 in pairs(a742pSndTouch) do
          if not s.Parent or not s:IsDescendantOf(workspaceService) then
            unhookAnimSound(s)
          elseif t0 > 0 and nowL - t0 <= 0.6 and s:IsDescendantOf(k) and s.SoundId ~= "" then
            local sidL = tostring(s.SoundId):match("%d+")
            if sidL and A655_SWING and A655_SWING[sidL] ~= k.Name then
              A655_SWING[sidL] = k.Name
              A663_LOG("SOUND-LEARN", sidL, k.Name, "anim-pair")
            end
          end
        end
        if a742pHitboxMode and f12() then a742pSpawnBox(k) else task.spawn(f19, "swing", k) end
      end
    end)
    for _, d in ipairs(k:GetDescendants()) do hookAnimSound(d) end
    local cDesc = k.DescendantAdded:Connect(function(d)
      if d:IsA("Sound") then
        task.defer(hookAnimSound, d)
      end
    end)
    local cAnc
    cAnc = k.AncestryChanged:Connect(function(_, parent)
      local pfNow = workspaceService:FindFirstChild("Players")
      local kfNow = pfNow and pfNow:FindFirstChild("Killers")
      if not parent or not (kfNow and k:IsDescendantOf(kfNow)) then
        unmountAnimEar(k)
      end
    end)
    a742pCharConns[k] = {
      Disconnect = function()
        if cDesc then pcall(function() cDesc:Disconnect() end) cDesc = nil end
        if cAnc then pcall(function() cAnc:Disconnect() end) cAnc = nil end
      end,
    }
  end

  local function f22()
    local curAnimKf = nil
    local animKfConns = {}
    local animPfConns = {}
    local curAnimPf = nil
    local function dropAnimKfConns()
      for i = #animKfConns, 1, -1 do
        local c = animKfConns[i]
        animKfConns[i] = nil
        pcall(function() c:Disconnect() end)
      end
    end
    local function dropAnimPfConns()
      for i = #animPfConns, 1, -1 do
        local c = animPfConns[i]
        animPfConns[i] = nil
        pcall(function() c:Disconnect() end)
      end
    end
    local function bindAnimKillers(killers3)
      if killers3 == curAnimKf and killers3 and killers3.Parent and killers3:IsDescendantOf(workspaceService) then return end
      dropAnimKfConns()
      curAnimKf = killers3
      pcall(unmountAnimEar, nil)
      if not (killers3 and killers3.Parent and killers3:IsDescendantOf(workspaceService)) then return end
      for _, k in ipairs(killers3:GetChildren()) do
        task.spawn(function() pcall(mountAnimEar, k) end)
      end
      animKfConns[#animKfConns + 1] = killers3.ChildAdded:Connect(function(child)
        if not __PLUS_GEN_ALIVE or _G.__NERG_KILLED then return end
        task.wait(0.1)
        if child.Parent and child:IsDescendantOf(workspaceService) and __PLUS_GEN_ALIVE and not _G.__NERG_KILLED then
          pcall(mountAnimEar, child)
        end
      end)
      animKfConns[#animKfConns + 1] = killers3.ChildRemoved:Connect(function(child)
        pcall(unmountAnimEar, child)
      end)
      animKfConns[#animKfConns + 1] = killers3.AncestryChanged:Connect(function(_, parent)
        if not parent or not killers3:IsDescendantOf(workspaceService) then
          if curAnimKf == killers3 then
            dropAnimKfConns()
            curAnimKf = nil
            pcall(unmountAnimEar, nil)
          end
        end
      end)
    end
    local function bindAnimPlayers(players2)
      if players2 == curAnimPf and players2 and players2.Parent then return end
      dropAnimPfConns()
      curAnimPf = players2
      if not (players2 and players2.Parent) then return end
      local k0 = players2:FindFirstChild("Killers")
      if k0 then bindAnimKillers(k0) end
      animPfConns[#animPfConns + 1] = players2.ChildAdded:Connect(function(c)
        if not __PLUS_GEN_ALIVE or _G.__NERG_KILLED then return end
        if c.Name == "Killers" then
          task.defer(bindAnimKillers, c)
        end
      end)
      animPfConns[#animPfConns + 1] = players2.ChildRemoved:Connect(function(c)
        if not __PLUS_GEN_ALIVE or _G.__NERG_KILLED then return end
        if c == curAnimKf or c.Name == "Killers" then
          bindAnimKillers(players2:FindFirstChild("Killers"))
        end
      end)
    end
    local pfNow = workspaceService:FindFirstChild("Players")
    if pfNow then bindAnimPlayers(pfNow) end
    local wsAnimConn = workspaceService.ChildAdded:Connect(function(c)
      if not __PLUS_GEN_ALIVE or _G.__NERG_KILLED then return end
      if c.Name == "Players" then
        task.defer(bindAnimPlayers, c)
      end
    end)
    a655FolderConns[#a655FolderConns + 1] = {
      Disconnect = function()
        if wsAnimConn then pcall(function() wsAnimConn:Disconnect() end) wsAnimConn = nil end
        dropAnimPfConns()
        dropAnimKfConns()
        curAnimPf = nil
        curAnimKf = nil
      end,
    }
  end
  pcall(f22)
end
-- A742p: AB detect "Hitbox đen" (mode-Anti-Bait) — nghe-đòn ⇒ sinh-hộp-kích-thước-TỔ trước killer; block CHỈ-khi-hộp-chạm-người
A742P_SIZES = { Noli = Vector3.new(5, 7, 8), Slasher = Vector3.new(5, 7, 8), c00lkidd = Vector3.new(5, 7, 5.5), ["1x1x1x1"] = Vector3.new(5, 7, 8), JohnDoe = Vector3.new(5, 7, 8), Sixer = Vector3.new(5, 7, 8), Nosferatu = Vector3.new(5, 7, 8), Azure = Vector3.new(5, 7, 8.5) }
A742P_ZOFF = { Noli = -1.7, Slasher = -2.1, c00lkidd = -0.3, ["1x1x1x1"] = -2, JohnDoe = -2.5, Sixer = 0, Nosferatu = -2, Azure = -2 }
local A742P_FALLBACK = Vector3.new(4.5, 6, 7.5)
local A742P_COLOR = Color3.fromRGB(0, 100, 225)
local A742P_OUTLINE = Color3.fromRGB(0, 70, 190)
a742pLenScale = v2.get("a742pLenScale", 1)
a742pWidScale = v2.get("a742pWidScale", 1)
a742pBoxes, a742pHeart = {}, nil
local a742pOverlap = OverlapParams.new()
a742pOverlap.FilterType = Enum.RaycastFilterType.Include
local a742pFolder = Instance.new("Folder")
a742pFolder.Name = "NergABBoxes"
a742pFolder.Parent = workspaceService
do
  local lastOverlapChar = nil
  local overlapFilter = {}
  local function syncOverlapChar()
    local ch = localPlayer.Character
    if ch ~= lastOverlapChar then
      lastOverlapChar = ch
      overlapFilter[1] = ch
      a742pOverlap.FilterDescendantsInstances = ch and overlapFilter or {}
    end
  end
  local function a742pEvalBoxNow(kb, bb, nowT)
    local h9 = kb and kb:FindFirstChild("HumanoidRootPart")
    if not h9 then return end
    syncOverlapChar()
    local look = h9.CFrame.LookVector
    local flat = Vector3.new(look.X, 0, look.Z)
    flat = (flat.Magnitude > 0.01 and flat.Unit) or Vector3.new(0, 0, -1)
    local pos = h9.Position + flat * (bb.zoff + 2 + (bb.part.Size.Z - (bb.baseZ or bb.part.Size.Z)) / 2)
    bb.part.CFrame = CFrame.lookAt(pos, pos + flat)
    local touches = #workspaceService:GetPartsInPart(bb.part, a742pOverlap) > 0
    if bb.hl then bb.hl.Color3 = touches and VIS_RED or A742P_OUTLINE end
    if touches and not bb.fired then
      bb.fired = true
      bb.firedAt = nowT
      A663_LOG("GEOM-FIRE", kb.Name, kb.Name, "hitbox")
      task.spawn(f19, "swing", kb)
    end
  end
  function a742pSpawnBox(k)
    if not (k and k.Parent) then return end
    local hrp = k:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local base = (k.Name or ""):gsub("^[!#]", "")
    local now = os.clock()
    local a742pB = A742P_SIZES[base] or A742P_FALLBACK
    local targetSize = Vector3.new(a742pB.X * (a742pWidScale or 1), a742pB.Y, a742pB.Z * (a742pLenScale or 1))
    local b = a742pBoxes[k]
    if b and b.part and b.part.Parent then
      b.untilT = now + 0.55
      b.part.Size = targetSize
      if b.hl then b.hl.Size = targetSize end
      if b.firedAt and now - b.firedAt >= 0.5 then b.fired, b.firedAt = nil, nil end
      a742pEvalBoxNow(k, b, now)
      return
    end
    local part = Instance.new("Part")
    part.Name = "NergABHitbox"
    part.Anchored, part.CanCollide, part.CanTouch, part.CanQuery, part.CastShadow = true, false, false, false, false
    part.Material = Enum.Material.ForceField
    part.Color = A742P_COLOR
    part.Transparency = 0.25
    part.Size = targetSize
    local hl = Instance.new("BoxHandleAdornment")
    hl.Name = "NergABOutline"
    hl.Adornee = part
    hl.Size = targetSize
    hl.Color3 = A742P_OUTLINE
    hl.Transparency = 0.55
    hl.AlwaysOnTop = true
    hl.ZIndex = 5
    hl.Parent = part
    part.Parent = a742pFolder
    local newBox = { part = part, hl = hl, untilT = now + 0.55, zoff = A742P_ZOFF[base] or -1.2, baseZ = a742pB.Z, fired = nil, firedAt = nil }
    a742pBoxes[k] = newBox
    A663_LOG("GEOM-BOX", base, k.Name, "hitbox")
    a742pEvalBoxNow(k, newBox, now)
    if not a742pHeart then
      a742pHeart = runService.Heartbeat:Connect(function()
        if not __PLUS_GEN_ALIVE or _G.__NERG_KILLED then
          if a742pHeart then a742pHeart:Disconnect() a742pHeart = nil end
          return
        end
        syncOverlapChar()
        local now2 = os.clock()
        for kb, bb in pairs(a742pBoxes) do
          if not (kb and kb.Parent) or now2 > bb.untilT then
            pcall(function() bb.part:Destroy() end)
            a742pBoxes[kb] = nil
          else
            a742pEvalBoxNow(kb, bb, now2)
          end
        end
        if next(a742pBoxes) == nil and a742pHeart then
          a742pHeart:Disconnect()
          a742pHeart = nil
        end
      end)
    end
  end
  function a742pClearBoxes()
    for kb, bb in pairs(a742pBoxes) do pcall(function() bb.part:Destroy() end) end
    a742pBoxes = {}
    lastOverlapChar = nil
    if a742pHeart then a742pHeart:Disconnect() a742pHeart = nil end
    if a742pFolder and a742pFolder.Parent then
      for _, c in ipairs(a742pFolder:GetChildren()) do c:Destroy() end
    end
  end
end
do
	local RunService = runService
	local Players = players
	local localPlayer = localPlayer
	assets = replicatedStorage:FindFirstChild("Assets")
	local CoreGui = game:GetService("CoreGui")
	local tbl = {
		EspKillerColor = Color3.fromRGB(255, 80, 80),
		EspSurvivorsColor = Color3.fromRGB(90, 255, 130),
		EspKillerSupportColor = Color3.fromRGB(255, 150, 60),
		HFillTransparency = 0.25,
		DisableOutline = 0,
		EspTextSize = 14,
		EspIconSize = 50,
		PlayersTagsEsp = false,
		TagsOptions = { Name = true, Role = true, Health = true, Distance = true, Stamina = true, Velocity = true, Abilities = true },
	}
	forsakenFK = forsakenFK or {}
	do
		local guiRoot = nil
		local function ensureGui()
			if guiRoot and guiRoot.Parent then return guiRoot end
			local ok, hui = pcall(function() return (gethui and gethui()) or game:GetService("CoreGui") end)
			local g = Instance.new("ScreenGui")
			g.Name = "NergFK_TextTags"
			g.ResetOnSpawn = false
			g.IgnoreGuiInset = true
			pcall(function() g.DisplayOrder = 100 end)
			g.Parent = (ok and hui) or game:GetService("CoreGui")
			g:SetAttribute("GEN", 4)
			guiRoot = g
			return g
		end
		forsakenFK.textTag = function()
			local g = ensureGui()
			local tl = Instance.new("TextLabel")
			tl.BackgroundTransparency = 1
			tl.AutomaticSize = Enum.AutomaticSize.XY
			tl.Size = UDim2.new(0, 0, 0, 0)
			tl.Font = Enum.Font.Nunito
			pcall(function() tl.FontFace = Font.new("rbxasset://fonts/families/Balthazar.json") end)
			tl.TextSize = 14
			tl.TextColor3 = Color3.new(1, 1, 1)
			tl.TextStrokeTransparency = 0
			tl.TextStrokeColor3 = Color3.new(0, 0, 0)
			tl.TextWrapped = false
			tl.Text = ""
			tl.Visible = false
			tl.Parent = g
			local centered = true
			local pos = Vector2.new(0, 0)
			local function place()
				tl.AnchorPoint = centered and Vector2.new(0.5, 0.5) or Vector2.zero
				tl.Position = UDim2.fromOffset(pos.X, pos.Y)
			end
			place()
			local bag = {}
			local function removeFn()
				pcall(function() tl:Destroy() end)
			end
			return setmetatable({}, {
				__index = function(_, k)
					if k == "Remove" or k == "Destroy" then
						return removeFn
					end
					local b = bag[k]
					if b ~= nil then return b end
					local ok, val = pcall(function() return tl[k] end)
					if ok then return val end
					return nil
				end,
				__newindex = function(_, k, v)
					if k == "Position" then
						pos = v
						tl.Position = UDim2.fromOffset(pos.X, pos.Y)
					elseif k == "Visible" then
						tl.Visible = (v == true)
					elseif k == "Text" then
						tl.Text = tostring(v or "")
					elseif k == "Color" then
						tl.TextColor3 = v
					elseif k == "Size" or k == "TextSize" then
						if type(v) == "number" then tl.TextSize = v else tl.Size = v end
					elseif k == "Center" then
						centered = v
						place()
					elseif k == "Outline" then
						tl.TextStrokeTransparency = (v == true and 0) or (v == false and 1) or (type(v) == "number" and v) or 0
					elseif k == "OutlineColor" then
						tl.TextStrokeColor3 = v
					elseif k == "Font" or k == "FontFace" or k == "TextScaled" or k == "ZIndex" or k == "Name" then
						pcall(function() tl[k] = v end)
					else
						bag[k] = v
					end
				end,
			})
		end
	end

local tbl7, tbl8, fn16

do
	local fn17 = gethui and gethui or function()
		return CoreGui
	end

	local flag = false
	tbl7 = {}
	tbl8 = {}
	local connection = nil
	local connection2 = nil
	local tbl9 = {}
	local forsakenDeviceESP = nil
	local forsakenAbilityESP = nil
	local n = 0.5
	local n2 = 100
	local n3 = 0.5
	local n4 = 100

	local tbl10 = {
		MinStamina = 0,
		MaxStamina = 100,
		SprintSpeed = 26,
		StaminaLoss = 10,
		StaminaGain = 20,
		PenaltyTime = 2,
	}

	local tbl11 = {
		PC = "rbxassetid://135066638879377",
		Mobile = "rbxassetid://89227325753198",
		Console = "rbxassetid://118447973769044",
		Unknown = "rbxassetid://89227325753198",
	}

	local tbl12 = {
		c00lkidd = {
			{ Name = "Punch", Anim = "Attack" },
			{ Name = "CorruptNature", Anim = "CorruptNature" },
			{ Name = "WalkspeedOverride", Anim = "WalkspeedOverrideStart" },
			{ Name = "PizzaDelivery", Anim = "SummonPizzaDelivery" },
		},
		Sixer = {
			{ Name = "Carving Slash", Anim = "Slash.Slash" },
			{ Name = "DemonicPursuit", Anim = "DemonicPursuitStart" },
			{ Name = "InfernalCry", Anim = "Cry" },
			{ Name = "BloodHunt", Anim = "BloodHuntActivate" },
		},
		Nosferatu = {
			{ Name = "Slash", Anim = "Slash" },
			{ Name = "Uppercut", Anim = "Uppercut" },
			{ Name = "Spire", Anim = "SpireStart" },
			{ Name = "Bats", Anim = "BatsThrow" },
			{ Name = "Ascent", Anim = "Ascent" },
		},
		Slasher = {
			{ Name = "Slash", Anim = "Slash" },
			{ Name = "Behead", Anim = "Behead" },
			{ Name = "GashingWound", Anim = "GashingWoundStart" },
			{ Name = "RagingPace", Anim = "EnragedStart" },
		},
		JohnDoe = {
			{ Name = "Slash", Anim = "Slash" },
			{ Name = "CorruptEnergy", Anim = "CorruptEnergy" },
			{ Name = "DigitalFootprint", Anim = "DigitalFootprint" },
		},
		Noli = {
			{ Name = "Stab", Anim = "Stab", CooldownKey = "StabCooldown" },
			{ Name = "VoidRush", Anim = "VoidRush.StartCharge", CooldownKey = "VoidRushC00ldown" },
			{ Name = "Nova", Anim = "NovaThrow", CooldownKey = "NovaCooldown" },
			{ Name = "Observant", Anim = "ObservantStart", CooldownKey = "ObservantC00ldown" },
		},
		Noob = {
			{ Name = "BloxyCola", Anim = "Drinking1", CooldownKey = "BloxyColaCooldown" },
			{
				Name = "SlateskinPotion",
				Anim = "Drinking2",
				CooldownKey = "SlateskinPotionCooldown",
			},
			{ Name = "Ghostburger", Anim = "Eating", CooldownKey = "GhostburgerCooldown" },
		},
		Builderman = {
			{ Name = "Sentry", Anim = "ConstructStart", CooldownKey = "SentryCooldown" },
			{ Name = "Dispenser", Anim = "ConstructStart", CooldownKey = "DispenserCooldown" },
		},
		["007n7"] = {
			{ Name = "Clone", CustomTrigger = "Invisibility", CooldownKey = "CloneCooldown" },
			{ Name = "c00lgui", Anim = "c00lguiStart", CooldownKey = "c00lguiCooldown" },
		},
		TwoTime = {
			{ Name = "Dagger", Anim = { "Stab", "LungeStart" }, CooldownKey = "DaggerCooldown" },
			{ Name = "Crouch", CustomTrigger = "Crouching" },
			{ Name = "Ritual", Anim = "Ritual" },
		},
		JaneDoe = { { Name = "Crystal", Anim = "CrystalThrow" }, { Name = "Axe", Anim = "Axe" } },
		Taph = {
			{ Name = "Tripwire", Anim = "TripwirePlaceStart", CooldownKey = "TripwireCooldown" },
			{
				Name = "SubspaceTripmine",
				Anim = "ThrowSubspace",
				CooldownKey = "SubspaceTripmineCooldown",
			},
		},
		Dusekkar = {
			{
				Name = "SpawnProtection",
				Anim = "StaffStartup",
				CooldownKey = "SpawnProtectionCooldown",
			},
			{ Name = "PlasmaBeam", Anim = "StaffShot", CooldownKey = "PlasmaBeamCooldown" },
		},
		Veeronica = {
			{ Name = "Sk8", Anim = "Sk8Start", CooldownKey = "Sk8CD" },
			{ Name = "Broadcast", Anim = "BroadcastSwitch", AlwaysShow = true, CycleIcons = true },
		},
		Chance = {
			{
				Name = "CoinFlip",
				Anim = { "FlipCoinHeads", "FlipCoinTails" },
				CooldownKey = "CoinFlipCooldown",
			},
			{ Name = "Shoot", Anim = "AimGun", CooldownKey = "ShootCooldown" },
			{ Name = "HatFix", Anim = "HatFix", CooldownKey = "HatFixCooldown" },
		},
		Azure = {
			{ Name = "Slash", Anim = "Slash" },
			{ Name = "Unravel", Anim = "Unravel" },
			{ Name = "Sow", Anim = "Sow" },
			{ Name = "Blossom", Anim = "Blossom" },
			{ Name = "Pummeling", Anim = "GolemSlash" },
			{ Name = "Blooming", Anim = "GolemShockwave" },
			{ Name = "Burrowing", Anim = "Burrowing" },
			{ Name = "Unearthing", Anim = "Unearthing" },
		},
	}

	local tbl13 = { "rbxassetid://99218231350350", "rbxassetid://115049033276951", "rbxassetid://70948225384237" }
	local tbl14 = { BloxyCola = 10, SlateskinPotion = 6, Ghostburger = 10 }

	fn16 = function(arg)
		if not assets then
			return nil
		end
		local v3 = assets

		for _, v4 in ipairs(arg) do
			if v3:FindFirstChild(v4) then
				v3 = v3[v4]
				continue
			end
			return nil
		end

		if v3:IsA("ModuleScript") then
			local ok, result = pcall(require, v3)
			if ok and type(result) == "table" then
				return result
			end
		end

		return nil
	end

	local function fn18(arg, arg2, arg3)
		if not arg then
			return {}
		end
		local tbl15

		if type(arg2) == "string" then
			tbl15 = { arg2 }
		else
			tbl15 = arg2
		end

		local tbl16 = {}

		local function fn19(arg4)
			if type(arg4) == "string" or type(arg4) == "number" then
				return string.match(tostring(arg4), "%d+")
			end
			return nil
		end

		if arg3 and arg[arg3] then
			local v3 = fn19(arg[arg3])

			if v3 then
				table.insert(tbl16, v3)
			end
		end

		if tbl15 then
			for _, v3 in ipairs(tbl15) do
				if arg[v3] then
					local v4 = fn19(arg[v3])

					if v4 then
						table.insert(tbl16, v4)
					end
				end

				local v4 = string.split(v3, ".")
				local v5 = arg

				for _, v6 in ipairs(v4) do
					if type(v5) == "table" then
						v5 = v5[v6]
					else
						v5 = nil
						break
					end
				end

				local v6 = fn19(v5)

				if v6 then
					table.insert(tbl16, v6)
				end

				if #v4 > 1 then
					local v7 = v4[#v4]

					if arg[v7] then
						local v8 = fn19(arg[v7])

						if v8 then
							table.insert(tbl16, v8)
						end
					end
				end
			end
		end

		if #tbl16 == 0 then
			local fn20 = nil

			fn20 = function(arg4)
				for k, v3 in pairs(arg4) do
					if type(v3) == "table" then
						fn20(v3)
					else
						local v4 = fn19(v3)

						if v4 then
							local str2 = tostring(k):lower()
							local pos = arg3 and str2:find(arg3:lower(), 1, true)
							local flag2 = false

							if pos then
								flag2 = true
							end

							if tbl15 then
								for _, v5 in ipairs(tbl15) do
									if str2:find(v5:lower(), 1, true) or v5:lower():find(str2, 1, true) then
										flag2 = true
										break
									end
								end
							end

							if flag2 then
								table.insert(tbl16, v4)
							end
						end
					end
				end
			end

			pcall(fn20, arg)
		end

		return tbl16
	end

	local function fn19(arg)
		local attribute = arg:GetAttribute("CharacterName") or arg.Name
		local attribute2 = arg:GetAttribute("SkinName") or ""
		local str2 = arg.Parent and arg.Parent.Name == "Killers" and "Killers" or "Survivors"
		local v3 = fn16({ str2, attribute, "Config" })
		local v4 = fn16({ str2, attribute, "Behavior" })
		local flag2 = attribute2 ~= "" and fn16({ "Skins", str2, attribute, attribute2, "Config" }) or nil
		local tbl15 = {}

		if v4 and v4.Abilities then
			local v5 = tbl12[attribute]

			if v5 then
				for i, v6 in ipairs(v5) do
					local name = v6.Name
					local v7 = v4.Abilities[name]

					if v7 then
						local icon = v7.Icon or ""

						if name == "Broadcast" and attribute == "Veeronica" then
							icon = tbl13[1]
						end

						local tbl16 = {}
						local cooldown

						if typeof(v7.Cooldown) == "number" then
							cooldown = v7.Cooldown
						elseif v6.CooldownKey and v3 then
							cooldown = v3[v6.CooldownKey]
						else
							cooldown = nil

							if v3 then
								cooldown = v3[name .. "Cooldown"]
							end
						end

						if v6.Anim then
							local anim = v6.Anim

							if flag2 and flag2.Animations then
								tbl16 = fn18(flag2.Animations, anim, name)
							end

							if #tbl16 == 0 and v3 and v3.Animations then
								tbl16 = fn18(v3.Animations, anim, name)
							end
						end

						local activeCondition

						if attribute == "Slasher" and name == "RagingPace" then
							activeCondition = "IsEnraged"
						elseif attribute == "Veeronica" and name == "Sk8" then
							activeCondition = "IsSkating"
						elseif attribute == "Noob" and tbl14[name] then
							activeCondition = name .. "Active"
						else
							local flag3 = attribute == "TwoTime" and name == "Crouch"
							activeCondition = nil

							if flag3 then
								activeCondition = "IsCrouching"
							end
						end

						if #tbl16 > 0 or v6.CustomTrigger then
							local tbl17 = { AnimIds = tbl16 }
							cooldown = cooldown or 0
							tbl17.Cooldown = cooldown
							tbl17.Icon = icon
							tbl17.AlwaysShow = v6.AlwaysShow or false
							tbl17.CycleIcons = v6.CycleIcons or false
							tbl17.CustomTrigger = v6.CustomTrigger
							tbl17.LayoutOrder = i
							tbl17.ActiveCondition = activeCondition
							tbl15[name] = tbl17
						end
					end
				end
			else
				local n5 = 0

				for k, ability in pairs(v4.Abilities) do
					n5 += 1
					local layoutOrder = ability.LayoutOrder or n5
					local icon = ability.Icon or ""
					local cooldown = typeof(ability.Cooldown) == "number" and ability.Cooldown or v3 and v3[k .. "Cooldown"] or 0
					local tbl16 = {}

					if flag2 and flag2.Animations then
						tbl16 = fn18(flag2.Animations, nil, k)
					end

					if #tbl16 == 0 and v3 and v3.Animations then
						tbl16 = fn18(v3.Animations, nil, k)
					end

					if #tbl16 > 0 then
						tbl15[k] = {
							AnimIds = tbl16,
							Cooldown = cooldown,
							Icon = icon,
							AlwaysShow = false,
							CycleIcons = false,
							LayoutOrder = layoutOrder,
							ActiveCondition = nil,
						}
					end
				end
			end
		end

		if next(tbl15) == nil and v3 and v3.Animations then
			local n5 = 0

			for k in pairs(v3.Animations) do
				local v5 = v3[k .. "Cooldown"]

				if v5 then
					local tbl16 = {}

					if flag2 and flag2.Animations then
						tbl16 = fn18(flag2.Animations, nil, k)
					end

					if #tbl16 == 0 then
						tbl16 = fn18(v3.Animations, nil, k)
					end

					if #tbl16 > 0 then
						n5 += 1

						tbl15[k] = {
							AnimIds = tbl16,
							Cooldown = v5,
							Icon = "",
							AlwaysShow = false,
							CycleIcons = false,
							LayoutOrder = n5,
							ActiveCondition = nil,
						}
					end
				end
			end
		end

		return tbl15
	end

	local function extractFirstAnimId(val, depth)
		if (depth or 0) > 3 or val == nil then return nil end
		if typeof(val) == "Instance" and val:IsA("Animation") then
			return string.match(tostring(val.AnimationId), "%d+")
		elseif type(val) == "string" or type(val) == "number" then
			return string.match(tostring(val), "%d+")
		elseif type(val) == "table" then
			for _, subv in pairs(val) do
				local id = extractFirstAnimId(subv, (depth or 0) + 1)
				if id then return id end
			end
		end
		return nil
	end

	local function fn20(arg, arg2)
		if arg:GetAttribute("FootstepOverride") == "GolemFootsteps" then
			return true
		end

		local tracks = (arg2 and arg2._frameTracks) or (arg2 and arg2.AbilityState and arg2.AbilityState.Animator and arg2.AbilityState.Animator:GetPlayingAnimationTracks())
		if tracks then
			for _, v3 in ipairs(tracks) do
				if v3.Animation and v3.Animation.AnimationId then
					if tostring(v3.Animation.AnimationId):lower():find("golem") then
						return true
					end
				end
			end
		end

		return false
	end

	local function fn21(arg, arg2)
		if fn20(arg, arg2) then
			return { MaxStamina = 50, StaminaGain = 20, StaminaLoss = 10, MinStamina = 0, PenaltyTime = 2, SprintSpeed = 26 }
		end
		local str2 = arg.Parent and arg.Parent.Name == "Survivors" and "Survivors" or "Killers"
		local name = (arg:GetAttribute("CharacterName") or arg:GetAttribute("ActorDisplayName") or arg.Name):gsub("^[!#]", "")
		if str2 == "Survivors" then
			return tbl10
		end
		local v3 = fn16({ "Killers", name, "Config" }) or fn16({ "Killers", arg.Name, "Config" })

		if v3 then
			return {
				MaxStamina = v3.MaxStamina or 110,
				StaminaGain = v3.StaminaGain or 21,
				StaminaLoss = v3.StaminaLoss or 9.5,
				MinStamina = v3.MinStamina or 0,
				PenaltyTime = 2,
				SprintSpeed = v3.SprintSpeed or 27,
			}
		end

		return { MaxStamina = 110, StaminaGain = 21, StaminaLoss = 9.5, MinStamina = 0, PenaltyTime = 2, SprintSpeed = 27 }
	end

	local function fn22(arg, arg2, arg3)
		local str2 = arg.Parent and arg.Parent.Name == "Survivors" and "Survivors" or "Killers"
		local name = (arg:GetAttribute("CharacterName") or arg:GetAttribute("ActorDisplayName") or arg.Name):gsub("^[!#]", "")
		local attribute = arg:GetAttribute("SkinName") or ""
		local str3 = arg3 and "GolemRun" or arg2 and "InjuredRun" or "Run"

		if attribute ~= "" then
			local v3 = fn16({ "Skins", str2, name, attribute, "Config" })
			local idS = v3 and v3.Animations and extractFirstAnimId(v3.Animations[str3], 0)
			if idS then return idS end
		end

		local v3 = fn16({ str2, name, "Config" }) or fn16({ str2, arg.Name, "Config" })
		local idB = v3 and v3.Animations and extractFirstAnimId(v3.Animations[str3], 0)
		if idB then return idB end

		if arg3 then
			return "130480436367274"
		end

		if arg2 then
			local idR = v3 and v3.Animations and extractFirstAnimId(v3.Animations.Run, 0)
			if idR then return idR end
		end

		return arg2 and "115946474977409" or "136252471123500"
	end

	local function fn23(arg, arg2, cachedTracks, allowRunName)
		if not arg and not cachedTracks then
			return false
		end

		local tracks = cachedTracks or arg:GetPlayingAnimationTracks()
		for _, v3 in ipairs(tracks) do
			if v3.Animation and v3.Animation.AnimationId and v3.WeightCurrent > 0.35 then
				local v4 = string.match(tostring(v3.Animation.AnimationId), "%d+")
				if arg2 and v4 == arg2 then
					return true
				end
			if allowRunName then
				local nm = v3.Animation.Name and v3.Animation.Name:lower() or ""
				if nm == "run" or nm == "sprint" or nm == "injuredrun" or nm == "golemrun" then
					return true
				end
			end
			end
		end

		return false
	end

	local function fn24(arg)
		if arg and arg.MaxHealth > 0 then
			return arg.Health / arg.MaxHealth
		end
		return 1
	end

	local function fn25(arg)
		local myCh = localPlayer and localPlayer.Character
		if myCh and myCh.Parent and myCh.Parent.Name == "Survivors" then
			local myHrp = myCh:FindFirstChild("HumanoidRootPart")
			local myHum = myCh:FindFirstChildOfClass("Humanoid")
			if myHrp and (not myHum or myHum.Health > 0) and (myHrp.Position - arg).Magnitude <= n4 then
				return true
			end
		end
		for k, v3 in pairs(tbl8) do
			if v3.Type == "Survivor" and k.Parent and (not v3.Hum or v3.Hum.Health > 0) then
				local humanoidRootPart = k:FindFirstChild("HumanoidRootPart")
				if humanoidRootPart and (humanoidRootPart.Position - arg).Magnitude <= n4 then
					return true
				end
			end
		end

		return false
	end

	local function fn26(arg, arg2)
		if not arg.AnimIds then
			return false
		end

		for _, animId in ipairs(arg.AnimIds) do
			if animId == arg2 then
				return true
			end
		end

		return false
	end

	local function fn27(arg)
		local now = os.clock()
		if arg.LastCycleTime and now - arg.LastCycleTime < 0.5 then
			return
		end
		arg.LastCycleTime = now
		arg.BroadcastChannelIndex = arg.BroadcastChannelIndex % 3 + 1
		local v3 = tbl13[arg.BroadcastChannelIndex]

		if v3 then
			arg.Abilities.Broadcast.Icon = v3
			local broadcast = arg.Frames.Broadcast

			if broadcast then
				local imageLabel = broadcast:FindFirstChild("ImageLabel", true)

				if imageLabel and imageLabel:IsA("ImageLabel") then
					imageLabel.Image = v3
				end
			end
		end
	end

	local function fn28(arg, adornee)
		if not (forsakenAbilityESP and forsakenAbilityESP.Parent) then
			return { Gui = nil, MainContainer = nil, DistanceScale = nil }
		end
		local uid690 = arg:GetAttribute("__ESP_UID")
		local name = uid690 and (arg.Name .. "_" .. uid690) or nil
		local billboardGui = name and forsakenAbilityESP:FindFirstChild(name) or nil
		if billboardGui and billboardGui.Adornee and billboardGui.Adornee.Parent and billboardGui.Adornee ~= adornee and not billboardGui.Adornee:IsDescendantOf(arg) then
			uid690 = nil
			billboardGui = nil
		end
		if not uid690 then
			uid690 = tostring(math.floor(os.clock() * 1000000)) .. "_" .. tostring(math.random(100000, 999999))
			arg:SetAttribute("__ESP_UID", uid690)
			name = arg.Name .. "_" .. uid690
			billboardGui = forsakenAbilityESP:FindFirstChild(name)
		end
		local frame = nil
		local uiScale = nil

		if not billboardGui then
			billboardGui = Instance.new("BillboardGui")
			billboardGui.Name = name
			billboardGui.Size = UDim2.new(0, 250, 0, 60)
			billboardGui.StudsOffsetWorldSpace = Vector3.new(0, 4.5, 0)
			billboardGui.AlwaysOnTop = true
			frame = Instance.new("Frame")
			frame.Name = "MainContainer"
			frame.Size = UDim2.new(1, 0, 1, 0)
			frame.BackgroundTransparency = 1
			frame.AnchorPoint = Vector2.new(0.5, 0.5)
			frame.Position = UDim2.new(0.5, 0, 0.5, 0)
			frame.Parent = billboardGui
			uiScale = Instance.new("UIScale")
			uiScale.Name = "DistanceScale"
			uiScale.Parent = frame
			local uiListLayout = Instance.new("UIListLayout")
			uiListLayout.Parent = frame
			uiListLayout.FillDirection = Enum.FillDirection.Horizontal
			uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			uiListLayout.Padding = UDim.new(0, 4)
			billboardGui.Parent = forsakenAbilityESP
		end

		if billboardGui then
			billboardGui.Adornee = adornee
		end

		if billboardGui and not frame then
			frame = billboardGui:FindFirstChild("MainContainer")
			uiScale = frame and frame:FindFirstChild("DistanceScale")
		end

		return { Gui = billboardGui, MainContainer = frame, DistanceScale = uiScale }
	end

	local function createFrame(arg, name, arg2)
		local billboardCache = arg.BillboardCache
		if not billboardCache or not billboardCache.MainContainer then
			return nil
		end
		local frame = Instance.new("Frame")
		frame.Name = name
		local iconN = tbl.EspIconSize or 50
		frame.Size = UDim2.new(0, iconN + 6, 0, iconN + 28)
		frame.BackgroundTransparency = 1
		frame.BorderSizePixel = 0
		frame.LayoutOrder = arg2.LayoutOrder
		frame.Parent = billboardCache.MainContainer
		local textLabel = Instance.new("TextLabel")
		textLabel.Size = UDim2.new(1, 0, 0, 17)
		textLabel.BackgroundTransparency = 1
		textLabel.TextColor3 = Color3.fromRGB(255, 170, 0)
		textLabel.TextScaled = true
		textLabel.TextStrokeTransparency = 0.1
		textLabel.Font = Enum.Font.Nunito
		pcall(function() textLabel.FontFace = Font.new("rbxasset://fonts/families/Balthazar.json") end)
		textLabel.Text = arg2.Name or name
		textLabel.Parent = frame
		local uiTextSizeConstraint = Instance.new("UITextSizeConstraint")
		uiTextSizeConstraint.MaxTextSize = 15
		uiTextSizeConstraint.MinTextSize = 9
		uiTextSizeConstraint.Parent = textLabel
		local frame2 = Instance.new("Frame")
		frame2.Name = "IconFrame"
		frame2.Size = UDim2.new(0, iconN, 0, iconN)
		frame2.Position = UDim2.new(0.5, -iconN / 2, 0, 20)
		frame2.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		frame2.BackgroundTransparency = 0.3
		frame2.BorderSizePixel = 0
		frame2.Parent = frame
		local uiCorner = Instance.new("UICorner")
		uiCorner.CornerRadius = UDim.new(0, math.max(4, math.floor(iconN * 0.18)))
		uiCorner.Parent = frame2
		local imageLabel = Instance.new("ImageLabel")
		imageLabel.Name = "ImageLabel"
		imageLabel.Size = UDim2.new(1, -2, 1, -2)
		imageLabel.Position = UDim2.new(0, 1, 0, 1)
		imageLabel.BackgroundTransparency = 1
		imageLabel.Image = arg2.Icon or ""
		imageLabel.Parent = frame2
		local textLabel2 = Instance.new("TextLabel")
		textLabel2.Name = "Timer"
		textLabel2.Size = UDim2.new(1, 0, 0, 22)
		textLabel2.Position = UDim2.new(0, 0, 1, -24)
		textLabel2.BackgroundTransparency = 1
		textLabel2.TextColor3 = Color3.new(1, 1, 1)
		textLabel2.TextSize = 20
		textLabel2.TextStrokeTransparency = 0.15
		textLabel2.TextStrokeColor3 = Color3.new(0, 0, 0)
		textLabel2.Font = Enum.Font.GothamBlack
		textLabel2.TextXAlignment = Enum.TextXAlignment.Center
		textLabel2.TextYAlignment = Enum.TextYAlignment.Center
		textLabel2.Text = ""
		textLabel2.Parent = frame
		arg.Frames[name] = frame
		arg.TimersUI[name] = textLabel2
		arg.IconLabels[name] = imageLabel
		return frame
	end

	local function fn29(arg, arg2)
		if not arg2.Animation or not arg2.Animation.AnimationId then
			return
		end
		local v3 = string.match(tostring(arg2.Animation.AnimationId), "%d+")
		if not v3 then
			return
		end

		for k, ability in pairs(arg.Abilities) do
			if ability.AnimIds and #ability.AnimIds > 0 and fn26(ability, v3) then
				if not arg.Timers[k] or arg.Timers[k] <= 0 then
					arg.Timers[k] = ability.Cooldown

					if ability.CycleIcons then
						fn27(arg)
					end

					local playerStateRef = arg.PlayerStateRef

					if playerStateRef and playerStateRef.NoobEffects and ability.ActiveCondition and tbl14[k] then
						local v4 = tbl14[k]
						playerStateRef.NoobEffects[k] = tick() + v4
						playerStateRef[ability.ActiveCondition] = true
					end
				end
			end
		end

		if arg.EnragedAnimIds and arg.EnragedAnimIds[v3] then
			local playerStateRef = arg.PlayerStateRef

			if playerStateRef then
				playerStateRef.IsEnraged = true
				playerStateRef.EnrageStartTime = tick()
			end
		end

		if arg.Sk8StartAnimId and v3 == arg.Sk8StartAnimId then
			local playerStateRef = arg.PlayerStateRef

			if playerStateRef then
				playerStateRef.IsSkating = true
			end
		end
	end

	local function fn30(arg, arg2, arg3, hum)
		local v3 = fn20(arg, nil)
		local v4 = fn21(arg, nil)
		local animator = hum and hum:WaitForChild("Animator", 5)
		if not flag or not (arg and arg.Parent and (arg.Parent.Name == "Survivors" or arg.Parent.Name == "Killers") and arg:IsDescendantOf(workspace)) then
			if RemovePlayerTagDrawing then pcall(RemovePlayerTagDrawing, arg) end
			return
		end
		local prevSt = tbl8[arg]
		if prevSt then
			if prevSt.CrouchAttrListener then pcall(function() prevSt.CrouchAttrListener:Disconnect() end) end
			if prevSt.AbilityState then
				local pab = prevSt.AbilityState
				if pab.Connections then
					for _, c3 in ipairs(pab.Connections) do pcall(function() c3:Disconnect() end) end
				end
				if pab.BillboardCache and pab.BillboardCache.Gui then
					pcall(function() pab.BillboardCache.Gui:Destroy() end)
				end
			end
			tbl8[arg] = nil
		end
		local str2 = arg.Parent.Name == "Survivors" and "Survivor" or "Killer"
		local charType = (arg:GetAttribute("CharacterName") or arg:GetAttribute("ActorDisplayName") or arg.Name):gsub("^[!#]", "")
		local v5 = fn24(hum)
		local isInjured = v5 <= 0.5
		local v6 = fn22(arg, false, false)
		local v7 = fn22(arg, true, false)
		local v8 = fn22(arg, false, true)
		local v9 = string.match(tostring(v6 or ""), "%d+")
		local v10 = string.match(tostring(v7 or ""), "%d+")
		local v11 = string.match(tostring(v8 or ""), "%d+")

		local tbl15 = {
			Name = arg.Name,
			Type = str2,
			Stats = v4,
			CurrentStamina = v4.MaxStamina,
			TimeUntilRecovery = 0,
			IsSprinting = false,
			StaminaPenaltyActive = false,
			MovementState = "IDLE",
			CurrentSpeed = 0,
			DisplaySpeed = 0,
			LastPosition = arg2 and arg2.Position or Vector3.zero,
		}

		tbl15.LastUpdateTime = tick()
		tbl15.LastSpeedUpdateTime = tick()
		tbl15.TotalDistance = 0
		tbl15.SpeedSampleCount = 0
		tbl15.NormalRunAnimationIdStr = v9
		tbl15.InjuredRunAnimationIdStr = v10
		tbl15.GolemRunAnimationIdStr = v11
		tbl15.IsInjured = isInjured
		tbl15.LastHealthCheck = v5
		tbl15.AbilityState = nil
		tbl15.Hum = hum
		tbl15.IsStaminaFrozen = false
		tbl15.IsEnraged = false
		tbl15.EnragedAnimIds = nil
		tbl15.EnrageStartTime = 0
		tbl15.IsSkating = false
		tbl15.Sk8SkatingAnimId = nil
		tbl15.IsCrouching = false
		tbl15.NoobEffects = {}
		tbl15.BloxyColaActive = false
		tbl15.SlateskinPotionActive = false
		tbl15.GhostburgerActive = false
		tbl15.CrouchAttrListener = nil
		tbl15.IsGolem = v3
		tbl15.GolemGraceUntil = v3 and tick() + 3 or 0
		local abilityState = nil

		if arg2 and animator then
			local v12 = fn19(arg)

			if v12 then
				abilityState = {
					Timers = {},
					Abilities = v12,
					Animator = animator,
					Head = arg3,
					BillboardCache = fn28(arg, arg2),
					Frames = {},
					TimersUI = {},
					IconLabels = {},
					Connections = {},
					BroadcastChannelIndex = 1,
					LastCycleTime = 0,
					WasInvisible = false,
					PlayerStateRef = tbl15,
					EnragedAnimIds = nil,
					Sk8StartAnimId = nil,
					Sk8SkatingAnimId = nil,
				}

				for k, v13 in pairs(v12) do
					if v13.AlwaysShow then
						createFrame(abilityState, k, v13)
					end
				end

				table.insert(abilityState.Connections, animator.AnimationPlayed:Connect(function(arg4)
					fn29(abilityState, arg4)
				end))

				for _, v13 in ipairs(animator:GetPlayingAnimationTracks()) do
					fn29(abilityState, v13)
				end

				if charType == "Slasher" then
					local enragedAnimIds = {}
					local v13 = fn16({ "Killers", "Slasher", "Config" })

					if v13 and v13.Animations then
						for _, v14 in ipairs({
							"EnragedStart",
							"EnragedIdle",
							"EnragedWalk",
							"EnragedRun",
							"EnragedSlash",
							"EnragedBehead",
						}) do
							local v15 = v13.Animations[v14]
							local v16 = v15 and extractFirstAnimId(v15, 0)
							if v16 then
								enragedAnimIds[v16] = true
							end
						end
					end

					abilityState.EnragedAnimIds = enragedAnimIds
				end

				if charType == "Veeronica" then
					local v13 = fn16({ "Survivors", "Veeronica", "Config" })

					if v13 and v13.Animations then
						local sk8Skating = v13.Animations.Sk8Skating
						local sk8Start = v13.Animations.Sk8Start

						if sk8Skating then
							tbl15.Sk8SkatingAnimId = extractFirstAnimId(sk8Skating, 0)
							abilityState.Sk8SkatingAnimId = tbl15.Sk8SkatingAnimId
						end

						if sk8Start then
							abilityState.Sk8StartAnimId = extractFirstAnimId(sk8Start, 0)
						end
					end
				end

				if charType == "TwoTime" then
					local function fn31()
						tbl15.IsCrouching = arg:GetAttribute("Crouching") == true
					end

					fn31()
					tbl15.CrouchAttrListener = arg:GetAttributeChangedSignal("Crouching"):Connect(fn31)
				end
			end
		end

		tbl15.CharType = charType
		tbl15.AbilityState = abilityState
		tbl8[arg] = tbl15
		if tbl.PlayersTagsEsp and not tbl7[arg] and arg ~= localPlayer.Character then
			CreatePlayerTagDrawing(arg, str2 == "Killer" and tbl.EspKillerColor or tbl.EspSurvivorsColor, arg2, hum)
		end
	end

	local function fn31(arg, arg2, arg3)
		if not arg or not arg.Parent then
			return
		end
		local humanoidRootPart = arg:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return
		end

		if arg3 <= 0 then
			arg3 = 0.016666666666666666
		end

		local animator = arg2.AbilityState and arg2.AbilityState.Animator
		local nowTr = os.clock()
		if animator and (not arg2._cachedTracks or nowTr - (arg2._tracksAt or 0) >= 0.1) then
			arg2._cachedTracks = animator:GetPlayingAnimationTracks()
			arg2._tracksAt = nowTr
		elseif not animator then
			arg2._cachedTracks = nil
		end
		local frameTracks = arg2._cachedTracks
		arg2._frameTracks = frameTracks

		local attribute = arg:GetAttribute("FootstepOverride")
		local v3 = fn20(arg, arg2)
		local flag2 = attribute == "GolemFootsteps" or v3
		local flag3 = attribute ~= nil and attribute ~= "GolemFootsteps"
		local now = tick()

		if flag2 then
			arg2.GolemGraceUntil = now + 3
		end

		if not arg2.IsGolem then
			if flag2 then
				arg2.IsGolem = true
				arg2.Stats = fn21(arg, arg2)
				arg2.CurrentStamina = arg2.Stats.MaxStamina
				arg2.TimeUntilRecovery = 0
			end
		else
			local flag4 = not flag2

			if flag4 then
				if not flag3 then
					flag3 = now >= (arg2.GolemGraceUntil or 0)
				end
			else
				flag3 = flag4
			end

			if flag3 then
				arg2.IsGolem = false
				arg2.Stats = fn21(arg, arg2)
				arg2.CurrentStamina = arg2.Stats.MaxStamina
				arg2.TimeUntilRecovery = 0
			end
		end

		local isGolem = arg2.IsGolem
		arg2.IsStaminaFrozen = false

		if isGolem and frameTracks then
			for _, v4 in ipairs(frameTracks) do
				local name = v4.Animation and v4.Animation.Name or ""
				if name:match("GolemShockwave") or name:match("Blooming") then
					arg2.IsStaminaFrozen = true
					break
				end
			end
		end

		local v4 = fn24(arg2.Hum)

		if math.abs(arg2.LastHealthCheck - v4) >= 0.05 then
			arg2.IsInjured = v4 <= 0.5
			arg2.LastHealthCheck = v4
		end

		local golemRunAnimationIdStr

		if isGolem then
			golemRunAnimationIdStr = arg2.GolemRunAnimationIdStr
		else
			golemRunAnimationIdStr = arg2.IsInjured and arg2.InjuredRunAnimationIdStr or arg2.NormalRunAnimationIdStr
		end

		local curSkin = arg:GetAttribute("SkinName") or ""
		if arg2._lastSkin ~= curSkin then
			arg2._lastSkin = curSkin
			arg2.NormalRunAnimationIdStr = string.match(tostring(fn22(arg, false, false) or ""), "%d+")
			arg2.InjuredRunAnimationIdStr = string.match(tostring(fn22(arg, true, false) or ""), "%d+")
			arg2.GolemRunAnimationIdStr = string.match(tostring(fn22(arg, false, true) or ""), "%d+")
			if isGolem then
			golemRunAnimationIdStr = arg2.GolemRunAnimationIdStr
			else
			golemRunAnimationIdStr = arg2.IsInjured and arg2.InjuredRunAnimationIdStr or arg2.NormalRunAnimationIdStr
			end
		end

		local abState = arg2.AbilityState
		if abState and abState.Abilities then
			for abName, abInfo in pairs(abState.Abilities) do
				if abInfo.CustomTrigger == "Invisibility" then
					local headP = abState.Head or arg:FindFirstChild("Head")
					local isInv = (arg:GetAttribute("Invisibility") == true)
						or (arg:GetAttribute("Invisible") == true)
						or (headP ~= nil and headP.Transparency >= 0.95)
					if isInv and not abState.WasInvisible then
						if not abState.Timers[abName] or abState.Timers[abName] <= 0 then
							abState.Timers[abName] = abInfo.Cooldown
						end
					end
					abState.WasInvisible = isInv
				end
			end
		end

		local position = humanoidRootPart.Position
		local rawMag = (Vector3.new(position.X, 0, position.Z) - Vector3.new(arg2.LastPosition.X, 0, arg2.LastPosition.Z)).Magnitude
		local magnitude = (rawMag > n2 * math.max(arg3, 0.05)) and math.max(0, arg2.CurrentSpeed * arg3) or rawMag
		arg2.LastPosition = position
		arg2._spdDist = (arg2._spdDist or 0) + magnitude
		arg2._spdDt = (arg2._spdDt or 0) + arg3
		if arg2._spdDt >= 0.055 then
			local n5 = arg2._spdDist / arg2._spdDt
			if n2 < n5 then
				n5 = arg2.CurrentSpeed
			end
			local alpha = 1 - math.exp(-14 * arg2._spdDt)
			arg2.CurrentSpeed = arg2.CurrentSpeed * (1 - alpha) + n5 * alpha
			arg2._spdDist = 0
			arg2._spdDt = 0
		end
		local now2 = tick()
		arg2.TotalDistance = arg2.TotalDistance + magnitude
		arg2.SpeedSampleCount = arg2.SpeedSampleCount + 1

		if n3 <= now2 - arg2.LastSpeedUpdateTime then
			arg2.DisplaySpeed = math.min(arg2.TotalDistance / (now2 - arg2.LastSpeedUpdateTime), 100)
			arg2.LastSpeedUpdateTime = now2
			arg2.TotalDistance = 0
			arg2.SpeedSampleCount = 0
		end

		local flag4 = arg2.CurrentSpeed > 0.4
		local flag5 = false

		if frameTracks then
			flag5 = fn23(animator, golemRunAnimationIdStr, frameTracks, true)
		end

		local isSkating = false

		if arg2.Sk8SkatingAnimId and frameTracks then
			isSkating = fn23(animator, arg2.Sk8SkatingAnimId, frameTracks, false)
		elseif arg2.IsSkating and abState and abState.Sk8StartAnimId and frameTracks then
			isSkating = fn23(animator, abState.Sk8StartAnimId, frameTracks, false)
		end

		arg2.IsSkating = isSkating
		local n6 = 1
		local n7 = 1

		if isSkating then
			n6 = 0
			n7 = 1.35
		end

		local sm = arg:FindFirstChild("SpeedMultipliers")
		local inAbilityDash = arg2.IsEnraged
			or arg:GetAttribute("VoidRushState") == "Dashing"
			or (sm ~= nil and (sm:FindFirstChild("Guest1337Charge") ~= nil or sm:FindFirstChild("VoidRushDash") ~= nil))
		local sprintSpeedFloor = (arg2.Type == "Killer") and 20.5 or 19.0
		local isMovingSprintSpeed = (not inAbilityDash) and ((arg2.CurrentSpeed >= sprintSpeedFloor) or (arg2.Hum ~= nil and arg2.Hum.WalkSpeed >= 22 and arg2.CurrentSpeed >= 15))
		local isSprintingNow = isSkating or ((flag5 or (not animator and isMovingSprintSpeed) or (isMovingSprintSpeed and (arg2.Hum == nil or arg2.Hum.WalkSpeed <= 29))) and flag4 and not inAbilityDash)

		if arg2.Type == "Killer" and isSprintingNow and not fn25(position) then
			isSprintingNow = false
		end

		local isSlasher = (arg2.CharType or arg2.Name) == "Slasher"
		if arg2.IsEnraged and isSlasher then
			local enragedAnimIds = arg2.AbilityState and arg2.AbilityState.EnragedAnimIds
			local flag6 = false

			if enragedAnimIds and frameTracks then
				for _, v5 in ipairs(frameTracks) do
					if v5.Animation and v5.Animation.AnimationId then
						local v6 = string.match(tostring(v5.Animation.AnimationId), "%d+")
						if v6 and enragedAnimIds[v6] then
							flag6 = true
							break
						end
					end
				end
			end

			if not flag6 then
				arg2.IsEnraged = false
			end
		end

		arg2._frameTracks = nil
		local maxStamina = arg2.Stats.MaxStamina

		if arg2.IsEnraged and isSlasher then
			maxStamina = arg2.Stats.MaxStamina + (70 - arg2.Stats.MaxStamina) * math.clamp((tick() - (arg2.EnrageStartTime or tick())) / 6.5, 0, 1)
		end

		if arg2.NoobEffects then
			local now3 = tick()
			arg2.BloxyColaActive = arg2.NoobEffects.BloxyCola and now3 < arg2.NoobEffects.BloxyCola or false
			arg2.SlateskinPotionActive = arg2.NoobEffects.SlateskinPotion and now3 < arg2.NoobEffects.SlateskinPotion or false
			arg2.GhostburgerActive = arg2.NoobEffects.Ghostburger and now3 < arg2.NoobEffects.Ghostburger or false
		end

		if isSprintingNow then
			arg2.IsSprinting = true
			arg2.MovementState = arg2.IsInjured and "INJURED_RUN" or "RUN"

			if not arg2.IsStaminaFrozen then
				arg2.TimeUntilRecovery = math.clamp((arg2.TimeUntilRecovery or 0) + arg3 * 0.05, 0.2, 2)
				arg2.CurrentStamina = math.clamp(arg2.CurrentStamina - arg2.Stats.StaminaLoss * n7 * arg3, arg2.Stats.MinStamina, maxStamina)

				if arg2.CurrentStamina <= arg2.Stats.MinStamina then
					arg2.IsSprinting = false
					arg2.StaminaPenaltyActive = true
					arg2.TimeUntilRecovery = arg2.Stats.PenaltyTime
				end
			end
		else
			if arg2.IsSprinting == true then
				if (arg2.TimeUntilRecovery or 0) <= 0.1 then
					arg2.TimeUntilRecovery = 0.1
				else
					arg2.TimeUntilRecovery = math.clamp(arg2.TimeUntilRecovery + 0.1, 0, 2)
				end
			end

			arg2.IsSprinting = false
			arg2.MovementState = arg2.CurrentSpeed > 2 and "WALK" or "IDLE"

			if arg:GetAttribute("StaminaPenaltyActive") == true and not arg2.StaminaPenaltyActive then
				arg2.StaminaPenaltyActive = true
				arg2.TimeUntilRecovery = math.max(arg2.TimeUntilRecovery or 0, arg2.Stats.PenaltyTime)
			end

			if not arg2.IsStaminaFrozen then
				arg2.TimeUntilRecovery = math.clamp((arg2.TimeUntilRecovery or 0) - arg3, 0, 2)

				if arg2.StaminaPenaltyActive then
					if arg2.TimeUntilRecovery <= 0 and not arg:GetAttribute("StaminaPenaltyActive") then
						arg2.StaminaPenaltyActive = false
					end
				elseif arg2.TimeUntilRecovery <= 0 and not arg:GetAttribute("AbilityStaminaOverride") then
					arg2.CurrentStamina = math.clamp(arg2.CurrentStamina + arg2.Stats.StaminaGain * n6 * arg3, arg2.Stats.MinStamina, maxStamina)
				end
			end
		end

		arg2.CurrentStamina = math.min(arg2.CurrentStamina, maxStamina)
	end

	CreatePlayerTagDrawing = function(arg, arg2, arg3, arg4)
		if tbl7[arg] then
			RemovePlayerTagDrawing(arg)
		end

		local name = localPlayer.Name
		if arg == localPlayer.Character or arg:GetAttribute("Username") == name then
			return
		end

		local function fn32(size, color)
			local v3 = forsakenFK.textTag()
			v3.Visible = false
			v3.Center = true
			v3.Outline = true
			v3.Font = Enum.Font.Nunito
			pcall(function() v3.FontFace = Font.new("rbxasset://fonts/families/Balthazar.json") end)
			v3.Size = size
			v3.Color = color
			v3.Text = ""
			return v3
		end

		local espTextSize = (tbl.EspTextSize or 14)
		local n5 = math.max(8, espTextSize - 1)
		local playerFromCharacter = Players:GetPlayerFromCharacter(arg)
		local frame = nil

		if forsakenDeviceESP then
			local iconD = math.clamp(math.floor((tbl.EspIconSize or 50) * 0.48 + 0.5), 12, 64)
			frame = Instance.new("Frame")
			frame.Size = UDim2.new(0, iconD, 0, iconD)
			frame.BackgroundTransparency = 1
			frame.Visible = false
			frame.Parent = forsakenDeviceESP
			local imageLabel = Instance.new("ImageLabel")
			imageLabel.Size = UDim2.new(1, 0, 1, 0)
			imageLabel.BackgroundTransparency = 1
			imageLabel.Image = tbl11[playerFromCharacter and playerFromCharacter:GetAttribute("Device") or "Unknown"] or tbl11.Unknown
			imageLabel.Parent = frame
		end

		tbl7[arg] = {
			MainText = fn32(espTextSize, arg2),
			SubText = fn32(n5, Color3.new(1, 1, 1)),
			DeviceGuiFrame = frame,
			HRP = arg3,
			Hum = arg4,
			RealNamePlr = playerFromCharacter,
			RealName = playerFromCharacter and playerFromCharacter.Name or arg.Name,
			CharName = arg.Name,
			_lastMainText = "",
			_lastSubText = "",
			_lastMainPos = Vector2.zero,
			_lastSubPos = Vector2.zero,
			_lastSubColor = Color3.new(1, 1, 1),
		}
	end

	RemovePlayerTagDrawing = function(arg)
		if tbl7[arg] then
			local v3 = tbl7[arg]
			v3.MainText:Remove()
			v3.SubText:Remove()

			if v3.DeviceGuiFrame then
				v3.DeviceGuiFrame:Destroy()
			end

			tbl7[arg] = nil
		end


		local v3 = tbl8[arg]

		if v3 then
			if v3.CrouchAttrListener then
				v3.CrouchAttrListener:Disconnect()
			end

			if v3.AbilityState then
				local abilityState = v3.AbilityState

				if abilityState.Connections then
					for _, connection3 in ipairs(abilityState.Connections) do
						connection3:Disconnect()
					end
				end

				if abilityState.BillboardCache and abilityState.BillboardCache.Gui then
					abilityState.BillboardCache.Gui:Destroy()
				end
			end
		end

		tbl8[arg] = nil
	end

local a723Flip = false
local fn33 = LPH_NO_VIRTUALIZE(function(delta)
		local cam = workspace.CurrentCamera
		a723Flip = not a723Flip
		if not cam then return end
		local opts = tbl.TagsOptions or {}
		local myChar = localPlayer.Character
		local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
		for char in pairs(tbl7) do
			local cp0 = char and char.Parent
			if not (cp0 and (cp0.Name == "Survivors" or cp0.Name == "Killers") and char:IsDescendantOf(workspace)) then
				pcall(RemovePlayerTagDrawing, char)
			end
		end
		for char, st in pairs(tbl8) do
			local cp = char.Parent
			if not (cp and (cp.Name == "Survivors" or cp.Name == "Killers") and char:IsDescendantOf(workspace)) then pcall(function() RemovePlayerTagDrawing(char) end) continue end
			fn31(char, st, delta)
			local ab = st.AbilityState
			local hrp = char:FindFirstChild("HumanoidRootPart")
			if ab and hrp then
				for k, ability in pairs(ab.Abilities) do
					local remaining = ab.Timers[k] or 0
					if remaining > 0 then
						remaining = remaining - delta
						if remaining < 0 then remaining = 0 end
						ab.Timers[k] = remaining
					end
					local activeCond = ability.ActiveCondition and st[ability.ActiveCondition] == true
					local isAbOn = (_G.NERG_ABILITY_ESP == true) or (opts.Abilities == true)
					local show = isAbOn and (ability.AlwaysShow == true or remaining > 0 or activeCond == true)
					local frame = ab.Frames[k]
					if show and not frame then
						frame = createFrame(ab, k, ability)
					end
					if frame then
						if frame.Visible ~= (show == true) then frame.Visible = show == true end
						local ui = ab.TimersUI[k]
						if ui then
							local txt = (show and remaining > 0) and string.format("%.1f", remaining) or "" if ui:GetAttribute("L") ~= txt then ui:SetAttribute("L", txt) ui.Text = txt end
						end
					end
				end
				local cache = ab.BillboardCache
				if cache and cache.Gui and cache.MainContainer then
					local sp = cam:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3.4, 0))
					local onScreen = sp.Z > 0
					local dOK = true
					if myHRP then
						local dA = (hrp.Position - myHRP.Position).Magnitude
						dOK = dA <= 120
						cache._aT = (cache._aT or 0.25) + delta
						if cache._aT >= 0.25 then
							cache._aT = 0
							if cache.DistanceScale then
								cache.DistanceScale.Scale = math.clamp(1.0 - dA / 140, 0.40, 1.0)
							end
						end
					end
					local isAbOn2 = (_G.NERG_ABILITY_ESP == true) or (opts.Abilities == true)
					local wantA = onScreen and isAbOn2 and dOK
					if cache.Gui.Enabled ~= wantA then
						cache.Gui.Enabled = wantA
					end
				end
			end
			local tag = tbl7[char]
			if tag and tag.HRP and tag.HRP.Parent then
				local sp, onScr = cam:WorldToViewportPoint(tag.HRP.Position + Vector3.new(0, 3.2, 0))
				local dTag = (myHRP and (tag.HRP.Position - myHRP.Position).Magnitude) or 0
				local visible = onScr and dTag <= 120
				if visible then
					st._txtT = (st._txtT or 0.25) + delta
					if st._txtT >= 0.25 then
						st._txtT = 0
					local mainParts, subParts = {}, {}
					if opts.Name == true then mainParts[#mainParts + 1] = tag.RealName or tag.CharName end
					if opts.Role then mainParts[#mainParts + 1] = st.Type == "Killer" and "[KILLER]" or "[SUR]" end
					if opts.Health and tag.Hum then
						subParts[#subParts + 1] = "HP " .. math.floor(fn24(tag.Hum) * 100 + 0.5) .. "%"
					end
					if opts.Distance and myHRP then
						subParts[#subParts + 1] = math.floor((tag.HRP.Position - myHRP.Position).Magnitude + 0.5) .. "m"
					end
					if opts.Stamina then subParts[#subParts + 1] = "ST " .. math.floor(st.CurrentStamina + 0.5) end
					if opts.Velocity then subParts[#subParts + 1] = math.floor(st.DisplaySpeed + 0.5) .. " st/s" end
					local mainT, subT = table.concat(mainParts, " "), table.concat(subParts, "  ")
					if mainT ~= tag._lastMainText then tag.MainText.Text = mainT; tag._lastMainText = mainT end
					if subT ~= tag._lastSubText then tag.SubText.Text = subT; tag._lastSubText = subT end
					end
					if a723Flip then
						local p2 = Vector2.new(sp.X, sp.Y)
						tag.MainText.Position = p2
						tag.SubText.Position = p2 + Vector2.new(0, 22)
						tag._lastMainPos, tag._lastSubPos = p2, p2 + Vector2.new(0, 22)
					end
					local mC, sC = tag._lastMainText or "", tag._lastSubText or ""
					tag.MainText.Visible = #mC > 0
					tag.SubText.Visible = #sC > 0
				end
				if not visible then
					tag.MainText.Visible = false
					tag.SubText.Visible = false
				end
				local dev = tag.DeviceGuiFrame
				if dev then
					if opts.Device and visible then
						if a723Flip then
							dev.Position = UDim2.fromOffset(math.floor(sp.X - 12), math.floor(sp.Y + 22))
						end
						local baseD = math.clamp(math.floor((tbl.EspIconSize or 50) * 0.48 + 0.5), 12, 64)
						local dS2 = math.clamp(1.0 - dTag / 140, 0.40, 1.0)
						local dN2 = math.clamp(math.floor(baseD * dS2 + 0.5), 8, 64)
						if dev:GetAttribute("_ls") ~= dN2 then
							dev:SetAttribute("_ls", dN2)
							dev.Size = UDim2.new(0, dN2, 0, dN2)
						end
						dev.Visible = true
					else
						dev.Visible = false
					end
				end
			end
		end
	end)

	local espHookedFolders = {}
	local espFolderConns = {}
	local espPlayersFolder = nil
	local espPlayersConn = nil

	local function clearEspFolderConn(tName)
		local list = espFolderConns[tName]
		if list then
			for i = #list, 1, -1 do
				local c = list[i]
				list[i] = nil
				pcall(function() c:Disconnect() end)
			end
			espFolderConns[tName] = nil
		end
		espHookedFolders[tName] = nil
	end

	StopESPSystem = function()
		flag = false

		if connection2 then
			connection2:Disconnect()
			connection2 = nil
		end

		if espPlayersConn then
			pcall(function() espPlayersConn:Disconnect() end)
			espPlayersConn = nil
		end
		espPlayersFolder = nil
		clearEspFolderConn("Survivors")
		clearEspFolderConn("Killers")

		for _, v3 in ipairs(tbl9) do
			pcall(function() v3:Disconnect() end)
		end

		tbl9 = {}

		for k in pairs(tbl7) do
			pcall(RemovePlayerTagDrawing, k)
		end
		for k in pairs(tbl8) do
			pcall(RemovePlayerTagDrawing, k)
		end

		tbl7 = {}
		tbl8 = {}

		if forsakenDeviceESP then
			forsakenDeviceESP:Destroy()
			forsakenDeviceESP = nil
		end

		if forsakenAbilityESP then
			forsakenAbilityESP:Destroy()
			forsakenAbilityESP = nil
		end
	end

	StartESPSystem = function()
		local guiParent = fn17()

		if not (forsakenDeviceESP and forsakenDeviceESP.Parent) then
			forsakenDeviceESP = (guiParent and guiParent:FindFirstChild("ForsakenDeviceESP")) or CoreGui:FindFirstChild("ForsakenDeviceESP") or Instance.new("ScreenGui")
			forsakenDeviceESP.Name = "ForsakenDeviceESP"
			forsakenDeviceESP:SetAttribute("GEN", 4)
			forsakenDeviceESP.DisplayOrder = 10
			forsakenDeviceESP.Parent = guiParent
		end

		if not (forsakenAbilityESP and forsakenAbilityESP.Parent) then
			forsakenAbilityESP = (guiParent and guiParent:FindFirstChild("ForsakenAbilityESP")) or CoreGui:FindFirstChild("ForsakenAbilityESP") or Instance.new("Folder")
			forsakenAbilityESP.Name = "ForsakenAbilityESP"
			forsakenAbilityESP:SetAttribute("GEN", 4)
			forsakenAbilityESP.Parent = guiParent
		end

		local function fn34(child)
			task.spawn(function()
				if child:IsA("Model") then
					if child == localPlayer.Character then return end
					local humanoidRootPart = child:FindFirstChild("HumanoidRootPart") or child:WaitForChild("HumanoidRootPart", 10)
					local humanoid = child:FindFirstChildOfClass("Humanoid") or child:WaitForChild("Humanoid", 10)
					local head = child:FindFirstChild("Head") or child:WaitForChild("Head", 10)

					if flag and humanoidRootPart and humanoid and child.Parent and child:IsDescendantOf(workspace) then
						if tbl.PlayersTagsEsp and not tbl7[child] then
							CreatePlayerTagDrawing(child, child.Parent.Name == "Killers" and tbl.EspKillerColor or tbl.EspSurvivorsColor, humanoidRootPart, humanoid)
						end
						if not tbl8[child] then
							fn30(child, humanoidRootPart, head, humanoid)
						end
					end
				end
			end)
		end

		local function fn35(arg)
			if not (arg and arg.Parent and arg:IsDescendantOf(workspace)) then
				return
			end
			local tName = arg.Name
			if espHookedFolders[tName] ~= arg then
				clearEspFolderConn(tName)
				espHookedFolders[tName] = arg
				local cAdd = arg.ChildAdded:Connect(fn34)
				local cRem = arg.ChildRemoved:Connect(RemovePlayerTagDrawing)
				local cAnc
				cAnc = arg.AncestryChanged:Connect(function(_, parent)
					if not parent or not arg:IsDescendantOf(workspace) then
						if espHookedFolders[tName] == arg then
							clearEspFolderConn(tName)
						end
					end
				end)
				espFolderConns[tName] = { cAdd, cRem, cAnc }
			end

			for _, child in ipairs(arg:GetChildren()) do
				if not tbl8[child] or (tbl.PlayersTagsEsp and not tbl7[child]) then
					fn34(child)
				end
			end
		end

		local function bindPlayersRoot(players2)
			if not (players2 and players2.Parent) then return end
			if espPlayersFolder ~= players2 then
				if espPlayersConn then pcall(function() espPlayersConn:Disconnect() end) espPlayersConn = nil end
				espPlayersFolder = players2
				espPlayersConn = players2.ChildAdded:Connect(function(sub)
					if flag and (sub.Name == "Survivors" or sub.Name == "Killers") then
						task.defer(fn35, sub)
					end
				end)
			end
			fn35(players2:FindFirstChild("Survivors"))
			fn35(players2:FindFirstChild("Killers"))
		end

		local playersNow = workspace:FindFirstChild("Players")
		if playersNow then
			bindPlayersRoot(playersNow)
		else
			task.spawn(function()
				local pWait = workspace:WaitForChild("Players", 15)
				if flag and pWait then bindPlayersRoot(pWait) end
			end)
		end

		if not flag then
			flag = true
			table.insert(tbl9, workspace.ChildAdded:Connect(function(ch)
				if flag and ch.Name == "Players" then
					task.defer(bindPlayersRoot, ch)
				end
			end))
		end

		if not connection2 then
			connection2 = RunService.RenderStepped:Connect(fn33)
		end
	end

end

	local function a723IconSweep(n, nd)
		local cg = (gethui and gethui()) or CoreGui
		for _, g in ipairs(cg:GetChildren()) do
			if g.Name == "ForsakenAbilityESP" or g.Name == "ForsakenDeviceESP" then
				for _, d in ipairs(g:GetDescendants()) do
					if d.Name == "IconFrame" and d:IsA("Frame") then
						d.Size = UDim2.new(0, n, 0, n)
						d.Position = UDim2.new(0.5, -n / 2, 0, 20)
						local uc = d:FindFirstChildOfClass("UICorner")
						if uc then uc.CornerRadius = UDim.new(0, math.max(4, math.floor(n * 0.18))) end
						if d.Parent and d.Parent:IsA("Frame") then d.Parent.Size = UDim2.new(0, n + 6, 0, n + 28) end
					elseif d:IsA("Frame") and d.Parent and d.Parent.Name == "ForsakenDeviceESP" then
						d.Size = UDim2.new(0, nd, 0, nd)
					end
				end
			end
		end
	end
	rawset(_G, "__A723_TOKEN", {})
	-- [r44 Event-Driven] Quét khởi tạo 1 lần duy nhất, sau đó chỉ cập nhật khi Slider thay đổi
	pcall(function()
		local n = tbl.EspIconSize or 50
		local nd = math.clamp(math.floor(n * 0.48 + 0.5), 12, 64)
		a723IconSweep(n, nd)
	end)
	local killers, ingame, survivors
	local function resolveFolders()

		local kp = workspace:FindFirstChild("Players")
		killers = kp and kp:FindFirstChild("Killers")
		survivors = kp and kp:FindFirstChild("Survivors")
		local mp = workspace:FindFirstChild("Map")
		ingame = mp and mp:FindFirstChild("Ingame")
	end
	ESP_SET = {
		killer = function(v)
			tbl.KillerEsp = v
			resolveFolders()
			if v and not killers then
				pcall(function() if v2.get("a720Telemetry", false) then print("[NERG] killer esp ON but Killers folder missing (lobby) — waiting for next round") end end)
				task.spawn(function()
					local kp = workspace:FindFirstChild("Players") or workspace:WaitForChild("Players", 60)
					local kl = kp and kp:WaitForChild("Killers", 60)
					if kl and tbl.KillerEsp then
						pcall(function() if v2.get("a720Telemetry", false) then print("[NERG] Killers folder up — painting highlights") end end)
						pcall(killerEsp)
					end
				end)
				return
			end
			pcall(killerEsp)
			pcall(function() if v2.get("a720Telemetry", false) then print("[NERG] killer esp → " .. tostring(v)) end end)
		end,
		surv = function(v)
			tbl.SurvivorsEsp = v
			resolveFolders()
			if v and not survivors then
				pcall(function() if v2.get("a720Telemetry", false) then print("[NERG] survivor esp ON but Survivors folder missing (lobby) — waiting for next round") end end)
				task.spawn(function()
					local kp = workspace:FindFirstChild("Players") or workspace:WaitForChild("Players", 60)
					local sv = kp and kp:WaitForChild("Survivors", 60)
					if sv and tbl.SurvivorsEsp then
						pcall(function() if v2.get("a720Telemetry", false) then print("[NERG] Survivors folder up — painting highlights") end end)
						pcall(survivorsEsp)
					end
				end)
				return
			end
			pcall(survivorsEsp)
			pcall(function() if v2.get("a720Telemetry", false) then print("[NERG] survivor esp → " .. tostring(v)) end end)
		end,
		color_killer = function(c) tbl.EspKillerColor = c
			for k, v in pairs(tbl7) do
				local st = tbl8[k]
				local isK = (st and st.Type == "Killer") or (k and k.Parent and k.Parent.Name == "Killers")
				if isK and v.MainText then pcall(function() v.MainText.Color = c end) end
			end
			pcall(killerEspColorUpdate)
		end,
		color_surv = function(c) tbl.EspSurvivorsColor = c
			for k, v in pairs(tbl7) do
				local st = tbl8[k]
				local isK = (st and st.Type == "Killer") or (k and k.Parent and k.Parent.Name == "Killers")
				if not isK and v.MainText then pcall(function() v.MainText.Color = c end) end
			end
			pcall(survivorsEspColorUpdate)
		end,
		ability = function(v)
			pcall(function()
				rawset(_G, "NERG_ABILITY_ESP", v and true or false)
				if not tbl.TagsOptions then tbl.TagsOptions = {} end
				tbl.TagsOptions.Abilities = v and true or false
				if v then
					StartESPSystem()
				elseif not tbl.PlayersTagsEsp then
					StopESPSystem()
				end
			end)
		end,
		tags = function(v)
			pcall(function()
				tbl.PlayersTagsEsp = v and true or false
				if v then
					StartESPSystem()
					if not forsakenDeviceESP then
						forsakenDeviceESP = CoreGui:FindFirstChild("ForsakenDeviceESP") or Instance.new("ScreenGui")
						forsakenDeviceESP.Name = "ForsakenDeviceESP"
						forsakenDeviceESP:SetAttribute("GEN", 4)
						forsakenDeviceESP.DisplayOrder = 10
						forsakenDeviceESP.Parent = (gethui and gethui()) or CoreGui
					end
					local plFolder = workspace:FindFirstChild("Players")
					if plFolder then
						for _, teamName in ipairs({ "Killers", "Survivors" }) do
							local tf = plFolder:FindFirstChild(teamName)
							if tf then
								for _, ch in ipairs(tf:GetChildren()) do
									if ch:IsA("Model") and ch ~= localPlayer.Character and not tbl7[ch] then
										local hrp = ch:FindFirstChild("HumanoidRootPart")
										local hum = ch:FindFirstChildOfClass("Humanoid")
										if hrp and hum then
											CreatePlayerTagDrawing(ch, teamName == "Killers" and tbl.EspKillerColor or tbl.EspSurvivorsColor, hrp, hum)
										end
									end
								end
							end
						end
					end
				elseif not _G.NERG_ABILITY_ESP then
					StopESPSystem()
				else
					for k, v3 in pairs(tbl7) do
						pcall(function() v3.MainText:Remove() end)
						pcall(function() v3.SubText:Remove() end)
						if v3.DeviceGuiFrame then pcall(function() v3.DeviceGuiFrame:Destroy() end) end
						tbl7[k] = nil
					end
					if forsakenDeviceESP then forsakenDeviceESP:Destroy() forsakenDeviceESP = nil end
				end
			end)
		end,
		opt = function(k, v)
			tbl.TagsOptions = tbl.TagsOptions or {}
			tbl.TagsOptions[k] = v
			pcall(function() if v2.get("a720Telemetry", false) then print("[NERG] tag-opt " .. tostring(k) .. " → " .. tostring(v)) end end)
		end,
		options = function(o)
			local d = {}
			if type(o) == "table" then
				for k, v in pairs(o) do
					if type(k) == "number" and type(v) == "string" then d[v] = true
					elseif v == true and type(k) == "string" then d[k] = true end
				end
			end
			if _G.NERG_ABILITY_ESP then d.Abilities = true end
			tbl.TagsOptions = d
			local cnt = 0
			for _ in pairs(d) do cnt += 1 end
			pcall(function() if v2.get("a720Telemetry", false) then print("[NERG] tag options set: " .. cnt .. " items") end end)
		end,
		dbg = function()
			local n = 0
			for _ in pairs(tbl7) do n += 1 end
			return "KillerEsp=" .. tostring(tbl.KillerEsp) .. " SurvEsp=" .. tostring(tbl.SurvivorsEsp) ..
				" opts-map: Name=" .. tostring(tbl.TagsOptions and tbl.TagsOptions.Name) .. " Health=" .. tostring(tbl.TagsOptions and tbl.TagsOptions.Health) ..
				" killers=" .. tostring(killers ~= nil) .. " survivors=" .. tostring(survivors ~= nil) .. " tags=" .. n .. " IconN=" .. tostring(tbl.EspIconSize)
		end,
		size = function(n) tbl.EspTextSize = n
			for _, v in pairs(tbl7) do
				if v.MainText then pcall(function() v.MainText.TextSize = n end) end
				if v.SubText then pcall(function() v.SubText.TextSize = math.max(8, n - 1) end) end
			end
		end,
		iconsize = function(n)
			n = math.clamp(math.floor(tonumber(n) or 50), 16, 120)
			tbl.EspIconSize = n
			local nd = math.clamp(math.floor(n * 0.48 + 0.5), 12, 64)
			pcall(a723IconSweep, n, nd)
			for _, st in pairs(tbl8) do
				local ab = st.AbilityState
				if ab and ab.Frames then
					for _, fr in pairs(ab.Frames) do
						pcall(function()
							fr.Size = UDim2.new(0, n + 6, 0, n + 28)
							local f2 = fr:FindFirstChild("IconFrame")
							if f2 then
								f2.Size = UDim2.new(0, n, 0, n)
								f2.Position = UDim2.new(0.5, -n / 2, 0, 20)
								local uc = f2:FindFirstChildOfClass("UICorner")
								if uc then uc.CornerRadius = UDim.new(0, math.max(4, math.floor(n * 0.18))) end
							end
						end)
					end
				end
			end
			for _, v in pairs(tbl7) do
				if v.DeviceGuiFrame then
					pcall(function()
						v.DeviceGuiFrame:SetAttribute("_ls", nil)
						v.DeviceGuiFrame.Size = UDim2.new(0, nd, 0, nd)
					end)
				end
			end
			pcall(function() a723IconSweep(n, nd) end)
			pcall(function() if v2.get("a720Telemetry", false) then print("[NERG] icon size → " .. n) end end)
		end,
		get = function(k, sub)
			if k == "Opt" then return (tbl.TagsOptions or {})[sub] end
			if k == "Options" then return tbl.TagsOptions or {} end
			if k == "KillerEsp" then return tbl.KillerEsp == true end
			if k == "SurvEsp" then return tbl.SurvivorsEsp == true end
			if k == "TagsEsp" then return tbl.PlayersTagsEsp == true end
			if k == "EspTextSize" then return tbl.EspTextSize or 14 end
			if k == "EspIconSize" then return tbl.EspIconSize or 50 end
			if k == "KillerColor" then return tbl.EspKillerColor end
			if k == "SurvColor" then return tbl.EspSurvivorsColor end
			return nil
		end,
		getOptions = function()
			return tbl.TagsOptions or {}
		end,
		rawset(_G, "ESP_DBG", function() return ESP_SET.dbg() end)
	}
	rawset(_G, "NERG_ESP_SET", ESP_SET)
	rawset(_G, "NERG_ESP_SHUTDOWN", function()
		pcall(function()
			tbl.PlayersTagsEsp = false
			if StopESPSystem then StopESPSystem() end
		end)
		pcall(function()
			if tbl.KillerEsp then tbl.KillerEsp = false pcall(killerEsp) end
			if tbl.SurvivorsEsp then tbl.SurvivorsEsp = false pcall(survivorsEsp) end
		end)
		pcall(function()
			local hub = (gethui and gethui()) or CoreGui
			for _, g in ipairs(hub:GetChildren()) do
				if g.Name == "NergFK_TextTags" or g.Name == "ForsakenDeviceESP" or g.Name == "ForsakenAbilityESP" then
					pcall(function() g:Destroy() end)
				end
			end
		end)
	end)
	local function purgeOldESP()
		local cg = (gethui and gethui()) or CoreGui
		for _, g in ipairs(cg:GetChildren()) do
			if (g:IsA("ScreenGui") or g:IsA("Folder")) and (g.Name == "NergFK_TextTags" or g.Name == "ForsakenDeviceESP" or g.Name == "ForsakenAbilityESP") and g:GetAttribute("GEN") ~= 4 then
				pcall(function() g:Destroy() end)
			end
		end
		for _, g in ipairs(cg:GetChildren()) do
			if g:IsA("Folder") and g.Name == "ForsakenAbilityESP" then
				for _, bb in ipairs(g:GetChildren()) do
					if bb:IsA("BillboardGui") and (not bb.Adornee or bb.Adornee.Parent == nil) then
						pcall(function() bb:Destroy() end)
					end
				end
			end
		end
	end
	purgeOldESP()
	pcall(function()
		local hub2 = (gethui and gethui()) or CoreGui
		for _, g2 in ipairs(hub2:GetChildren()) do
			if g2.Name == "NergFK_TextTags" or g2.Name == "ForsakenDeviceESP" or g2.Name == "ForsakenAbilityESP" then
				pcall(function() g2:Destroy() end)
			end
		end
	end)
	pcall(function()
		local kp = workspace:FindFirstChild("Players")
		if kp then
			local kf = kp:FindFirstChild("Killers")
			if kf then
				for _, d in ipairs(kf:GetDescendants()) do
					if d:IsA("Highlight") and (d:GetAttribute("NergHL") == true or d.Name == "External_Protected_HL") then
						pcall(function() d:Destroy() end)
					end
				end
			end
			local sf = kp:FindFirstChild("Survivors")
			if sf then
				for _, d in ipairs(sf:GetDescendants()) do
					if d:IsA("Highlight") and (d:GetAttribute("NergHL") == true or d.Name == "External_Protected_HL") then
						pcall(function() d:Destroy() end)
					end
				end
			end
		end
	end)
	task.spawn(function() while true do if _G.__NERG_KILLED or not __PLUS_GEN_ALIVE then break end task.wait(2) pcall(purgeOldESP) end end)
	if tbl.PlayersTagsEsp then StartESPSystem() end
	local function isOurHL(d)
		return d:IsA("Highlight") and (d:GetAttribute("NergHL") == true or d.Name == "External_Protected_HL" or d.Name == tostring(_G.__NERG_HL_NAME))
	end
	local function nergEspSweepTeam(teamName)
		local kp = workspace:FindFirstChild("Players")
		local f = kp and kp:FindFirstChild(teamName)
		if f then
			for _, ch in ipairs(f:GetChildren()) do
				for _, d in ipairs(ch:GetDescendants()) do
					if isOurHL(d) then pcall(function() d:Destroy() end) end
				end
			end
		end
		if teamName == "Killers" then
			local mp = workspace:FindFirstChild("Map")
			local ig = mp and mp:FindFirstChild("Ingame")
			if ig then
				for _, ch in ipairs(ig:GetChildren()) do
					if isOurHL(ch) then
						pcall(function() ch:Destroy() end)
					elseif ch:IsA("Model") or ch:IsA("Folder") then
						for _, d in ipairs(ch:GetChildren()) do
							if isOurHL(d) then pcall(function() d:Destroy() end) end
						end
					end
				end
			end
		end
	end
	local lastK5, lastS5, lastIng5 = nil, nil, nil
	task.spawn(function()
		while true do
			if _G.__NERG_KILLED or not __PLUS_GEN_ALIVE then break end
			task.wait(5)
			pcall(function()
				local mapInst = workspace:FindFirstChild("Map")
				local curIng = mapInst and mapInst:FindFirstChild("Ingame")
				local ingChanged = (curIng ~= lastIng5)
				lastIng5 = curIng
				if tbl.KillerEsp ~= lastK5 or (tbl.KillerEsp and ingChanged) then
					lastK5 = tbl.KillerEsp
					if tbl.KillerEsp then pcall(killerEsp) else pcall(nergEspSweepTeam, "Killers") end
				end
				if tbl.SurvivorsEsp ~= lastS5 or (tbl.SurvivorsEsp and ingChanged) then
					lastS5 = tbl.SurvivorsEsp
					if tbl.SurvivorsEsp then pcall(survivorsEsp) else pcall(nergEspSweepTeam, "Survivors") end
				end
				if ingChanged and (tbl.PlayersTagsEsp or _G.NERG_ABILITY_ESP == true) then
					pcall(StartESPSystem)
				end
			end)
		end
	end)
	pcall(function() for _ = 1, 3 do print('[A693] AUTO-ON-CALLED') end end)


-- [NERG-B1/r14] Objects + Items ESP (port tu TO-A615 · event-driven · self-destruct via __NERG_KILLED)
do
	local OBJ = {
		master = false, itemsOn = false, tagsOn = false, azureRadius = false,
		perType = { Graffiti = true, TaphTrap = true, Ritual = true, Builderman = true, AzureTrap = true },
		colors = {
			Graffiti = Color3.fromRGB(255, 192, 203),
			TaphTrap = Color3.fromRGB(255, 165, 0),
			Ritual = Color3.fromRGB(170, 120, 255),
			Builderman = Color3.fromRGB(90, 200, 250),
			AzureTrap = Color3.fromRGB(255, 30, 30),
			Items = Color3.fromRGB(89, 0, 255),
		},
	}
	rawset(_G, "NERG_OBJ", OBJ)

	local REG = {
		{ key = "Graffiti", label = "Graffiti", trans = true,
			match = function(d) return d.Name == "GraffitiCL" end },
		{ key = "TaphTrap", label = "Taph Trap", trans = false,
			match = function(d) return d.Name == "SubspaceTripmine" or d:FindFirstChild("Wire") ~= nil end },
		{ key = "Ritual", label = "Ritual", trans = true,
			match = function(d) return string.find(d.Name, "RespawnLocation", 1, true) ~= nil end },
		{ key = "Builderman", label = "Sentry/Dispenser", trans = false,
			match = function(d) return d.Name == "BuildermanSentry" or d.Name == "BuildermanDispenser" end },
		{ key = "AzureTrap", label = "Azure Trap", trans = false,
			match = function(d)
				if not (d:IsA("Model") and d.Parent and d.Parent.Name == "Ingame") then
					return false
				end
				local name = d.Name
				if name == "GroundBulbModel" or name == "GroundBulb" then
					return d.PrimaryPart ~= nil or d:FindFirstChildWhichIsA("BasePart") ~= nil
				end
				if name == "VineModel" then
					return d:FindFirstChild("AnimationController") ~= nil or d:FindFirstChild("RootPart") ~= nil
				end
				return false
			end,
			radius = function(d)
				local name = d.Name
				if name == "GroundBulbModel" or name == "GroundBulb" then return 30 end
				if name == "VineModel" then return 20 end
				return nil
			end },
	}
	local ITEM_MATCH = { BloxyCola = true, Medkit = true }
	local HLNAME = "NP_ObjHL"

	local reg, items = {}, {}
	local conns, ingame = {}, nil
	local supConn, tagConn = nil, nil
	local players = game:GetService("Players")
	local rs = game:GetService("RunService")

	local function baseOf(d)
		if not d then return nil end
		if d:IsA("Model") then return d.PrimaryPart or d:FindFirstChildWhichIsA("BasePart", true) end
		if d:IsA("Tool") then
			return d:FindFirstChild("ItemRoot", true) or d:FindFirstChild("Handle", true) or d:FindFirstChildWhichIsA("BasePart", true)
		end
		if d:IsA("BasePart") then return d end
		return nil
	end

	local function findEntry(d)
		if not (d:IsA("Model") or d:IsA("BasePart")) then return nil end
		local nm = d.Name
		if nm == "GraffitiCL" then return REG[1] end
		if nm == "SubspaceTripmine" or (d:IsA("Model") and d:FindFirstChild("Wire") ~= nil) then return REG[2] end
		if string.find(nm, "RespawnLocation", 1, true) ~= nil then return REG[3] end
		if nm == "BuildermanSentry" or nm == "BuildermanDispenser" then return REG[4] end
		if (nm == "GroundBulbModel" or nm == "GroundBulb" or nm == "VineModel") and d:IsA("Model") and d.Parent and d.Parent.Name == "Ingame" then
			local ok, res = pcall(REG[5].match, d)
			if ok and res then return REG[5] end
		end
		return nil
	end

	local function applyHL(target, color)
		local adornee = target
		if target:IsA("Tool") then
			adornee = baseOf(target) or target
		end
		local hl = target:FindFirstChild(HLNAME)
		if not hl then
			hl = Instance.new("Highlight")
			hl.Name = HLNAME
			hl.FillTransparency = 0.45
			hl.OutlineTransparency = 0
			hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			hl.Parent = target
		end
		hl.Adornee = adornee
		hl.FillColor = color
		hl.OutlineColor = color
		return hl
	end

	local function rmReg(inst)
		local rec = reg[inst]
		if not rec then return end
		if rec.hl then pcall(function() rec.hl:Destroy() end) end
		if rec.tag then pcall(function() rec.tag.Remove() end) end
		if rec.cyl then pcall(function() rec.cyl:Destroy() end) end
		if rec.trans and rec.savedT ~= nil and inst.Parent then
			pcall(function() inst.Transparency = rec.savedT end)
		end
		reg[inst] = nil
	end

	local function rmItem(tool)
		local rec = items[tool]
		if not rec then return end
		if rec.hl then pcall(function() rec.hl:Destroy() end) end
		if rec.box then pcall(function() rec.box:Destroy() end) end
		if rec.tag then pcall(function() rec.tag.Remove() end) end
		items[tool] = nil
	end

	local function applyReg(inst, entry)
		local active = OBJ.master and OBJ.perType[entry.key]
		local rec = reg[inst]
		if not active then
			if rec then rmReg(inst) end
			return
		end
		local bp = baseOf(inst)
		if not bp then
			if rec then rmReg(inst) end
			return
		end
		if not rec then
			rec = { entry = entry, bp = bp }
			reg[inst] = rec
			if entry.trans and inst:IsA("BasePart") then
				rec.trans = true
				rec.savedT = inst.Transparency
				pcall(function() inst.Transparency = 0 end)
			end
		else
			rec.bp = bp
		end
		if rec.hl and rec.hl.Parent then
			rec.hl = applyHL(inst, OBJ.colors[entry.key])
		else
			rec.hl = nil
		end
		if OBJ.tagsOn then
			if not rec.tag then rec.tag = forsakenFK.textTag() end
			rec.tag.Text = entry.label
			rec.tag.Color = OBJ.colors[entry.key]
			rec.tag.Size = 14
		else
			if rec.tag then rec.tag.Remove() rec.tag = nil end
		end
		if rec.cyl and rec.cyl.Parent ~= inst then
			rec.cyl = nil
		end
		if OBJ.azureRadius and entry.radius then
			local okR, r = pcall(entry.radius, inst)
			if okR and r and bp then
				local cyl = inst:FindFirstChild("NP_ObjRadius")
				if not cyl then
					cyl = Instance.new("CylinderHandleAdornment")
					cyl.Name = "NP_ObjRadius"
					cyl.Color3 = Color3.fromRGB(255, 30, 30)
					cyl.Transparency = 0.75
					cyl.Height = 0.05
					cyl.AlwaysOnTop = true
					cyl.Parent = inst
				end
				cyl.Adornee = bp
				cyl.Radius = r
				cyl.CFrame = bp.CFrame:ToObjectSpace(CFrame.new(bp.Position) * CFrame.Angles(1.5707963267948966, 0, 0))
				rec.cyl = cyl
			elseif rec.cyl then
				pcall(function() rec.cyl:Destroy() end)
				rec.cyl = nil
			end
		elseif rec.cyl then
			pcall(function() rec.cyl:Destroy() end)
			rec.cyl = nil
		end
	end

	local function applyItem(tool)
		local active = OBJ.itemsOn and ITEM_MATCH[tool.Name] == true
		local rec = items[tool]
		if not active then
			if rec then rmItem(tool) end
			return
		end
		local bp = baseOf(tool)
		if not bp then
			if rec then rmItem(tool) end
			return
		end
		if not rec then
			rec = {}
			items[tool] = rec
		end
		rec.bp = bp
		if rec.hl and rec.hl.Parent then
			rec.hl = applyHL(tool, OBJ.colors.Items)
		else
			rec.hl = nil
		end
		local box = tool:FindFirstChild("NP_ItemBox")
		if not box then
			box = Instance.new("BoxHandleAdornment")
			box.Name = "NP_ItemBox"
			box.AlwaysOnTop = true
			box.ZIndex = 7
			box.Transparency = 0.45
			box.Parent = tool
		end
		box.Adornee = bp
		box.Size = bp.Size + Vector3.new(0.25, 0.25, 0.25)
		box.Color3 = OBJ.colors.Items
		rec.box = box
		if OBJ.tagsOn then
			if not rec.tag then rec.tag = forsakenFK.textTag() end
			rec.tag.Text = tool.Name
			rec.tag.Color = OBJ.colors.Items
			rec.tag.Size = 14
		else
			if rec.tag then rec.tag.Remove() rec.tag = nil end
		end
	end

	local function detachConns()
		if conns.added then pcall(function() conns.added:Disconnect() end) conns.added = nil end
		if conns.rem then pcall(function() conns.rem:Disconnect() end) conns.rem = nil end
	end

	local function scanIngame()
		if not ingame then return end
		for _, d in ipairs(ingame:GetDescendants()) do
			if (d:IsA("Tool") or d:IsA("Model")) and ITEM_MATCH[d.Name] == true then
				if OBJ.itemsOn then applyItem(d) end
			elseif OBJ.master then
				local e = findEntry(d)
				if e then applyReg(d, e) end
			end
		end
	end

	local function ensureConns()
		local mp = workspace:FindFirstChild("Map")
		local ing = mp and mp:FindFirstChild("Ingame")
		if ing == ingame then
			if ingame and ((OBJ.master and next(reg) == nil) or (OBJ.itemsOn and next(items) == nil)) then
				scanIngame()
			end
			return
		end
		for inst in pairs(reg) do rmReg(inst) end
		for tool in pairs(items) do rmItem(tool) end
		ingame = ing
		detachConns()
		if not ingame then return end
		conns.added = ingame.DescendantAdded:Connect(function(d)
			if not (d:IsA("Model") or d:IsA("Tool") or d:IsA("BasePart") or d:IsA("AnimationController")) then return end
			task.defer(function()
				if not d.Parent then return end
				if (d:IsA("Tool") or d:IsA("Model")) and ITEM_MATCH[d.Name] == true then
					applyItem(d)
					return
				end
				if d:IsA("BasePart") and d.Parent and ITEM_MATCH[d.Parent.Name] == true then
					applyItem(d.Parent)
					return
				end
				local e = findEntry(d)
				if e then
					applyReg(d, e)
				elseif d.Parent and d.Parent ~= ingame then
					local ep = findEntry(d.Parent)
					if ep then applyReg(d.Parent, ep) end
				end
			end)
		end)
		conns.rem = ingame.DescendantRemoving:Connect(function(d)
			if reg[d] then rmReg(d) end
			if items[d] then rmItem(d) end
		end)
		scanIngame()
	end

	local function projStep()
		local cam = workspace.CurrentCamera
		if not cam then return end
		local lp = players.LocalPlayer
		local ch = lp and lp.Character
		local myHRP = ch and ch:FindFirstChild("HumanoidRootPart")
		for inst, rec in pairs(reg) do
			local t = rec.tag
			if t then
				local bp = rec.bp
				if bp == nil or bp.Parent == nil then
					bp = baseOf(inst)
					rec.bp = bp
				end
				if bp and bp.Parent then
					local okP, sp = pcall(cam.WorldToViewportPoint, cam, bp.Position)
					local show = false
					if okP and sp then
						local dOK = true
						if myHRP then
							dOK = (bp.Position - myHRP.Position).Magnitude <= 120
						end
						show = sp.Z > 0 and dOK
						if show then
							t.Position = Vector2.new(sp.X, sp.Y)
						end
					end
					t.Visible = show
				else
					t.Visible = false
				end
			end
		end
		for tool, rec in pairs(items) do
			local t = rec.tag
			if t then
				local bp = rec.bp
				if bp == nil or bp.Parent == nil then
					bp = baseOf(tool)
					rec.bp = bp
				end
				if bp and bp.Parent then
					local dOK = (not myHRP) or ((bp.Position - myHRP.Position).Magnitude <= 300)
					local show = false
					if dOK then
						local okP, sp = pcall(cam.WorldToViewportPoint, cam, bp.Position)
						if okP and sp and sp.Z > 0 then
							show = true
							t.Position = Vector2.new(sp.X, sp.Y)
						end
					end
					t.Visible = show
				else
					t.Visible = false
				end
			end
		end
	end

	local function setTagLoop(on)
		if on and not tagConn then
			tagConn = rs.RenderStepped:Connect(projStep)
		elseif not on and tagConn then
			tagConn:Disconnect()
			tagConn = nil
			for _, rec in pairs(reg) do
				if rec.tag then rec.tag.Visible = false end
			end
			for _, rec in pairs(items) do
				if rec.tag then rec.tag.Visible = false end
			end
		end
	end

	local MAX_OBJ_HL, MAX_ITEM_HL = 12, 8
	local function cullFar()
		local lp = players.LocalPlayer
		local ch = lp and lp.Character
		local myHRP = ch and ch:FindFirstChild("HumanoidRootPart")
		if not myHRP then return end
		local myList = {}
		for inst, rec in pairs(reg) do
			if not inst.Parent or not inst:IsDescendantOf(workspace) or (ingame and not inst:IsDescendantOf(ingame)) then
				rmReg(inst)
			elseif OBJ.master and rec.entry then
				local bp = rec.bp
				if bp == nil or bp.Parent == nil then
					bp = baseOf(inst)
					rec.bp = bp
				end
				if bp and bp.Parent and bp:IsDescendantOf(workspace) then
					local okD, d = pcall(function() return (bp.Position - myHRP.Position).Magnitude end)
					if okD and d then
						if d > 120 then
							if rec.hl then pcall(function() rec.hl:Destroy() end) rec.hl = nil end
						else
							myList[#myList + 1] = { d = d, inst = inst, rec = rec }
						end
					end
				else
					rmReg(inst)
				end
			end
		end
		table.sort(myList, function(a, b) return a.d < b.d end)
		for i, e in ipairs(myList) do
			if i <= MAX_OBJ_HL then
				if not e.rec.hl or not e.rec.hl.Parent then
					e.rec.hl = applyHL(e.inst, OBJ.colors[e.rec.entry.key])
				end
				if OBJ.azureRadius and e.rec.cyl and (e.rec.entry.key == "AzureTrap") then
					local dynR = e.rec.entry.radius and e.rec.entry.radius(e.inst)
					if dynR and dynR ~= e.rec.cyl.Radius then
						pcall(function() e.rec.cyl.Radius = dynR end)
					end
				end
			else
				if e.rec.hl then pcall(function() e.rec.hl:Destroy() end) e.rec.hl = nil end
			end
		end
		local iList = {}
		for tool, rec in pairs(items) do
			if not tool.Parent or not tool:IsDescendantOf(workspace) or (ingame and not tool:IsDescendantOf(ingame)) then
				rmItem(tool)
			elseif OBJ.itemsOn then
				local bp = rec.bp
				if bp == nil or bp.Parent == nil then
					bp = baseOf(tool)
					rec.bp = bp
				end
				if bp and bp.Parent then
					local okD, d = pcall(function() return (bp.Position - myHRP.Position).Magnitude end)
					if okD and d then
						if d > 300 then
							if rec.hl then pcall(function() rec.hl:Destroy() end) rec.hl = nil end
							if rec.box then rec.box.Visible = false end
						else
							iList[#iList + 1] = { d = d, inst = tool, rec = rec, bp = bp }
						end
					end
				else
					rmItem(tool)
				end
			end
		end
		table.sort(iList, function(a, b) return a.d < b.d end)
		for i, e in ipairs(iList) do
			if i <= MAX_ITEM_HL then
				if not e.rec.hl or not e.rec.hl.Parent then
					e.rec.hl = applyHL(e.inst, OBJ.colors.Items)
				elseif e.rec.hl.Adornee ~= e.bp and e.inst:IsA("Tool") then
					e.rec.hl.Adornee = e.bp
				end
				if e.rec.box then
					e.rec.box.Adornee = e.bp
					e.rec.box.Color3 = OBJ.colors.Items
					e.rec.box.Visible = true
				end
			else
				if e.rec.hl then pcall(function() e.rec.hl:Destroy() end) e.rec.hl = nil end
				if e.rec.box then e.rec.box.Visible = false end
			end
		end
	end

	local function rescanAll()
		if (OBJ.master and next(reg) == nil) or (OBJ.itemsOn and next(items) == nil) then
			pcall(scanIngame)
		end
		for inst, rec in pairs(reg) do
			if rec.entry then applyReg(inst, rec.entry) end
		end
		for tool in pairs(items) do
			applyItem(tool)
		end
		pcall(cullFar)
	end

	function OBJ.setMaster(v)
		OBJ.master = v and true or false
		if OBJ.master then pcall(ensureConns) end
		rescanAll()
	end
	function OBJ.setItems(v)
		OBJ.itemsOn = v and true or false
		if OBJ.itemsOn then pcall(ensureConns) end
		rescanAll()
	end
	function OBJ.setType(k, v)
		OBJ.perType[k] = v and true or false
		if OBJ.master and OBJ.perType[k] then pcall(scanIngame) end
		rescanAll()
	end
	function OBJ.setTags(v)
		OBJ.tagsOn = v and true or false
		setTagLoop(OBJ.tagsOn)
		rescanAll()
	end
	function OBJ.setAzure(v)
		OBJ.azureRadius = v and true or false
		rescanAll()
	end
	function OBJ.setColor(k, c)
		OBJ.colors[k] = c
		rescanAll()
	end
	function OBJ.shutdown()
		if supConn then
			pcall(function() supConn:Disconnect() end)
			supConn = nil
		end
		setTagLoop(false)
		for inst in pairs(reg) do rmReg(inst) end
		for tool in pairs(items) do rmItem(tool) end
		detachConns()
		ingame = nil
	end

	local accObj = 0
	supConn = rs.Heartbeat:Connect(function(dt)
		if _G.__NERG_KILLED or not __PLUS_GEN_ALIVE then
			supConn:Disconnect()
			supConn = nil
			pcall(function() OBJ.shutdown() end)
			return
		end
		if not (OBJ.master or OBJ.itemsOn) then return end
		accObj += dt
		if accObj < 0.5 then return end
		accObj = 0
		pcall(ensureConns)
		pcall(cullFar)
	end)
end


-- [NERG-ITEM-MAP] Dedicated Map Items ESP (Brandon Graffiti/Bottle, Hotel Fruits/Maw)
do
	local ITEM_MAP = {
		master = false,
		graffiti = false,
		fruits = false,
		showDist = false,
	}
	rawset(_G, "NERG_ITEM_MAP", ITEM_MAP)

	local ITEM_META = {
		["Blueberries"] = { color = Color3.fromRGB(80, 140, 255), icon = "🫐", name = "Blueberries" },
		["Cherries"] = { color = Color3.fromRGB(255, 50, 70), icon = "🍒", name = "Cherries" },
		["Grapes"] = { color = Color3.fromRGB(180, 70, 240), icon = "🍇", name = "Grapes" },
		["Lemons"] = { color = Color3.fromRGB(255, 240, 50), icon = "🍋", name = "Lemons" },
		["Mangos"] = { color = Color3.fromRGB(255, 160, 30), icon = "🥭", name = "Mangos" },
		["Oranges"] = { color = Color3.fromRGB(255, 120, 0), icon = "🍊", name = "Oranges" },
		["Passionfruits"] = { color = Color3.fromRGB(200, 100, 180), icon = "🍈", name = "Passionfruits" },
		["Watermelons"] = { color = Color3.fromRGB(50, 220, 90), icon = "🍉", name = "Watermelons" },
		["Fruit"] = { color = Color3.fromRGB(255, 140, 0), icon = "🍎", name = "Fruit" },
		["Wipe"] = { color = Color3.fromRGB(255, 105, 180), icon = "🧼", name = "Wipe" },
		["Spray Bottle"] = { color = Color3.fromRGB(0, 220, 255), icon = "🧴", name = "Spray Bottle" },
		["The Maw"] = { color = Color3.fromRGB(255, 170, 0), icon = "👄", name = "The Maw" },
	}

	local rs = game:GetService("RunService")
	local players = game:GetService("Players")

	local activeEntries = {}
	local mapConns = {}
	local heartbeatConn = nil
	local accTime = 0

	local function getTargetPart(inst)
		if not inst then return nil end
		if inst:IsA("BasePart") then return inst end
		if inst:IsA("Model") then return inst.PrimaryPart or inst:FindFirstChildWhichIsA("BasePart", true) end
		if inst:IsA("Tool") then
			return inst:FindFirstChild("ItemRoot", true) or inst:FindFirstChild("Handle", true) or inst:FindFirstChildWhichIsA("BasePart", true)
		end
		return nil
	end

	local function clearRecord(inst)
		local rec = activeEntries[inst]
		if not rec then return end
		if rec.conn then pcall(function() rec.conn:Disconnect() end) end
		if rec.hl then pcall(function() rec.hl:Destroy() end) end
		if rec.bb then pcall(function() rec.bb:Destroy() end) end
		activeEntries[inst] = nil
	end

	local function createAdornment(inst, metaKey, kind)
		if activeEntries[inst] then return end
		local part = getTargetPart(inst)
		if not part then return end

		local meta = ITEM_META[metaKey] or { color = Color3.fromRGB(255, 140, 0), icon = "✨", name = metaKey }
		local color = meta.color
		local name = meta.name
		local icon = meta.icon

		-- Soft anti-glare Highlight
		local hl = Instance.new("Highlight")
		hl.Name = "NP_MapItemHL"
		hl.Adornee = (inst:IsA("Tool") and part) or inst
		hl.FillColor = color
		hl.FillTransparency = 0.65
		hl.OutlineColor = color
		hl.OutlineTransparency = 0.3
		hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		hl.Parent = inst

		-- High-contrast anti-glare Card Pill BillboardGui
		local bb = Instance.new("BillboardGui")
		bb.Name = "NP_MapItemBB"
		bb.Adornee = part
		bb.Size = UDim2.fromOffset(140, 42)
		bb.StudsOffsetWorldSpace = Vector3.new(0, 2.5, 0)
		bb.AlwaysOnTop = true
		bb.MaxDistance = 500

		local tl = Instance.new("TextLabel")
		tl.Name = "CardLabel"
		tl.Size = UDim2.fromScale(1, 1)
		tl.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
		tl.BackgroundTransparency = 0.15
		tl.Font = Enum.Font.GothamBold
		tl.TextScaled = false
		tl.TextSize = 13
		tl.TextColor3 = Color3.fromRGB(255, 255, 255)
		tl.TextStrokeTransparency = 0.6
		tl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		tl.Text = string.format("%s %s", icon, name)

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 6)
		corner.Parent = tl

		local stroke = Instance.new("UIStroke")
		stroke.Color = color
		stroke.Thickness = 1
		stroke.Transparency = 0.2
		stroke.Parent = tl

		tl.Parent = bb
		bb.Parent = inst

		local rec = {
			inst = inst,
			part = part,
			name = name,
			icon = icon,
			color = color,
			kind = kind,
			hl = hl,
			bb = bb,
			tl = tl,
		}

		rec.conn = inst.AncestryChanged:Connect(function(_, parent)
			if not parent or not inst:IsDescendantOf(workspace) then
				clearRecord(inst)
			end
		end)

		activeEntries[inst] = rec
	end

	local function scanItems()
		if not (ITEM_MAP.master and (ITEM_MAP.graffiti or ITEM_MAP.fruits)) then
			for inst in pairs(activeEntries) do
				clearRecord(inst)
			end
			return
		end

		local mapFolder = workspace:FindFirstChild("Map")
		local ingame = mapFolder and mapFolder:FindFirstChild("Ingame")
		if not ingame then
			for inst in pairs(activeEntries) do
				clearRecord(inst)
			end
			return
		end

		local currentMap = ingame:FindFirstChild("Map")
		if not currentMap then return end

		if ITEM_MAP.master and ITEM_MAP.graffiti then
			local graffitiFolder = currentMap:FindFirstChild("Graffiti")
			if graffitiFolder then
				for _, child in ipairs(graffitiFolder:GetChildren()) do
					if child:IsA("BasePart") then
						local prompt = child:FindFirstChildWhichIsA("ProximityPrompt", true)
						if prompt and prompt.ActionText == "Wipe" then
							createAdornment(child, "Wipe", "graffiti")
						end
					end
				end
			end

			local bottleSpawns = currentMap:FindFirstChild("BottleSpawns")
			if bottleSpawns then
				for _, child in ipairs(bottleSpawns:GetChildren()) do
					if child:IsA("Tool") or child.Name:find("SprayBottle") then
						createAdornment(child, "Spray Bottle", "bottle")
					end
				end
			end
		else
			for inst, rec in pairs(activeEntries) do
				if rec.kind == "graffiti" or rec.kind == "bottle" then
					clearRecord(inst)
				end
			end
		end

		if ITEM_MAP.master and ITEM_MAP.fruits then
			local fruitsFolder = currentMap:FindFirstChild("OrangeFruits")
			if fruitsFolder then
				for _, child in ipairs(fruitsFolder:GetChildren()) do
					if child:IsA("Tool") or child:IsA("Model") or child:IsA("BasePart") then
						createAdornment(child, child.Name, "fruit")
					end
				end
			end

			local themap = currentMap:FindFirstChild("themap")
			if themap then
				local maw = themap:FindFirstChild("TheMaw")
				if maw then
					local mouth = maw:FindFirstChild("Mouth", true)
					if mouth then
						createAdornment(mouth, "The Maw", "maw")
					end
				end
			end
		else
			for inst, rec in pairs(activeEntries) do
				if rec.kind == "fruit" or rec.kind == "maw" then
					clearRecord(inst)
				end
			end
		end
	end

	local function hookMapEvents()
		for _, c in ipairs(mapConns) do pcall(function() c:Disconnect() end) end
		table.clear(mapConns)

		local mapFolder = workspace:FindFirstChild("Map")
		local ingame = mapFolder and mapFolder:FindFirstChild("Ingame")
		if not ingame then return end

		table.insert(mapConns, ingame.DescendantAdded:Connect(function(d)
			if not (ITEM_MAP.master and (ITEM_MAP.graffiti or ITEM_MAP.fruits)) then return end
			task.defer(function()
				if not d.Parent then return end
				if ITEM_MAP.graffiti then
					if d:IsA("ProximityPrompt") and d.ActionText == "Wipe" and d.Parent and d.Parent:IsA("BasePart") then
						createAdornment(d.Parent, "Wipe", "graffiti")
					elseif (d:IsA("Tool") or d.Name:find("SprayBottle")) and d:IsDescendantOf(ingame) then
						local p = d.Parent
						if p and p.Name == "BottleSpawns" then
							createAdornment(d, "Spray Bottle", "bottle")
						end
					end
				end
				if ITEM_MAP.fruits then
					local p = d.Parent
					if p and p.Name == "OrangeFruits" then
						createAdornment(d, d.Name, "fruit")
					elseif d.Name == "Mouth" and d:IsDescendantOf(ingame) then
						createAdornment(d, "The Maw", "maw")
					end
				end
			end)
		end))

		table.insert(mapConns, ingame.DescendantRemoving:Connect(function(d)
			if activeEntries[d] then
				clearRecord(d)
			end
		end))
	end

	local function updateLoop(dt)
		if _G.__NERG_KILLED or not __PLUS_GEN_ALIVE then
			ITEM_MAP.shutdown()
			return
		end

		if not ITEM_MAP.master then return end

		accTime += dt
		if accTime < 0.25 then return end
		accTime = 0

		local lp = players.LocalPlayer
		local char = lp and lp.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		local myPos = hrp and hrp.Position

		for inst, rec in pairs(activeEntries) do
			if not inst.Parent or not inst:IsDescendantOf(workspace) then
				clearRecord(inst)
			else
				local part = rec.part
				if not part or not part.Parent then
					part = getTargetPart(inst)
					rec.part = part
					if rec.bb then rec.bb.Adornee = part end
				end
				if part and rec.tl then
					if ITEM_MAP.showDist and myPos then
						local dist = math.floor((part.Position - myPos).Magnitude + 0.5)
						rec.tl.Text = string.format("%s %s\n[%dm]", rec.icon, rec.name, dist)
					else
						rec.tl.Text = string.format("%s %s", rec.icon, rec.name)
					end
				end
			end
		end
	end

	function ITEM_MAP.setMaster(v)
		ITEM_MAP.master = v and true or false
		if ITEM_MAP.master then
			hookMapEvents()
			scanItems()
			if not heartbeatConn then
				heartbeatConn = rs.Heartbeat:Connect(updateLoop)
			end
		else
			for inst in pairs(activeEntries) do clearRecord(inst) end
			if heartbeatConn then
				heartbeatConn:Disconnect()
				heartbeatConn = nil
			end
		end
	end

	function ITEM_MAP.setGraffiti(v)
		ITEM_MAP.graffiti = v and true or false
		scanItems()
	end

	function ITEM_MAP.setFruits(v)
		ITEM_MAP.fruits = v and true or false
		scanItems()
	end

	function ITEM_MAP.setShowDist(v)
		ITEM_MAP.showDist = v and true or false
		if not ITEM_MAP.showDist then
			for _, rec in pairs(activeEntries) do
				if rec.tl then rec.tl.Text = string.format("%s %s", rec.icon, rec.name) end
			end
		end
	end

	function ITEM_MAP.shutdown()
		if heartbeatConn then
			pcall(function() heartbeatConn:Disconnect() end)
			heartbeatConn = nil
		end
		for _, c in ipairs(mapConns) do pcall(function() c:Disconnect() end) end
		table.clear(mapConns)
		for inst in pairs(activeEntries) do clearRecord(inst) end
		table.clear(activeEntries)
	end

	local mapWatchConn = nil
	local function checkMapIngame()
		local mapF = workspace:FindFirstChild("Map")
		if mapF then
			if mapWatchConn then mapWatchConn:Disconnect() end
			mapWatchConn = mapF.ChildAdded:Connect(function(c)
				if c.Name == "Ingame" and ITEM_MAP.master then
					task.wait(1)
					hookMapEvents()
					scanItems()
				end
			end)
		end
	end
	pcall(checkMapIngame)
end


-- [NERG-B2/r17] Projectile landing-marker (doc-module-game · defensive · poll-0.5s · tu-huy KILLALL)
do
	local P = { on = false, color = Color3.fromRGB(255, 60, 60) }
	rawset(_G, "NERG_PROJ", P)
	local rs = game:GetService("RunService")
	local m1, m2 = nil, nil
	local markers = {}
	local births = {}

	local function clearAll()
		for id, part in pairs(markers) do
			if typeof(part) == "Instance" then pcall(function() part:Destroy() end) end
			markers[id] = nil
		end
		table.clear(births)
	end

	local function ensureMods()
		if m1 and m2 then return true end
		local ok1, r1 = pcall(function() return require(game:GetService("ReplicatedStorage").Systems.Player.Game.ProjectileReplication) end)
		local ok2, r2 = pcall(function() return require(game:GetService("ReplicatedStorage").Modules.Gameplay.PredictProjectile) end)
		if ok1 and type(r1) == "table" and type(r1.Projectiles) == "table" then m1 = r1 end
		if ok2 and type(r2) == "table" and type(r2.FindLeadShot) == "function" then m2 = r2 end
		return m1 ~= nil
	end

	local projRayParams = RaycastParams.new()
	projRayParams.FilterType = Enum.RaycastFilterType.Exclude
	projRayParams.IgnoreWater = true
	projRayParams.RespectCanCollide = true

	local function landingOf(p)
		local cf = p.InitialCFrame
		local vel = p.InitialVelocity
		if typeof(cf) ~= "CFrame" or typeof(vel) ~= "Vector3" then return nil end
		local pos = cf.Position
		local g = math.abs(tonumber(p.Gravity) or 0)
		local pf = workspace:FindFirstChild("Players")
		projRayParams.FilterDescendantsInstances = pf and { pf } or {}
		local prev = pos
		local steps = 8
		local maxT = 2.0
		for i = 1, steps do
			local t = (i / steps) * maxT
			local nxt = pos + vel * t - Vector3.new(0, 0.5 * g * t * t, 0)
			local seg = nxt - prev
			if seg.Magnitude > 0.05 then
				local hit = workspace:Raycast(prev, seg, projRayParams)
				if hit then
					return hit.Position
				end
			end
			prev = nxt
		end
		return prev
	end

	local function projPoll()
		if not P.on then return end
		if not ensureMods() then return end
		local live = m1.Projectiles
		local liveN = 0
		for _ in pairs(live) do liveN += 1 end
		local maxAge = tonumber(P.maxAge) or 1.5
		local nowP = os.clock()
		for id, part in pairs(markers) do
			if live[id] == nil then
				if typeof(part) == "Instance" then pcall(function() part:Destroy() end) end
				markers[id] = nil
				births[id] = nil
			elseif part ~= false then
				local b = births[id]
				local age = b and (nowP - b) or 999
				if age >= maxAge then
					if typeof(part) == "Instance" then pcall(function() part:Destroy() end) end
					markers[id] = false
				else
					local ratio = math.clamp(age / maxAge, 0, 1)
					local fade = ratio * ratio
					pcall(function()
						part.Color = P.color
						part.Transparency = 0.5 + (0.5 * fade)
						local ad = part:FindFirstChildOfClass("BoxHandleAdornment")
						if ad then
							ad.Color3 = P.color
							ad.Transparency = 0.4 + (0.6 * fade)
						end
					end)
				end
			end
		end
		for id, p in pairs(live) do
			if markers[id] == nil and type(p) == "table" then
				local land = nil
				pcall(function() land = landingOf(p) end)
				if land then
					local pos = p.InitialCFrame.Position
					local thick = 0.8
					pcall(function()
						local m = p.Model
						if m then
							if m:IsA("Model") then
								local es = m:GetExtentsSize()
								thick = math.max(es.X, es.Y)
							elseif m:IsA("BasePart") then
								thick = math.max(m.Size.X, m.Size.Y)
							end
						end
					end)
					thick = math.clamp(thick, 0.8, 6) * 1.2
					local mag = (land - pos).Magnitude
					local part = Instance.new("Part")
					part.Name = "NP_ProjLine_" .. tostring(id)
					part.Anchored = true
					part.CanCollide = false
					part.CanQuery = false
					part.CanTouch = false
					part.CastShadow = false
					part.Size = Vector3.new(thick, thick, mag)
					part.CFrame = CFrame.lookAt(pos, land) * CFrame.new(0, 0, -mag / 2)
					part.Material = Enum.Material.Neon
					part.Color = P.color
					part.Transparency = 0.5
					pcall(function() part.Parent = workspace end)
					local ad = Instance.new("BoxHandleAdornment")
					ad.Size = part.Size
					ad.AlwaysOnTop = true
					ad.ZIndex = 10
					ad.Adornee = part
					ad.CFrame = CFrame.new()
					ad.Color3 = P.color
					ad.Transparency = 0.4
					ad.Parent = part
					markers[id] = part
					births[id] = os.clock()
				end
			elseif typeof(markers[id]) == "Instance" then
				pcall(function() markers[id].Color = P.color end)
			end
		end
		local mc = 0
		for _ in pairs(markers) do mc += 1 end
		P.dbg = { t = os.clock(), n = liveN, m = mc }
	end

	function P.set(v)
		P.on = v and true or false
		if not P.on then clearAll() end
	end
	function P.setColor(c)
		P.color = c
	end
	function P.shutdown()
		P.on = false
		if P.hbConn then pcall(function() P.hbConn:Disconnect() end) P.hbConn = nil end
		clearAll()
	end

	local projAcc = 0
	P.hbConn = rs.Heartbeat:Connect(function(dt)
		if _G.__NERG_KILLED or not __PLUS_GEN_ALIVE then
			pcall(function() P.shutdown() end)
			return
		end
		if not P.on then return end
		projAcc += (dt or 0.016)
		if projAcc < 0.033 then return end
		projAcc = 0
		pcall(projPoll)
	end)
end

-- [NERG-B2b/r24] Projectile WINDUP preview (VANG) — port 1:1 tu TO Cursedsaken (block tbl8 "ProjectileWindupPreview")
-- Nguon: uploads/Cursedsaken.md @3253-3745: fn14/15/16, v6-draw, v7-Cat(Nosferatu-Spire),
-- v8-Extra(Chance/Sixer/JohnDoe/c00lkidd), fn23/24/25-factory, Heartbeat v9 (rescan 0.15s, v8-gate 30Hz).
-- Mau RGB(255,185,45), chest (0,0,-2), ring 40x0.22 RGB(255,155,45), trail RGB(90,205,255) 0.3 — TỔ nguyen van.
-- INFER (capture-obf khong doc duoc): CAP=650 (khop clamp displayDistance generic), SIXBOX=4 (scale box-cross Sixer).
do
	local r24ok, r24err = pcall(function()
	local W = { on = false }
	rawset(_G, "NERG_WINDUP", W)
	local rs = game:GetService("RunService")
	local hbConn = nil
	local folder = nil
	local reg = {}
	local acc = 0
	local speedCache = {}

	local COL = Color3.fromRGB(255, 185, 45)
	local COL_RING = Color3.fromRGB(255, 155, 45)
	local COL_TRAIL = Color3.fromRGB(90, 205, 255)
	local CHEST = Vector3.new(0, 0, -2)
	local SCAN = 0.15
	local CAP = 650
	local SIXBOX = 4
	local V8DT = 1 / 30

	-- TỔ tbl10-windup (ability generic duy nhat trong TO)
	local GENERIC = {
		c00lkidd = {},
		["1x1x1x1"] = {
			MassInfection = { Windup = 1.7, SpeedKey = "MassInfectionShockwaveSpeed", Speed = 104, LifetimeKey = "MassInfectionShockwaveLifetime", Lifetime = 6, Animation = "99050723653468", TemplateKey = "ShockwaveTemplate" },
			Entanglement = { Windup = 0.75, SpeedKey = "EntanglementSpeed", Speed = 125, LifetimeKey = "EntanglementLifetime", Lifetime = 1, Animation = "133272604443790", TemplateKey = "SwordsTemplate" },
		},
	}
	local NAMED = { Nosferatu = true, Chance = true, Sixer = true, JohnDoe = true, JoshDoe = true }

	local function newFolder()
		if folder and folder.Parent then return end
		folder = Instance.new("Folder")
		folder.Name = "ProjectileWindupPreview"
		folder.Parent = workspace
	end

	local function visClear(v)
		if v.Part then
			pcall(function() v.Part:Destroy() end)
		end
		v.Part = nil
		v.Box = nil
	end

	-- v6 TỔ: Part "EstimatedWindup" (transparency 1) + BoxHandleAdornment "ApproximateDirection" (0.45 / Z10 / AlwaysOnTop)
	local function visDraw(v, c, m)
		local h = (m - c).Magnitude
		if h < 0.01 then
			visClear(v)
			return
		end
		if not v.Part then
			local p = Instance.new("Part")
			p.Name = "EstimatedWindup"
			p.Anchored = true
			p.CanCollide = false
			p.CanQuery = false
			p.CanTouch = false
			p.CastShadow = false
			p.Transparency = 1
			local pf = folder
			pcall(function() p.Parent = (pf and pf.Parent) and pf or workspace end)
			local ad = Instance.new("BoxHandleAdornment")
			ad.Name = "ApproximateDirection"
			ad.Adornee = p
			ad.AlwaysOnTop = true
			ad.ZIndex = 10
			ad.Color3 = v.Color or COL
			ad.Transparency = 0.45
			ad.Parent = p
			v.Part = p
			v.Box = ad
		end
		local dir = (m - c) / h
		local up = Vector3.new(0, 1, 0)
		if math.abs(dir:Dot(up)) > 0.99 then up = Vector3.new(1, 0, 0) end
		v.Part.Size = Vector3.new(v.Width, v.Height, h)
		v.Part.CFrame = CFrame.lookAt(c, m, up) * CFrame.new(0, 0, -h / 2)
		v.Box.Size = v.Part.Size
	end

	-- fn19 TỔ
	local function visNew(entry, color, thick)
		local v = { Width = thick, Height = thick, Color = color }
		table.insert(entry.Visuals, v)
		return v
	end

	-- fn22 TỔ
	local function visGet(entry, key, w, h)
		local v = entry.Visuals[key]
		if not v then
			v = { Color = COL }
			entry.Visuals[key] = v
		end
		v.Width = w
		v.Height = h
		return v
	end

	-- fn18 TỔ (Cat full-clear)
	local function catClear(e)
		for _, v in ipairs(e.Visuals) do
			visClear(v)
		end
		table.clear(e.Visuals)
		e.Line = nil
		e.Ring = nil
		e.Trail = nil
		e.LastPosition = nil
		e.LastTrail = nil
		e.Started = nil
		e.Velocity = nil
		e.Phase = nil
	end

	-- fn21 TỔ (Extra full-clear)
	local function extraClear(e)
		for _, v in ipairs(e.Visuals) do
			visClear(v)
		end
		table.clear(e.Visuals)
		e.ChargeStart = nil
		e.DashStart = nil
		e.Accum = 0
	end

	-- fn20 TỔ: ring 40 doan quanh Radius tai diem du doan
	local function ringDraw(e, center)
		if not e.Ring then
			e.Ring = {}
			for i = 1, 40 do
				e.Ring[i] = visNew(e, COL_RING, 0.22)
			end
		end
		for i = 1, 40 do
			local a1 = (i - 1) * math.pi * 2 / 40
			local a2 = i * math.pi * 2 / 40
			local p1 = center + Vector3.new(math.cos(a1), 0, math.sin(a1)) * e.Radius
			local p2 = center + Vector3.new(math.cos(a2), 0, math.sin(a2)) * e.Radius
			visDraw(e.Ring[i], p1, p2)
		end
	end

	-- v7 TỔ (Cat / Nosferatu Spire): phase Windup -> Moving, du-bao velocity, ring + trail
	local function catStep(e, mdl, root, hum, tracks, dt)
		if not root or not root:IsA("BasePart") or not hum or hum.Health <= 0 or not mdl:IsDescendantOf(workspace) then
			catClear(e)
			return
		end
		local startT, loopT, endT
		for _, tr in ipairs(tracks) do
			local id = tr.Animation and tostring(tr.Animation.AnimationId):match("%d+")
			if id and tr.IsPlaying and tr.WeightTarget > 0 then
				if e.StartIds[id] then startT = tr end
				if e.LoopIds[id] then loopT = tr end
				if e.EndIds[id] then endT = tr end
			end
		end
		if endT or not (startT or loopT) then
			catClear(e)
			return
		end
		local phase = loopT and "Moving" or "Windup"
		if e.Phase and e.Phase ~= phase then catClear(e) end
		e.Phase = phase
		local pos = root.Position
		local lift = hum.HipHeight + root.Size.Y * 0.5 - 0.12
		local function flat(v)
			return v - Vector3.new(0, lift, 0)
		end
		local look = root.CFrame.LookVector * Vector3.new(1, 0, 1)
		look = if look.Magnitude < 0.001 then Vector3.new(0, 0, -1) else look.Unit
		if not e.Line then e.Line = visNew(e, COL, 0.45) end
		if phase == "Windup" then
			if startT.TimePosition <= e.Windup + 0.2 then
				local ws = speedCache[e.CacheKey] or math.max(0, hum.WalkSpeed)
				local dst = pos + look * math.min(CAP, ws * e.Duration)
				visDraw(e.Line, flat(pos), flat(dst))
				ringDraw(e, flat(dst))
			else
				for _, v in ipairs(e.Visuals) do
					visClear(v)
				end
			end
			return
		end
		local now = os.clock()
		if not e.Started then
			e.Started = now - math.min(loopT.TimePosition, e.Duration)
			e.LastPosition = pos
			e.LastTrail = pos
			e.LastSample = now
			e.Trail = {}
			e.SpeedSamples = {}
			e.SpeedSampleTime = now
		end
		local el = now - e.Started
		if el > e.Duration + 0.3 then
			for _, v in ipairs(e.Visuals) do
				visClear(v)
			end
			return
		end
		local vel = root.AssemblyLinearVelocity * Vector3.new(1, 0, 1)
		if dt > 0 and dt <= 0.2 and e.LastPosition then
			local inst = (pos - e.LastPosition) * Vector3.new(1, 0, 1) / dt
			if inst.Magnitude > 0.5 then vel = inst end
		end
		e.LastPosition = pos
		if vel.Magnitude > 500 then
			for _, v in ipairs(e.Visuals) do
				visClear(v)
			end
			e.Started = now - e.Duration - 1
			return
		end
		local k = 1 - math.exp(-12 * math.max(dt, 0))
		e.Velocity = e.Velocity and e.Velocity:Lerp(vel, k) or vel
		local remain = math.max(0, e.Duration - el)
		local pred = pos + e.Velocity * remain
		visDraw(e.Line, flat(pos), flat(pred))
		ringDraw(e, flat(pred))
		if el >= 0.2 and el < e.Duration - 0.1 and now - e.SpeedSampleTime >= 0.05 then
			e.SpeedSampleTime = now
			local spd = e.Velocity.Magnitude
			if spd > 1 and spd < 500 then
				table.insert(e.SpeedSamples, spd)
				if #e.SpeedSamples >= 5 then
					local srt = table.clone(e.SpeedSamples)
					table.sort(srt)
					speedCache[e.CacheKey] = srt[math.ceil(#srt * 0.7)]
				end
			end
		end
		if now - e.LastSample >= 0.05 and (pos - e.LastTrail).Magnitude >= 0.6 then
			if #e.Trail < 80 then
				local seg = visNew(e, COL_TRAIL, 0.3)
				table.insert(e.Trail, seg)
				visDraw(seg, flat(e.LastTrail), flat(pos))
			end
			e.LastTrail = pos
			e.LastSample = now
		end
	end

	-- v8 TỔ (Extra): Chance-gun / Sixer-pursuit / c00lkidd-dash / JohnDoe-spike-row (gate 30Hz)
	local function extraStep(e, mdl, root, hum, tracks, dt)
		if not root or not root:IsA("BasePart") or not hum or hum.Health <= 0 or not mdl:IsDescendantOf(workspace) then
			extraClear(e)
			return
		end
		local mainT, startT, loopT
		local stopped = false
		for _, tr in ipairs(tracks) do
			local id = tr.Animation and tostring(tr.Animation.AnimationId):match("%d+")
			if id and tr.IsPlaying and tr.WeightTarget > 0 then
				if e.Ids[id] then mainT = tr end
				if e.StartIds and e.StartIds[id] then startT = tr end
				if e.LoopIds and e.LoopIds[id] then loopT = tr end
				if e.StopIds and e.StopIds[id] then stopped = true end
			end
		end
		if stopped or not mainT or (e.Kind == "Sixer" and mdl:GetAttribute("PursuitState") == "Cancelled") then
			extraClear(e)
			return
		end
		if e.Kind == "Chance" and mainT.TimePosition >= 0.9 then
			extraClear(e)
			return
		end
		if e.Kind == "JohnDoe" and mainT.TimePosition >= 3.6 then
			extraClear(e)
			return
		end
		if e.Kind == "Sixer" and not e.ChargeStart then
			e.ChargeStart = os.clock() - (startT and startT.TimePosition or mainT.TimePosition)
		end
		e.Accum += dt
		if e.Accum < V8DT then return end
		e.Accum = 0
		local pivot = mdl.PrimaryPart or root
		local look = pivot.CFrame.LookVector
		local pos = pivot.Position
		if e.Kind == "Chance" then
			visDraw(visGet(e, 1, e.Width, e.Width), pos, pos + look * e.Range)
		elseif e.Kind == "Sixer" then
			local dir = look * Vector3.new(1, 0, 1)
			dir = if dir.Magnitude < 0.001 then Vector3.new(0, 0, -1) else dir.Unit
			local held = math.clamp(os.clock() - e.ChargeStart, e.Hold.Min, e.Hold.Max)
			local spd = (e.BaseSpeed + (e.MaxSpeed - e.BaseSpeed) * (held / math.max(0.001, e.Hold.Max))) * e.Speed
			local dist = math.clamp(spd * e.Length, 0, CAP)
			local hitbox = mdl:FindFirstChild("CollisionHitbox")
			local lift = hitbox and hitbox:IsA("BasePart") and hitbox.Size.Y / 1.6 or hum.HipHeight + root.Size.Y * 0.5
			local base = pos - Vector3.new(0, lift, 0)
			local tip = base + dir * dist
			visDraw(visGet(e, 1, 0.6 * SIXBOX, 0.25 * SIXBOX), base, tip)
			local side = dir:Cross(Vector3.new(0, 1, 0))
			visDraw(visGet(e, 2, 0.2, 0.2), tip - side * 2, tip + side * 2)
			visDraw(visGet(e, 3, 0.2, 0.2), tip - dir * 2, tip + dir * 2)
		elseif e.Kind == "c00lkidd" then
			local remain = e.Duration
			local dir = look * Vector3.new(1, 0, 1)
			if loopT then
				if not e.DashStart then e.DashStart = os.clock() - math.min(loopT.TimePosition, e.Duration) end
				remain = math.max(0, e.Duration - (os.clock() - e.DashStart))
				local v = pivot.AssemblyLinearVelocity * Vector3.new(1, 0, 1)
				if v.Magnitude > 1 then dir = v.Unit end
			elseif e.DashStart or mainT.TimePosition > e.Windup + 0.25 then
				for _, v in ipairs(e.Visuals) do
					visClear(v)
				end
				return
			end
			if remain <= 0 then
				for _, v in ipairs(e.Visuals) do
					visClear(v)
				end
				return
			end
			local diru = if dir.Magnitude < 0.001 then Vector3.new(0, 0, -1) else dir.Unit
			local tip = pos + diru * math.min(CAP, e.Speed * remain)
			local hit = workspace:Raycast(pos, tip - pos, e.Raycast)
			visDraw(visGet(e, 1, 4, 4), pos, if hit then hit.Position else tip)
		else
			local dir = look * Vector3.new(1, 0, 1)
			dir = if dir.Magnitude < 0.001 then Vector3.new(0, 0, -1) else dir.Unit
			for i = 1, e.Count do
				local c = pos + dir * (e.Spacing * i)
				local g = workspace:Raycast(c + Vector3.new(0, 12, 0), Vector3.new(0, -80, 0), e.Raycast)
				c = if g then Vector3.new(c.X, g.Position.Y + e.Size.Y / 2, c.Z) else c - Vector3.new(0, hum.HipHeight + root.Size.Y / 2 - e.Size.Y / 2, 0)
				visDraw(visGet(e, i, e.Size.X, e.Size.Y), c - dir * e.Size.Z / 2, c + dir * e.Size.Z / 2)
			end
		end
	end

	-- fn14 TỔ: Assets.<...> walk + require ModuleScript
	local assetsRoot = nil
	local function assetPath(parts)
		if not assetsRoot then
			assetsRoot = game:GetService("ReplicatedStorage"):FindFirstChild("Assets")
		end
		if not assetsRoot then return nil end
		local cur = assetsRoot
		for _, nm in ipairs(parts) do
			cur = cur:FindFirstChild(nm)
			if not cur then return nil end
		end
		if cur:IsA("ModuleScript") then
			local ok, res = pcall(require, cur)
			if ok and type(res) == "table" then return res end
		end
		return nil
	end

	-- fn15 TỔ: gom anim (Instance/string/number/table) -> set id
	local function animIds(v, out)
		out = out or {}
		if typeof(v) == "Instance" and v:IsA("Animation") then
			v = v.AnimationId
		end
		if type(v) == "string" or type(v) == "number" then
			local m = tostring(v):match("%d+")
			if m then out[m] = true end
		elseif type(v) == "table" then
			animIds(v.AnimationId or v.Id or v.ID, out)
			for _, x in ipairs(v) do
				animIds(x, out)
			end
		end
		return out
	end

	-- fn16 TỔ: AABB cua template (BasePart/Model) theo pivot -> (size, center-offset)
	local function templateBox(inst)
		if typeof(inst) ~= "Instance" then return nil end
		if not inst:IsA("BasePart") and not inst:IsA("Model") then return nil end
		local pivot = inst:GetPivot()
		local parts = inst:IsA("BasePart") and { inst } or inst:GetDescendants()
		local mn, mx
		for _, d in ipairs(parts) do
			if d:IsA("BasePart") then
				local rel = pivot:ToObjectSpace(d.CFrame)
				local half = d.Size * 0.5
				for sx = -1, 1, 2 do
					for sy = -1, 1, 2 do
						for sz = -1, 1, 2 do
							local corner = rel:PointToWorldSpace(Vector3.new(half.X * sx, half.Y * sy, half.Z * sz))
							if mn == nil then
								mn, mx = corner, corner
							else
								mn = Vector3.new(math.min(mn.X, corner.X), math.min(mn.Y, corner.Y), math.min(mn.Z, corner.Z))
								mx = Vector3.new(math.max(mx.X, corner.X), math.max(mx.Y, corner.Y), math.max(mx.Z, corner.Z))
							end
						end
					end
				end
			end
		end
		if mn then return mx - mn, (mx + mn) * 0.5 end
		return nil
	end

	-- fn23/25 TỔ: dung entry theo killer (Config + Skin override, fallback id default TỔ)
	local function buildEntry(mdl, name, skin)
		local t = GENERIC[name]
		if not t and not NAMED[name] then return nil end
		local side = (name == "Chance") and "Survivors" or "Killers"
		local cfg = assetPath({ side, name, "Config" })
		if not cfg then return nil end
		local scfg = nil
		if skin ~= "" then
			scfg = assetPath({ "Skins", side, name, skin, "Config" })
		end
		local e = { Name = name, Skin = skin, Abilities = {} }
		local function idsOf(key, defId)
			local out = animIds(scfg and scfg.Animations and scfg.Animations[key])
			if not next(out) then out = animIds(cfg.Animations and cfg.Animations[key]) end
			if not next(out) and defId then out[defId] = true end
			return out
		end
		local function numOf(key, def)
			local v = scfg and scfg[key]
			if v == nil then v = cfg[key] end
			if v == nil then return def end
			return v
		end
		if name == "Nosferatu" then
			local function spireNum(key, def)
				local v = scfg and scfg.Spire and scfg.Spire[key]
				if v == nil then v = cfg.Spire and cfg.Spire[key] end
				return type(v) == "number" and math.max(0, v) or def
			end
			e.Cat = {
				CacheKey = name .. ":" .. skin,
				StartIds = idsOf("SpireStart", "72186169160926"),
				LoopIds = idsOf("SpireLoop", "103995840833619"),
				EndIds = idsOf("SpireEnd", "88612618621871"),
				Windup = spireNum("Windup", 0.75),
				Duration = spireNum("Duration", 1.25),
				Radius = spireNum("ExplosionRadius", 17.5),
				Visuals = {},
			}
		end
		do
			local kind = (name == "JoshDoe") and "JohnDoe" or name
			if kind == "Chance" or kind == "Sixer" or kind == "JohnDoe" or kind == "c00lkidd" then
				local x = { Kind = kind, Visuals = {}, Accum = 0 }
				if kind == "Chance" then
					x.Ids = idsOf("AimGun", "133491532453922")
					x.StopIds = {}
					for _, k2 in ipairs({ "GunFire", "GunFail", "GunExplode" }) do
						for id in pairs(idsOf(k2)) do x.StopIds[id] = true end
					end
					x.Width = numOf("ShootHitboxSize", 2.5)
					x.Range = numOf("ShootHitboxRange", 90)
				elseif kind == "Sixer" then
					x.StartIds = idsOf("DemonicPursuitStart", "133363345661032")
					x.Ids = table.clone(x.StartIds)
					for id in pairs(idsOf("DemonicPursuitLoop", "128414736976503")) do x.Ids[id] = true end
					x.StopIds = idsOf("DemonicPursuitLunge", "139309647473555")
					x.Hold = numOf("PursuitHold", NumberRange.new(0.6, 1.25))
					x.BaseSpeed = numOf("PursuitBaseSpeed", 7)
					x.MaxSpeed = numOf("PursuitMaxSpeed", 17)
					x.Speed = numOf("Speed", 9)
					x.Length = numOf("PursuitLength", 0.8)
				elseif kind == "c00lkidd" then
					x.Ids = idsOf("WalkspeedOverrideStart", "98456918873918")
					x.LoopIds = idsOf("WalkspeedOverrideLoop", "106776364623742")
					for id in pairs(x.LoopIds) do x.Ids[id] = true end
					x.StopIds = {}
					for _, k2 in ipairs({ "WalkspeedOverrideHit", "WalkspeedOverrideMiss", "WalkspeedOverrideDuration", "WalkspeedOverrideCollide" }) do
						for id in pairs(idsOf(k2)) do x.StopIds[id] = true end
					end
					x.Speed = numOf("WalkspeedOverrideSpeed", 90)
					x.Duration = numOf("WalkspeedOverrideDuration", 1.34)
					x.Windup = numOf("WalkspeedOverrideWindup", 0.5)
					x.Raycast = RaycastParams.new()
					x.Raycast.FilterType = Enum.RaycastFilterType.Exclude
					x.Raycast.RespectCanCollide = true
				else
					x.Ids = idsOf("CorruptEnergy", "127172483138092")
					x.Size = numOf("SpikeHitboxSize", Vector3.new(11, 5, 5))
					x.Spacing = numOf("DistanceBetweenSpikes", 4)
					x.Count = math.clamp(math.floor(numOf("SpikeAmount", 31)), 0, 64)
					x.Raycast = RaycastParams.new()
					x.Raycast.FilterType = Enum.RaycastFilterType.Exclude
					x.Raycast.RespectCanCollide = true
				end
				if x.Raycast then
					local fl = { folder }
					local plf = workspace:FindFirstChild("Players")
					if plf then table.insert(fl, plf) end
					x.Raycast.FilterDescendantsInstances = fl
				end
				e.Extra = x
			end
		end
		for k, ab in pairs(t or {}) do
			local animKey = ab.AnimKey or k
			local ids = animIds(scfg and scfg.Animations and scfg.Animations[animKey])
			if not next(ids) then ids = animIds(cfg.Animations and cfg.Animations[animKey]) end
			if not next(ids) then ids[ab.Animation] = true end
			local tmpl = scfg and scfg.Instances and scfg.Instances[ab.TemplateKey] or cfg.Instances and cfg.Instances[ab.TemplateKey]
			local sz, ctr = templateBox(tmpl)
			local spd = ab.SpeedKey and (scfg and scfg[ab.SpeedKey] or cfg[ab.SpeedKey]) or ab.Speed
			local life = ab.LifetimeKey and (scfg and scfg[ab.LifetimeKey] or cfg[ab.LifetimeKey]) or ab.Lifetime
			local wnp = ab.WindupKey and (scfg and scfg[ab.WindupKey] or cfg[ab.WindupKey]) or ab.Windup
			local dist = ab.DisplayDistance
			if not dist and type(spd) == "number" and type(life) == "number" then dist = spd * life end
			if type(dist) == "number" then
				e.Abilities[k] = {
					Ids = ids,
					Width = sz and math.max(0.05, sz.X) or 0.8,
					Height = sz and math.max(0.05, sz.Y) or 0.8,
					Center = ctr or Vector3.zero,
					Windup = wnp,
					Distance = math.clamp(dist, 0, CAP),
				}
			end
		end
		return e
	end

	-- fn24 TỔ: xoa entry khoi model
	local function dropEntry(mdl)
		local e = reg[mdl]
		if not e then return end
		for _, ab in pairs(e.Abilities) do
			visClear(ab)
		end
		if e.Cat then catClear(e.Cat) end
		if e.Extra then extraClear(e.Extra) end
		reg[mdl] = nil
	end

	-- fn26 TỔ: validate + discover (0.15s)
	local function rescan()
		local plf = workspace:FindFirstChild("Players")
		local killersF = plf and plf:FindFirstChild("Killers")
		local survF = plf and plf:FindFirstChild("Survivors")
		for mdl, e in pairs(reg) do
			local nm = mdl:GetAttribute("CharacterName") or mdl.Name
			local sk = mdl:GetAttribute("SkinName") or ""
			if not mdl.Parent or (mdl.Parent ~= killersF and mdl.Parent ~= survF) or nm ~= e.Name or sk ~= e.Skin then
				dropEntry(mdl)
			end
		end
		newFolder()
		for _, f2 in ipairs({ killersF, survF }) do
			if f2 then
				for _, child in ipairs(f2:GetChildren()) do
					if child:IsA("Model") and not reg[child] then
						local nm = child:GetAttribute("CharacterName") or child.Name
						local sk = child:GetAttribute("SkinName") or ""
						local e = buildEntry(child, nm, sk)
						reg[child] = e or { Name = nm, Skin = sk, Unsupported = true, Abilities = {} }
					end
				end
			end
		end
		local n = 0
		for _, e in pairs(reg) do
			if not e.Unsupported then n += 1 end
		end
		W.dbg = { t = os.clock(), n = n, f = folder and folder.Parent ~= nil or false }
	end

	local function stepModel(mdl, e, dt)
		if e.Unsupported then return end
		local hum = (e._hum and e._hum.Parent == mdl) and e._hum or mdl:FindFirstChildOfClass("Humanoid")
		local root = (e._root and e._root.Parent == mdl) and e._root or mdl:FindFirstChild("HumanoidRootPart")
		local anim = (e._anim and e._anim.Parent == hum) and e._anim or (hum and hum:FindFirstChildOfClass("Animator"))
		e._hum, e._root, e._anim = hum, root, anim
		local alive = mdl.Parent ~= nil and mdl:IsDescendantOf(workspace) and hum ~= nil and hum.Health > 0
		local nowW = os.clock()
		if anim and (not e._tracks or nowW - (e._tracksAt or 0) >= 0.08) then
			e._tracks = anim:GetPlayingAnimationTracks()
			e._tracksAt = nowW
		elseif not anim then
			e._tracks = nil
		end
		local tracks = e._tracks or {}
		if e.Cat then catStep(e.Cat, mdl, root, hum, tracks, dt) end
		if e.Extra then extraStep(e.Extra, mdl, root, hum, tracks, dt) end
		local active = {}
		if alive and root and root:IsA("BasePart") and anim then
			for _, tr in ipairs(tracks) do
				local an = tr.Animation
				local id = an and tostring(an.AnimationId):match("%d+")
				if id and tr.IsPlaying then
					for k2, ab in pairs(e.Abilities) do
						if ab.Ids[id] and tr.TimePosition < ab.Windup then
							active[k2] = true
						end
					end
				end
			end
		end
		for k2, ab in pairs(e.Abilities) do
			if active[k2] then
				local off = Vector3.new(ab.Center.X, ab.Center.Y, 0)
				local c = root.CFrame:PointToWorldSpace(CHEST + off)
				visDraw(ab, c, c + root.CFrame.LookVector * ab.Distance)
			else
				visClear(ab)
			end
		end
	end

	local function step(dt)
		acc += dt
		if acc >= SCAN then
			acc = 0
			pcall(rescan)
		end
		for mdl, e in pairs(reg) do
			pcall(stepModel, mdl, e, dt)
		end
	end

	function W.set(v)
		W.on = v and true or false
		if hbConn then
			pcall(function() hbConn:Disconnect() end)
			hbConn = nil
		end
		for mdl in pairs(reg) do
			dropEntry(mdl)
		end
		if folder then
			pcall(function() folder:Destroy() end)
			folder = nil
		end
		if W.on then
			newFolder()
			acc = SCAN
			hbConn = rs.Heartbeat:Connect(function(dt)
				if _G.__NERG_KILLED or not __PLUS_GEN_ALIVE then
					pcall(function() W.shutdown() end)
					return
				end
				if not W.on then return end
				pcall(step, dt)
			end)
		end
	end

	function W.shutdown()
		W.on = false
		if hbConn then
			pcall(function() hbConn:Disconnect() end)
			hbConn = nil
		end
		for mdl in pairs(reg) do
			dropEntry(mdl)
		end
		if folder then
			pcall(function() folder:Destroy() end)
			folder = nil
		end
	end

	W.dbg = { t = 0, n = 0, f = false }
	end)
	if not r24ok then warn("[NERG-WINDUP] boot fail: ", r24err) end
end

	local function safeDesc(obj)
		if obj then return obj:GetDescendants() end
		return {}
	end
	local legacyName = "External_Protected_HL"
	local hlSeed = (math.floor(os.clock() * 1000) + math.random(0, 999999)) % 16777216
	local name = string.format("%07x", hlSeed)
	if name == legacyName then name = "n" .. name:sub(2) end
	rawset(_G, "__NERG_HL_NAME", name)
	local function hlIsOurs(d)
		return d:IsA("Highlight") and (d:GetAttribute("NergHL") == true or d.Name == name or d.Name == legacyName)
	end
	local function hlSweepTeam(teamName)
		local kp = workspace:FindFirstChild("Players")
		local f = kp and kp:FindFirstChild(teamName)
		if f then
			for _, d in ipairs(f:GetDescendants()) do
				if hlIsOurs(d) then pcall(function() d:Destroy() end) end
			end
		end
		if teamName == "Killers" then
			local mp = workspace:FindFirstChild("Map")
			local ig = mp and mp:FindFirstChild("Ingame")
			if ig then
				for _, d in ipairs(ig:GetDescendants()) do
					if hlIsOurs(d) then pcall(function() d:Destroy() end) end
				end
			end
		end
	end
	local tbl6 = {}
	local tbl6rem, tbl6saved = {}, {}
	local function reconcileTeam(teamName, on, color)
		local kp = workspace:FindFirstChild("Players")
		local f = kp and kp:FindFirstChild(teamName)
		if not f then return end
		for _, mdl in ipairs(f:GetChildren()) do
			if mdl:IsA("Model") and mdl ~= localPlayer.Character then
				local has = mdl:FindFirstChild(name)
				if on then
					if not has and mdl:FindFirstChildOfClass("Humanoid") then
						pcall(function() createHighlight2(mdl, color) end)
					end
				else
					if has then pcall(function() has:Destroy() end) end
					for _, cand in ipairs(mdl:GetChildren()) do
						if cand:IsA("Highlight") and cand ~= has and hlIsOurs(cand) then
							pcall(function() cand:Destroy() end)
						end
					end
					if tbl6[mdl] then pcall(function() tbl6[mdl]:Disconnect() end) tbl6[mdl] = nil end
					if tbl6rem[mdl] then pcall(function() tbl6rem[mdl]:Disconnect() end) tbl6rem[mdl] = nil end
					local saved = tbl6saved[mdl]
					if saved then
						for _, h in ipairs(saved) do
							if h and h.Parent then pcall(function() h.Enabled = true end) end
						end
						tbl6saved[mdl] = nil
					end
				end
			end
		end
	end
	task.spawn(function()
		while true do
			if _G.__NERG_KILLED or not __PLUS_GEN_ALIVE then break end
			task.wait(0.25)
			if tbl.KillerEsp == true or tbl.SurvivorsEsp == true or next(tbl6) ~= nil then
				pcall(function()
					pcall(reconcileTeam, "Killers", tbl.KillerEsp == true, tbl.EspKillerColor)
					pcall(reconcileTeam, "Survivors", tbl.SurvivorsEsp == true, tbl.EspSurvivorsColor)
					local cam = workspace.CurrentCamera
					if not cam then return end
					local cp = cam.CFrame.Position
					local base = tbl.HFillTransparency or 0.25
					for mdl in pairs(tbl6) do
						if not mdl.Parent or not mdl:IsDescendantOf(workspace) then
							if tbl6[mdl] then pcall(function() tbl6[mdl]:Disconnect() end) end
							if tbl6rem[mdl] then pcall(function() tbl6rem[mdl]:Disconnect() end) tbl6rem[mdl] = nil end
							tbl6[mdl] = nil
							tbl6saved[mdl] = nil
						else
							local hl = mdl:FindFirstChild(name)
							if hl and hl:IsA("Highlight") then
								local root = mdl:FindFirstChild("HumanoidRootPart") or mdl.PrimaryPart or mdl:FindFirstChildWhichIsA("BasePart")
								if root then
									local d = (cp - root.Position).Magnitude
									local f
									local nearF = math.min(0.15, base)
									if d > 1200 then
										f = 1
									elseif d < 100 then
										f = nearF
									else
										f = nearF + (base - nearF) * math.clamp((d - 100) / 1100, 0, 1)
									end
									if math.abs(hl.FillTransparency - f) > 0.02 then
										hl.FillTransparency = f
										hl.OutlineTransparency = math.clamp(f - 0.05, 0, 1)
									end
								end
							end
						end
					end
				end)
			end
		end
	end)

	createHighlight2 = function(adornee, fillColor)
		if not adornee or not adornee.Parent then
			return
		end
		local name2 = localPlayer.Name
		if adornee == localPlayer.Character or adornee:GetAttribute("Username") == name2 then
			return
		end

		if tbl6[adornee] then
			local externalProtectedHl = adornee:FindFirstChild(name)

			if externalProtectedHl then
				externalProtectedHl.FillColor = fillColor
				externalProtectedHl.OutlineColor = fillColor
				return
			end
		end

		local function fn16()
			for _, descendant in ipairs(adornee:GetDescendants()) do
				if descendant:IsA("Highlight") and descendant.Name ~= name then
					if descendant.Enabled then
						descendant.Enabled = false
						local saved = tbl6saved[adornee]
						if not saved then saved = {} tbl6saved[adornee] = saved end
						local dup = false
						for _, h in ipairs(saved) do if h == descendant then dup = true break end end
						if not dup then saved[#saved + 1] = descendant end
					end
				end
			end

			local externalProtectedHl = adornee:FindFirstChild(name)

			if not externalProtectedHl then
				externalProtectedHl = Instance.new("Highlight")
				externalProtectedHl.Name = name
				externalProtectedHl.Adornee = adornee
				externalProtectedHl.Parent = adornee
				externalProtectedHl:SetAttribute("NergHL", true)
			end

			externalProtectedHl.FillColor = fillColor
			externalProtectedHl.OutlineColor = fillColor
			externalProtectedHl.FillTransparency = tbl.HFillTransparency or 0.25
			externalProtectedHl.OutlineTransparency = tbl.DisableOutline or 0
			externalProtectedHl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			pcall(function() if v2.get("a720Telemetry", false) then print("[NERG] hl created: " .. tostring(adornee.Name) .. " color=" .. tostring(fillColor)) end end)
		end

		fn16()

		if tbl6[adornee] then pcall(function() tbl6[adornee]:Disconnect() end) end
		if tbl6rem[adornee] then pcall(function() tbl6rem[adornee]:Disconnect() end) end

		tbl6[adornee] = adornee.ChildAdded:Connect(function(child)
			if child:IsA("Highlight") and child.Name ~= name then
				task.wait(3)

				task.defer(function()
					if child.Parent and child.Name ~= name then
						if child.Enabled then
							child.Enabled = false
							local saved = tbl6saved[adornee]
							if not saved then saved = {} tbl6saved[adornee] = saved end
							local dup = false
							for _, h in ipairs(saved) do if h == child then dup = true break end end
							if not dup then saved[#saved + 1] = child end
						end
					end
					local kp2 = workspace:FindFirstChild("Players")
					local okRe = false
					if kp2 then
						local kf2 = kp2:FindFirstChild("Killers")
						local sf2 = kp2:FindFirstChild("Survivors")
						if kf2 and adornee.Parent == kf2 then okRe = tbl.KillerEsp == true
						elseif sf2 and adornee.Parent == sf2 then okRe = tbl.SurvivorsEsp == true
						else okRe = tbl.KillerEsp == true end
					end
					if okRe and not adornee:FindFirstChild(name) then fn16() end
				end)
			end
		end)

		tbl6rem[adornee] = adornee.ChildRemoved:Connect(function(child)
			if child.Name ~= name then return end
			local p2 = adornee.Parent
			if not p2 then return end
			local okRe = false
			if p2.Name == "Killers" then okRe = tbl.KillerEsp == true
			elseif p2.Name == "Survivors" then okRe = tbl.SurvivorsEsp == true end
			if okRe then
				task.delay(0.15, function()
					if adornee.Parent and tbl6rem[adornee] and not adornee:FindFirstChild(name) then
						pcall(fn16)
					end
				end)
			end
		end)
	end

	local connection = nil
	local connection2 = nil
	local connection3 = nil
	local shadowConns = {}
	local function clearShadowConns()
		for i = #shadowConns, 1, -1 do
			local sc = shadowConns[i]
			shadowConns[i] = nil
			pcall(function() sc:Disconnect() end)
		end
	end

	local function hookJohnDoeTrail(child)
		local trailESPModel = child:FindFirstChild("TrailESPModel")
		if not trailESPModel then
			trailESPModel = Instance.new("Model")
			trailESPModel.Name = "TrailESPModel"
			trailESPModel.Parent = child
		end
		for _, child2 in ipairs(child:GetChildren()) do
			if child2:IsA("BasePart") then
				child2.Transparency = 0
				child2.Parent = trailESPModel
			end
		end
		shadowConns[#shadowConns + 1] = child.ChildAdded:Connect(function(child2)
			if tbl.KillerEsp and child2:IsA("BasePart") and trailESPModel and trailESPModel.Parent then
				task.defer(function()
					if tbl.KillerEsp and child2.Parent == child and trailESPModel.Parent == child then
						child2.Transparency = 0
						child2.Parent = trailESPModel
					end
				end)
			end
		end)
		createHighlight2(trailESPModel, tbl.EspKillerColor)
	end

	killerEsp = function()
		if connection2 then
			pcall(function() connection2:Disconnect() end)
			connection2 = nil
		end
		if connection3 then
			pcall(function() connection3:Disconnect() end)
			connection3 = nil
		end
		clearShadowConns()

		resolveFolders()
		local v3 = killers
		pcall(function() if v2.get("a720Telemetry", false) then print("[NERG] killerEsp: folder=" .. tostring(v3 and v3.Name or "nil") .. " children=" .. (v3 and #v3:GetChildren() or 0) .. " ON=" .. tostring(tbl.KillerEsp)) end end)
		if not v3 then
			if not tbl.KillerEsp then hlSweepTeam("Killers") end
			return
		end

		if tbl.KillerEsp then
			for _, child in ipairs(v3:GetChildren()) do
				createHighlight2(child, tbl.EspKillerColor)
			end

			for _, child in ipairs(ingame and ingame:GetChildren() or {}) do
				local humanoid = child:FindFirstChildOfClass("Humanoid")

				if humanoid and not Players:GetPlayerFromCharacter(child) and humanoid.WalkSpeed ~= 16 and humanoid.WalkSpeed ~= 26 then
					createHighlight2(child, tbl.EspKillerSupportColor)
				elseif child:IsA("Folder") and string.sub(child.Name, -7) == "Shadows" then
					for _, child2 in ipairs(child:GetChildren()) do
						if child2.Name == "Shadow" then
							child2.Transparency = 0
							createHighlight2(child2, tbl.EspKillerSupportColor)
						end
					end
					shadowConns[#shadowConns + 1] = child.ChildAdded:Connect(function(child2)
						if tbl.KillerEsp and child2.Name == "Shadow" then
							child2.Transparency = 0
							createHighlight2(child2, tbl.EspKillerSupportColor)
						end
					end)
				elseif string.sub(child.Name, -12) == "JohnDoeTrail" then
					hookJohnDoeTrail(child)
				end
			end

			connection2 = v3.ChildAdded:Connect(function(child)
				task.wait(0.5)
				if not tbl.KillerEsp then return end
				createHighlight2(child, tbl.EspKillerColor)
			end)

			connection3 = ingame and ingame.ChildAdded:Connect(function(child)
				task.wait(0.5)
				if not tbl.KillerEsp then return end
				local humanoid = child:FindFirstChildOfClass("Humanoid")

				if humanoid and not Players:GetPlayerFromCharacter(child) and humanoid.WalkSpeed ~= 16 and humanoid.WalkSpeed ~= 26 then
					createHighlight2(child, tbl.EspKillerSupportColor)
				elseif child:IsA("Folder") and string.sub(child.Name, -7) == "Shadows" then
					for _, child2 in ipairs(child:GetChildren()) do
						if child2.Name == "Shadow" then
							child2.Transparency = 0
							createHighlight2(child2, tbl.EspKillerSupportColor)
						end
					end
					shadowConns[#shadowConns + 1] = child.ChildAdded:Connect(function(child2)
						if tbl.KillerEsp and child2.Name == "Shadow" then
							child2.Transparency = 0
							createHighlight2(child2, tbl.EspKillerSupportColor)
						end
					end)
				elseif string.sub(child.Name, -12) == "JohnDoeTrail" then
					hookJohnDoeTrail(child)
				end
			end)
		else
			for _, child in ipairs(killers:GetChildren()) do
				if tbl6[child] then
					pcall(function() tbl6[child]:Disconnect() end)
					tbl6[child] = nil
				end

				if tbl6rem[child] then pcall(function() tbl6rem[child]:Disconnect() end) tbl6rem[child] = nil end
				local ourHl = child:FindFirstChild(name) or child:FindFirstChild(legacyName)
				if ourHl then pcall(function() ourHl:Destroy() end) end
				local saved = tbl6saved[child]
				if saved then
					for _, h in ipairs(saved) do
						if h and h.Parent then pcall(function() h.Enabled = true end) end
					end
					tbl6saved[child] = nil
				end
			end
			for mdl in pairs(tbl6) do
				if not (survivors and mdl.Parent == survivors) then
					pcall(function() tbl6[mdl]:Disconnect() end)
					tbl6[mdl] = nil
					if tbl6rem[mdl] then pcall(function() tbl6rem[mdl]:Disconnect() end) tbl6rem[mdl] = nil end
					local ourHl = mdl:FindFirstChild(name) or mdl:FindFirstChild(legacyName)
					if ourHl then pcall(function() ourHl:Destroy() end) end
					local saved = tbl6saved[mdl]
					if saved then
						for _, h in ipairs(saved) do
							if h and h.Parent then pcall(function() h.Enabled = true end) end
						end
						tbl6saved[mdl] = nil
					end
				end
			end

			for _, descendant in ipairs(safeDesc(ingame)) do
				if descendant.Name == name then
					descendant:Destroy()
				end

				if descendant.Name == "Shadow" then
					descendant.Transparency = 1
				end
			end

			hlSweepTeam("Killers")

			for _, child in ipairs(ingame and ingame:GetChildren() or {}) do
				if string.sub(child.Name, -12) == "JohnDoeTrail" then
					local trailESPModel = child:FindFirstChild("TrailESPModel")

					if trailESPModel then
						for _, child2 in ipairs(trailESPModel:GetChildren()) do
							if child2:IsA("BasePart") then
								child2.Transparency = 1
								child2.Parent = child
							end
						end

						trailESPModel:Destroy()
					end

					for _, child2 in ipairs(child:GetChildren()) do
						if child2:IsA("BasePart") then
							child2.Transparency = 1
						end
					end
				end
			end
		end
	end

	killerEspColorUpdate = function()
		resolveFolders()
		if tbl.KillerEsp then
			for _, descendant in pairs(safeDesc(killers)) do
				if descendant.ClassName == "Highlight" and descendant.Name == name then
					descendant.FillColor = tbl.EspKillerColor
					descendant.OutlineColor = tbl.EspKillerColor
				end
			end
		end
	end

	killerSupportsEspColorUpdate = function()
		resolveFolders()
		if tbl.KillerEsp then
			for _, descendant in pairs(safeDesc(ingame)) do
				if descendant.ClassName == "Highlight" and descendant.Name == name then
					descendant.FillColor = tbl.EspKillerSupportColor
					descendant.OutlineColor = tbl.EspKillerSupportColor
				end
			end
		end
	end

	survivorsEsp = function()
		if connection then
			pcall(function() connection:Disconnect() end)
			connection = nil
		end

		resolveFolders()
		local survivors2 = survivors
		if not survivors2 then
			if not tbl.SurvivorsEsp then hlSweepTeam("Survivors") end
			return
		end

		if tbl.SurvivorsEsp then
			for _, child in ipairs(survivors2:GetChildren()) do
				createHighlight2(child, tbl.EspSurvivorsColor)
			end

			connection = survivors2.ChildAdded:Connect(function(child)
				task.wait(0.5)
				if not tbl.SurvivorsEsp then return end
				createHighlight2(child, tbl.EspSurvivorsColor)
			end)
		else
			for _, child in ipairs(survivors2:GetChildren()) do
				if tbl6[child] then
					tbl6[child]:Disconnect()
					tbl6[child] = nil
				end

				if tbl6rem[child] then pcall(function() tbl6rem[child]:Disconnect() end) tbl6rem[child] = nil end
				local ourHl = child:FindFirstChild(name) or child:FindFirstChild(legacyName)
				if ourHl then pcall(function() ourHl:Destroy() end) end
				local saved = tbl6saved[child]
				if saved then
					for _, h in ipairs(saved) do
						if h and h.Parent then pcall(function() h.Enabled = true end) end
					end
					tbl6saved[child] = nil
				end
			end

			hlSweepTeam("Survivors")
		end
	end

	survivorsEspColorUpdate = function()
		resolveFolders()
		if tbl.SurvivorsEsp then
			for _, descendant in pairs(safeDesc(survivors)) do
				if descendant.ClassName == "Highlight" and descendant.Name == name then
					descendant.FillColor = tbl.EspSurvivorsColor
					descendant.OutlineColor = tbl.EspSurvivorsColor
				end
			end
		end
	end

end

A641_ANIM_N = 0
for _, vv in pairs(AllAnimations) do
  for _ in pairs(vv) do A641_ANIM_N += 1 end
end

walkSpeed3, jumpPower, autoRotate2 = nil
a724AimConn = nil

local function a724AimStep()
  if not __PLUS_GEN_ALIVE or _G.__NERG_KILLED then
    if a724AimConn then a724AimConn:Disconnect() a724AimConn = nil end
    return
  end

  if not v33 or not aimPunch or not humanoid or not v45 or tick() - v34 > v10 then
    v33 = false
    if a724AimConn then a724AimConn:Disconnect() a724AimConn = nil end
    a724RotUnlock(humanoid, "punch")
    walkSpeed3, jumpPower, autoRotate2 = nil, nil, nil
    return
  end

  a724RotLock(humanoid, "punch")
  humanoid.AutoRotate = false
  v45.AssemblyAngularVelocity = Vector3.zero
  local players3 = workspaceService:FindFirstChild("Players")
  local killers5 = players3 and players3:FindFirstChild("Killers")

  if killers5 and v45 then
    local huge = math.huge
    local v123 = nil

    for index14, value19 in ipairs(killers5:GetChildren()) do
      local humanoidRootPart10 = value19:FindFirstChild("HumanoidRootPart")

      if humanoidRootPart10 then
        local magnitude2 = (humanoidRootPart10.Position - v45.Position).Magnitude

        if magnitude2 < huge then
          huge = magnitude2
          v123 = humanoidRootPart10
        end
      end
    end

    if v123 then
      local v124 = punchPrediction
      local assemblyLinearVelocity = v123.AssemblyLinearVelocity

      local v125 = ((assemblyLinearVelocity.Magnitude > 0.5
              and v123.Position + assemblyLinearVelocity * (v124 / 60)
            or v123.Position)
          - v45.Position)
        * Vector3.new(1, 0, 1)

      if v125.Magnitude > 0.01 then
        v45.CFrame = CFrame.new(v45.Position, v45.Position + v125.Unit)
      end
    end
  end
end

a724StartAimLoop = function()
  if a724AimConn or not __PLUS_GEN_ALIVE or _G.__NERG_KILLED then return end
  a724AimConn = runService.RenderStepped:Connect(a724AimStep)
end

a724MainCharConn = localPlayer.CharacterAdded:Connect(function(character11)
  if not __PLUS_GEN_ALIVE or _G.__NERG_KILLED then return end
  v33 = false
  HDT_InProgress = false
  if a724AimConn then pcall(function() a724AimConn:Disconnect() end) a724AimConn = nil end
  a724RotUnlock(character11 and character11:FindFirstChildOfClass("Humanoid"), nil)
  task.delay(0.5, function()
    if not __PLUS_GEN_ALIVE or _G.__NERG_KILLED then return end
    if localPlayer.Character ~= character11 or not (character11 and character11.Parent) then return end
    a724RotUnlock(character11:FindFirstChildOfClass("Humanoid"), nil)
    f18()
    f4(character11)
  end)
end)

if localPlayer.Character then
  f4(localPlayer.Character)
end

SSystem = v1PRBLOCKWindow:Section({ Title = "Overview & Config", Opened = true })
infoTab = SSystem:Tab({ Title = "Info", Icon = "info" })
factTab = SSystem:Tab({ Title = "Fact", Icon = "lightbulb" })
local SKiller = v1PRBLOCKWindow:Section({ Title = "Killer", Opened = true })
local killerTab = SKiller:Tab({ Title = "Killer", Icon = "crosshair" })

-- [A747] Anti Backstab (port) — event-driven · default OFF · full cleanup
do
  local ABS_SOUND_IDS = { ["134932463887703"] = true, ["101489994047160"] = true }
  local ABS_ANIM_IDS = { ["100725497418533"] = "Stab", ["89448354637442"] = "LungeStart" }
  local ABS_MODEL_NAME = "TwoTime"

  local abs = {
    on = v2.get("a747ABOn", false) and true or false,
    range = math.clamp(tonumber(v2.get("a747ABRange", 27)) or 27, 10, 120),
    duration = math.clamp(tonumber(v2.get("a747ABDur", 0.8)) or 0.8, 0.15, 2),
    locked = false,
    gui = nil,
    hits = 0,
    conns = {},
    soundConns = {},
    animConns = {},
    rings = {},
  }

  local function absTrack(c)
    if c then abs.conns[#abs.conns + 1] = c end
    return c
  end

  local function absDropConns()
    for _, c in ipairs(abs.conns) do pcall(function() c:Disconnect() end) end
    abs.conns = {}
    for snd, c in pairs(abs.soundConns) do
      pcall(function() c:Disconnect() end)
      abs.soundConns[snd] = nil
    end
    for mdl, c in pairs(abs.animConns) do
      pcall(function() c:Disconnect() end)
      abs.animConns[mdl] = nil
    end
  end

  local function absGui()
    if abs.gui and abs.gui.Parent then return abs.gui end
    local pg = localPlayer:FindFirstChild("PlayerGui")
    if not pg then return nil end
    abs.gui = Instance.new("ScreenGui")
    abs.gui.Name = "NergAbsGui"
    abs.gui.ResetOnSpawn = false
    abs.gui.DisplayOrder = 5
    abs.gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    abs.gui.Parent = pg
    return abs.gui
  end

  local function absLabel(show)
    pcall(function()
      local g = absGui()
      if not g then return end
      local lbl = g:FindFirstChild("AbsTaunt")
      if not lbl then
        lbl = Instance.new("TextLabel")
        lbl.Name = "AbsTaunt"
        lbl.Size = UDim2.new(0, 560, 0, 50)
        lbl.Position = UDim2.new(0.5, -280, 0.34, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "At least they tried"
        lbl.TextColor3 = Color3.new(1, 1, 1)
        lbl.TextStrokeTransparency = 0.4
        lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 34
        lbl.TextTransparency = 1
        lbl.Parent = g
      end
      tweenService:Create(lbl, TweenInfo.new(show and 0.15 or 0.5), { TextTransparency = show and 0 or 1 }):Play()
    end)
  end

  local function absRing(model)
    if abs.rings[model] or not model or not model.Parent then return end
    if not players:GetPlayerFromCharacter(model) then return end
    local hrp = model:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local ring = Instance.new("Part")
    ring.Name = "NergAbsRing"
    ring.Shape = Enum.PartType.Cylinder
    ring.Size = Vector3.new(0.1, abs.range * 2, abs.range * 2)
    ring.CFrame = hrp.CFrame * CFrame.Angles(0, 0, math.rad(90))
    ring.Color = Color3.fromRGB(220, 50, 50)
    ring.Material = Enum.Material.ForceField
    ring.Transparency = 0.5
    ring.Anchored = false
    ring.CanCollide = false
    ring.CanTouch = false
    ring.CanQuery = false
    ring.CastShadow = false
    ring.Massless = true
    ring.Locked = true
    ring.Parent = hrp
    local w = Instance.new("WeldConstraint")
    w.Part0 = hrp
    w.Part1 = ring
    w.Parent = ring
    abs.rings[model] = ring
  end

  local function absRingOff(model)
    local r = abs.rings[model]
    if r then pcall(function() r:Destroy() end) end
    abs.rings[model] = nil
  end

  local function absRingsClear()
    for m in pairs(abs.rings) do absRingOff(m) end
  end

  local function absRingsResize()
    for _, r in pairs(abs.rings) do
      if r and r.Parent then r.Size = Vector3.new(0.1, abs.range * 2, abs.range * 2) end
    end
  end

  local function absNearestModel(pos)
    if not pos then return nil end
    local pl = workspace:FindFirstChild("Players")
    if not pl then return nil end
    local best, bestD = nil, 14
    for _, folder in ipairs(pl:GetChildren()) do
      for _, m in ipairs(folder:GetChildren()) do
        if m:IsA("Model") and m ~= localPlayer.Character then
          local hrp = m:FindFirstChild("HumanoidRootPart")
          if hrp then
            local d = (hrp.Position - pos).Magnitude
            if d < bestD then best, bestD = m, d end
          end
        end
      end
    end
    return best
  end

  local function absFindModel(pos)
    local near = absNearestModel(pos)
    if near then return near end
    local pl = workspace:FindFirstChild("Players")
    if not pl then return nil end
    for _, folder in ipairs(pl:GetChildren()) do
      local m = folder:FindFirstChild(ABS_MODEL_NAME)
      if m and m:IsA("Model") then return m end
    end
    return nil
  end

  local function absSoundPos(snd)
    local p = snd and snd.Parent
    while p and p ~= workspace do
      if p:IsA("BasePart") then return p.Position end
      p = p.Parent
    end
    return nil
  end

  local absCatalogBuilt = false
  local function absHarvestCatalog()
    if absCatalogBuilt then return end
    absCatalogBuilt = true
    pcall(function()
      local assets = replicatedStorage:FindFirstChild("Assets")
      if not assets then return end
      local function extractIds(val, outTbl, tagVal, depth)
        if (depth or 0) > 3 or val == nil then return end
        if type(val) == "string" or type(val) == "number" then
          local num = tostring(val):match("%d+")
          if num then outTbl[num] = tagVal end
        elseif typeof(val) == "Instance" and (val:IsA("Animation") or val:IsA("Sound")) then
          local raw = val:IsA("Animation") and val.AnimationId or val.SoundId
          local num = tostring(raw):match("%d+")
          if num then outTbl[num] = tagVal end
        elseif type(val) == "table" then
          for _, subv in pairs(val) do extractIds(subv, outTbl, tagVal, (depth or 0) + 1) end
        end
      end
      local function harvestCfg(cfgMod)
        if not (cfgMod and cfgMod:IsA("ModuleScript")) then return end
        local ok, mod = pcall(require, cfgMod)
        if not (ok and type(mod) == "table") then return end
        if type(mod.Animations) == "table" then
          for k, v in pairs(mod.Animations) do
            local kl = tostring(k):lower()
            if kl:find("stab") or kl:find("lunge") or kl:find("dagger") then
              extractIds(v, ABS_ANIM_IDS, tostring(k), 0)
            end
          end
        end
        if type(mod.Sounds) == "table" then
          for k, v in pairs(mod.Sounds) do
            local kl = tostring(k):lower()
            if kl:find("stab") or kl:find("lunge") or kl:find("dagger") then
              extractIds(v, ABS_SOUND_IDS, true, 0)
            end
          end
        end
      end
      local surv = assets:FindFirstChild("Survivors")
      local ttBase = surv and surv:FindFirstChild(ABS_MODEL_NAME)
      if ttBase then harvestCfg(ttBase:FindFirstChild("Config")) end
      local skins = assets:FindFirstChild("Skins")
      local sSurv = skins and skins:FindFirstChild("Survivors")
      local ttSkins = sSurv and sSurv:FindFirstChild(ABS_MODEL_NAME)
      if ttSkins then
        for _, sk in ipairs(ttSkins:GetChildren()) do
          harvestCfg(sk:FindFirstChild("Config"))
        end
      end
    end)
  end

  local function absTrigger(pos)
    if not abs.on or abs.locked or not __PLUS_GEN_ALIVE or _G.__NERG_KILLED then return end
    local ch = localPlayer.Character
    local myRoot = ch and ch:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local hum = ch:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health <= 0 then return end
    local model = absFindModel(pos)
    if not model or model == ch then return end
    local ttRoot = model:FindFirstChild("HumanoidRootPart")
    if not ttRoot or not ttRoot.Parent then return end
    if (myRoot.Position - ttRoot.Position).Magnitude > abs.range then return end
    abs.locked = true
    abs.hits += 1
    absLabel(true)
    task.spawn(function()
      if hum and hum.Parent then hum.AutoRotate = false end
      pcall(function()
        local deadline = os.clock() + abs.duration
        local hp0 = hum and hum.Health
        while os.clock() < deadline and abs.on and __PLUS_GEN_ALIVE and not _G.__NERG_KILLED do
          local ch2 = localPlayer.Character
          local r2 = ch2 and ch2:FindFirstChild("HumanoidRootPart")
          local hum2 = ch2 and ch2:FindFirstChildOfClass("Humanoid")
          if hp0 and hum2 and hum2.Health < hp0 - 0.5 then break end
          if not r2 or not ttRoot.Parent then break end
          local p2 = r2.Position
          local t2 = ttRoot.Position
          local flat = Vector3.new(t2.X - p2.X, 0, t2.Z - p2.Z)
          if flat.Magnitude < 0.05 then break end
          if hum2 then hum2.AutoRotate = false end
          r2.CFrame = CFrame.lookAt(p2, Vector3.new(t2.X, p2.Y, t2.Z))
          runService.RenderStepped:Wait()
        end
      end)
      pcall(function()
        local ch3 = localPlayer.Character
        local hum3 = (ch3 and ch3:FindFirstChildOfClass("Humanoid")) or hum
        if hum3 and hum3.Parent then hum3.AutoRotate = true end
      end)
      abs.locked = false
      absLabel(false)
    end)
  end

  local function absCheckSound(snd)
    if not abs.on then return end
    local ok, id = pcall(function() return snd.SoundId:match("%d+") end)
    if not ok or not id then return end
    if ABS_SOUND_IDS[id] then absTrigger(absSoundPos(snd)) end
  end

  local function absBindSound(snd)
    if abs.soundConns[snd] or not (snd and snd.Parent) then return end
    local cId, cPlay, cAnc
    local function dropSnd()
      if cId then pcall(function() cId:Disconnect() end) cId = nil end
      if cPlay then pcall(function() cPlay:Disconnect() end) cPlay = nil end
      if cAnc then pcall(function() cAnc:Disconnect() end) cAnc = nil end
      abs.soundConns[snd] = nil
    end
    cId = snd:GetPropertyChangedSignal("SoundId"):Connect(function() absCheckSound(snd) end)
    cPlay = snd.Played:Connect(function() absCheckSound(snd) end)
    cAnc = snd.AncestryChanged:Connect(function(_, parent)
      if not parent then dropSnd() end
    end)
    abs.soundConns[snd] = { Disconnect = dropSnd }
  end

  local function absScanSounds(root)
    if not root then return end
    for _, d in ipairs(root:GetDescendants()) do
      if d:IsA("Sound") then absBindSound(d) end
    end
  end

  local function absHookModel(model)
    if not (model and model:IsA("Model") and model.Parent) then return end
    absRing(model)
    if not abs.animConns[model] then
      local hum = model:FindFirstChildOfClass("Humanoid")
      local animator = hum and hum:FindFirstChildOfClass("Animator")
      if animator then
        local cAnim = animator.AnimationPlayed:Connect(function(track)
          local ok, aid = pcall(function() return track.Animation.AnimationId end)
          if not ok or not aid then return end
          local num = aid:match("%d+")
          if not num or not ABS_ANIM_IDS[num] then return end
          local hrp = model:FindFirstChild("HumanoidRootPart")
          absTrigger(hrp and hrp.Position)
        end)
        local cDesc = model.DescendantAdded:Connect(function(d)
          if d:IsA("Sound") then absBindSound(d) end
        end)
        abs.animConns[model] = {
          Disconnect = function()
            if cAnim then pcall(function() cAnim:Disconnect() end) cAnim = nil end
            if cDesc then pcall(function() cDesc:Disconnect() end) cDesc = nil end
          end,
        }
        absScanSounds(model)
      end
    end
  end

  local function absScanTick()
    local pl = workspace:FindFirstChild("Players")
    if pl then
      for _, folder in ipairs(pl:GetChildren()) do
        for _, model in ipairs(folder:GetChildren()) do
          if model:IsA("Model") and (model.Name == ABS_MODEL_NAME or model:GetAttribute("CharacterName") == ABS_MODEL_NAME) then
            absHookModel(model)
          end
        end
      end
    end
    for m in pairs(abs.rings) do
      local r = abs.rings[m]
      if not m.Parent or not r or not r.Parent or not players:GetPlayerFromCharacter(m) then absRingOff(m) end
    end
    for m, c in pairs(abs.animConns) do
      if not m.Parent then pcall(function() c:Disconnect() end) abs.animConns[m] = nil end
    end
  end

  local scanThread

  local function absStartScan()
    if scanThread then return end
    scanThread = task.spawn(function()
      while abs.on and __PLUS_GEN_ALIVE and not _G.__NERG_KILLED do
        pcall(absScanTick)
        task.wait(1)
      end
      scanThread = nil
    end)
  end

  local absStop

  local function absStart()
    absHarvestCatalog()
    absDropConns()
    absTrack(soundService.DescendantAdded:Connect(function(obj)
      if abs.on and obj:IsA("Sound") then absBindSound(obj) end
    end))
    local pl = workspace:FindFirstChild("Players")
    if pl then
      for _, folder in ipairs(pl:GetChildren()) do
        absTrack(folder.ChildAdded:Connect(function(obj)
          if abs.on and obj:IsA("Model") and (obj.Name == ABS_MODEL_NAME or obj:GetAttribute("CharacterName") == ABS_MODEL_NAME) then
            task.delay(0.15, function()
              if abs.on and obj.Parent then pcall(absHookModel, obj) end
            end)
          end
        end))
      end
    end
    pcall(absScanSounds, soundService)
    absStartScan()
    pcall(absScanTick)
  end

  absStop = function()
    abs.on = false
    absDropConns()
    if scanThread then pcall(task.cancel, scanThread) scanThread = nil end
    absRingsClear()
    if abs.locked then
      pcall(function()
        local ch = localPlayer.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        if hum then hum.AutoRotate = true end
      end)
    end
    abs.locked = false
    absLabel(false)
    pcall(function()
      if abs.gui then abs.gui:Destroy() end
      abs.gui = nil
    end)
  end

  rawset(_G, "NERG_ABS", {
    on = function() return abs.on end,
    locked = function() return abs.locked end,
    hits = function() return abs.hits end,
    range = function() return abs.range end,
    duration = function() return abs.duration end,
    rings = function()
      local n = 0
      for _ in pairs(abs.rings) do n += 1 end
      return n
    end,
    set = function(v)
      v2.set("a747ABOn", v and true or false)
      if v then abs.on = true absStart() else absStop() end
      return abs.on
    end,
    setRange = function(n)
      abs.range = math.clamp(tonumber(n) or abs.range, 10, 120)
      v2.set("a747ABRange", abs.range)
      absRingsResize()
      return abs.range
    end,
    setDuration = function(n)
      abs.duration = math.clamp(tonumber(n) or abs.duration, 0.15, 2)
      v2.set("a747ABDur", abs.duration)
      return abs.duration
    end,
    stop = function() absStop() end,
    trigger = function() pcall(absTrigger) end,
    dbg = function()
      local n = 0
      for _ in pairs(abs.rings) do n += 1 end
      return string.format("on=%s locked=%s rings=%d range=%.0f dur=%.1f hits=%d model=%s",
        tostring(abs.on), tostring(abs.locked), n, abs.range, abs.duration, abs.hits, ABS_MODEL_NAME)
    end,
  })

  -- boot purge: don rac cua lan chay truoc (thu hẹp phạm vi quét nhân vật, xóa bỏ 30.000 objects)
  pcall(function()
    local pf = workspaceService:FindFirstChild("Players")
    local rootsToScan = { pf, localPlayer and localPlayer.Character }
    for _, root in ipairs(rootsToScan) do
      if root then
        for _, d in ipairs(root:GetDescendants()) do
          if d:IsA("Part") and d.Name == "NergAbsRing" then d:Destroy() end
        end
      end
    end
    local pg0 = localPlayer:FindFirstChild("PlayerGui")
    if pg0 then
      for _, nm in ipairs({ "NergAbsGui", "AbsGui" }) do
        local old = pg0:FindFirstChild(nm)
        if old then old:Destroy() end
      end
    end
  end)

  local absSec = killerTab:Section({ Title = "Anti Backstab", Opened = true })
  CFG_UI["AbsOn"] = absSec:Toggle({
    Title = "Anti Backstab",
    Type = "Checkbox",
    Value = abs.on,
    Callback = function(v)
      if uiBoot then return end
      pcall(function() _G.NERG_ABS.set(v) end)
    end,
  })
  CFG_UI["AbsRange"] = absSec:Slider({
    Title = "Detection Range",
    Step = 1,
    Value = { Min = 10, Max = 120, Default = abs.range },
    Callback = function(n)
      if uiBoot then return end
      pcall(function() _G.NERG_ABS.setRange(n) end)
    end,
  })
  CFG_UI["AbsDur"] = absSec:Slider({
    Title = "Look Duration (s)",
    Step = 0.05,
    Value = { Min = 0.15, Max = 2.0, Default = abs.duration },
    Callback = function(n)
      if uiBoot then return end
      pcall(function() _G.NERG_ABS.setDuration(n) end)
    end,
  })

  if abs.on then task.defer(absStart) end
end

-- [A750] Auto Dodge (Slasher Raging Pace / John Doe 404 Error) — Dynamic Skin Catalog · Zero-Delay Local Animator Mount · Default OFF · Full Cleanup
do
  local autoDodge = {
    on = v2.get("a750DodgeOn", false) and true or false,
    meleeRadius = math.clamp(tonumber(v2.get("a750DodgeMelee", 18)) or 18, 8, 30),
    chanceRadius = math.clamp(tonumber(v2.get("a750DodgeChance", 75)) or 75, 30, 100),
    facingCheck = v2.get("a750DodgeFacing", false) and true or false,
    showNotif = v2.get("a750DodgeNotif", true) and true or false,
    debounce = math.clamp(tonumber(v2.get("a750DodgeCd", 1.0)) or 1.0, 0.5, 3.0),
    lastFired = 0,
    hits = 0,
    conns = {},
    survConns = {},
    gui = nil,
    catalogBuilt = false,
  }

  local STUN_ANIMS = {
    -- Fallback base IDs measured live (docId canon)
    ["87259391926321"] = { char = "Guest1337", skill = "Punch" },
    ["116618003477002"] = { char = "Shedletsky", skill = "Slash" },
    ["100725497418533"] = { char = "TwoTime", skill = "Stab" },
    ["89448354637442"] = { char = "TwoTime", skill = "LungeStart" },
    ["133491532453922"] = { char = "Chance", skill = "AimGun" },
    ["90499469533503"] = { char = "Chance", skill = "GunFire" },
  }

  local STUN_SOUNDS = {
    -- Fallback base sound IDs measured live
    ["133398613783505"] = { char = "Guest1337", skill = "Punch" },
    ["13471740561"] = { char = "Guest1337", skill = "CriticalPunch" },
    ["609342351"] = { char = "Guest1337", skill = "PunchWindup" },
    ["12222208"] = { char = "Shedletsky", skill = "Slash" },
    ["134932463887703"] = { char = "TwoTime", skill = "Stab" },
    ["101489994047160"] = { char = "TwoTime", skill = "CrouchStab" },
    ["139012439429121"] = { char = "Chance", skill = "GunWindUp" },
    ["121120408563206"] = { char = "Chance", skill = "GunFire" },
  }

  local function buildDynamicCatalog()
    if autoDodge.catalogBuilt then return end
    autoDodge.catalogBuilt = true
    pcall(function()
      local rs = game:GetService("ReplicatedStorage")
      local assets = rs:FindFirstChild("Assets")
      if not assets then return end

      local function extractStunIds(val, outTbl, infoObj, depth)
        if (depth or 0) > 3 or val == nil then return end
        if type(val) == "string" or type(val) == "number" then
          local num = tostring(val):match("%d+")
          if num then outTbl[num] = infoObj end
        elseif typeof(val) == "Instance" and (val:IsA("Animation") or val:IsA("Sound")) then
          local rawId = val:IsA("Animation") and val.AnimationId or val.SoundId
          local num = tostring(rawId):match("%d+")
          if num then outTbl[num] = infoObj end
        elseif type(val) == "table" then
          for _, subv in pairs(val) do
            extractStunIds(subv, outTbl, infoObj, (depth or 0) + 1)
          end
        end
      end

      local function harvest(cfgMod, sName)
        if not (cfgMod and cfgMod:IsA("ModuleScript")) then return end
        local ok, mod = pcall(require, cfgMod)
        if not (ok and type(mod) == "table") then return end
        if type(mod.Animations) == "table" then
          for aKey, aVal in pairs(mod.Animations) do
            local ks = tostring(aKey)
            if ks:find("Punch") or ks:find("Slash") or ks:find("Stab") or ks:find("Lunge") or ks:find("AimGun") or ks:find("GunFire") or ks:find("Hatchet") or ks:find("Axe") then
              extractStunIds(aVal, STUN_ANIMS, { char = sName, skill = ks }, 0)
            end
          end
        end
        if type(mod.Sounds) == "table" then
          for sKey, sVal in pairs(mod.Sounds) do
            local ks = tostring(sKey)
            if ks:find("Punch") or ks:find("Slash") or ks:find("Stab") or ks:find("Gun") or ks:find("Hatchet") or ks:find("Axe") then
              extractStunIds(sVal, STUN_SOUNDS, { char = sName, skill = ks }, 0)
            end
          end
        end
      end

      -- Scan base survivors (Guest1337, Shedletsky, TwoTime, Chance, JaneDoe)
      local bSurv = assets:FindFirstChild("Survivors")
      if bSurv then
        for _, sName in ipairs({ "Guest1337", "Shedletsky", "TwoTime", "Chance", "JaneDoe" }) do
          local f = bSurv:FindFirstChild(sName)
          if f then harvest(f:FindFirstChild("Config"), sName) end
        end
      end

      -- Scan all skins
      local sFolder = assets:FindFirstChild("Skins") and assets.Skins:FindFirstChild("Survivors")
      if sFolder then
        for _, sName in ipairs({ "Guest1337", "Shedletsky", "TwoTime", "Chance", "JaneDoe" }) do
          local charSkins = sFolder:FindFirstChild(sName)
          if charSkins then
            for _, sk in ipairs(charSkins:GetChildren()) do
              harvest(sk:FindFirstChild("Config"), sName)
            end
          end
        end
      end    end)
  end

  local function showDodgeBanner(txt)
    if not autoDodge.showNotif then return end
    pcall(function()
      local pg = localPlayer:FindFirstChild("PlayerGui")
      if not pg then return end
      if not autoDodge.gui or not autoDodge.gui.Parent then
        autoDodge.gui = Instance.new("ScreenGui")
        autoDodge.gui.Name = "NergDodgeGui"
        autoDodge.gui.ResetOnSpawn = false
        autoDodge.gui.DisplayOrder = 6
        autoDodge.gui.Parent = pg
      end
      local f = autoDodge.gui:FindFirstChild("Banner")
      if not f then
        f = Instance.new("Frame")
        f.Name = "Banner"
        f.AnchorPoint = Vector2.new(0.5, 0)
        f.Position = UDim2.new(0.5, 0, 0, 75)
        f.Size = UDim2.new(0, 320, 0, 32)
        f.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        f.BackgroundTransparency = 0.2
        f.BorderSizePixel = 0
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = f
        local stroke = Instance.new("UIStroke")
        stroke.Name = "Stroke"
        stroke.Color = Color3.fromRGB(255, 200, 50)
        stroke.Thickness = 1.5
        stroke.Parent = f
        local lbl = Instance.new("TextLabel")
        lbl.Name = "Text"
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 13
        lbl.Parent = f
        f.Parent = autoDodge.gui
      end
      local tLbl = f:FindFirstChild("Text")
      if tLbl then tLbl.Text = txt end
      f.Visible = true
      task.delay(1.8, function()
        if f and f.Parent then f.Visible = false end
      end)
    end)
  end

  local function tryAutoDodge(info, sModel)
    if not __PLUS_GEN_ALIVE or not autoDodge.on then return end
    local myChar = localPlayer.Character
    if not (myChar and myChar.Parent) then return end

    -- Determine killer ability
    local abilityName, payload = nil, nil
    if myChar.Name == "Slasher" then
      abilityName = "RagingPace"
      payload = buffer.fromstring("\3\n\0\0\0RagingPace")
    elseif myChar.Name == "JohnDoe" then
      abilityName = "404Error"
      payload = buffer.fromstring("\3\8\0\0\000404Error")
    else
      return
    end

    -- Debounce
    local nowT = os.clock()
    if nowT - autoDodge.lastFired < autoDodge.debounce then return end

    -- Cooldown check via UI
    local pg = localPlayer:FindFirstChild("PlayerGui")
    local mu = pg and pg:FindFirstChild("MainUI")
    local ac = mu and mu:FindFirstChild("AbilityContainer")
    local btn = ac and ac:FindFirstChild(abilityName)
    local cdLbl = btn and btn:FindFirstChild("CooldownTime")
    if cdLbl and cdLbl.Text ~= "" then return end

    -- Range check
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    local sRoot = sModel and sModel:FindFirstChild("HumanoidRootPart")
    if not (myRoot and sRoot) then return end

    local dist = (myRoot.Position - sRoot.Position).Magnitude
    local isChance = (info.char == "Chance" or (info.skill and info.skill:find("Gun")))
    local maxDist = isChance and autoDodge.chanceRadius or autoDodge.meleeRadius
    if dist > maxDist then return end

    -- Facing check (optional)
    if autoDodge.facingCheck then
      local toKiller = (myRoot.Position - sRoot.Position).Unit
      local look = sRoot.CFrame.LookVector
      if look:Dot(toKiller) < 0.15 then return end
    end

    -- Fire ability
    autoDodge.lastFired = nowT
    autoDodge.hits += 1
    if remoteEvent then
      remoteEvent:FireServer("UseActorAbility", { [1] = payload })
    end

    if v2.get("a720Telemetry", false) then
      print(string.format("[NERG] ★ AutoDodge fired: %s vs %s %s (dist=%.1f)", abilityName, tostring(info.char), tostring(info.skill), dist))
    end
    showDodgeBanner(string.format("★ Auto Dodge: %s vs %s (%s)", abilityName, tostring(info.char), tostring(info.skill)))
  end

  local function hookSurvivor(model)
    if not (model and model:IsA("Model") and model.Parent) then return end
    if autoDodge.survConns[model] then return end
    local conns = {}
    autoDodge.survConns[model] = conns

    local hookedSounds = setmetatable({}, { __mode = "k" })
    local function checkSound(d)
      if not (autoDodge.on and d and d.Parent) then return end
      local num = d.SoundId and tostring(d.SoundId):match("%d+")
      if num and STUN_SOUNDS[num] then
        tryAutoDodge(STUN_SOUNDS[num], model)
      end
    end
    local function bindSurvSound(d)
      if not (d and d:IsA("Sound") and d.Parent) or hookedSounds[d] then return end
      hookedSounds[d] = true
      conns[#conns + 1] = d.Played:Connect(function() checkSound(d) end)
      conns[#conns + 1] = d:GetPropertyChangedSignal("IsPlaying"):Connect(function()
        if d.IsPlaying then checkSound(d) end
      end)
      conns[#conns + 1] = d:GetPropertyChangedSignal("SoundId"):Connect(function()
        if d.IsPlaying then checkSound(d) end
      end)
      if d.IsPlaying then checkSound(d) end
    end

    for _, d in ipairs(model:GetDescendants()) do
      if d:IsA("Sound") then bindSurvSound(d) end
    end
    conns[#conns + 1] = model.DescendantAdded:Connect(function(d)
      if d:IsA("Sound") then
        task.defer(bindSurvSound, d)
      end
    end)

    task.spawn(function()
      local hum = model:FindFirstChildOfClass("Humanoid") or model:WaitForChild("Humanoid", 5)
      local an = hum and (hum:FindFirstChildOfClass("Animator") or hum:WaitForChild("Animator", 5))
      if not (an and model.Parent and autoDodge.survConns[model] == conns) then return end
      conns[#conns + 1] = an.AnimationPlayed:Connect(function(track)
        local aid = track and track.Animation and track.Animation.AnimationId
        local num = aid and tostring(aid):match("%d+")
        if num and STUN_ANIMS[num] then
          tryAutoDodge(STUN_ANIMS[num], model)
        end
      end)
    end)
  end

  local function unhookSurvivor(model)
    local conns = autoDodge.survConns[model]
    if conns then
      for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
      autoDodge.survConns[model] = nil
    end
  end

  local dodgeScanThread = nil
  local hookedSvFolder = nil

  local function bindDodgeSurvivorsFolder(sv)
    if not (sv and sv.Parent and sv:IsDescendantOf(workspace)) then return end
    if hookedSvFolder ~= sv then
      hookedSvFolder = sv
      if autoDodge.conns["svChildAdded"] then
        pcall(function() autoDodge.conns["svChildAdded"]:Disconnect() end)
        autoDodge.conns["svChildAdded"] = nil
      end
      if autoDodge.conns["svChildRemoved"] then
        pcall(function() autoDodge.conns["svChildRemoved"]:Disconnect() end)
        autoDodge.conns["svChildRemoved"] = nil
      end
      autoDodge.conns["svChildAdded"] = sv.ChildAdded:Connect(function(c)
        task.wait(0.1)
        if autoDodge.on and c:IsA("Model") and c.Parent and c:IsDescendantOf(workspace) then
          hookSurvivor(c)
        end
      end)
      autoDodge.conns["svChildRemoved"] = sv.ChildRemoved:Connect(function(c)
        if c:IsA("Model") then unhookSurvivor(c) end
      end)
    end
    for _, m in ipairs(sv:GetChildren()) do
      if m:IsA("Model") and not autoDodge.survConns[m] then
        hookSurvivor(m)
      end
    end
  end

  local function autoDodgeStart()
    buildDynamicCatalog()
    local pl = workspace:FindFirstChild("Players")
    if pl then
      local sv = pl:FindFirstChild("Survivors")
      if sv then bindDodgeSurvivorsFolder(sv) end
      if not autoDodge.conns["plChildAdded"] then
        autoDodge.conns["plChildAdded"] = pl.ChildAdded:Connect(function(c)
          if autoDodge.on and c.Name == "Survivors" then
            task.defer(bindDodgeSurvivorsFolder, c)
          end
        end)
      end
    end
    if not dodgeScanThread then
      dodgeScanThread = task.spawn(function()
        while __PLUS_GEN_ALIVE and not _G.__NERG_KILLED and autoDodge.on do
          task.wait(2.0)
          if not (__PLUS_GEN_ALIVE and not _G.__NERG_KILLED and autoDodge.on) then break end
          local pl2 = workspace:FindFirstChild("Players")
          local sv2 = pl2 and pl2:FindFirstChild("Survivors")
          if sv2 then
            bindDodgeSurvivorsFolder(sv2)
          end
          for m in pairs(autoDodge.survConns) do
            if not (m.Parent and m:IsDescendantOf(workspace)) or (sv2 and m.Parent ~= sv2) then
              unhookSurvivor(m)
            end
          end
        end
        dodgeScanThread = nil
      end)
    end
  end

  local function autoDodgeStop()
    hookedSvFolder = nil
    if dodgeScanThread then
      pcall(task.cancel, dodgeScanThread)
      dodgeScanThread = nil
    end
    for _, conns in pairs(autoDodge.survConns) do
      for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
    end
    autoDodge.survConns = {}
    for k, c in pairs(autoDodge.conns) do
      pcall(function() c:Disconnect() end)
      autoDodge.conns[k] = nil
    end
    pcall(function()
      if autoDodge.gui then autoDodge.gui:Destroy() autoDodge.gui = nil end
    end)
  end

  rawset(_G, "NERG_DODGE", {
    on = function() return autoDodge.on end,
    hits = function() return autoDodge.hits end,
    melee = function() return autoDodge.meleeRadius end,
    chance = function() return autoDodge.chanceRadius end,
    facing = function() return autoDodge.facingCheck end,
    notif = function() return autoDodge.showNotif end,
    cd = function() return autoDodge.debounce end,
    set = function(v)
      autoDodge.on = v and true or false
      v2.set("a750DodgeOn", autoDodge.on)
      if autoDodge.on then autoDodgeStart() else autoDodgeStop() end
      return autoDodge.on
    end,
    setMelee = function(n)
      autoDodge.meleeRadius = math.clamp(tonumber(n) or autoDodge.meleeRadius, 8, 30)
      v2.set("a750DodgeMelee", autoDodge.meleeRadius)
      return autoDodge.meleeRadius
    end,
    setChance = function(n)
      autoDodge.chanceRadius = math.clamp(tonumber(n) or autoDodge.chanceRadius, 30, 100)
      v2.set("a750DodgeChance", autoDodge.chanceRadius)
      return autoDodge.chanceRadius
    end,
    setFacing = function(v)
      autoDodge.facingCheck = v and true or false
      v2.set("a750DodgeFacing", autoDodge.facingCheck)
      return autoDodge.facingCheck
    end,
    setNotif = function(v)
      autoDodge.showNotif = v and true or false
      v2.set("a750DodgeNotif", autoDodge.showNotif)
      return autoDodge.showNotif
    end,
    setCd = function(n)
      autoDodge.debounce = math.clamp(tonumber(n) or autoDodge.debounce, 0.5, 3.0)
      v2.set("a750DodgeCd", autoDodge.debounce)
      return autoDodge.debounce
    end,
    stop = function() autoDodgeStop() end,
    trigger = function(char, skill)
      local pl = workspace:FindFirstChild("Players")
      local sv = pl and pl:FindFirstChild("Survivors")
      local m = sv and sv:FindFirstChild(char or "Guest1337")
      tryAutoDodge({ char = char or "Guest1337", skill = skill or "Punch" }, m)
    end,
    catalog = function()
      local aN, sN = 0, 0
      for _ in pairs(STUN_ANIMS) do aN += 1 end
      for _ in pairs(STUN_SOUNDS) do sN += 1 end
      return { anims = aN, sounds = sN }
    end,
    status = function()
      local aN, sN = 0, 0
      for _ in pairs(STUN_ANIMS) do aN += 1 end
      for _ in pairs(STUN_SOUNDS) do sN += 1 end
      return string.format("on=%s hits=%d melee=%.0f chance=%.0f facing=%s notif=%s cd=%.1f anims=%d snds=%d",
        tostring(autoDodge.on), autoDodge.hits, autoDodge.meleeRadius, autoDodge.chanceRadius,
        tostring(autoDodge.facingCheck), tostring(autoDodge.showNotif), autoDodge.debounce, aN, sN)
    end,
  })

  -- Section UI Controls in killerTab
  local dodgeSec = killerTab:Section({ Title = "Auto Dodge", Opened = true })
  CFG_UI["AutoDodgeOn"] = dodgeSec:Toggle({
    Title = "Auto Dodge (Raging Pace / 404)",
    Type = "Checkbox",
    Value = autoDodge.on,
    Callback = function(v)
      if uiBoot then return end
      pcall(function() _G.NERG_DODGE.set(v) end)
    end,
  })
  CFG_UI["AutoDodgeMelee"] = dodgeSec:Slider({
    Title = "Melee Radius (studs)",
    Step = 1,
    Value = { Min = 8, Max = 30, Default = autoDodge.meleeRadius },
    Callback = function(n)
      if uiBoot then return end
      pcall(function() _G.NERG_DODGE.setMelee(n) end)
    end,
  })
  CFG_UI["AutoDodgeChance"] = dodgeSec:Slider({
    Title = "Chance Gun Radius (studs)",
    Step = 5,
    Value = { Min = 30, Max = 100, Default = autoDodge.chanceRadius },
    Callback = function(n)
      if uiBoot then return end
      pcall(function() _G.NERG_DODGE.setChance(n) end)
    end,
  })
  CFG_UI["AutoDodgeFacing"] = dodgeSec:Toggle({
    Title = "Facing Check",
    Type = "Checkbox",
    Value = autoDodge.facingCheck,
    Callback = function(v)
      if uiBoot then return end
      pcall(function() _G.NERG_DODGE.setFacing(v) end)
    end,
  })
  CFG_UI["AutoDodgeNotif"] = dodgeSec:Toggle({
    Title = "Screen Notification",
    Type = "Checkbox",
    Value = autoDodge.showNotif,
    Callback = function(v)
      if uiBoot then return end
      pcall(function() _G.NERG_DODGE.setNotif(v) end)
    end,
  })
  CFG_UI["AutoDodgeCd"] = dodgeSec:Slider({
    Title = "Debounce Cooldown (s)",
    Step = 0.1,
    Value = { Min = 0.5, Max = 3.0, Default = autoDodge.debounce },
    Callback = function(n)
      if uiBoot then return end
      pcall(function() _G.NERG_DODGE.setCd(n) end)
    end,
  })

  if autoDodge.on then task.defer(autoDodgeStart) end
end

-- [A751] Noli Suite (Event-Driven Direct Config Control 1.0–16.0 · Independent Custom Speed · On-Demand Wall-Safe Aimbot · Anti-Crash · 30Hz Auto Detonate Nova)
do
  local pathfindingService = game:GetService("PathfindingService")

  local noli = {
    rushCtrl = v2.get("a751NoliRushCtrl", false) and true or false,
    turnStrength = math.clamp(tonumber(v2.get("a751NoliTurnStr", 5.0)) or 5.0, 1.0, 16.0),
    rushAim = v2.get("a751NoliRushAim", false) and true or false,
    speedOn = v2.get("a751NoliSpdOn", false) and true or false,
    dashSpeed = math.clamp(tonumber(v2.get("a751NoliDashSpd", 60)) or 60, 45, 110),
    antiCrash = v2.get("a751NoliAntiCrash", false) and true or false,
    autoNova = v2.get("a751NoliAutoNova", false) and true or false,
    novaRadius = math.clamp(tonumber(v2.get("a751NoliNovaRad", 12)) or 12, 6, 24),
    aimBound = false,
    aimSteppedConn = nil,
    savedAutoRotate = nil,
    curDir = nil,
    activeSteerDir = nil,
    dashStartAt = 0,
    sawDashMult = false,
    waypoints = {},
    wpIdx = 1,
    lastPathTargetPos = nil,
    lastPathAt = 0,
    pathBusy = false,
    actorsMod = nil,
    savedConfigs = setmetatable({}, { __mode = "k" }),
    charConns = {},
    charAddedConn = nil,
    netMod = nil,
    origFireServerConn = nil,
    hookedNet = false,
    novaConn = nil,
    novaAcc = 0,
    projMod = nil,
    detonatedIds = {},
    lastNovaFireAt = 0,
  }

  local losRayParams = RaycastParams.new()
  losRayParams.FilterType = Enum.RaycastFilterType.Exclude
  losRayParams.IgnoreWater = true
  losRayParams.RespectCanCollide = true

  local STEER_ANGLES = {
    { math.cos(math.rad(20)), math.sin(math.rad(20)) },
    { math.cos(math.rad(-20)), math.sin(math.rad(-20)) },
    { math.cos(math.rad(40)), math.sin(math.rad(40)) },
    { math.cos(math.rad(-40)), math.sin(math.rad(-40)) },
    { math.cos(math.rad(65)), math.sin(math.rad(65)) },
    { math.cos(math.rad(-65)), math.sin(math.rad(-65)) },
    { math.cos(math.rad(90)), math.sin(math.rad(90)) },
    { math.cos(math.rad(-90)), math.sin(math.rad(-90)) },
  }

  -- 1. Direct O(1) Config Patcher (Zero Per-Frame Polling · Non-Linear Smooth Curve & Inverse Burst Compensation)
  -- Game formula: TurnRate = VoidRushTurnSpeed * (VoidRushInitialTurnMult * ease + 1).
  local function patchSingleConfig(cfg)
    if type(cfg) ~= "table" then return end
    if cfg.VoidRushTurnSpeed == nil and cfg.VoidRushDashSpeed == nil then return end
    local orig = noli.savedConfigs[cfg]
    if not orig then
      orig = {
        turn = cfg.VoidRushTurnSpeed or 1,
        mult = cfg.VoidRushInitialTurnMult or 6.6,
        dur  = cfg.VoidRushInitialTurnDuration or 1.5,
        spd  = cfg.VoidRushDashSpeed or 60,
      }
      noli.savedConfigs[cfg] = orig
    end
    local alive = __PLUS_GEN_ALIVE and not _G.__NERG_KILLED
    if alive and (noli.rushCtrl or noli.rushAim) then
      local ratio = math.clamp((noli.turnStrength - 1.0) / 15.0, 0.0, 1.0)
      local curved = ratio ^ 1.35
      local baseTurn = (orig.turn > 1e-4) and orig.turn or 0.15
      local sustainedMult = 1.0 + curved * 6.5
      local newTurn = baseTurn * sustainedMult
      if noli.rushAim then
        newTurn = math.max(newTurn, 1.5 + curved * 6.0)
      end
      local origPeak = baseTurn * ((orig.mult or 6.6) + 1.0)
      local targetPeak = math.max(newTurn, origPeak * (1.0 + curved * 0.25))
      cfg.VoidRushTurnSpeed = newTurn
      cfg.VoidRushInitialTurnMult = math.max(0.0, (targetPeak / math.max(newTurn, 1e-4)) - 1.0)
      cfg.VoidRushInitialTurnDuration = orig.dur
    else
      cfg.VoidRushTurnSpeed = orig.turn
      cfg.VoidRushInitialTurnMult = orig.mult
      cfg.VoidRushInitialTurnDuration = orig.dur
    end

    noli.origDashSpeed = orig.spd
    if alive and noli.speedOn then
      cfg.VoidRushDashSpeed = noli.dashSpeed
    else
      cfg.VoidRushDashSpeed = orig.spd
    end
  end

  local function syncNoliConfigs()
    pcall(function()
      local assets = replicatedStorage:FindFirstChild("Assets")
      local killers = assets and assets:FindFirstChild("Killers")
      local noliFolder = killers and killers:FindFirstChild("Noli")
      local baseCfgMod = noliFolder and noliFolder:FindFirstChild("Config")
      if baseCfgMod and baseCfgMod:IsA("ModuleScript") then
        local ok, baseCfg = pcall(require, baseCfgMod)
        if ok and type(baseCfg) == "table" then patchSingleConfig(baseCfg) end
      end

      local skins = assets and assets:FindFirstChild("Skins")
      local skinKillers = skins and skins:FindFirstChild("Killers")
      local noliSkins = skinKillers and skinKillers:FindFirstChild("Noli")
      if noliSkins then
        for _, sk in ipairs(noliSkins:GetChildren()) do
          local sCfgMod = sk:FindFirstChild("Config")
          if sCfgMod and sCfgMod:IsA("ModuleScript") then
            local okS, sCfg = pcall(require, sCfgMod)
            if okS and type(sCfg) == "table" then patchSingleConfig(sCfg) end
          end
        end
      end

      if not noli.actorsMod then
        local okA, aMod = pcall(function()
          return require(replicatedStorage.Modules.Gameplay.Actors)
        end)
        if okA and type(aMod) == "table" then noli.actorsMod = aMod end
      end
      local curActors = noli.actorsMod and noli.actorsMod.CurrentActors
      if type(curActors) == "table" then
        local myActor = curActors[localPlayer]
        if type(myActor) == "table" and type(myActor.Config) == "table" then
          patchSingleConfig(myActor.Config)
        end
        for _, act in pairs(curActors) do
          if type(act) == "table" and (act.Player == localPlayer or act.Rig == localPlayer.Character) and type(act.Config) == "table" then
            patchSingleConfig(act.Config)
          end
        end
      end

      for cfg in pairs(noli.savedConfigs) do
        patchSingleConfig(cfg)
      end

      -- If currently mid-dash when Custom Speed toggle/slider changes, update active SpeedMultiplier once
      local ch = localPlayer.Character
      if ch and (ch.Name == "Noli" or ch:GetAttribute("CharacterName") == "Noli") then
        local sm = ch:FindFirstChild("SpeedMultipliers")
        local dashMult = sm and sm:FindFirstChild("VoidRushDash")
        if dashMult and dashMult:IsA("NumberValue") then
          local targetSpd = (noli.speedOn and __PLUS_GEN_ALIVE and not _G.__NERG_KILLED) and noli.dashSpeed or (noli.origDashSpeed or 60)
          dashMult.Value = targetSpd / 8
        end
      end
    end)
  end

  local function resetPathState()
    noli.waypoints = {}
    noli.wpIdx = 1
    noli.lastPathTargetPos = nil
    noli.lastPathAt = 0
  end

  local function releaseAimRotLock()
    if noli.savedAutoRotate ~= nil or a724RotLocks["noli_aim"] then
      noli.savedAutoRotate = nil
      pcall(function()
        local ch = localPlayer.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        a724RotUnlock(hum, "noli_aim")
        if hum then
          hum:Move(Vector3.zero)
        end
      end)
    end
  end

  local function unbindAimStep()
    local wasBound = noli.aimBound
    if noli.aimBound then
      noli.aimBound = false
      pcall(function() runService:UnbindFromRenderStep("NergNoliRushAim") end)
    end
    if noli.aimSteppedConn then
      local sc = noli.aimSteppedConn
      noli.aimSteppedConn = nil
      pcall(function() sc:Disconnect() end)
    end
    if wasBound or noli.savedAutoRotate ~= nil or a724RotLocks["noli_aim"] then
      releaseAimRotLock()
    end
    noli.curDir = nil
    noli.activeSteerDir = nil
    noli.sawDashMult = false
    noli.dashStartAt = 0
    resetPathState()
  end

  local function isNoliChar(ch)
    return ch ~= nil and ch.Parent ~= nil and (ch.Name == "Noli" or ch:GetAttribute("CharacterName") == "Noli")
  end

  local function isNoliDashing(ch)
    if not isNoliChar(ch) then return false end
    if ch:GetAttribute("VoidRushState") == "Dashing" then return true end
    local sm = ch:FindFirstChild("SpeedMultipliers")
    if sm and sm:FindFirstChild("VoidRushDash") ~= nil then return true end
    return false
  end

  local losFilter = {}
  local lastLosMy, lastLosTarget, lastLosCam, lastLosPf = nil, nil, nil, nil
  local function refreshLosFilter(myChar, targetChar)
    local cam = workspaceService.CurrentCamera
    local pf = workspaceService:FindFirstChild("Players")
    if myChar ~= lastLosMy or targetChar ~= lastLosTarget or cam ~= lastLosCam or pf ~= lastLosPf then
      lastLosMy, lastLosTarget, lastLosCam, lastLosPf = myChar, targetChar, cam, pf
      table.clear(losFilter)
      if pf then losFilter[#losFilter + 1] = pf end
      if myChar then losFilter[#losFilter + 1] = myChar end
      if targetChar then losFilter[#losFilter + 1] = targetChar end
      if cam then losFilter[#losFilter + 1] = cam end
      if visFolder then losFilter[#losFilter + 1] = visFolder end
      if a742pFolder then losFilter[#losFilter + 1] = a742pFolder end
      losRayParams.FilterDescendantsInstances = losFilter
    end
  end

  local function hasLineOfSight(fromPos, myChar, targetChar, toPos)
    local origin = fromPos + Vector3.new(0, 0.6, 0)
    local dest = toPos + Vector3.new(0, 0.6, 0)
    local delta = dest - origin
    if delta.Magnitude < 0.5 then return true end
    refreshLosFilter(myChar, targetChar)
    local hit = workspaceService:Raycast(origin, delta, losRayParams)
    return hit == nil
  end

  local function isCorridorClear(origin, dir, dist)
    if workspaceService:Raycast(origin, dir * dist, losRayParams) ~= nil then
      return false
    end
    local sideDist = math.min(dist, 4.5)
    local rightVec = Vector3.new(-dir.Z * 1.2, 0, dir.X * 1.2)
    if workspaceService:Raycast(origin + rightVec, dir * sideDist, losRayParams) ~= nil then
      return false
    end
    if workspaceService:Raycast(origin - rightVec, dir * sideDist, losRayParams) ~= nil then
      return false
    end
    return true
  end

  local function findOpenSteerDir(fromPos, myChar, targetChar, desiredDir, maxDist)
    if not desiredDir then return nil end
    refreshLosFilter(myChar, targetChar)
    local origin = fromPos + Vector3.new(0, 0.6, 0)
    local checkDist = math.clamp(maxDist or 8.0, 2.5, 9.5)
    if isCorridorClear(origin, desiredDir, checkDist) then
      return desiredDir
    end
    local dx, dz = desiredDir.X, desiredDir.Z
    for i = 1, #STEER_ANGLES do
      local cs, sn = STEER_ANGLES[i][1], STEER_ANGLES[i][2]
      local cand = Vector3.new(dx * cs - dz * sn, 0, dx * sn + dz * cs)
      if isCorridorClear(origin, cand, checkDist) then
        return cand
      end
    end
    if workspaceService:Raycast(origin, desiredDir * 3.8, losRayParams) == nil then
      return desiredDir
    end
    for i = 1, #STEER_ANGLES do
      local cs, sn = STEER_ANGLES[i][1], STEER_ANGLES[i][2]
      local cand = Vector3.new(dx * cs - dz * sn, 0, dx * sn + dz * cs)
      if workspaceService:Raycast(origin, cand * 4.2, losRayParams) == nil then
        return cand
      end
    end
    return nil
  end

  local function findNearestSurvivor(myPos, myLookFlat, myChar)
    local pf = workspaceService:FindFirstChild("Players")
    local sf = pf and pf:FindFirstChild("Survivors")
    if not sf then return nil, nil, false end
    local bestVisChar, bestVisHrp, bestVisScore = nil, nil, math.huge
    local bestOccChar, bestOccHrp, bestOccD = nil, nil, 55
    for _, ch in ipairs(sf:GetChildren()) do
      if ch:IsA("Model") and ch ~= localPlayer.Character and not ch:GetAttribute("Undetectable") then
        local hrp = ch:FindFirstChild("HumanoidRootPart")
        local hum = ch:FindFirstChildOfClass("Humanoid")
        if hrp and hum and hum.Health > 0 then
          local tPos = hrp.Position
          local d = (tPos - myPos).Magnitude
          if d <= 150 then
            if hasLineOfSight(myPos, myChar, ch, tPos) then
              local score = d
              if myLookFlat and d > 0.5 then
                local flatTo = Vector3.new(tPos.X - myPos.X, 0, tPos.Z - myPos.Z)
                if flatTo.Magnitude > 0.1 then
                  local dot = myLookFlat:Dot(flatTo.Unit)
                  score = d * (1.0 - 0.22 * dot)
                end
              end
              if score < bestVisScore then
                bestVisScore = score
                bestVisChar = ch
                bestVisHrp = hrp
              end
            elseif d < bestOccD then
              bestOccD = d
              bestOccChar = ch
              bestOccHrp = hrp
            end
          end
        end
      end
    end
    if bestVisChar then
      return bestVisChar, bestVisHrp, true
    end
    return bestOccChar, bestOccHrp, false
  end

  local function computePathThrottled(fromPos, toPos)
    if noli.pathBusy then return end
    local now = os.clock()
    local movedFar = (not noli.lastPathTargetPos)
      or (Vector2.new(toPos.X - noli.lastPathTargetPos.X, toPos.Z - noli.lastPathTargetPos.Z).Magnitude > 6)
    if not movedFar and (now - noli.lastPathAt) < 0.30 then return end
    noli.pathBusy = true
    task.spawn(function()
      local ok = pcall(function()
        local path = pathfindingService:CreatePath({
          AgentRadius = 2.2,
          AgentHeight = 5,
          AgentCanJump = false,
          WaypointSpacing = 3,
        })
        path:ComputeAsync(fromPos, toPos)
        if path.Status == Enum.PathStatus.Success then
          local wps = path:GetWaypoints()
          if #wps > 0 then
            local startIdx = 1
            for i = 1, #wps do
              local wp = wps[i].Position
              if Vector2.new(wp.X - fromPos.X, wp.Z - fromPos.Z).Magnitude > 3.5 then
                startIdx = i
                break
              end
            end
            noli.waypoints = wps
            noli.wpIdx = math.min(startIdx, #wps)
            noli.lastPathTargetPos = wps[#wps].Position
          else
            resetPathState()
          end
        else
          resetPathState()
        end
      end)
      if not ok then resetPathState() end
      noli.lastPathAt = os.clock()
      noli.pathBusy = false
    end)
  end

  local function flatUnit(fromPos, toPos)
    local v = Vector3.new(toPos.X - fromPos.X, 0, toPos.Z - fromPos.Z)
    if v.Magnitude < 0.25 then return nil end
    return v.Unit
  end

  local function computeHybridSteer(myHrp, myChar, targetChar, targetHrp, hasLos, allowLead)
    local myPos = myHrp.Position
    local rawTargetPos = targetHrp.Position
    local distToTarget = (rawTargetPos - myPos).Magnitude

    if hasLos then
      resetPathState()
      local aimPos = rawTargetPos
      if allowLead then
        local vel = targetHrp.AssemblyLinearVelocity
        local flatV = Vector3.new(vel.X, 0, vel.Z)
        if flatV.Magnitude > 1.5 and flatV.Magnitude < 90 then
          local leadT = math.clamp(distToTarget / 65, 0.02, 0.22)
          local candPos = rawTargetPos + flatV * leadT
          if hasLineOfSight(myPos, myChar, targetChar, candPos) then
            aimPos = candPos
          end
        end
      end
      local direct = flatUnit(myPos, aimPos)
      return findOpenSteerDir(myPos, myChar, targetChar, direct, math.min(distToTarget, 8.5)) or direct
    end

    computePathThrottled(myPos, rawTargetPos)
    local wps = noli.waypoints
    if not wps or #wps == 0 then
      return findOpenSteerDir(myPos, myChar, targetChar, flatUnit(myPos, rawTargetPos), 8.0)
    end

    while noli.wpIdx < #wps do
      local wp = wps[noli.wpIdx].Position
      if Vector2.new(wp.X - myPos.X, wp.Z - myPos.Z).Magnitude < 4.2 then
        noli.wpIdx += 1
      else
        break
      end
    end

    local chosenPos = nil
    local accDist = 0
    local prevPos = myPos
    for i = noli.wpIdx, #wps do
      local wpPos = wps[i].Position
      local seg = Vector2.new(wpPos.X - prevPos.X, wpPos.Z - prevPos.Z).Magnitude
      accDist += seg
      prevPos = wpPos
      if accDist <= 11.5 and hasLineOfSight(myPos, myChar, targetChar, wpPos) then
        chosenPos = wpPos
      else
        break
      end
    end

    if not chosenPos then
      return findOpenSteerDir(myPos, myChar, targetChar, flatUnit(myPos, rawTargetPos), 8.0)
    end

    local wpDir = flatUnit(myPos, chosenPos)
    return findOpenSteerDir(myPos, myChar, targetChar, wpDir, 7.5)
  end

  local function turnRateClamp(curDir, targetDir, dt, maxRadPerSec)
    if not targetDir then return curDir end
    local tx, tz = targetDir.X, targetDir.Z
    local tMag = math.sqrt(tx * tx + tz * tz)
    if tMag < 0.001 then return curDir end
    tx, tz = tx / tMag, tz / tMag
    if not curDir or curDir.Magnitude < 0.001 then
      return Vector3.new(tx, 0, tz)
    end
    local cx, cz = curDir.X, curDir.Z
    local cMag = math.sqrt(cx * cx + cz * cz)
    if cMag < 0.001 then
      return Vector3.new(tx, 0, tz)
    end
    cx, cz = cx / cMag, cz / cMag
    local dot = math.clamp(cx * tx + cz * tz, -1, 1)
    local angle = math.acos(dot)
    local dtClamped = math.clamp(dt or 0.016, 0.002, 0.05)
    local maxTurn = math.min((maxRadPerSec or 4.5) * dtClamped, 0.85)
    if angle <= maxTurn then
      return Vector3.new(tx, 0, tz)
    end
    local sign = (cz * tx - cx * tz < -1e-5) and -1 or 1
    local stepAng = maxTurn * sign
    local cs, sn = math.cos(stepAng), math.sin(stepAng)
    return Vector3.new(cx * cs + cz * sn, 0, -cx * sn + cz * cs)
  end

  local function applyDashSteerFrame(myHrp, hum, steerDir, syncCam)
    if not (myHrp and myHrp.Parent and hum and hum.Parent and steerDir) then return end
    if noli.savedAutoRotate == nil then
      noli.savedAutoRotate = hum.AutoRotate
    end
    a724RotLock(hum, "noli_aim")
    hum.AutoRotate = false
    pcall(function() myHrp.AssemblyAngularVelocity = Vector3.zero end)
    myHrp.CFrame = CFrame.lookAt(myHrp.Position, myHrp.Position + steerDir)
    local curVel = myHrp.AssemblyLinearVelocity
    local flatSpd = math.sqrt(curVel.X * curVel.X + curVel.Z * curVel.Z)
    if flatSpd > 8 then
      myHrp.AssemblyLinearVelocity = Vector3.new(steerDir.X * flatSpd, curVel.Y, steerDir.Z * flatSpd)
    end
    hum:Move(steerDir)
    if syncCam then
      local cam = workspaceService.CurrentCamera
      if cam then
        local camLv = cam.CFrame.LookVector
        local oldFlat = Vector3.new(camLv.X, 0, camLv.Z)
        if oldFlat.Magnitude > 0.001 then
          local focusPos = cam.Focus.Position
          local oldYawCF = CFrame.lookAt(focusPos, focusPos + oldFlat.Unit)
          local newYawCF = CFrame.lookAt(focusPos, focusPos + steerDir)
          cam.CFrame = newYawCF * oldYawCF:ToObjectSpace(cam.CFrame)
        end
      end
    end
  end

  -- 2. On-Demand Aimbot RenderStep (Runs ONLY during Void Rush Dash at RenderPriority.Last)
  local function noliAimStep(dt)
    if not __PLUS_GEN_ALIVE or _G.__NERG_KILLED or not noli.rushAim then
      unbindAimStep()
      return
    end
    local ch = localPlayer.Character
    if not isNoliDashing(ch) then
      unbindAimStep()
      return
    end
    if (os.clock() - (noli.dashStartAt or 0)) > 6.5 then
      unbindAimStep()
      return
    end

    local myHrp = ch:FindFirstChild("HumanoidRootPart")
    local hum = ch:FindFirstChildOfClass("Humanoid")
    if not (myHrp and hum and hum.Health > 0) then
      unbindAimStep()
      return
    end

    local lv = myHrp.CFrame.LookVector
    local actualDir = Vector3.new(lv.X, 0, lv.Z)
    actualDir = (actualDir.Magnitude > 0.01) and actualDir.Unit or (noli.curDir or Vector3.new(0, 0, -1))
    local refDir = (noli.curDir and noli.curDir.Magnitude > 0.01) and noli.curDir.Unit or actualDir

    local tChar, tHrp, hasLos = findNearestSurvivor(myHrp.Position, refDir, ch)
    if not (tChar and tHrp) then
      noli.activeSteerDir = nil
      noli.curDir = actualDir
      releaseAimRotLock()
      return
    end

    local desiredDir = computeHybridSteer(myHrp, ch, tChar, tHrp, hasLos, noli.turnStrength >= 4.0)
    if not desiredDir then
      noli.activeSteerDir = nil
      noli.curDir = actualDir
      releaseAimRotLock()
      return
    end

    local ratio = math.clamp((noli.turnStrength - 1.0) / 15.0, 0.0, 1.0)
    local maxRadPerSec = 2.2 + (ratio ^ 1.2) * 12.0
    local dtClamped = math.clamp(dt or 0.016, 0.002, 0.05)

    local steerDir = turnRateClamp(refDir, desiredDir, dtClamped, maxRadPerSec)
    noli.curDir = steerDir
    noli.activeSteerDir = steerDir
    applyDashSteerFrame(myHrp, hum, steerDir, true)
  end

  local function bindAimStepIfDashing()
    local ch = localPlayer.Character
    if not isNoliChar(ch) then
      unbindAimStep()
      return
    end
    syncNoliConfigs()
    if noli.rushAim and isNoliDashing(ch) then
      if not noli.aimBound then
        noli.aimBound = true
        noli.dashStartAt = os.clock()
        noli.activeSteerDir = nil
        local sm = ch:FindFirstChild("SpeedMultipliers")
        noli.sawDashMult = (sm and sm:FindFirstChild("VoidRushDash") ~= nil) or false
        local myHrp = ch:FindFirstChild("HumanoidRootPart")
        if myHrp then
          local lv0 = myHrp.CFrame.LookVector
          noli.curDir = Vector3.new(lv0.X, 0, lv0.Z).Magnitude > 0.01 and Vector3.new(lv0.X, 0, lv0.Z).Unit or Vector3.new(0, 0, -1)
        end
        pcall(function()
          runService:UnbindFromRenderStep("NergNoliRushAim")
          runService:BindToRenderStep("NergNoliRushAim", Enum.RenderPriority.Last.Value, noliAimStep)
        end)
        if not noli.aimSteppedConn then
          noli.aimSteppedConn = runService.Stepped:Connect(function()
            if not noli.aimBound or not noli.rushAim or not __PLUS_GEN_ALIVE or _G.__NERG_KILLED then return end
            local cNow = localPlayer.Character
            if not isNoliDashing(cNow) or not noli.activeSteerDir then return end
            local hrpNow = cNow:FindFirstChild("HumanoidRootPart")
            local humNow = cNow:FindFirstChildOfClass("Humanoid")
            if hrpNow and humNow and humNow.Health > 0 then
              applyDashSteerFrame(hrpNow, humNow, noli.activeSteerDir, false)
            end
          end)
        end
      end
    else
      unbindAimStep()
    end
  end

  local noliCharSeq = 0
  local noliSmThread = nil

  local function clearCharConns()
    noliCharSeq += 1
    if noliSmThread then
      local th = noliSmThread
      noliSmThread = nil
      if coroutine.running() ~= th then
        pcall(task.cancel, th)
      end
    end
    for i = #noli.charConns, 1, -1 do
      local c = noli.charConns[i]
      noli.charConns[i] = nil
      pcall(function() c:Disconnect() end)
    end
  end

  local function hookNoliCharacter(ch)
    clearCharConns()
    unbindAimStep()
    if not ch then return end
    local mySeq = noliCharSeq
    task.defer(function()
      if noliCharSeq ~= mySeq or not (ch and ch.Parent and ch:IsDescendantOf(workspaceService) and localPlayer.Character == ch and __PLUS_GEN_ALIVE and not _G.__NERG_KILLED) then return end
      if noli.rushCtrl or noli.rushAim or noli.speedOn then syncNoliConfigs() end
      noli.charConns[#noli.charConns + 1] = ch:GetAttributeChangedSignal("VoidRushState"):Connect(function()
        if noliCharSeq ~= mySeq then return end
        local st = ch:GetAttribute("VoidRushState")
        if st == "Charging" or st == "Dashing" then
          if noli.rushCtrl or noli.rushAim or noli.speedOn then syncNoliConfigs() end
        end
        bindAimStepIfDashing()
      end)
      noliSmThread = task.spawn(function()
        local sm = ch:FindFirstChild("SpeedMultipliers") or ch:WaitForChild("SpeedMultipliers", 5)
        if noliCharSeq ~= mySeq then return end
        noliSmThread = nil
        if not (sm and ch.Parent and ch:IsDescendantOf(workspaceService) and localPlayer.Character == ch and __PLUS_GEN_ALIVE and not _G.__NERG_KILLED) then return end
        noli.charConns[#noli.charConns + 1] = sm.ChildAdded:Connect(function(child)
          if noliCharSeq ~= mySeq then return end
          if child.Name == "VoidRushDash" then
            if noli.rushCtrl or noli.rushAim or noli.speedOn then syncNoliConfigs() end
            bindAimStepIfDashing()
          end
        end)
        noli.charConns[#noli.charConns + 1] = sm.ChildRemoved:Connect(function(child)
          if noliCharSeq ~= mySeq then return end
          if child.Name == "VoidRushDash" then
            bindAimStepIfDashing()
          end
        end)
      end)
      bindAimStepIfDashing()
    end)
  end

  if localPlayer.Character then hookNoliCharacter(localPlayer.Character) end
  noli.charAddedConn = localPlayer.CharacterAdded:Connect(function(ch)
    if not __PLUS_GEN_ALIVE or _G.__NERG_KILLED then return end
    clearCharConns()
    unbindAimStep()
    task.delay(0.6, function()
      if __PLUS_GEN_ALIVE and not _G.__NERG_KILLED and localPlayer.Character == ch then
        hookNoliCharacter(ch)
      end
    end)
  end)

  local function setAntiCrash(v)
    noli.antiCrash = v and true or false
    v2.set("a751NoliAntiCrash", noli.antiCrash)
    if noli.antiCrash then
      if not noli.hookedNet then
        pcall(function()
          local net = noli.netMod or require(replicatedStorage.Modules.Network.Network)
          if type(net) == "table" and type(net.FireServerConnection) == "function" then
            noli.netMod = net
            noli.origFireServerConn = net.FireServerConnection
            net.FireServerConnection = function(selfArg, eventName, kind, ...)
              if noli.antiCrash and __PLUS_GEN_ALIVE and not _G.__NERG_KILLED then
                local ev = (type(selfArg) == "string") and selfArg or eventName
                local kd = (type(selfArg) == "string") and eventName or kind
                if ev == (localPlayer.Name .. "VoidRushCollision") and kd == "REMOTE_EVENT" then
                  return nil
                end
              end
              return noli.origFireServerConn(selfArg, eventName, kind, ...)
            end
            noli.hookedNet = true
          end
        end)
      end
    else
      if noli.hookedNet and noli.netMod and noli.origFireServerConn then
        pcall(function()
          noli.netMod.FireServerConnection = noli.origFireServerConn
        end)
        noli.hookedNet = false
      end
    end
  end

  local function setAutoNova(v)
    noli.autoNova = v and true or false
    v2.set("a751NoliAutoNova", noli.autoNova)
    if noli.novaConn then
      pcall(function() noli.novaConn:Disconnect() end)
      noli.novaConn = nil
    end
    table.clear(noli.detonatedIds)
    noli.prevNovaDist = {}
    if not noli.autoNova then return end

    pcall(function()
      if not noli.projMod then
        noli.projMod = require(replicatedStorage.Systems.Player.Game.ProjectileReplication)
      end
    end)

    noli.novaAcc = 0
    noli.novaConn = runService.Heartbeat:Connect(function(dt)
      if not __PLUS_GEN_ALIVE or _G.__NERG_KILLED or not noli.autoNova then
        if noli.novaConn then noli.novaConn:Disconnect() noli.novaConn = nil end
        return
      end
      noli.novaAcc += (dt or 0.016)
      if noli.novaAcc < 0.033 then return end
      noli.novaAcc = 0

      local live = noli.projMod and noli.projMod.Projectiles
      if type(live) ~= "table" or next(live) == nil then
        if noli.prevNovaDist and next(noli.prevNovaDist) ~= nil then table.clear(noli.prevNovaDist) end
        return
      end

      local ch = localPlayer.Character
      if not (ch and ch.Parent and (ch.Name == "Noli" or ch:GetAttribute("CharacterName") == "Noli")) then return end
      local now = os.clock()
      if now - noli.lastNovaFireAt < 0.45 then return end

      local pf = workspaceService:FindFirstChild("Players")
      local sf = pf and pf:FindFirstChild("Survivors")
      if not sf then return end

      local prevMap = noli.prevNovaDist or {}
      noli.prevNovaDist = prevMap

      for id, p in pairs(live) do
        if not noli.detonatedIds[id] and type(p) == "table" then
          local mdl = p.Model
          local isNova = false
          local pPos = nil
          if typeof(mdl) == "Instance" and mdl.Parent then
            if mdl.Name == "Voidstar" or mdl.Name:find("Voidstar") or mdl.Name:find("Nova") then
              isNova = true
              local okP, posVal = pcall(function()
                return mdl:IsA("BasePart") and mdl.Position or mdl:GetPivot().Position
              end)
              if okP then pPos = posVal end
            end
          end
          if isNova and pPos then
            local bestD = math.huge
            for _, surv in ipairs(sf:GetChildren()) do
              if surv:IsA("Model") and not surv:GetAttribute("Undetectable") then
                local sHrp = surv:FindFirstChild("HumanoidRootPart")
                local sHum = surv:FindFirstChildOfClass("Humanoid")
                if sHrp and sHum and sHum.Health > 0 then
                  local d = (sHrp.Position - pPos).Magnitude
                  if d < bestD then bestD = d end
                end
              end
            end
            if bestD <= noli.novaRadius then
              local prevD = prevMap[id]
              local innerCore = noli.novaRadius * 0.65
              if bestD <= innerCore or (prevD ~= nil and bestD >= prevD - 0.08) then
                prevMap[id] = nil
                noli.detonatedIds[id] = now
                noli.lastNovaFireAt = now
                if remoteEvent then
                  remoteEvent:FireServer("UseActorAbility", { [1] = buffer.fromstring("\3\4\0\0\0Nova") })
                end
                return
              end
            end
            prevMap[id] = bestD
          end
        end
      end

      for id in pairs(prevMap) do
        if live[id] == nil then prevMap[id] = nil end
      end
      for id, t0 in pairs(noli.detonatedIds) do
        if live[id] == nil or (now - t0) > 10 then
          noli.detonatedIds[id] = nil
        end
      end
    end)
  end

  local function stopNoliSuite()
    noli.rushCtrl = false
    noli.speedOn = false
    noli.rushAim = false
    syncNoliConfigs()
    unbindAimStep()
    clearCharConns()
    if noli.charAddedConn then pcall(function() noli.charAddedConn:Disconnect() end) noli.charAddedConn = nil end
    setAntiCrash(false)
    setAutoNova(false)
  end

  rawset(_G, "NERG_NOLI", {
    setRushCtrl = function(v)
      noli.rushCtrl = v and true or false
      v2.set("a751NoliRushCtrl", noli.rushCtrl)
      syncNoliConfigs()
    end,
    setTurnStrength = function(n)
      noli.turnStrength = math.clamp(tonumber(n) or 5.0, 1.0, 16.0)
      v2.set("a751NoliTurnStr", noli.turnStrength)
      if noli.rushCtrl then syncNoliConfigs() end
    end,
    setRushAim = function(v)
      noli.rushAim = v and true or false
      v2.set("a751NoliRushAim", noli.rushAim)
      bindAimStepIfDashing()
    end,
    setSpeedOn = function(v)
      noli.speedOn = v and true or false
      v2.set("a751NoliSpdOn", noli.speedOn)
      syncNoliConfigs()
    end,
    setDashSpeed = function(n)
      noli.dashSpeed = math.clamp(tonumber(n) or 60, 45, 110)
      v2.set("a751NoliDashSpd", noli.dashSpeed)
      if noli.speedOn then syncNoliConfigs() end
    end,
    setAntiCrash = setAntiCrash,
    setAutoNova = setAutoNova,
    setNovaRadius = function(n)
      noli.novaRadius = math.clamp(tonumber(n) or 12, 6, 24)
      v2.set("a751NoliNovaRad", noli.novaRadius)
    end,
    get = function(k) return noli[k] end,
    stop = stopNoliSuite,
  })

  local noliSec = killerTab:Section({ Title = "Noli (Void Rush & Nova)", Opened = true })
  CFG_UI["NoliRushCtrl"] = noliSec:Toggle({
    Title = "Void Rush Control",
    Type = "Checkbox",
    Value = noli.rushCtrl,
    Callback = function(v)
      if uiBoot then return end
      pcall(function() _G.NERG_NOLI.setRushCtrl(v) end)
    end,
  })
  CFG_UI["NoliTurnStr"] = noliSec:Slider({
    Title = "Void Rush Turn Strength (1.0 - 16.0)",
    Step = 0.5,
    Value = { Min = 1.0, Max = 16.0, Default = noli.turnStrength },
    Callback = function(n)
      if uiBoot then return end
      pcall(function() _G.NERG_NOLI.setTurnStrength(n) end)
    end,
  })
  CFG_UI["NoliRushAim"] = noliSec:Toggle({
    Title = "Void Rush Aimbot (Wall-Safe Pathfind)",
    Type = "Checkbox",
    Value = noli.rushAim,
    Callback = function(v)
      if uiBoot then return end
      pcall(function() _G.NERG_NOLI.setRushAim(v) end)
    end,
  })
  CFG_UI["NoliSpdOn"] = noliSec:Toggle({
    Title = "Void Rush Custom Speed",
    Type = "Checkbox",
    Value = noli.speedOn,
    Callback = function(v)
      if uiBoot then return end
      pcall(function() _G.NERG_NOLI.setSpeedOn(v) end)
    end,
  })
  CFG_UI["NoliDashSpd"] = noliSec:Slider({
    Title = "Void Rush Speed",
    Step = 2,
    Value = { Min = 45, Max = 110, Default = noli.dashSpeed },
    Callback = function(n)
      if uiBoot then return end
      pcall(function() _G.NERG_NOLI.setDashSpeed(n) end)
    end,
  })
  CFG_UI["NoliAntiCrash"] = noliSec:Toggle({
    Title = "Void Rush Anti-Crash (Wall Bypass)",
    Type = "Checkbox",
    Value = noli.antiCrash,
    Callback = function(v)
      if uiBoot then return end
      pcall(function() _G.NERG_NOLI.setAntiCrash(v) end)
    end,
  })
  CFG_UI["NoliAutoNova"] = noliSec:Toggle({
    Title = "Auto Detonate Nova",
    Type = "Checkbox",
    Value = noli.autoNova,
    Callback = function(v)
      if uiBoot then return end
      pcall(function() _G.NERG_NOLI.setAutoNova(v) end)
    end,
  })
  CFG_UI["NoliNovaRad"] = noliSec:Slider({
    Title = "Nova Detonate Radius (studs)",
    Step = 1,
    Value = { Min = 6, Max = 24, Default = noli.novaRadius },
    Callback = function(n)
      if uiBoot then return end
      pcall(function() _G.NERG_NOLI.setNovaRadius(n) end)
    end,
  })

  if noli.rushCtrl or noli.speedOn then task.defer(syncNoliConfigs) end
  if noli.rushAim then task.defer(bindAimStepIfDashing) end
  if noli.antiCrash then task.defer(setAntiCrash, true) end
  if noli.autoNova then task.defer(setAutoNova, true) end
end

local SPlayer = v1PRBLOCKWindow:Section({ Title = "Player", Opened = true })
local visualTab = SPlayer:Tab({ Title = "Visual", Icon = "eye" })
local staminaTab = SPlayer:Tab({ Title = "Stamina", Icon = "zap" })
local genAutoTab = SPlayer:Tab({ Title = "Auto Gen", Icon = "cpu" })
local camTab = SPlayer:Tab({ Title = "Camera", Icon = "camera" })
do
local camCore = { fov = 70, origFov = 70, zoom = 12, keep = false, on = false, bound = false }
local function readDefaultFov()
  local pd = localPlayer:FindFirstChild("PlayerData")
  local st = pd and pd:FindFirstChild("Settings")
  local gm = st and st:FindFirstChild("Game")
  local fv = (gm and gm:FindFirstChild("FieldOfView")) or (pd and pd:FindFirstChild("FieldOfView", true))
  if fv and (fv:IsA("NumberValue") or fv:IsA("IntValue")) then
    return math.clamp(math.floor(fv.Value), 60, 120)
  end
  local cam = workspaceService.CurrentCamera
  if cam then
    return math.clamp(math.floor(cam.FieldOfView), 60, 120)
  end
  return 70
end
pcall(function()
  local defFov = readDefaultFov()
  camCore.fov = defFov
  camCore.origFov = defFov
  camCore.zoom = game:GetService("StarterPlayer").CameraMaxZoomDistance
end)
local function camPushFov()
  local c0 = workspaceService.CurrentCamera
  if c0 and c0.FieldOfView ~= camCore.fov then
    c0.FieldOfView = camCore.fov
  end
end
local function setCustomFov(v)
  local want = v and true or false
  local cam = workspaceService.CurrentCamera
  if want then
    if not camCore.on then
      camCore.origFov = readDefaultFov()
    end
    camCore.on = true
    if not camCore.bound then
      camCore.bound = true
      pcall(function()
        runService:BindToRenderStep("NergCamFov", Enum.RenderPriority.Camera.Value + 1, function()
          if not __PLUS_GEN_ALIVE or _G.__NERG_KILLED or not camCore.on then return end
          camPushFov()
        end)
      end)
    end
    camPushFov()
  else
    camCore.on = false
    if camCore.bound then
      camCore.bound = false
      pcall(function() runService:UnbindFromRenderStep("NergCamFov") end)
    end
    local restoreFov = readDefaultFov() or camCore.origFov or 70
    if cam then
      pcall(function() cam.FieldOfView = restoreFov end)
    end
  end
end
camCore.set = setCustomFov
rawset(_G, "__NERG_CAM_RELEASE", function()
  pcall(function() camCore.set(false) end)
  pcall(function() camCore.keep = false end)
  if camCore.zoomConn then pcall(function() camCore.zoomConn:Disconnect() end) camCore.zoomConn = nil end
end)
local camSec = camTab:Section({ Title = "Camera", Opened = true })
CFG_UI["CamFovOn"] = camSec:Toggle({
  Title = "Custom FOV",
  Type = "Checkbox",
  Value = false,
  Callback = function(v) if uiBoot then return end pcall(function()
    camCore.set(v)
  end) end,
})
CFG_UI["CamFov"] = camSec:Slider({
  Title = "Field of View",
  Step = 1,
  Value = { Min = 60, Max = 120, Default = math.clamp(camCore.fov, 60, 120) },
  Callback = function(n) if uiBoot then return end pcall(function()
    camCore.fov = n
    if camCore.on then camPushFov() end
  end) end,
})
CFG_UI["CamZoom"] = camSec:Slider({
  Title = "Max Zoom (studs)",
  Step = 2,
  Value = { Min = 12, Max = 128, Default = 12 },
  Callback = function(n) if uiBoot then return end pcall(function()
    camCore.zoom = n
    camCore.keep = n > game:GetService("StarterPlayer").CameraMaxZoomDistance
    localPlayer.CameraMaxZoomDistance = n
  end) end,
})
do
  camCore.zoomConn = localPlayer:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(function()
    if camCore.keep and localPlayer.CameraMaxZoomDistance < camCore.zoom then
      pcall(function() localPlayer.CameraMaxZoomDistance = camCore.zoom end)
    end
  end)
end
end

SCombat = v1PRBLOCKWindow:Section({ Title = "Combat", Opened = true })
blockTab = SCombat:Tab({ Title = "AutoBlock", Icon = "shield" })
hdtTab = SCombat:Tab({ Title = "HDT", Icon = "magnet" })
local punchTab = SCombat:Tab({ Title = "Punch", Icon = "hand-fist" })
local stamCore = { run = false, conns = {}, neg = nil, origMod = nil, origChar = nil, memo = { m = nil, t = 0 }, fire = { v = nil, t = 0 }, val = { max = 100, loss = 10, gain = 20, min = 0, sprint = 26, inf = false }, view = { conn = nil, dragConns = {}, pos = nil, gui = nil, lbl = nil, lastV = nil, lastM = nil }, mgmt = { conn = nil, on = false, pct = 10 } }
function stamCore.guard()
	local ch = localPlayer.Character
	if not ch then return true end
	local hu = ch:FindFirstChild("Humanoid")
	if not hu or hu.Health <= 0 then return true end
	if ch.Parent and ch.Parent.Name == "Spectating" then return true end
	return false
end
function stamCore.mod()
	local now = tick()
	if stamCore.memo.m and now - stamCore.memo.t < 2 then return stamCore.memo.m end
	local ok, mod = pcall(function() return require(replicatedStorage.Systems.Character.Game.Sprinting) end)
	if ok and mod then stamCore.memo.m, stamCore.memo.t = mod, now return mod end
	return nil
end
function stamCore.captureOrig(mod)
	local ch = localPlayer.Character
	if not mod or not mod.DefaultsSet then return end
	if not stamCore.origMod or stamCore.origChar ~= ch then
		stamCore.origChar = ch
		stamCore.origMod = {
			max = mod.MaxStamina,
			min = mod.MinStamina,
			loss = mod.StaminaLoss,
			gain = mod.StaminaGain,
			sprint = mod.SprintSpeed,
		}
	end
end
function stamCore.restoreMod()
	pcall(function()
		local mod = stamCore.mod()
		if not mod then return end
		mod.StaminaLossDisabled = false
		local o = stamCore.origMod
		if o then
			if o.max ~= nil then mod.MaxStamina = o.max end
			if o.min ~= nil then mod.MinStamina = o.min end
			if o.loss ~= nil then mod.StaminaLoss = o.loss end
			if o.gain ~= nil then mod.StaminaGain = o.gain end
			if o.sprint ~= nil then mod.SprintSpeed = o.sprint end
		else
			mod.MinStamina = 0
		end
		if type(mod.Stamina) == "number" and type(mod.MaxStamina) == "number" then
			mod.Stamina = math.clamp(mod.Stamina, 0, mod.MaxStamina)
		end
	end)
end
function stamCore.apply(mod)
	stamCore.captureOrig(mod)
	local o = stamCore.origMod
	local effMax, effLoss, effGain, effSprint = stamCore.val.max, stamCore.val.loss, stamCore.val.gain, stamCore.val.sprint
	local chA = localPlayer.Character
	if chA and chA.Parent and chA.Parent.Name == "Killers" and stamCore.val.max == 100 and stamCore.val.loss == 10 and stamCore.val.gain == 20 and stamCore.val.sprint == 26 then
		effMax = (o and o.max) or 110
		effLoss = (o and o.loss) or 9.5
		effGain = (o and o.gain) or 21
		effSprint = nil
	end
	mod.StaminaLoss = effLoss
	mod.StaminaGain = effGain
	mod.MinStamina = stamCore.val.min
	mod.MaxStamina = effMax
	if effSprint then mod.SprintSpeed = effSprint end
	mod.StaminaLossDisabled = stamCore.val.inf
	if stamCore.val.inf then
		mod.Stamina = effMax
		if mod.__staminaChangedEvent then
			local now = tick()
			if mod.Stamina ~= stamCore.fire.v or now - stamCore.fire.t >= 0.25 then
				stamCore.fire.v, stamCore.fire.t = mod.Stamina, now
				pcall(function() mod.__staminaChangedEvent:Fire(effMax) end)
			end
		end
	end
end
function stamCore.stop()
	for _, c in ipairs(stamCore.conns) do pcall(function() c:Disconnect() end) end
	stamCore.conns = {}
	stamCore.neg = nil
	stamCore.run = false
	stamCore.restoreMod()
end
function stamCore.start()
	if stamCore.run then return end
	stamCore.run = true
	table.insert(stamCore.conns, runService.Stepped:Connect(function()
		if stamCore.guard() then return end
		local mod = stamCore.mod()
		if mod and mod.DefaultsSet then stamCore.apply(mod) end
	end))
	table.insert(stamCore.conns, runService.Heartbeat:Connect(function(delta)
		if stamCore.guard() then stamCore.neg = nil return end
		if stamCore.val.inf or stamCore.val.min >= 0 then return end
		local mod = stamCore.mod()
		if not (mod and mod.DefaultsSet) or type(mod.Stamina) ~= "number" then return end
		local st = mod.Stamina
		if st > 0 then
			stamCore.neg = st
			return
		end
		local ch = localPlayer.Character
		local hu = ch and ch:FindFirstChildOfClass("Humanoid")
		local moving = hu ~= nil and hu.MoveDirection.Magnitude > 0.05
		local isSpr = (mod.IsSprinting == true) and moving
		local nv = stamCore.neg or 0
		if nv > 0 then nv = 0 end
		if isSpr then
			nv = nv - stamCore.val.loss * (delta or 0.0166666666666667)
		else
			nv = nv + stamCore.val.gain * (delta or 0.0166666666666667)
		end
		nv = math.clamp(nv, stamCore.val.min, stamCore.val.max)
		mod.Stamina = nv
		if mod.__staminaChangedEvent then
			pcall(function() mod.__staminaChangedEvent:Fire(nv) end)
		end
		stamCore.neg = nv
	end))
end
function stamCore.poke()
	if not stamCore.run then
		if not stamCore.val.inf then
			pcall(function()
				local mod = stamCore.mod()
				if mod then mod.StaminaLossDisabled = false end
			end)
		end
		return
	end
	if stamCore.guard() then return end
	local mod = stamCore.mod()
	if mod and mod.DefaultsSet then stamCore.apply(mod) end
end
function stamCore.resetDefaults()
	stamCore.val.max, stamCore.val.loss, stamCore.val.gain = 100, 10, 20
	stamCore.val.min, stamCore.val.sprint, stamCore.val.inf = 0, 26, false
	stamCore.mgmt.on = false
	stamCore.mgmt.pct = 10
	stamCore.mgmtStop()
	stamCore.viewStop()
	stamCore.stop()
	pcall(function()
		local mapUi = {
			StamCtl = false, StamInf = false, StamView = false, StamMgOn = false,
			StamMgPct = "10", StamMax = "100", StamMin = "0", StamLoss = "10", StamGain = "20", StamSprint = "26",
		}
		for k, val in pairs(mapUi) do
			local ctrl = CFG_UI and CFG_UI[k]
			if ctrl and ctrl.Set then pcall(function() ctrl:Set(val) end) end
		end
	end)
end
function stamCore.viewStop()
	if stamCore.view.conn then pcall(function() stamCore.view.conn:Disconnect() end) stamCore.view.conn = nil end
	if stamCore.view.dragConns then
		for i = #stamCore.view.dragConns, 1, -1 do
			local dc = stamCore.view.dragConns[i]
			stamCore.view.dragConns[i] = nil
			pcall(function() dc:Disconnect() end)
		end
	end
	if stamCore.view.gui then pcall(function() stamCore.view.gui:Destroy() end) stamCore.view.gui = nil stamCore.view.lbl = nil end
	stamCore.view.lastV, stamCore.view.lastM = nil, nil
	stamCore.view.sim = nil
end
function stamCore.viewStart()
	if stamCore.view.conn then return end
	local gui = Instance.new("ScreenGui")
	gui.Name = "NergStaminaView"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = 520
	gui.Parent = (gethui and gethui()) or game:GetService("CoreGui")
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0, 160, 0, 30)
	lbl.AnchorPoint = Vector2.new(0.5, 0.5)
	lbl.Position = stamCore.view.pos or UDim2.new(0.5, 0, 0.82, 0)
	lbl.BackgroundTransparency = 0.35
	lbl.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	lbl.TextSize = 18
	lbl.Font = Enum.Font.GothamBold
	lbl.Text = "..."
	lbl.Active = true
	lbl.Visible = false
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = lbl
	lbl.Parent = gui
	stamCore.view.gui, stamCore.view.lbl = gui, lbl
	local vDrag, vStart, vPos0 = false, nil, nil
	stamCore.view.dragConns[#stamCore.view.dragConns + 1] = lbl.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			vDrag = true
			vStart = inp.Position
			vPos0 = lbl.Position
			local endC
			endC = inp.Changed:Connect(function()
				if inp.UserInputState == Enum.UserInputState.End then
					endC:Disconnect()
					vDrag = false
					stamCore.view.pos = lbl.Position
				end
			end)
		end
	end)
	stamCore.view.dragConns[#stamCore.view.dragConns + 1] = userInputService.InputChanged:Connect(function(inp)
		if vDrag and vStart and vPos0 and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
			local cam = workspaceService.CurrentCamera
			local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
			local d = inp.Position - vStart
			local nx = math.clamp((vPos0.X.Scale * vp.X + vPos0.X.Offset + d.X) / math.max(1, vp.X), 0.05, 0.95)
			local ny = math.clamp((vPos0.Y.Scale * vp.Y + vPos0.Y.Offset + d.Y) / math.max(1, vp.Y), 0.05, 0.95)
			lbl.Position = UDim2.new(nx, 0, ny, 0)
		end
	end)
	stamCore.view.conn = runService.Heartbeat:Connect(function(dt)
		local lb = stamCore.view.lbl
		if not lb then return end
		if stamCore.guard() then
			if lb.Visible then lb.Visible = false end
			return
		end
		local mod = stamCore.mod()
		if not (mod and mod.DefaultsSet and type(mod.Stamina) == "number" and type(mod.MaxStamina) == "number") or mod.MaxStamina <= 0 then
			if lb.Visible then lb.Visible = false end
			return
		end
		local m = math.floor(mod.MaxStamina)
		local v
		if stamCore.run and stamCore.val.inf then
			local sv = stamCore.view.sim
			if not sv then
				sv = { v = mod.Stamina, pen = false, tur = 0, wasSpr = false }
				stamCore.view.sim = sv
			end
			local ch = localPlayer.Character
			local root = ch and ch:FindFirstChild("HumanoidRootPart")
			local isK = ch and ch.Parent and ch.Parent.Name == "Killers"
			local sLoss = isK and 9.5 or 10
			local sGain = isK and 21 or 20
			if root then
				local linVel = root.AssemblyLinearVelocity
				local flatVelMag = Vector3.new(linVel.X, 0, linVel.Z).Magnitude
				local hum = ch:FindFirstChildOfClass("Humanoid")
				local moveDirMag = hum and hum.MoveDirection.Magnitude or 0
				local moving = flatVelMag > 0.5 or moveDirMag > 0.1
				local sprinting = mod.IsSprinting == true
				local isSpr = sprinting and moving and (not sv.pen)
				if isSpr then
					sv.tur = math.clamp((sv.tur or 0) + dt * 0.05, 0.2, 3)
					sv.v = math.clamp(sv.v - sLoss * dt, 0, m)
					if sv.v <= 0 then
						sv.v = 0
						sv.pen = true
						sv.tur = 2
					end
				else
					if sv.wasSpr and not sv.pen then
						sv.tur = math.max(sv.tur or 0, 0.11)
					end
					sv.tur = math.clamp((sv.tur or 0) - dt, 0, 3)
					if sv.pen then
						if sv.tur <= 0 then
							sv.pen = false
						end
					elseif sv.tur <= 0 then
						sv.v = math.clamp(sv.v + sGain * dt, 0, m)
					end
				end
				sv.wasSpr = isSpr
			end
			v = math.floor(sv.v)
		else
			stamCore.view.sim = nil
			v = math.floor(mod.Stamina)
		end
		if v ~= stamCore.view.lastV or m ~= stamCore.view.lastM then
			stamCore.view.lastV, stamCore.view.lastM = v, m
			lb.Text = string.format("%d/%d", v, m)
			local r = v / m
			local col
			if r > 0.6 then col = Color3.fromRGB(90, 255, 130)
			elseif r > 0.25 then col = Color3.fromRGB(255, 210, 80)
			else col = Color3.fromRGB(255, 80, 80) end
			if lb.TextColor3 ~= col then lb.TextColor3 = col end
		end
		if not lb.Visible then lb.Visible = true end
	end)
end
function stamCore.mgmtStop()
	if stamCore.mgmt.conn then pcall(function() stamCore.mgmt.conn:Disconnect() end) stamCore.mgmt.conn = nil end
	pcall(function()
		local mod = stamCore.mod()
		if mod then mod.BindsEnabled = true end
	end)
end
function stamCore.mgmtStart()
	if stamCore.mgmt.conn then return end
	stamCore.mgmt.conn = runService.Heartbeat:Connect(function()
		if not stamCore.mgmt.on then return end
		if stamCore.guard() then return end
		local mod = stamCore.mod()
		if not (mod and mod.DefaultsSet and type(mod.Stamina) == "number" and type(mod.MaxStamina) == "number") or mod.MaxStamina <= 0 then return end
		local want = (mod.Stamina / mod.MaxStamina) * 100 >= stamCore.mgmt.pct
		if mod.BindsEnabled ~= want then
			mod.BindsEnabled = want
		end
		if not want and mod.IsSprinting == true then
			mod.IsSprinting = false
			if type(mod.StopSprinting) == "function" then
				pcall(function() mod:StopSprinting() end)
			end
		end
	end)
end
local stamSec = staminaTab:Section({ Title = "Stamina", Icon = "zap" })
CFG_UI["StamCtl"] = stamSec:Toggle({
  Title = "Stamina Control",
  Type = "Checkbox",
  Value = false,
  Callback = function(v)
    if uiBoot then return end
    if v then stamCore.start() else stamCore.stop() end
    pcall(function() windUI:Notify({ Title = "Stamina", Content = v and "control on" or "control off", Duration = 3, Icon = "zap" }) end)
  end,
})
CFG_UI["StamInf"] = stamSec:Toggle({
  Title = "Infinite Stamina",
  Icon = "infinity",
  Value = false,
  Callback = function(v)
    stamCore.val.inf = v and true or false
    if not uiBoot then stamCore.poke() end
  end,
})
CFG_UI["StamView"] = stamSec:Toggle({
  Title = "Legit Stamina View",
  Icon = "activity",
  Value = false,
  Callback = function(v)
    if uiBoot then return end
    if v then stamCore.viewStart() else stamCore.viewStop() end
  end,
})
CFG_UI["StamMgOn"] = stamSec:Toggle({
  Title = "Sprint Management",
  Icon = "gauge",
  Value = false,
  Callback = function(v)
    if uiBoot then return end
    stamCore.mgmt.on = v and true or false
    if v then stamCore.mgmtStart() else stamCore.mgmtStop() end
    pcall(function() windUI:Notify({ Title = "Stamina", Content = v and ("management on (" .. stamCore.mgmt.pct .. "%)") or "management off", Duration = 3, Icon = "gauge" }) end)
  end,
})
CFG_UI["StamMgPct"] = stamSec:Input({
  Title = "Disable Sprint at %",
  Value = "10",
  InputIcon = "gauge",
  Type = "Input",
  Placeholder = "10",
  Callback = function(val)
    local num = tonumber(val)
    if num then
      stamCore.mgmt.pct = num
      if not uiBoot then pcall(function() windUI:Notify({ Title = "Stamina", Content = "threshold: " .. num .. "%", Duration = 3, Icon = "gauge" }) end) end
    end
  end,
})
CFG_UI["StamMax"] = stamSec:Input({
  Title = "Max Stamina",
  Value = "100",
  InputIcon = "zap",
  Type = "Input",
  Placeholder = "100",
  Callback = function(val)
    local num = tonumber(val)
    if num then
      stamCore.val.max = num
      if not uiBoot then stamCore.poke() end
      pcall(function() windUI:Notify({ Title = "Stamina", Content = "max: " .. num, Duration = 3, Icon = "zap" }) end)
    end
  end,
})
CFG_UI["StamMin"] = stamSec:Input({
  Title = "Min Stamina",
  Value = "0",
  InputIcon = "minus",
  Type = "Input",
  Placeholder = "-100",
  Callback = function(val)
    local num = tonumber(val)
    if num then
      stamCore.val.min = num
      if not uiBoot then stamCore.poke() end
      pcall(function() windUI:Notify({ Title = "Stamina", Content = "min: " .. num, Duration = 3, Icon = "minus" }) end)
    end
  end,
})
CFG_UI["StamLoss"] = stamSec:Input({
  Title = "Stamina Loss",
  Value = "10",
  InputIcon = "trending-down",
  Type = "Input",
  Placeholder = "10",
  Callback = function(val)
    local num = tonumber(val)
    if num then
      stamCore.val.loss = num
      if not uiBoot then stamCore.poke() end
      pcall(function() windUI:Notify({ Title = "Stamina", Content = "loss: " .. num, Duration = 3, Icon = "trending-down" }) end)
    end
  end,
})
CFG_UI["StamGain"] = stamSec:Input({
  Title = "Stamina Gain",
  Value = "20",
  InputIcon = "trending-up",
  Type = "Input",
  Placeholder = "20",
  Callback = function(val)
    local num = tonumber(val)
    if num then
      stamCore.val.gain = num
      if not uiBoot then stamCore.poke() end
      pcall(function() windUI:Notify({ Title = "Stamina", Content = "gain: " .. num, Duration = 3, Icon = "trending-up" }) end)
    end
  end,
})
CFG_UI["StamSprint"] = stamSec:Input({
  Title = "Sprint Speed",
  Value = "26",
  InputIcon = "bird",
  Type = "Input",
  Placeholder = "26",
  Callback = function(val)
    local num = tonumber(val)
    if num then
      stamCore.val.sprint = num
      if not uiBoot then stamCore.poke() end
      pcall(function() windUI:Notify({ Title = "Stamina", Content = "speed: " .. num, Duration = 3, Icon = "bird" }) end)
    end
  end,
})
CFG_UI["StamReset"] = stamSec:Button({
  Title = "Reset Stamina to Defaults",
  Justify = "Center",
  Callback = function()
    stamCore.resetDefaults()
    pcall(function()
      windUI:Notify({ Title = "Stamina", Content = "back to defaults — all off, numbers reset", Duration = 4, Icon = "rotate-ccw" })
    end)
  end,
})
		-- [A742j] NÚT-NỔI-AUTOBLOCK (tap-mobile-toggle + status-2-chiều: xanh=ON / đỏ=OFF · drag-nhớ-vị-trí · chặn-double-fire)
do
	local abGui = Instance.new("ScreenGui")
	abGui.Name = "NergABToggle"
	abGui.ResetOnSpawn = false
	abGui.DisplayOrder = 500
	abGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")
	local abBtn = Instance.new("TextButton")
	abBtn.Name = "ABBtn"
	abBtn.Size = UDim2.new(0, 138, 0, 34)
	abBtn.Position = UDim2.new(0.5, 0, 0.5, 90)
	abBtn.AnchorPoint = Vector2.new(0.5, 0.5)
	abBtn.BackgroundTransparency = 0.2
	abBtn.Text = autoBlock and "AutoBlock : On" or "AutoBlock : Off"
	abBtn.TextSize = 14
	abBtn.Font = Enum.Font.GothamBold
	abBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	abBtn.Active = true
	abBtn.Parent = abGui
	local abCorner = Instance.new("UICorner")
	abCorner.CornerRadius = UDim.new(1, 0)
	abCorner.Parent = abBtn
	local abSaved = v2.get("a742jPos", nil)
	if type(abSaved) == "table" and type(abSaved.x) == "number" and type(abSaved.y) == "number" then
		abBtn.Position = UDim2.new(abSaved.x, 0, abSaved.y, 0)
	end
	local AB_ON = Color3.fromRGB(46, 204, 113)
	local AB_OFF = Color3.fromRGB(214, 48, 49)
	local abLastToggle = 0
	local function abPaint()
		abBtn.BackgroundColor3 = autoBlock and AB_ON or AB_OFF
		local wantText = autoBlock and "AutoBlock : On" or "AutoBlock : Off"
		if abBtn.Text ~= wantText then abBtn.Text = wantText end
	end
	abPaint()
	a742jPaint = abPaint
	a742jGui = abGui
	local function abToggle()
		local now = tick()
		if now - abLastToggle < 0.25 then return end
		abLastToggle = now
		autoBlock = not autoBlock
		v2.set("guestAutoBlockAudioOn", autoBlock)
		if not autoBlock then
			default = false
			v2.set("guestShowVisionRange", false)
			if setVisLoop then setVisLoop(false) elseif f18 then pcall(f18) end
		else
			local shouldCone = (not a742pHitboxMode)
			default = shouldCone
			v2.set("guestShowVisionRange", shouldCone)
			if setVisLoop then setVisLoop(shouldCone) elseif not shouldCone and f18 then pcall(f18) end
		end
		pcall(function()
			local tg = CFG_UI["AutoBlock"]
			if tg and tg.Set then tg:Set(autoBlock) end
		end)
		abPaint()
	end
	local abDrag, abStart, abPos0, abMoved = false, nil, nil, false
	abBtn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			abDrag, abMoved = true, false
			abStart = input.Position
			abPos0 = abBtn.Position
			local changedConn
			changedConn = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					changedConn:Disconnect()
					abDrag = false
					if not abMoved then
						abToggle()
					else
						v2.set("a742jPos", { x = abBtn.Position.X.Scale, y = abBtn.Position.Y.Scale })
					end
				end
			end)
		end
	end)
	a742jConn = userInputService.InputChanged:Connect(function(input)
		if not abDrag or not abStart or not abPos0 then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			local d = input.Position - abStart
			if math.abs(d.X) + math.abs(d.Y) > 8 then abMoved = true end
			if abMoved then
				local cam = workspaceService.CurrentCamera
				local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
				local px = abPos0.X.Scale * vp.X + abPos0.X.Offset + d.X
				local py = abPos0.Y.Scale * vp.Y + abPos0.Y.Offset + d.Y
				local nx = math.clamp(px / math.max(1, vp.X), 0.04, 0.96)
				local ny = math.clamp(py / math.max(1, vp.Y), 0.04, 0.96)
				abBtn.Position = UDim2.new(nx, 0, ny, 0)
			end
		end
	end)
	-- AutoBlock UI sync is now purely event-driven via a742jPaint (zero per-frame polling)
end

	local visSec = visualTab:Section({ Title = "Visual — ESP Kit — Ability Icon + Cooldown", Opened = true })
CFG_UI["VisAbility"] = visSec:Toggle({
  Title = "Ability ESP (icon + cooldown above heads)",
  Type = "Checkbox",
  Value = false,
  Callback = function(v)
    if uiBoot then return end
    pcall(function() ESP_SET.ability(v) end)
  end,
})
rawset(_G, "NERG_ABILITY_ESP", false)
CFG_UI["VisKillerEsp"] = visSec:Toggle({
  Title = "Killer esp (highlight)",
  Type = "Checkbox",
  Value = false,
  Callback = function(v)
    if uiBoot then return end
    pcall(function() ESP_SET.killer(v) end)
  end,
})
CFG_UI["VisSurvEsp"] = visSec:Toggle({
  Title = "Survivors esp (highlight)",
  Type = "Checkbox",
  Value = false,
  Callback = function(v)
    if uiBoot then return end
    pcall(function() ESP_SET.surv(v) end)
  end,
})
CFG_UI["VisTagsEsp"] = visSec:Toggle({
  Title = "Player Tags",
  Type = "Checkbox",
  Value = false,
  Callback = function(v)
    if uiBoot then return end
    pcall(function() ESP_SET.tags(v) end)
  end,
})
CFG_UI["TagOptions"] = visSec:Dropdown({
  Title = "Player Tags",
  Values = { "Name", "Role", "Health", "Distance", "Stamina", "Velocity", "Device", "Abilities" },
  Multi = true,
  AllowNone = true,
  Value = { "Name", "Role", "Health", "Distance", "Stamina", "Velocity", "Abilities" },
  Callback = function(o)
    if uiBoot then return end
    pcall(function() ESP_SET.options(o) end)
  end,
})
CFG_UI["VisTextSize"] = visSec:Slider({
  Title = "ESP Text Size",
  Step = 1,
  Value = { Min = 8, Max = 28, Default = 14 },
  Callback = function(n) if uiBoot then return end pcall(function() ESP_SET.size(n) end) end,
})
pcall(function()
  CFG_UI["VisKillerColor"] = visSec:Colorpicker({
    Title = "Killer color",
    Default = Color3.fromRGB(255, 80, 80),
    Transparency = 0,
    Callback = function(c) if uiBoot then return end pcall(function() ESP_SET.color_killer(c) end) end,
  })
end)
pcall(function()
  CFG_UI["VisSurvColor"] = visSec:Colorpicker({
    Title = "Survivor color",
    Default = Color3.fromRGB(90, 255, 130),
    Transparency = 0,
    Callback = function(c) if uiBoot then return end pcall(function() ESP_SET.color_surv(c) end) end,
  })
end)

pcall(function()
  local objSec = visualTab:Section({ Title = "Objects & Items ESP", Icon = "shapes" })
  local O = _G.NERG_OBJ
  CFG_UI["ObjMaster"] = objSec:Toggle({
    Title = "Objects ESP",
    Type = "Checkbox",
    Value = false,
    Callback = function(v) if uiBoot then return end pcall(function() O.setMaster(v) end) end,
  })
  local objTypeMap = {
    ["Graffiti"] = "Graffiti",
    ["Taph Traps"] = "TaphTrap",
    ["Rituals"] = "Ritual",
    ["Builderman"] = "Builderman",
    ["Azure Traps"] = "AzureTrap",
  }
  CFG_UI["ObjTypes"] = objSec:Dropdown({
    Title = "Object & Trap Types",
    Values = { "Graffiti", "Taph Traps", "Rituals", "Builderman", "Azure Traps" },
    Multi = true,
    AllowNone = true,
    Value = { "Graffiti", "Taph Traps", "Rituals", "Builderman", "Azure Traps" },
    Callback = function(o)
      if uiBoot then return end
      local sel = {}
      if type(o) == "table" then
        for k, v in pairs(o) do
          if type(k) == "number" and type(v) == "string" then sel[v] = true
          elseif v == true and type(k) == "string" then sel[k] = true end
        end
      end
      for label, internalKey in pairs(objTypeMap) do
        pcall(function() O.setType(internalKey, sel[label] == true) end)
      end
    end,
  })
  CFG_UI["ObjAzureR"] = objSec:Toggle({
    Title = "  Azure attack radius (circle)",
    Type = "Checkbox",
    Value = false,
    Callback = function(v) if uiBoot then return end pcall(function() O.setAzure(v) end) end,
  })
  CFG_UI["ObjItems"] = objSec:Toggle({
    Title = "Items ESP (Medkit / Bloxy Cola)",
    Type = "Checkbox",
    Value = false,
    Callback = function(v) if uiBoot then return end pcall(function() O.setItems(v) end) end,
  })
  CFG_UI["ObjTags"] = objSec:Toggle({
    Title = "Object name tags",
    Type = "Checkbox",
    Value = false,
    Callback = function(v) if uiBoot then return end pcall(function() O.setTags(v) end) end,
  })
  pcall(function()
    objSec:Colorpicker({
      Title = "Graffiti color",
      Default = Color3.fromRGB(255, 192, 203),
      Transparency = 0,
      Callback = function(c) if uiBoot then return end pcall(function() O.setColor("Graffiti", c) end) end,
    })
  end)
  pcall(function()
    objSec:Colorpicker({
      Title = "Taph color",
      Default = Color3.fromRGB(255, 165, 0),
      Transparency = 0,
      Callback = function(c) if uiBoot then return end pcall(function() O.setColor("TaphTrap", c) end) end,
    })
  end)
  pcall(function()
    objSec:Colorpicker({
      Title = "Azure color",
      Default = Color3.fromRGB(255, 30, 30),
      Transparency = 0,
      Callback = function(c) if uiBoot then return end pcall(function() O.setColor("AzureTrap", c) end) end,
    })
  end)
  pcall(function()
    objSec:Colorpicker({
      Title = "Items color",
      Default = Color3.fromRGB(89, 0, 255),
      Transparency = 0,
      Callback = function(c) if uiBoot then return end pcall(function() O.setColor("Items", c) end) end,
    })
  end)
end)
pcall(function()
  local itemMapSec = visualTab:Section({ Title = "Item Map", Icon = "map-pin" })
  local IM = _G.NERG_ITEM_MAP
  CFG_UI["ItemMapMaster"] = itemMapSec:Toggle({
    Title = "Item Map ESP Master",
    Type = "Checkbox",
    Value = false,
    Callback = function(v) if uiBoot then return end pcall(function() IM.setMaster(v) end) end,
  })
  CFG_UI["ItemMapGraffiti"] = itemMapSec:Toggle({
    Title = "Brandon: Graffiti & Spray Bottle",
    Type = "Checkbox",
    Value = false,
    Callback = function(v) if uiBoot then return end pcall(function() IM.setGraffiti(v) end) end,
  })
  CFG_UI["ItemMapFruits"] = itemMapSec:Toggle({
    Title = "Hotel: Fruits & The Maw",
    Type = "Checkbox",
    Value = false,
    Callback = function(v) if uiBoot then return end pcall(function() IM.setFruits(v) end) end,
  })
  CFG_UI["ItemMapDist"] = itemMapSec:Toggle({
    Title = "Show Distance Tags",
    Type = "Checkbox",
    Value = false,
    Callback = function(v) if uiBoot then return end pcall(function() IM.setShowDist(v) end) end,
  })
end)
pcall(function()
  local projSec = visualTab:Section({ Title = "Projectiles", Icon = "crosshair" })
  local P = _G.NERG_PROJ
  CFG_UI["ProjMark"] = projSec:Toggle({
    Title = "Projectile trajectory + hitbox",
    Type = "Checkbox",
    Value = false,
    Callback = function(v) if uiBoot then return end pcall(function() P.set(v) end) end,
  })
  pcall(function()
    projSec:Colorpicker({
      Title = "Marker color",
      Default = Color3.fromRGB(255, 60, 60),
      Transparency = 0,
      Callback = function(c) if uiBoot then return end pcall(function() P.setColor(c) end) end,
    })
  end)
  pcall(function()
    local W = _G.NERG_WINDUP
    CFG_UI["Windup"] = projSec:Toggle({
      Title = "Windup preview (yellow)",
      Type = "Checkbox",
      Value = false,
      Callback = function(v) if uiBoot then return end pcall(function() W.set(v) end) end,
    })
  end)
end)

pcall(function()
  local lighting = game:GetService("Lighting")
  local hudState = { on = false, gui = nil, bar = nil, lbl = nil, hbConn = nil, dragConns = {}, accTime = 0, frames = 0, pos = nil }

  local function clearHudConns()
    if hudState.hbConn then pcall(function() hudState.hbConn:Disconnect() end) hudState.hbConn = nil end
    for i = #hudState.dragConns, 1, -1 do
      local c = hudState.dragConns[i]
      hudState.dragConns[i] = nil
      pcall(function() c:Disconnect() end)
    end
  end

  local function setupStatusHud(v)
    hudState.on = v and true or false
    clearHudConns()
    if not hudState.on then
      if hudState.gui then pcall(function() hudState.gui:Destroy() end) hudState.gui = nil hudState.bar = nil hudState.lbl = nil end
      return
    end
    if not (hudState.gui and hudState.gui.Parent) then
      local g = Instance.new("ScreenGui")
      g.Name = "NergStatusHUD"
      g.ResetOnSpawn = false
      g.IgnoreGuiInset = true
      g.DisplayOrder = 550
      g.Parent = (gethui and gethui()) or game:GetService("CoreGui")

      local bar = Instance.new("Frame")
      bar.Name = "Bar"
      bar.Size = UDim2.fromOffset(130, 26)
      bar.Position = hudState.pos or UDim2.new(0.5, -65, 0, 12)
      bar.BackgroundColor3 = Color3.fromHex("#080C14")
      bar.BackgroundTransparency = 0.35
      bar.BorderSizePixel = 0
      bar.Active = true
      bar.Parent = g

      local cor = Instance.new("UICorner")
      cor.CornerRadius = UDim.new(0, 6)
      cor.Parent = bar

      local str = Instance.new("UIStroke")
      str.Color = Color3.fromHex("#FF6B00")
      str.Thickness = 1.2
      str.Transparency = 0.25
      str.Parent = bar

      local lbl = Instance.new("TextLabel")
      lbl.Name = "StatusText"
      lbl.Size = UDim2.fromScale(1, 1)
      lbl.BackgroundTransparency = 1
      lbl.Font = Enum.Font.GothamBold
      lbl.TextSize = 12
      lbl.TextColor3 = Color3.fromHex("#EAF6FF")
      lbl.Text = "FPS: -- | -- ms"
      lbl.Parent = bar

      hudState.gui, hudState.bar, hudState.lbl = g, bar, lbl
    end

    local bar = hudState.bar
    local dragging, dragStart, startPos = false, nil, nil
    hudState.dragConns[#hudState.dragConns + 1] = bar.InputBegan:Connect(function(inp)
      if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = inp.Position
        startPos = bar.Position
        local endConn
        endConn = inp.Changed:Connect(function()
          if inp.UserInputState == Enum.UserInputState.End then
            endConn:Disconnect()
            dragging = false
            hudState.pos = bar.Position
          end
        end)
      end
    end)
    hudState.dragConns[#hudState.dragConns + 1] = userInputService.InputChanged:Connect(function(inp)
      if dragging and dragStart and startPos and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
        local cam = workspaceService.CurrentCamera
        local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
        local d = inp.Position - dragStart
        local nx = math.clamp(startPos.X.Scale * vp.X + startPos.X.Offset + d.X, 4, math.max(4, vp.X - 134))
        local ny = math.clamp(startPos.Y.Scale * vp.Y + startPos.Y.Offset + d.Y, 4, math.max(4, vp.Y - 30))
        bar.Position = UDim2.fromOffset(nx, ny)
      end
    end)

    hudState.accTime, hudState.frames = 0.5, 0
    hudState.hbConn = runService.Heartbeat:Connect(function(dt)
      if _G.__NERG_KILLED or not __PLUS_GEN_ALIVE or not hudState.on then
        setupStatusHud(false)
        return
      end
      hudState.frames += 1
      hudState.accTime += (dt or 0.016)
      if hudState.accTime < 0.5 then return end
      local fps = math.clamp(math.floor((hudState.frames / math.max(0.05, hudState.accTime)) + 0.5), 1, 999)
      hudState.frames, hudState.accTime = 0, 0
      local ping = 0
      local okP, pVal = pcall(function() return localPlayer:GetNetworkPing() * 1000 end)
      if okP and type(pVal) == "number" and pVal > 0 then
        ping = math.floor(pVal + 0.5)
      else
        pcall(function()
          local net = statsService:FindFirstChild("Network")
          local ssi = net and net:FindFirstChild("ServerStatsItem")
          local dp = ssi and ssi:FindFirstChild("Data Ping")
          if dp then ping = math.floor(dp:GetValue() + 0.5) end
        end)
      end
      if hudState.lbl then
        hudState.lbl.Text = string.format("FPS: %d | %d ms", fps, ping)
      end
    end)
  end

  rawset(_G, "NERG_HUD", {
    set = setupStatusHud,
    shutdown = function() setupStatusHud(false) end
  })

  local fbState = { on = false, saved = nil, fxSaved = setmetatable({}, { __mode = "k" }), lightConn = nil, descConn = nil, lock = false }
  local ltState = { on = false, parts = setmetatable({}, { __mode = "k" }), decals = setmetatable({}, { __mode = "k" }), fx = setmetatable({}, { __mode = "k" }), addConn = nil }

  local function applyFxFullbright(inst)
    if not inst then return end
    if inst:IsA("Atmosphere") then
      if not fbState.fxSaved[inst] then
        fbState.fxSaved[inst] = { d = inst.Density, h = inst.Haze, g = inst.Glare }
      end
      pcall(function()
        inst.Density = 0
        inst.Haze = 0
        inst.Glare = 0
      end)
    elseif inst:IsA("BlurEffect") or inst:IsA("DepthOfFieldEffect") then
      if not fbState.fxSaved[inst] then
        fbState.fxSaved[inst] = { e = inst.Enabled }
      end
      pcall(function() inst.Enabled = false end)
    end
  end

  local function pushFullbright()
    if fbState.lock or not fbState.on then return end
    fbState.lock = true
    pcall(function()
      lighting.Ambient = Color3.fromRGB(178, 178, 178)
      lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
      lighting.Brightness = 2
      lighting.FogStart = 100000
      lighting.FogEnd = 100000
      lighting.GlobalShadows = false
      for _, ch in ipairs(lighting:GetChildren()) do
        applyFxFullbright(ch)
      end
    end)
    fbState.lock = false
  end

  local function setFullbright(v)
    local want = v and true or false
    if want then
      if not fbState.saved then
        fbState.saved = {
          Ambient = lighting.Ambient,
          OutdoorAmbient = lighting.OutdoorAmbient,
          Brightness = lighting.Brightness,
          FogStart = lighting.FogStart,
          FogEnd = lighting.FogEnd,
          GlobalShadows = lighting.GlobalShadows
        }
      end
      fbState.on = true
      pushFullbright()
      if not fbState.lightConn then
        fbState.lightConn = lighting.Changed:Connect(function()
          if fbState.on and not fbState.lock then
            pushFullbright()
          end
        end)
      end
      if not fbState.descConn then
        fbState.descConn = lighting.ChildAdded:Connect(function(ch)
          if fbState.on then task.defer(applyFxFullbright, ch) end
        end)
      end
    else
      fbState.on = false
      if fbState.lightConn then pcall(function() fbState.lightConn:Disconnect() end) fbState.lightConn = nil end
      if fbState.descConn then pcall(function() fbState.descConn:Disconnect() end) fbState.descConn = nil end
      if fbState.saved then
        local s = fbState.saved
        fbState.saved = nil
        fbState.lock = true
        pcall(function()
          lighting.Ambient = s.Ambient
          lighting.OutdoorAmbient = s.OutdoorAmbient
          lighting.Brightness = s.Brightness
          lighting.FogStart = s.FogStart
          lighting.FogEnd = s.FogEnd
          lighting.GlobalShadows = s.GlobalShadows
        end)
        fbState.lock = false
      end
      for inst, sv in pairs(fbState.fxSaved) do
        if inst and inst.Parent then
          pcall(function()
            if inst:IsA("Atmosphere") then
              inst.Density = sv.d
              inst.Haze = sv.h
              inst.Glare = sv.g
            elseif sv.e ~= nil then
              inst.Enabled = sv.e
            end
          end)
        end
        fbState.fxSaved[inst] = nil
      end
    end
  end

  local function isIgnoredRoot(inst)
    local pf = workspaceService:FindFirstChild("Players")
    if pf and inst:IsDescendantOf(pf) then return true end
    if visFolder and inst:IsDescendantOf(visFolder) then return true end
    if a742pFolder and inst:IsDescendantOf(a742pFolder) then return true end
    return false
  end

  local function applyLowTexInst(d)
    if not d or not d.Parent or isIgnoredRoot(d) then return end
    if d:IsA("BasePart") then
      if not ltState.parts[d] then
        ltState.parts[d] = { m = d.Material, v = d.MaterialVariant, c = d.CastShadow }
      end
      pcall(function()
        d.Material = Enum.Material.SmoothPlastic
        d.MaterialVariant = ""
        d.CastShadow = false
      end)
    elseif d:IsA("Decal") or d:IsA("Texture") then
      if ltState.decals[d] == nil then
        ltState.decals[d] = d.Transparency
      end
      pcall(function() d.Transparency = 1 end)
    elseif d:IsA("ParticleEmitter") or d:IsA("Trail") then
      if ltState.fx[d] == nil then
        ltState.fx[d] = d.Enabled
      end
      pcall(function() d.Enabled = false end)
    end
  end

  local function setLowTexture(v)
    local want = v and true or false
    if want then
      ltState.on = true
      local roots = { workspaceService:FindFirstChild("Map"), workspaceService:FindFirstChild("Lobby") }
      if not roots[1] and not roots[2] then roots = { workspaceService } end
      for _, r in ipairs(roots) do
        if r then
          for _, d in ipairs(r:GetDescendants()) do
            applyLowTexInst(d)
          end
        end
      end
      if not ltState.addConn then
        ltState.addConn = workspaceService.DescendantAdded:Connect(function(d)
          if ltState.on then task.defer(applyLowTexInst, d) end
        end)
      end
    else
      ltState.on = false
      if ltState.addConn then pcall(function() ltState.addConn:Disconnect() end) ltState.addConn = nil end
      for d, sv in pairs(ltState.parts) do
        if d and d.Parent then
          pcall(function()
            d.Material = sv.m
            d.MaterialVariant = sv.v
            d.CastShadow = sv.c
          end)
        end
        ltState.parts[d] = nil
      end
      for d, tr in pairs(ltState.decals) do
        if d and d.Parent then
          pcall(function() d.Transparency = tr end)
        end
        ltState.decals[d] = nil
      end
      for d, en in pairs(ltState.fx) do
        if d and d.Parent then
          pcall(function() d.Enabled = en end)
        end
        ltState.fx[d] = nil
      end
    end
  end

  rawset(_G, "NERG_GFX", {
    setFullbright = setFullbright,
    setLowTexture = setLowTexture,
    shutdown = function()
      setFullbright(false)
      setLowTexture(false)
    end
  })

  local gfxSec = visualTab:Section({ Title = "Graphics Optimizer", Icon = "sparkles" })
  CFG_UI["StatusHud"] = gfxSec:Toggle({
    Title = "Status HUD (FPS/Ping)",
    Type = "Checkbox",
    Value = false,
    Callback = function(v) if uiBoot then return end pcall(setupStatusHud, v) end
  })
  CFG_UI["Fullbright"] = gfxSec:Toggle({
    Title = "Fullbright & No Fog",
    Type = "Checkbox",
    Value = false,
    Callback = function(v) if uiBoot then return end pcall(setFullbright, v) end
  })
  CFG_UI["LowTex"] = gfxSec:Toggle({
    Title = "Low Texture Mode (FPS Booster)",
    Type = "Checkbox",
    Value = false,
    Callback = function(v) if uiBoot then return end pcall(setLowTexture, v) end
  })
end)


pcall(function()
	local _, pObj = infoTab:Paragraph({
		Title = "NergPlus - Version : 3.3",
		Desc = "Make you look more way like a Pro Player ( if you know how to use it , ofc )",
		Image = "zap",
		ImageSize = 24,
		Thumbnail = "rbxassetid://138962977470942",
		ThumbnailSize = 196,
		Color = Color3.fromHex("#18151C"),
		Buttons = {
			{
				Title = "Copy Discord",
				Icon = "link",
				Variant = "Primary",
				Callback = function()
					if setclipboard then pcall(setclipboard, "https://discord.gg/TYD8jX9fP") end
					pcall(function()
						windUI:Notify({ Title = "NergPlus", Content = "Discord link copied to clipboard!", Duration = 4, Icon = "paw-print" })
					end)
				end,
			},
		},
	})
	if pObj and pObj.ParagraphFrame and pObj.ParagraphFrame.UIElements and pObj.ParagraphFrame.UIElements.Main then
		local s = Instance.new("UIStroke")
		s.Color = Color3.fromHex("#FF6B00")
		s.Thickness = 1.2
		s.Transparency = 0.35
		s.Parent = pObj.ParagraphFrame.UIElements.Main
	end
	infoTab:Paragraph({
		Title = "Changelog",
		Desc = "Changelog details will be updated soon.",
		Image = "scroll-text",
		ImageSize = 24,
		Color = Color3.fromRGB(150, 255, 180),
	})
	infoTab:Select()
end)

pcall(function()
	factTab:Paragraph({
		Title = "Fact",
		Desc = "Coming Soon cuz im to lazy",
		Image = "lightbulb",
		ImageSize = 24,
		Color = Color3.fromRGB(255, 220, 120),
	})
end)

coreBlockSection = blockTab:Section({ Title = "AutoBlock", Opened = true })
local genCore = {
	esp = false, espGen = 0,
	conns = {}, hl = {}, tags2 = {},
	bars = setmetatable({}, { __mode = "kv" }),
	colr = setmetatable({}, { __mode = "k" }),
	cap = 6,
}
local function genIsGen(name)
	return name == "Generator" or string.match(name, "^Generator%d+$") ~= nil or name == "FakeGenerator" or string.match(name, "^FakeGenerator%d+$") ~= nil
end
local function genResolveCore(child)
	local ins = child:FindFirstChild("Instances")
	if ins then
		local m = ins:FindFirstChild("Generator")
		if m and m:IsA("Model") then return m end
	end
	return child
end
local function genProgressOf(child)
	local pr = child:FindFirstChild("Progress")
	if pr then
		local okv, vv = pcall(function() return pr.Value end)
		if okv and type(vv) == "number" then
			if vv >= 100 then genCore.bars[child] = nil end
			return vv
		end
	end
	local bar = genCore.bars[child]
	if bar ~= nil and not (bar.Parent and bar:IsDescendantOf(child)) then
		bar = nil
		genCore.bars[child] = nil
	end
	if not bar then
		local best = nil
		for _, d in ipairs(child:GetDescendants()) do
			if d:IsA("Frame") and d.Name == "Bar" then
				local okv2, sv = pcall(function() return d.Size.X.Scale end)
				if okv2 and type(sv) == "number" and (not best or sv > best.Scale) then
					best = d
				end
			end
		end
		if best then
			genCore.bars[child] = best
			bar = best
		end
	end
	if bar then
		local okv3, sv3 = pcall(function() return bar.Size.X.Scale end)
		if okv3 and type(sv3) == "number" then return sv3 * 100 end
	end
	return 0
end
function genCore.findMaps()
	local found = {}
	local function harvest(container)
		if not container then return end
		local direct = {}
		for _, c in ipairs(container:GetChildren()) do
			if genIsGen(c.Name) then table.insert(direct, c) end
		end
		if #direct > 0 then
			table.insert(found, { container = container, gens = direct })
			return
		end
		local gfolder = container:FindFirstChild("Generators")
		if gfolder then
			local gg = {}
			for _, c in ipairs(gfolder:GetChildren()) do
				if genIsGen(c.Name) then table.insert(gg, c) end
			end
			if #gg > 0 then table.insert(found, { container = gfolder, gens = gg }) end
		end
	end
	local map = workspace:FindFirstChild("Map")
	if map then
		harvest(map)
		local ing = map:FindFirstChild("Ingame") or map:FindFirstChild("ingame")
		harvest(ing)
		if ing then harvest(ing:FindFirstChild("Map")) end
	end
	for _, nm in ipairs({ "ingame", "Ingame", "Game" }) do
		local alt = workspace:FindFirstChild(nm)
		if alt then
			harvest(alt)
			if nm ~= "Game" then harvest(alt:FindFirstChild("Map")) end
		end
	end
	return found
end

local function genDone(inst)
	return genProgressOf(inst) >= 100
end
function genCore.clearAll()
	for _, h in pairs(genCore.hl) do pcall(function() h:Destroy() end) end
	genCore.hl = {}
	for _, d in pairs(genCore.tags2) do pcall(function() d:Remove() end) end
	genCore.tags2 = {}
	table.clear(genCore.bars)
	table.clear(genCore.colr)
end
function genCore.espApply()
	local alive = {}
	local refPos = nil
	pcall(function()
		local ch = localPlayer.Character
		local root = ch and ch:FindFirstChild("HumanoidRootPart")
		refPos = (root and root.Position) or (workspace.CurrentCamera and workspace.CurrentCamera.CFrame.Position)
	end)
	for _, entry in ipairs(genCore.findMaps()) do
		for _, child in ipairs(entry.gens) do
			if genCore.esp and not genDone(child) then
				alive[#alive + 1] = child
			end
		end
	end
	if refPos and #alive > (genCore.cap or 6) then
		table.sort(alive, function(a2, b2)
			local okA, dA = pcall(function() return (genResolveCore(a2):GetPivot().Position - refPos).Magnitude end)
			local okB, dB = pcall(function() return (genResolveCore(b2):GetPivot().Position - refPos).Magnitude end)
			if not okA then return false end
			if not okB then return true end
			return dA < dB
		end)
	end
	local limit = genCore.cap or 6
	for i2, child in ipairs(alive) do
		local h = genCore.hl[child]
		if i2 <= limit then
			local coreM = genResolveCore(child)
			if h and not h.Parent then
				h = nil
				genCore.hl[child] = nil
			end
			if not h and not coreM:FindFirstChild("NergGenHL") then
				h = Instance.new("Highlight")
				h.Name = "NergGenHL"
				h.Adornee = coreM
				h.FillTransparency = 0.6
				h.Parent = coreM
				genCore.hl[child] = h
				genCore.colr[child] = nil
			end
			if h then
				local band = "y"
				if child.Name == "FakeGenerator" then
					band = "o"
				elseif genDone(child) then
					band = "g"
				end
				if genCore.colr[child] ~= band then
					genCore.colr[child] = band
					local c = (band == "g" and Color3.fromRGB(0, 255, 0)) or (band == "o" and Color3.fromRGB(255, 165, 0)) or Color3.fromRGB(255, 255, 0)
					pcall(function() h.FillColor = c h.OutlineColor = c end)
				end
			end
		elseif h then
			genCore.hl[child] = nil
			genCore.colr[child] = nil
			pcall(function() h:Destroy() end)
		end
	end
	for child, h in pairs(genCore.hl) do
		if not (child.Parent and child:IsDescendantOf(workspace)) or genDone(child) then
			genCore.hl[child] = nil
			genCore.colr[child] = nil
			genCore.bars[child] = nil
			pcall(function() h:Destroy() end)
		end
	end
	for child, bar in pairs(genCore.bars) do
		if not (child and child.Parent and child:IsDescendantOf(workspace)) or not (bar and bar.Parent and bar:IsDescendantOf(child)) or genDone(child) then
			genCore.bars[child] = nil
			genCore.colr[child] = nil
		end
	end
end
function genCore.espStart()
	genCore.espStop()
	genCore.esp = true
	genCore.espApply()
	local function watchContainer(container)
		if not container then return end
		table.insert(genCore.conns, container.ChildAdded:Connect(function()
			task.wait(1)
			if genCore.esp then genCore.espApply() end
		end))
	end
	local map = workspace:FindFirstChild("Map")
	if map then
		watchContainer(map)
		local ing = map:FindFirstChild("Ingame") or map:FindFirstChild("ingame")
		watchContainer(ing)
		if ing then watchContainer(ing:FindFirstChild("Map")) end
	end
	genCore.espGen = (genCore.espGen or 0) + 1
	local myGen = genCore.espGen
	task.spawn(function()
		while genCore.esp and genCore.espGen == myGen and __PLUS_GEN_ALIVE and not _G.__NERG_KILLED do
			task.wait(1)
			if genCore.esp and genCore.espGen == myGen then
				pcall(function() genCore.espApply() end)
			end
		end
	end)
	end
function genCore.espStop()
	genCore.esp = false
	genCore.espGen = (genCore.espGen or 0) + 1
	for _, c in ipairs(genCore.conns) do pcall(function() c:Disconnect() end) end
	genCore.conns = {}
	genCore.clearAll()
end


pcall(function()
	local genSec = visualTab:Section({ Title = "Generator", Icon = "cpu" })
	CFG_UI["GenEsp"] = genSec:Toggle({
	  Title = "Generator ESP",
	  Type = "Checkbox",
	  Value = false,
	  Callback = function(v)
	    if uiBoot then return end
	    if v then genCore.espStart() else genCore.espStop() end
	  end,
	})
end)
local genA743
do
  local okA743, modA743 = pcall(function()
    local RunA = game:GetService("RunService")
    local RSA = game:GetService("ReplicatedStorage")
    local LPA = game:GetService("Players").LocalPlayer
    -- A743 GEN HELPERS (minigames) — Flow n-1 / Lock frame-exact / Connect mates / Gear ESP
    -- luật: chỉ đường-input thật của game · Heartbeat+accumulator · ESP tự hạ 3s khi có bàn
    local mod = {
      flow = { on = false }, lock = { on = false }, conn = { on = false },
      gear = { on = false }, pace = 0.15, jit = 0.2,
    }
    local active = {}
    local hlogC, logL = {}, {}
    local function paced()
      local base = tonumber(mod.pace) or 0.15
      local j = tonumber(mod.jit) or 0
      local d = base * (1 - j + math.random() * 2 * j)
      if d < 0.03 then d = 0.03 end
      return d
    end
    local function moduleOf(name)
      local sys = RSA:FindFirstChild("Systems")
      local ply = sys and sys:FindFirstChild("Player")
      local gam = ply and ply:FindFirstChild("Game")
      local mgFolder = gam and gam:FindFirstChild("Minigames")
      if not mgFolder then
        pcall(function()
          mgFolder = RSA:WaitForChild("Systems", 5):WaitForChild("Player", 5):WaitForChild("Game", 5):WaitForChild("Minigames", 5)
        end)
      end
      local m = mgFolder and (mgFolder:FindFirstChild(name) or mgFolder:WaitForChild(name, 5))
      if not m then return nil end
      local okR, mm = pcall(require, m)
      if okR and type(mm) == "table" then return mm end
      return nil
    end
    local function classValues(mm)
      if type(mm) ~= "table" then return nil end
      for k in pairs(mm) do
        if tostring(k):find("ClassValues") then
          local cls = mm[k]
          if type(cls) == "table" and type(cls.Start) == "function" then return cls end
        end
      end
      return nil
    end
    local origStarts = {}
    local function hookStart(cls, onSession)
      local cur = cls.Start
      if not origStarts[cls] then origStarts[cls] = cur end
      cls.Start = function(...)
        local a = { ... }
        local rets = { cur(table.unpack(a)) }
        for _, v in ipairs(a) do
          if type(v) == "table" and (type(v.Network) == "table" or v.__input ~= nil or v.__renderer ~= nil) then
            local ses = v
            task.spawn(function()
              active[ses] = true
              local ok2, err2 = pcall(onSession, ses)
              active[ses] = nil
              if not ok2 then pcall(function() warn("[NERG-A743] " .. tostring(err2)) end) end
            end)
            break
          end
        end
        return table.unpack(rets)
      end
    end
    mod.restoreHooks = function()
      for cls, orig in pairs(origStarts) do
        pcall(function() cls.Start = orig end)
      end
      origStarts = {}
    end
    do -- FLOW: tự giải n-1 cặp (BFS gọn + DFS dự bị) — owner kéo cú chốt
      local cls = classValues(moduleOf("FlowClientMinigame"))
      if cls then hookStart(cls, function(ses)
        if not mod.flow.on then return end
        local b, inp, rd
        for _ = 1, 28 do
          inp = ses.__input
          rd = ses.__renderer
          b = inp and inp.Board
          if b and rd and not inp.Ended
            and type(b.Size) == "number" and b.Size > 0
            and type(b.Pairs) == "table" and next(b.Pairs) ~= nil
            and type(b.Paths) == "table" and type(b.Position) == "table" then
            break
          end
          task.wait(0.25)
        end
        if not (b and rd and inp and not inp.Ended and type(b.Pairs) == "table" and next(b.Pairs) ~= nil) then return end
        task.wait(0.45)
        if inp.Ended or not mod.flow.on then return end
        local s = b.Size
        local function rc(c) return math.ceil(c / s), (c - 1) % s + 1 end
        local function pairDist(i)
          local pr = b.Pairs[i]
          if type(pr) ~= "table" then return 999 end
          return math.abs(math.ceil(pr[1] / s) - math.ceil(pr[2] / s)) + math.abs((pr[1] - 1) % s - (pr[2] - 1) % s)
        end
        local maxI = 0
        for i in pairs(b.Pairs) do
          if i > maxI then maxI = i end
        end
        for i = 1, maxI do
          if type(b.Paths[i]) ~= "table" then b.Paths[i] = {} end
        end
        local tran, co = {}, {}
        for i, pr in pairs(b.Pairs) do
          if type(pr) == "table" then
            local pp = b.Paths[i]
            if type(pp) == "table" and #pp > 0 then
              co[#co + 1] = i
            else
              tran[#tran + 1] = i
            end
          end
        end
        table.sort(tran)
        if #tran == 0 then return end
        local bestI, bestD
        for _, i in ipairs(tran) do
          local d = pairDist(i)
          if not bestD or d < bestD then
            bestD, bestI = d, i
          end
        end
        local used = {}
        for c in pairs(b.Position) do used[c] = true end
        local prs = {}
        for _, i in ipairs(tran) do
          if i ~= bestI then prs[#prs + 1] = i end
        end
        table.sort(prs, function(iA, iB)
          local dA, dB = pairDist(iA), pairDist(iB)
          if dA ~= dB then return dA < dB end
          return iA < iB
        end)
        local function neighbors(c)
          local r, co2 = rc(c)
          local t = {}
          if r > 1 then t[#t + 1] = c - s end
          if r < s then t[#t + 1] = c + s end
          if co2 > 1 then t[#t + 1] = c - 1 end
          if co2 < s then t[#t + 1] = c + 1 end
          return t
        end
        local function endpointBlocked(nx, i2)
          for ii, pr2 in pairs(b.Pairs) do
            if type(pr2) == "table" and (pr2[1] == nx or pr2[2] == nx) then
              return ii ~= i2
            end
          end
          return false
        end
        local function reachable(a2, z2)
          if a2 == z2 then return true end
          local seen = { [a2] = true }
          local q = { a2 }
          local head = 1
          while head <= #q do
            local cur = q[head]
            head += 1
            for _, nx in ipairs(neighbors(cur)) do
              if not seen[nx] and not used[nx] then
                if nx == z2 then return true end
                seen[nx] = true
                q[#q + 1] = nx
              end
            end
          end
          return false
        end
        local function mutatePath(i2, pts)
          local tgt = b.Paths[i2]
          if type(tgt) ~= "table" then
            tgt = {}
            b.Paths[i2] = tgt
          end
          for j = #tgt, 1, -1 do
            tgt[j] = nil
          end
          for j, v in ipairs(pts) do
            tgt[j] = v
          end
        end
        local success = false
        local nodes = 0
        local function commit(i2, snap)
          mutatePath(i2, snap)
          for j, cc in ipairs(snap) do
            b.Position[cc] = j
            if type(b.Owner) == "table" then b.Owner[cc] = i2 end
          end
        end
        local function uncommit(i2, snap)
          mutatePath(i2, {})
          for _, cc in ipairs(snap) do
            b.Position[cc] = nil
            if type(b.Owner) == "table" then b.Owner[cc] = nil end
          end
          for _, cc in ipairs(snap) do used[cc] = nil end
        end
        local function bt(k)
          if success then return end
          if k > #prs then success = true return end
          local i2 = prs[k]
          local pr = b.Pairs[i2]
          local a2, z2 = pr[1], pr[2]
          local bpath
          do
            local prev = { [a2] = 0 }
            local q = { a2 }
            local head = 1
            while head <= #q and not prev[z2] do
              local cur = q[head]
              head += 1
              for _, nx in ipairs(neighbors(cur)) do
                if not prev[nx] and not used[nx] and (nx == z2 or not endpointBlocked(nx, i2)) then
                  prev[nx] = cur
                  q[#q + 1] = nx
                end
              end
            end
            if prev[z2] then
              local rev = {}
              local cur = z2
              while cur ~= 0 do
                rev[#rev + 1] = cur
                cur = prev[cur]
              end
              bpath = {}
              for j = #rev, 1, -1 do bpath[j] = rev[#rev - j + 1] end
            end
          end
          if bpath then
            for _, cc in ipairs(bpath) do used[cc] = true end
            commit(i2, bpath)
            local okc = true
            for k2 = k + 1, #prs do
              local p2 = b.Pairs[prs[k2]]
              if not reachable(p2[1], p2[2]) then
                okc = false
                break
              end
            end
            if okc then bt(k + 1) end
            if not success then
              uncommit(i2, bpath)
            end
          end
          if success then return end
          local rz, cz = rc(z2)
          local onp = { [a2] = true }
          local cells = { a2 }
          local function cmpNbr(p, q)
            local rp, cp = rc(p)
            local rq, cq = rc(q)
            return (math.abs(rp - rz) + math.abs(cp - cz)) < (math.abs(rq - rz) + math.abs(cq - cz))
          end
          local function dfs(c)
            nodes += 1
            if nodes > 15000 or success or inp.Ended or not mod.flow.on then return end
            if nodes % 350 == 0 then
              task.wait()
              if inp.Ended or not mod.flow.on then return end
            end
            if c == z2 then
              local snap = {}
              for j, vv in ipairs(cells) do snap[j] = vv end
              for _, cc in ipairs(snap) do used[cc] = true end
              commit(i2, snap)
              local okc = true
              for k2 = k + 1, #prs do
                local p2 = b.Pairs[prs[k2]]
                if not reachable(p2[1], p2[2]) then
                  okc = false
                  break
                end
              end
              if okc then bt(k + 1) end
              if not success then
                uncommit(i2, snap)
              end
              return
            end
            local nbrs = neighbors(c)
            table.sort(nbrs, cmpNbr)
            for _, nx in ipairs(nbrs) do
              if not onp[nx] and not used[nx] and (nx == z2 or not endpointBlocked(nx, i2)) then
                onp[nx] = true
                cells[#cells + 1] = nx
                dfs(nx)
                cells[#cells] = nil
                onp[nx] = nil
                if nodes > 15000 or success or inp.Ended or not mod.flow.on then return end
              end
            end
          end
          dfs(a2)
          return success
        end
        local t0 = os.clock()
        bt(1)
        if not success then
          warn("[NERG-A743] flow: fail — solve by hand")
          return
        end
        if type(b.__rebuild) == "function" then pcall(function() return b:__rebuild() end) end
        local rd = ses.__renderer
        if type(rd) == "table" and type(rd.Render) == "function" then
          pcall(function() return rd:Render() end)
        end
        local prB = b.Pairs[bestI]
        local r1, c1 = rc(prB[1])
        local r2, c2 = rc(prB[2])
        print(string.format("[NERG-A743] flow %d/%d (%.2fs) — YOU pull pair-%d: (%d,%d)-(%d,%d)", #prs, maxI, os.clock() - t0, bestI, r1, c1, r2, c2))
      end) end
    end
    do -- LOCK: bấm theo frame (kim cộng tâm Target mới OnPress — 35/35 E2E)
      local cls = classValues(moduleOf("LockClientMinigame"))
      if cls then hookStart(cls, function(ses)
        if not mod.lock.on then return end
        local inp, rd
        for _ = 1, 14 do
          inp = ses.__input
          rd = ses.__renderer
          if inp and rd and not inp.Ended then break end
          task.wait(0.5)
        end
        if not (inp and rd and not inp.Ended) then return end
        task.wait(0.6)
        if inp.Ended or not mod.lock.on then return end
        local b = rd.Board
        local circle = rd.Circle
        if type(b) ~= "table" or typeof(circle) ~= "Instance" then return end
        local line = circle:FindFirstChild("Line")
        if not line then return end
        local cb = inp.Callbacks
        if type(cb) ~= "table" or type(cb.OnPress) ~= "function" then return end
        local guard = 0
        while mod.lock.on and not inp.Ended and guard < 30 do
          guard += 1
          local st = b.State
          local remaining = tonumber(st.Remaining) or 0
          if remaining <= 0 or rd.__broken then break end
          local target = tonumber(st.Target)
          if not target then
            task.wait(0.2)
            continue
          end
          local cfg = b.Config
          local half = (tonumber(cfg.TargetSize) or 45) / 2
          local t0 = os.clock()
          local prevOff, prevRot = nil, nil
          local fired, offAtFire = false, nil
          while os.clock() - t0 < 12 and mod.lock.on and not inp.Ended do
            local rot = line.Rotation
            local off = (rot - target + 180) % 360 - 180
            local hit = false
            if not prevOff then
              hit = (math.abs(off) <= half)
            else
              local dd = (rot - prevRot + 180) % 360 - 180
              if dd > 0 then
                hit = (prevOff < 0 and off >= 0)
              elseif dd < 0 then
                hit = (prevOff > 0 and off <= 0)
              end
              if not hit and math.abs(off) <= 1 then hit = true end
            end
            if hit then
              offAtFire = off
              pcall(function() return cb.OnPress() end)
              fired = true
              break
            end
            prevOff, prevRot = off, rot
            RunA.Heartbeat:Wait()
          end
          if not fired then
            warn("[NERG-A743] lock: lost ring (12s)")
            break
          end
          logL[#logL + 1] = { sp = tonumber(cfg.Speed), sz = tonumber(cfg.TargetSize), off = offAtFire }
          if #logL > 200 then table.remove(logL, 1) end
          task.wait(0.25)
        end
        if inp.Ended or rd.__broken then
          print("[NERG-A743] lock broken ✓")
        end
      end) end
    end
    do -- CONNECT: nối đúng Mates qua __begin/__release (input thật) — nhịp paced()
      local cls = classValues(moduleOf("ConnectClientMinigame"))
      if cls then hookStart(cls, function(ses)
        if not mod.conn.on then return end
        local inp, rd
        for _ = 1, 16 do
          inp = ses.__input
          rd = ses.__renderer
          if inp and rd and not inp.Ended and type(inp.Board) == "table"
            and type(inp.Board.Mates) == "table" and next(inp.Board.Mates) ~= nil
            and type(rd.Blobs) == "table" then
            break
          end
          task.wait(0.5)
        end
        if not (inp and rd and not inp.Ended) then return end
        task.wait(0.5)
        if inp.Ended or not mod.conn.on then return end
        local board = inp.Board
        local function ctr(i)
          local f = rd.Blobs[i]
          if typeof(f) ~= "Instance" then return nil end
          local go = f :: any
          return Vector2.new(go.AbsolutePosition.X + go.AbsoluteSize.X / 2, go.AbsolutePosition.Y + go.AbsoluteSize.Y / 2)
        end
        local guard = 0
        while mod.conn.on and not inp.Ended and guard < 12 do
          guard += 1
          local links = board.Links
          local pending = nil
          for i, mate in pairs(board.Mates) do
            i = tonumber(i)
            mate = tonumber(mate)
            if i and mate and links[tonumber(i)] == nil then
              pending = { i, mate }
              break
            end
          end
          if not pending then break end
          local c1, c2 = ctr(pending[1]), ctr(pending[2])
          if c1 and c2 then
            inp:__begin(pending[1], c1)
            inp:__release(c2)
            hlogC[#hlogC + 1] = { a = pending[1], b = pending[2] }
            if #hlogC > 60 then table.remove(hlogC, 1) end
          end
          task.wait(paced())
        end
        task.wait(0.4)
        if board:IsSolved() or inp.Ended then
          print("[NERG-A743] connect solved ✓ (game finishes it)")
        end
      end) end
    end
    do -- GEAR tracker: chỉ đánh dấu activeSessions (ESP hạ 3s) — KHÔNG auto-solve gear
      local cls = classValues(moduleOf("GearClientMinigame"))
      if cls then hookStart(cls, function(ses)
        local i = ses.__input
        local t0 = os.clock()
        while i == nil and os.clock() - t0 < 8 do
          task.wait(0.25)
          i = ses.__input
        end
        while i and i.Ended == false do
          task.wait(0.25)
        end
      end) end
    end
    local espFolder, espConn, hlPool, bbPool, boxPool, slotUsed, tracked = nil, nil, {}, {}, {}, {}, {}
    local gearPool, gearIng, gearAddConn, gearRemConn = {}, nil, nil, nil
    local MAXD, CAP = 200, 8
    local accA743 = 0
    local idleG = 0
    local function espClean()
      for _, e in pairs(tracked) do
        if e.hl then e.hl.Enabled = false e.hl.Adornee = nil end
        if e.bb then e.bb.Enabled = false e.bb.Adornee = nil end
        if e.box then e.box.Visible = false e.box.Adornee = nil end
        if e.slot then slotUsed[e.slot] = nil end
        if e.ghl and e.ghl.Parent then pcall(function() e.ghl.Enabled = true end) end
        e.hl, e.bb, e.box, e.slot, e.ghl = nil, nil, nil, nil, nil
      end
      table.clear(tracked)
      table.clear(slotUsed)
    end
    local function allocSlot()
      for s = 1, CAP do
        if not slotUsed[s] then
          slotUsed[s] = true
          return s
        end
      end
      return nil
    end
    local function espBuild()
      if espFolder and espFolder.Parent then return end
      espFolder = Instance.new("Folder")
      espFolder.Name = "NergPlus_A743_GearESP"
      espFolder.Parent = workspace
      for i = 1, CAP do
        local hl = Instance.new("Highlight")
        hl.Name = "NergPlus_A743_GearHL"
        hl.FillColor = Color3.fromRGB(255, 200, 0)
        hl.OutlineColor = Color3.fromRGB(255, 235, 80)
        hl.FillTransparency = 0.55
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Enabled = false
        hl.Parent = espFolder
        hlPool[i] = hl
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "NergPlus_A743_GearBox"
        box.Color3 = Color3.fromRGB(255, 205, 0)
        box.Transparency = 0.35
        box.AlwaysOnTop = true
        box.ZIndex = 8
        box.Size = Vector3.new(2.2, 2.2, 2.2)
        box.Visible = false
        box.Parent = espFolder
        boxPool[i] = box
        local bb = Instance.new("BillboardGui")
        bb.Name = "NergPlus_A743_GearTag"
        bb.Size = UDim2.fromOffset(140, 22)
        bb.StudsOffsetWorldSpace = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop = true
        bb.Enabled = false
        local tl = Instance.new("TextLabel")
        tl.Name = "TextLabel"
        tl.Size = UDim2.fromScale(1, 1)
        tl.BackgroundTransparency = 1
        tl.Font = Enum.Font.GothamBold
        tl.TextScaled = true
        tl.TextColor3 = Color3.fromRGB(255, 220, 80)
        tl.TextStrokeTransparency = 0.2
        tl.Text = "Gear"
        tl.Parent = bb
        bb.Parent = espFolder
        bbPool[i] = bb
      end
    end
    local gearTick = LPH_NO_VIRTUALIZE(function(dt)
      for ses in pairs(active) do
        local i2 = ses.__input
        if not i2 or i2.Ended ~= false then active[ses] = nil end
      end
      local interval = (mod.gear.on and next(active) ~= nil) and 3 or 1
      accA743 = accA743 + dt
      if accA743 < interval then return end
      accA743 = 0
      if not mod.gear.on then
        espClean()
        idleG += 1
        if idleG >= 10 and espConn then
          espConn:Disconnect()
          espConn = nil
          idleG = 0
          return
        end
        return
      end
      idleG = 0
      espBuild()
      local chr = LPA.Character
      local hrp = chr and chr:FindFirstChild("HumanoidRootPart")
      if not hrp then
        espClean()
        return
      end
      local seen = {}
      local mapInst = workspace:FindFirstChild("Map")
      local ing = mapInst and mapInst:FindFirstChild("Ingame")
      if not ing then
        if gearIng then
          gearIng = nil
          table.clear(gearPool)
          if gearAddConn then pcall(function() gearAddConn:Disconnect() end) gearAddConn = nil end
          if gearRemConn then pcall(function() gearRemConn:Disconnect() end) gearRemConn = nil end
        end
        espClean()
        return
      end
      if ing ~= gearIng then
        gearIng = ing
        table.clear(gearPool)
        espClean()
        if gearAddConn then pcall(function() gearAddConn:Disconnect() end) gearAddConn = nil end
        if gearRemConn then pcall(function() gearRemConn:Disconnect() end) gearRemConn = nil end
        for _, d0 in ipairs(ing:GetDescendants()) do
          if d0:IsA("Model") and d0.Name == "Gear" then gearPool[d0] = true end
        end
        gearAddConn = ing.DescendantAdded:Connect(function(d0)
          if d0:IsA("Model") and d0.Name == "Gear" then gearPool[d0] = true end
        end)
        gearRemConn = ing.DescendantRemoving:Connect(function(d0)
          gearPool[d0] = nil
        end)
      end
      for d in pairs(gearPool) do
        if not (d.Parent and d:IsDescendantOf(ing)) then
          gearPool[d] = nil
        elseif d:IsA("Model") and d.Name == "Gear" then
          local realG = (d:GetAttribute("__NP_REAL_GEAR") == true)
          local ghl = d:FindFirstChild("GearHighlight")
          if ghl then
            realG = true
          elseif not realG then
            local prompt = d:FindFirstChildWhichIsA("ProximityPrompt", true)
            if prompt then
              local act = tostring(prompt.ActionText):lower()
              local obj = tostring(prompt.ObjectText):lower()
              if act:find("pick") or act:find("take") or act:find("grab") or act:find("collect")
                 or act:find("gear") or obj:find("gear") then
                realG = true
              end
            end
          end
          if realG then
            if d:GetAttribute("__NP_REAL_GEAR") ~= true then
              pcall(function() d:SetAttribute("__NP_REAL_GEAR", true) end)
            end
            local bp = (ghl and ghl.Parent and ghl.Parent:IsA("BasePart") and ghl.Parent)
              or d.PrimaryPart
              or d:FindFirstChildWhichIsA("BasePart", true)
            if bp and bp.Size.Magnitude <= 25 then
              local ok, pv = pcall(function() return bp.Position end)
              if ok and pv then
                local kc = (hrp.Position - pv).Magnitude
                if kc <= (tracked[d] and MAXD or 185) then
                  local entry = tracked[d]
                  if not entry then
                    local s = allocSlot()
                    if s then
                      entry = { slot = s, hl = hlPool[s], bb = bbPool[s], box = boxPool[s], dist = kc, ghl = ghl }
                      tracked[d] = entry
                    end
                  else
                    entry.dist = kc
                    entry.ghl = ghl or entry.ghl
                  end
                  if entry then
                    seen[d] = true
                    if entry.hl then
                      entry.hl.Enabled = false
                      entry.hl.Adornee = nil
                    end
                    entry.box.Adornee = bp
                    entry.box.Size = bp.Size + Vector3.new(0.3, 0.3, 0.3)
                    entry.box.Visible = true
                    entry.bb.Adornee = bp
                    entry.bb.Enabled = true
                    entry.bb.TextLabel.Text = string.format("Gear [%dm]", math.floor(kc + 0.5))
                  end
                end
              end
            end
          end
        end
      end
      for d, entry in pairs(tracked) do
        if seen[d] and d.Parent and d:IsDescendantOf(ing) then
          entry.miss = 0
        else
          entry.miss = (entry.miss or 0) + 1
          if not (d.Parent and d:IsDescendantOf(workspace)) or entry.miss >= 2 then
            if entry.hl then entry.hl.Enabled = false entry.hl.Adornee = nil end
            if entry.bb then entry.bb.Enabled = false entry.bb.Adornee = nil end
            if entry.box then entry.box.Visible = false entry.box.Adornee = nil end
            if entry.slot then slotUsed[entry.slot] = nil end
            tracked[d] = nil
          end
        end
      end
    end)
    function mod.gearStart()
      if mod.gear.on then return end
      mod.gear.on = true
      espBuild()
      if not espConn then
        espConn = RunA.Heartbeat:Connect(gearTick)
      end
    end
    function mod.gearStop()
      mod.gear.on = false
      if espConn then pcall(function() espConn:Disconnect() end) espConn = nil end
      if gearAddConn then pcall(function() gearAddConn:Disconnect() end) gearAddConn = nil end
      if gearRemConn then pcall(function() gearRemConn:Disconnect() end) gearRemConn = nil end
      gearIng = nil
      table.clear(gearPool)
      espClean()
      if espFolder then pcall(function() espFolder:Destroy() end) espFolder = nil table.clear(hlPool) table.clear(bbPool) table.clear(boxPool) end
    end
    return mod
  end)
  if okA743 and type(modA743) == "table" then genA743 = modA743 end
end
-- [r39] Auto Generator & Close UI sections retired; Minigame Helpers preserved



pcall(function()
  local mSec = genAutoTab:Section({ Title = "Minigame Helpers", Icon = "puzzle" })
  CFG_UI["GenFlow"] = mSec:Toggle({
    Title = "Flow Solver (you finish last pair)",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
      if uiBoot then return end
      if genA743 then genA743.flow.on = v and true or false end
    end,
  })
  CFG_UI["GenLock"] = mSec:Toggle({
    Title = "Lock Solver (frame-exact)",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
      if uiBoot then return end
      if genA743 then genA743.lock.on = v and true or false end
    end,
  })
  CFG_UI["GenConnect"] = mSec:Toggle({
    Title = "Connect Solver (auto pairs)",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
      if uiBoot then return end
      if genA743 then genA743.conn.on = v and true or false end
    end,
  })
  CFG_UI["GenGear"] = mSec:Toggle({
    Title = "Gear ESP (200 studs)",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
      if uiBoot then return end
      if genA743 then
        if v then genA743.gearStart() else genA743.gearStop() end
      end
    end,
  })
  CFG_UI["GenPace"] = mSec:Slider({
    Title = "Solver pace (seconds)",
    Step = 0.01,
    Value = { Min = 0.05, Max = 0.6, Default = 0.15 },
    Callback = function(v)
      if genA743 then genA743.pace = tonumber(v) or 0.15 end
    end,
  })
  CFG_UI["GenJit"] = mSec:Slider({
    Title = "Pace jitter",
    Step = 0.05,
    Value = { Min = 0, Max = 0.5, Default = 0.2 },
    Callback = function(v)
      if genA743 then genA743.jit = tonumber(v) or 0.2 end
    end,
  })
end)

CFG_UI["AutoBlock"] = coreBlockSection:Toggle({
  Title = "Auto Block",
  Type = "Checkbox",
  Default = autoBlock,
  Callback = function(value20)
    if uiBoot then return end
    autoBlock = value20
    if a742jPaint then pcall(a742jPaint) end
    v2.set("guestAutoBlockAudioOn", value20)
    if not autoBlock then
      default = false
      v2.set("guestShowVisionRange", false)
      if setVisLoop then setVisLoop(false) elseif f18 then pcall(f18) end
    else
      local shouldCone = (not a742pHitboxMode)
      default = shouldCone
      v2.set("guestShowVisionRange", shouldCone)
      if setVisLoop then setVisLoop(shouldCone) elseif not shouldCone and f18 then pcall(f18) end
    end
  end,
})

CFG_UI["ABKey"] = coreBlockSection:Keybind({
  Title = "Toggle Auto Block Keybind",
  CanChange = true,
  Callback = function()
    if uiBoot then return end
    autoBlock = not autoBlock
    if a742jPaint then pcall(a742jPaint) end
    v2.set("guestAutoBlockAudioOn", autoBlock)
    if not autoBlock then
      default = false
      v2.set("guestShowVisionRange", false)
      if setVisLoop then setVisLoop(false) elseif f18 then pcall(f18) end
    else
      local shouldCone = (not a742pHitboxMode)
      default = shouldCone
      v2.set("guestShowVisionRange", shouldCone)
      if setVisLoop then setVisLoop(shouldCone) elseif not shouldCone and f18 then pcall(f18) end
    end
    pcall(function()
      local tg = CFG_UI["AutoBlock"]
      if tg and tg.Set then tg:Set(autoBlock) end
    end)
  end,
})

CFG_UI["ABM1Detect"] = coreBlockSection:Dropdown({
  Title = "M1 Detection",
  Values = { "Sound", "Animation" },
  Value = a742oAnimM1 and "Animation" or "Sound",
  Callback = function(v)
    if uiBoot then return end
    local isAnim = (v == "Animation")
    a742oAnimM1 = isAnim
    v2.set("a742oAnimM1", isAnim)
  end,
})

CFG_UI["ABBlockMode"] = coreBlockSection:Dropdown({
  Title = "Block Detection",
  Values = { "Cone", "Hitbox" },
  Value = a742pHitboxMode and "Hitbox" or "Cone",
  Callback = function(v)
    if uiBoot then return end
    local isHitbox = (v == "Hitbox")
    a742pHitboxMode = isHitbox
    v2.set("a742pHitboxMode", isHitbox)
    if not isHitbox and a742pClearBoxes then pcall(a742pClearBoxes) end
    if autoBlock then
      default = not isHitbox
      v2.set("guestShowVisionRange", not isHitbox)
      if setVisLoop then setVisLoop(not isHitbox) elseif isHitbox and f18 then pcall(f18) end
    else
      default = false
      v2.set("guestShowVisionRange", false)
      if setVisLoop then setVisLoop(false) elseif f18 then pcall(f18) end
    end
  end,
})
CFG_UI["ABHbLen"] = coreBlockSection:Slider({
  Title = "Hitbox Length Scale",
  Step = 0.05,
  Value = { Min = 0.5, Max = 3, Default = a742pLenScale },
  Callback = function(value21l)
    if uiBoot then return end
    a742pLenScale = value21l
    v2.set("a742pLenScale", value21l)
  end,
})
CFG_UI["ABHbWid"] = coreBlockSection:Slider({
  Title = "Hitbox Width Scale",
  Step = 0.05,
  Value = { Min = 0.5, Max = 3, Default = a742pWidScale },
  Callback = function(value21w)
    if uiBoot then return end
    a742pWidScale = value21w
    v2.set("a742pWidScale", value21w)
  end,
})

CFG_UI["BlockDelay"] = coreBlockSection:Slider({
  Title = "Block Delay",
  Step = 0.05,
  Value = { Min = 0, Max = 2, Default = blockDelay },
  Callback = function(value21)
    if uiBoot then return end
    blockDelay = value21
    v2.set("guestBlockDelay", value21)
  end,
})

CFG_UI["Telemetry"] = coreBlockSection:Toggle({
  Title = "Telemetry (verbose logs)",
  Type = "Checkbox",
  Value = false,
  Callback = function(valueTE)
    if uiBoot then return end
    v2.set("a720Telemetry", valueTE)
  end,
})

-- [r39] Cleaned up legacy diagnostic paragraph

CFG_UI["Facing"] = coreBlockSection:Toggle({
  Title = "Verify Facing Check",
  Type = "Checkbox",
  Default = v8,
  Callback = function(value23)
    if uiBoot then return end
    v8 = value23
    v2.set("guestVerifyFacingCheckOn", value23)
  end,
})

CFG_UI["VisRange"] = coreBlockSection:Slider({
  Title = "Vision Range (block reach)",
  Step = 0.5,
  Value = { Min = 1, Max = 20, Default = visionRange },
  Callback = function(value24)
    if uiBoot then return end
    visionRange = value24
    v2.set("guestVisionRange", value24)
  end,
})

CFG_UI["VisAngle"] = coreBlockSection:Slider({
  Title = "Vision Angle",
  Step = 1,
  Value = { Min = 1, Max = 200, Default = visionAngle },
  Callback = function(value25)
    if uiBoot then return end
    visionAngle = value25
    v2.set("guestVisionAngle", value25)
  end,
})

-- [r39] Standalone VisionCone toggle retired; linked directly to AutoBlock state & BlockMode

local v126


CFG_UI["BlockCD"] = coreBlockSection:Slider({
  Title = "Block Cooldown (s)",
  Step = 0.05,
  Value = { Min = 0.05, Max = 2, Default = v11 },
  Callback = function(value29)
    if uiBoot then return end
    v11 = value29
    v2.set("guestBlockCooldown", value29)
  end,
})

hdtKeoSection = hdtTab:Section({ Title = "Body Pull", Opened = true })
CFG_UI["NoHDTCD"] = hdtKeoSection:Toggle({
  Title = "No HDT Cooldown",
  Type = "Checkbox",
  Default = v17,
  Callback = function(value27)
    if uiBoot then return end
    v17 = value27
    v2.set("noHDTCooldown", value27)
  end,
})

CFG_UI["CDChecker"] = hdtKeoSection:Toggle({
  Title = "Block Cooldown Checker",
  Type = "Checkbox",
  Default = default5,
  Callback = function(value28)
    if uiBoot then return end
    default5 = value28
    v2.set("hdtCooldownChecker", value28)

    if not value28 and v126 then
      v126:Destroy()
      v126 = nil
    end
  end,
})

pcall(function() CFG_UI["HDTKeo"] = hdtKeoSection:Toggle({
  Title = "HDT (pull toward killer)",
  Type = "Checkbox",
  Default = hdtKeo,
Callback = function(v) if uiBoot then return end hdtKeo = v v2.set("guestHDTKeoThan", v) end,
}) end)
pcall(function() CFG_UI["HDTSpd"] = hdtKeoSection:Slider({
  Title = "HDT Speed",
  Step = 1,
  Value = { Min = 5, Max = 20, Default = hdtSpeed },
Callback = function(v) if uiBoot then return end hdtSpeed = v v2.set("guestHDTSpeed", v) end,
}) end)

do
  local aimSec = punchTab:Section({ Title = "Aimbot Punch", Opened = true })
  CFG_UI["AimPunch"] = aimSec:Toggle({
    Title = "Aimbot Punch (steer)",
    Type = "Checkbox",
    Default = aimPunch,
    Callback = function(v)
      if uiBoot then return end
      aimPunch = v
      v2.set("guestAimPunchActive", v)
    end,
  })
  CFG_UI["PunchPred"] = aimSec:Slider({
    Title = "Prediction (frame)",
    Step = 0.1,
    Value = { Min = 0, Max = 6, Default = punchPrediction },
    Callback = function(v)
      if uiBoot then return end
      punchPrediction = v
      v2.set("guestPunchPrediction", v)
    end,
  })
  CFG_UI["AimDur"] = aimSec:Slider({
    Title = "Steer duration (s)",
    Step = 0.05,
    Value = { Min = 0.1, Max = 1.5, Default = v10 },
    Callback = function(v)
      if uiBoot then return end
      v10 = v
      v2.set("guestAimPunchDuration", v)
    end,
  })
  local autoSec = punchTab:Section({ Title = "Auto Punch", Opened = true })
  CFG_UI["AutoPunch"] = autoSec:Toggle({
    Title = "Auto Punch",
    Type = "Checkbox",
    Default = autoPunch,
    Callback = function(v)
      if uiBoot then return end
      autoPunch = v
      v2.set("guestAutoPunchOn", v)
    end,
  })
  CFG_UI["AutoDelay"] = autoSec:Slider({
    Title = "Delay (s)",
    Step = 0.05,
    Value = { Min = 0, Max = 2, Default = v12 },
    Callback = function(v)
      if uiBoot then return end
      v12 = v
      v2.set("guestAutoPunchDelay", v)
    end,
  })
end

do
  local chargeSec = punchTab:Section({ Title = "Auto Charge & Aim", Opened = true })
  CFG_UI["AutoCharge"] = chargeSec:Toggle({
    Title = "Auto Charge (fallback when Block on CD)",
    Type = "Checkbox",
    Default = autoCharge,
    Callback = function(v)
      if uiBoot then return end
      autoCharge = v and true or false
      v2.set("guestAutoChargeOn", autoCharge)
    end,
  })
  CFG_UI["ChargeAim"] = chargeSec:Toggle({
    Title = "Charge Aim (HRP track & auto-detach)",
    Type = "Checkbox",
    Default = chargeAim,
    Callback = function(v)
      if uiBoot then return end
      chargeAim = v and true or false
      v2.set("chargeAimOn", chargeAim)
      v2.set("guestChargeAimOn", chargeAim)
      if not chargeAim and _G.NERG_CHARGE and _G.NERG_CHARGE.stopAim then
        pcall(_G.NERG_CHARGE.stopAim, "toggle-off")
      end
    end,
  })
  CFG_UI["ChargeMaxRange"] = chargeSec:Slider({
    Title = "Charge Max Range",
    Step = 1,
    Value = { Min = 10, Max = 35, Default = chargeMaxRange },
    Callback = function(v)
      if uiBoot then return end
      chargeMaxRange = v
      v2.set("chargeMaxRangeVal", v)
    end,
  })
end

cfgTab = SSystem:Tab({ Title = "Config", Icon = "settings" })
pcall(function()
  local HttpService = game:GetService("HttpService")
  local function cfgNotify(msg)
    pcall(function()
      windUI:Notify({ Title = "PLUS-MASTER", Content = tostring(msg), Duration = 3, Icon = "waves" })
    end)
  end
  local CFG_REG = {
    { "Auto Block", "guestAutoBlockAudioOn", function() return autoBlock end, function(v) autoBlock = v if a742jPaint then pcall(a742jPaint) end end, true, "AutoBlock" },
    { "M1 Detection", "blockM1Detect", function() return a742oAnimM1 and "Animation" or "Sound" end, function(v) a742oAnimM1 = (v == "Animation") end, "Sound", "ABM1Detect" },
    { "Block Detection", "blockDetectMode", function() return a742pHitboxMode and "Hitbox" or "Cone" end, function(v) local isHb = (v == "Hitbox") a742pHitboxMode = isHb default = autoBlock and (not isHb) or false if setVisLoop then setVisLoop(default) end if not isHb and a742pClearBoxes then pcall(a742pClearBoxes) end end, "Cone", "ABBlockMode" },
    { "Hitbox Length Scale", "a742pLenScale", function() return a742pLenScale end, function(v) a742pLenScale = v end, 1, "ABHbLen" },
    { "Hitbox Width Scale", "a742pWidScale", function() return a742pWidScale end, function(v) a742pWidScale = v end, 1, "ABHbWid" },
    { "Auto Punch", "guestAutoPunchOn", function() return autoPunch end, function(v) autoPunch = v end, true, "AutoPunch" },
    { "Auto Punch Delay (s)", "guestAutoPunchDelay", function() return v12 end, function(v) v12 = v end, 0.3, "AutoDelay" },
    { "Verify Facing", "guestVerifyFacingCheckOn", function() return v8 end, function(v) v8 = v end, true, "Facing" },
    { "Vision Cone", "guestShowVisionRange", function() return default end, function(v) default = v; if setVisLoop then setVisLoop(v) end end, false, "VisionCone" },
    { "Vision Range", "guestVisionRange", function() return visionRange end, function(v) visionRange = v end, 13.5, "VisRange" },
    { "Vision Angle", "guestVisionAngle", function() return visionAngle end, function(v) visionAngle = v end, 85, "VisAngle" },
    { "Block Delay", "guestBlockDelay", function() return blockDelay end, function(v) blockDelay = v end, 0, "BlockDelay" },
    { "Punch Aim (steer)", "guestAimPunchActive", function() return aimPunch end, function(v) aimPunch = v end, true, "AimPunch" },
    { "Steer Duration (s)", "guestAimPunchDuration", function() return v10 end, function(v) v10 = v end, 0.5, "AimDur" },
    { "Punch Prediction", "guestPunchPrediction", function() return punchPrediction end, function(v) punchPrediction = v end, 2.3, "PunchPred" },
    { "HDT Body Pull", "guestHDTKeoThan", function() return hdtKeo end, function(v) hdtKeo = v end, true, "HDTKeo" },
    { "HDT Speed", "guestHDTSpeed", function() return hdtSpeed end, function(v) hdtSpeed = v end, 12, "HDTSpd" },
    { "No HDT Cooldown", "noHDTCooldown", function() return v17 end, function(v) v17 = v end, false, "NoHDTCD" },
    { "Block Cooldown (s)", "guestBlockCooldown", function() return v11 end, function(v) v11 = v end, 0.35, "BlockCD" },
    { "Cooldown Checker", "hdtCooldownChecker", function() return default5 end, function(v) default5 = v end, false, "CDChecker" },
    { "Auto Charge", "guestAutoChargeOn", function() return autoCharge end, function(v) autoCharge = (v == true) end, false, "AutoCharge" },
    { "Charge Aim", "chargeAimOn", function() return chargeAim end, function(v) chargeAim = (v ~= false) if not chargeAim and _G.NERG_CHARGE and _G.NERG_CHARGE.stopAim then pcall(_G.NERG_CHARGE.stopAim, "cfg") end end, true, "ChargeAim" },
    { "Charge Max Range", "chargeMaxRangeVal", function() return chargeMaxRange end, function(v) local n = tonumber(v) if n then chargeMaxRange = math.clamp(n, 10, 35) end end, 20, "ChargeMaxRange" },
    { "Ability ESP", "a720VisAbility", function() return _G.NERG_ABILITY_ESP ~= false end, function(v) rawset(_G, "NERG_ABILITY_ESP", v and true or false) pcall(function() if ESP_SET and ESP_SET.ability then ESP_SET.ability(v) end end) end, false, "VisAbility" },
    { "Killer esp (highlight)", "a720VisKiller", function() return ESP_SET.get("KillerEsp") end, function(v) pcall(function() ESP_SET.killer(v) end) end, false, "VisKillerEsp" },
    { "Survivors esp (highlight)", "a720VisSurv", function() return ESP_SET.get("SurvEsp") end, function(v) pcall(function() ESP_SET.surv(v) end) end, false, "VisSurvEsp" },
    { "Player Tags (overhead text)", "a720VisTags", function() return ESP_SET.get("TagsEsp") end, function(v) pcall(function() ESP_SET.tags(v) end) end, false, "VisTagsEsp" },
    { "Player Tags", "espPlayerTags", function()
      local t = {}
      local cur = (ESP_SET and ESP_SET.getOptions and ESP_SET.getOptions()) or (ESP_SET and ESP_SET.get and ESP_SET.get("Options")) or {}
      for _, k in ipairs({ "Name", "Role", "Health", "Distance", "Stamina", "Velocity", "Device", "Abilities" }) do
        if cur[k] then table.insert(t, k) end
      end
      return t
    end, function(v) pcall(function() ESP_SET.options(v) end) end, { "Name", "Role", "Health", "Distance", "Stamina", "Velocity", "Abilities" }, "TagOptions" },
    { "ESP Text Size", "a720TextSize", function() return ESP_SET.get("EspTextSize") end, function(v) pcall(function() ESP_SET.size(v) end) end, 14, "VisTextSize" },
    { "Killer color", "a720KillerColor", function() local c = ESP_SET.get("KillerColor") return c and (math.floor(c.R * 255 + 0.5) .. "," .. math.floor(c.G * 255 + 0.5) .. "," .. math.floor(c.B * 255 + 0.5)) or "255,80,80" end, function(v) local r, g2, b = tostring(v):match("^(%d+),(%d+),(%d+)$") if r then pcall(function() ESP_SET.color_killer(Color3.fromRGB(tonumber(r), tonumber(g2), tonumber(b))) end) end end, "255,80,80", "VisKillerColor" },
    { "Survivor color", "a720SurvColor", function() local c = ESP_SET.get("SurvColor") return c and (math.floor(c.R * 255 + 0.5) .. "," .. math.floor(c.G * 255 + 0.5) .. "," .. math.floor(c.B * 255 + 0.5)) or "90,255,130" end, function(v) local r, g2, b = tostring(v):match("^(%d+),(%d+),(%d+)$") if r then pcall(function() ESP_SET.color_surv(Color3.fromRGB(tonumber(r), tonumber(g2), tonumber(b))) end) end end, "90,255,130", "VisSurvColor" },
    { "Telemetry", "a720Telemetry", function() return v2.get("a720Telemetry", false) end, function(v) v2.set("a720Telemetry", v) end, false, "Telemetry" },
    { "Stamina Control", "a730sCtl", function() return stamCore.run end, function(v) if v then stamCore.start() else stamCore.stop() end end, false, "StamCtl" },
    { "Infinite Stamina", "a730sInf", function() return stamCore.val.inf end, function(v) stamCore.val.inf = v and true or false pcall(function() stamCore.poke() end) end, false, "StamInf" },
    { "Stamina Max", "a730sMax", function() return tostring(stamCore.val.max) end, function(v) local n = tonumber(v) if n then stamCore.val.max = n stamCore.poke() end end, "100", "StamMax" },
    { "Stamina Min", "a730sMin", function() return tostring(stamCore.val.min) end, function(v) local n = tonumber(v) if n then stamCore.val.min = n stamCore.poke() end end, "0", "StamMin" },
    { "Stamina Loss", "a730sLoss", function() return tostring(stamCore.val.loss) end, function(v) local n = tonumber(v) if n then stamCore.val.loss = n stamCore.poke() end end, "10", "StamLoss" },
    { "Stamina Gain", "a730sGain", function() return tostring(stamCore.val.gain) end, function(v) local n = tonumber(v) if n then stamCore.val.gain = n stamCore.poke() end end, "20", "StamGain" },
    { "Sprint Speed", "a730sSprint", function() return tostring(stamCore.val.sprint) end, function(v) local n = tonumber(v) if n then stamCore.val.sprint = n stamCore.poke() end end, "26", "StamSprint" },
    { "Legit Stamina View", "a735sView", function() return stamCore.view.conn ~= nil end, function(v) if v then stamCore.viewStart() else stamCore.viewStop() end end, false, "StamView" },
    { "Sprint Management", "a735sMgOn", function() return stamCore.mgmt.on end, function(v) stamCore.mgmt.on = v and true or false if v then stamCore.mgmtStart() else stamCore.mgmtStop() end end, false, "StamMgOn" },
    { "Sprint Threshold %", "a735sMgPct", function() return tostring(stamCore.mgmt.pct) end, function(v) local n2 = tonumber(v) if n2 then stamCore.mgmt.pct = n2 end end, "10", "StamMgPct" },
    { "Generator ESP", "a740gEsp", function() return genCore.esp end, function(v) if v then genCore.espStart() else genCore.espStop() end end, false, "GenEsp" },
    { "Flow Solver", "a743mFlow", function() return genA743 and genA743.flow.on or false end, function(v) if genA743 then genA743.flow.on = v and true or false end end, false, "GenFlow" },
    { "Lock Solver", "a743mLock", function() return genA743 and genA743.lock.on or false end, function(v) if genA743 then genA743.lock.on = v and true or false end end, false, "GenLock" },
    { "Connect Solver", "a743mConn", function() return genA743 and genA743.conn.on or false end, function(v) if genA743 then genA743.conn.on = v and true or false end end, false, "GenConnect" },
    { "Minigame Gear ESP", "a743mGear", function() return genA743 and genA743.gear.on or false end, function(v) if genA743 then if v then genA743.gearStart() else genA743.gearStop() end end end, false, "GenGear" },
    { "Solver Pace", "a743mPace", function() return tostring(genA743 and genA743.pace or 0.15) end, function(v) local nA = tonumber(v) if nA and genA743 then genA743.pace = nA end end, "0.15", "GenPace" },
    { "Solver Jitter", "a743mJit", function() return tostring(genA743 and genA743.jit or 0.2) end, function(v) local nB = tonumber(v) if nB and genA743 then genA743.jit = nB end end, "0.2", "GenJit" },
    { "Objects ESP", "a746ObjMaster", function() return _G.NERG_OBJ and _G.NERG_OBJ.master or false end, function(v) pcall(function() _G.NERG_OBJ.setMaster(v) end) end, false, "ObjMaster" },
    { "Object & Trap Types", "espObjectTypes", function()
      local t = {}
      local O = _G.NERG_OBJ
      if O and O.perType then
        if O.perType.Graffiti then table.insert(t, "Graffiti") end
        if O.perType.TaphTrap then table.insert(t, "Taph Traps") end
        if O.perType.Ritual then table.insert(t, "Rituals") end
        if O.perType.Builderman then table.insert(t, "Builderman") end
        if O.perType.AzureTrap then table.insert(t, "Azure Traps") end
      end
      return t
    end, function(v)
      local O = _G.NERG_OBJ
      if not O then return end
      local sel = {}
      if type(v) == "table" then
        for k2, v2 in pairs(v) do
          if type(k2) == "number" and type(v2) == "string" then sel[v2] = true
          elseif v2 == true and type(k2) == "string" then sel[k2] = true end
        end
      end
      pcall(function()
        O.setType("Graffiti", sel["Graffiti"] == true)
        O.setType("TaphTrap", sel["Taph Traps"] == true)
        O.setType("Ritual", sel["Rituals"] == true)
        O.setType("Builderman", sel["Builderman"] == true)
        O.setType("AzureTrap", sel["Azure Traps"] == true)
      end)
    end, { "Graffiti", "Taph Traps", "Rituals", "Builderman", "Azure Traps" }, "ObjTypes" },
    { "Obj Azure Radius", "a746ObjAzureR", function() return _G.NERG_OBJ and _G.NERG_OBJ.azureRadius or false end, function(v) pcall(function() _G.NERG_OBJ.setAzure(v) end) end, false, "ObjAzureR" },
    { "Items ESP", "a746ObjItems", function() return _G.NERG_OBJ and _G.NERG_OBJ.itemsOn or false end, function(v) pcall(function() _G.NERG_OBJ.setItems(v) end) end, false, "ObjItems" },
    { "Object Name Tags", "a746ObjTags", function() return _G.NERG_OBJ and _G.NERG_OBJ.tagsOn or false end, function(v) pcall(function() _G.NERG_OBJ.setTags(v) end) end, false, "ObjTags" },
    { "Projectile Marker", "a746ProjMark", function() return _G.NERG_PROJ and _G.NERG_PROJ.on or false end, function(v) pcall(function() _G.NERG_PROJ.set(v) end) end, false, "ProjMark" },
    { "Windup Preview", "a746Windup", function() return _G.NERG_WINDUP and _G.NERG_WINDUP.on or false end, function(v) pcall(function() _G.NERG_WINDUP.set(v) end) end, false, "Windup" },
    { "Anti Backstab", "a747ABOn", function() return _G.NERG_ABS and _G.NERG_ABS.on() or false end, function(v) pcall(function() _G.NERG_ABS.set(v) end) end, false, "AbsOn" },
    { "Anti Backstab Range", "a747ABRange", function() return _G.NERG_ABS and _G.NERG_ABS.range() or 27 end, function(v) pcall(function() _G.NERG_ABS.setRange(v) end) end, 27, "AbsRange" },
    { "Anti Backstab Duration", "a747ABDur", function() return _G.NERG_ABS and _G.NERG_ABS.duration() or 0.8 end, function(v) pcall(function() _G.NERG_ABS.setDuration(v) end) end, 0.8, "AbsDur" },
    { "Auto Dodge", "a750DodgeOn", function() return _G.NERG_DODGE and _G.NERG_DODGE.on() or false end, function(v) pcall(function() _G.NERG_DODGE.set(v) end) end, false, "AutoDodgeOn" },
    { "Auto Dodge Melee Radius", "a750DodgeMelee", function() return _G.NERG_DODGE and _G.NERG_DODGE.melee() or 18 end, function(v) pcall(function() _G.NERG_DODGE.setMelee(v) end) end, 18, "AutoDodgeMelee" },
    { "Auto Dodge Chance Radius", "a750DodgeChance", function() return _G.NERG_DODGE and _G.NERG_DODGE.chance() or 75 end, function(v) pcall(function() _G.NERG_DODGE.setChance(v) end) end, 75, "AutoDodgeChance" },
    { "Auto Dodge Facing Check", "a750DodgeFacing", function() return _G.NERG_DODGE and _G.NERG_DODGE.facing() or false end, function(v) pcall(function() _G.NERG_DODGE.setFacing(v) end) end, false, "AutoDodgeFacing" },
    { "Auto Dodge Notification", "a750DodgeNotif", function() return _G.NERG_DODGE and _G.NERG_DODGE.notif() or false end, function(v) pcall(function() _G.NERG_DODGE.setNotif(v) end) end, true, "AutoDodgeNotif" },
    { "Auto Dodge Cooldown", "a750DodgeCd", function() return _G.NERG_DODGE and _G.NERG_DODGE.cd() or 1.0 end, function(v) pcall(function() _G.NERG_DODGE.setCd(v) end) end, 1.0, "AutoDodgeCd" },
    { "Noli Void Rush Control", "a751NoliRushCtrl", function() return _G.NERG_NOLI and _G.NERG_NOLI.get("rushCtrl") or false end, function(v) pcall(function() _G.NERG_NOLI.setRushCtrl(v) end) end, false, "NoliRushCtrl" },
    { "Noli Turn Strength", "a751NoliTurnStr", function() return _G.NERG_NOLI and _G.NERG_NOLI.get("turnStrength") or 5.0 end, function(v) pcall(function() _G.NERG_NOLI.setTurnStrength(v) end) end, 5.0, "NoliTurnStr" },
    { "Noli Void Rush Aimbot", "a751NoliRushAim", function() return _G.NERG_NOLI and _G.NERG_NOLI.get("rushAim") or false end, function(v) pcall(function() _G.NERG_NOLI.setRushAim(v) end) end, false, "NoliRushAim" },
    { "Noli Custom Speed On", "a751NoliSpdOn", function() return _G.NERG_NOLI and _G.NERG_NOLI.get("speedOn") or false end, function(v) pcall(function() _G.NERG_NOLI.setSpeedOn(v) end) end, false, "NoliSpdOn" },
    { "Noli Dash Speed", "a751NoliDashSpd", function() return _G.NERG_NOLI and _G.NERG_NOLI.get("dashSpeed") or 60 end, function(v) pcall(function() _G.NERG_NOLI.setDashSpeed(v) end) end, 60, "NoliDashSpd" },
    { "Noli Anti-Crash", "a751NoliAntiCrash", function() return _G.NERG_NOLI and _G.NERG_NOLI.get("antiCrash") or false end, function(v) pcall(function() _G.NERG_NOLI.setAntiCrash(v) end) end, false, "NoliAntiCrash" },
    { "Noli Auto Nova", "a751NoliAutoNova", function() return _G.NERG_NOLI and _G.NERG_NOLI.get("autoNova") or false end, function(v) pcall(function() _G.NERG_NOLI.setAutoNova(v) end) end, false, "NoliAutoNova" },
    { "Noli Nova Radius", "a751NoliNovaRad", function() return _G.NERG_NOLI and _G.NERG_NOLI.get("novaRadius") or 12 end, function(v) pcall(function() _G.NERG_NOLI.setNovaRadius(v) end) end, 12, "NoliNovaRad" },
    { "Item Map ESP Master", "itemMapMaster", function() return _G.NERG_ITEM_MAP and _G.NERG_ITEM_MAP.master or false end, function(v) pcall(function() _G.NERG_ITEM_MAP.setMaster(v) end) end, false, "ItemMapMaster" },
    { "Brandon Graffiti & Bottle", "itemMapGraffiti", function() return _G.NERG_ITEM_MAP and _G.NERG_ITEM_MAP.graffiti or false end, function(v) pcall(function() _G.NERG_ITEM_MAP.setGraffiti(v) end) end, false, "ItemMapGraffiti" },
    { "Hotel Fruits & The Maw", "itemMapFruits", function() return _G.NERG_ITEM_MAP and _G.NERG_ITEM_MAP.fruits or false end, function(v) pcall(function() _G.NERG_ITEM_MAP.setFruits(v) end) end, false, "ItemMapFruits" },
    { "Item Map Distance Tags", "itemMapDist", function() return _G.NERG_ITEM_MAP and _G.NERG_ITEM_MAP.showDist or false end, function(v) pcall(function() _G.NERG_ITEM_MAP.setShowDist(v) end) end, false, "ItemMapDist" },
  }
  local function uiRepaint()
    for _, e in ipairs(CFG_REG) do
      local obj = e[6] and CFG_UI[e[6]]
      if obj then
        pcall(function()
          local val = e[3]()
          if obj.Select then
            obj:Select(val)
          elseif obj.Set then
            obj:Set(val)
          end
        end)
      end
    end
  end
  task.delay(0.5, function()
    uiBoot = false
    pcall(uiRepaint)
  end)
  pcall(function() cfgTab:Paragraph({ Title = "Config — Share Code (VP1)",
    Desc = "Generate code to clipboard or paste code to load." }) end)
  pcall(function() cfgTab:Button({ Title = "Generate config (copy code)", Justify = "Center", Callback = function()
    local tt = {}
    for _, e in ipairs(CFG_REG) do
      local okV, val = pcall(e[3])
      if okV and val ~= nil then
        tt[e[2]] = val
      elseif e[5] ~= nil then
        tt[e[2]] = e[5]
      end
    end
    local okJ, s = pcall(function() return httpService:JSONEncode(tt) end)
    if not okJ or not s then cfgNotify("generate failed (JSON)") return end
    local b = (base64_encode and base64_encode(s)) or (crypt and crypt.base64_encode and crypt.base64_encode(s)) or (crypt and crypt.base64 and crypt.base64.encode and crypt.base64.encode(s))
    local code = "VP1|" .. (b or s)
    local setcb = setclipboard or toclipboard or set_clipboard
    if setcb then pcall(setcb, code) end
    cfgNotify("copied config code (" .. #CFG_REG .. " keys) — stash it somewhere safe")
  end }) end)
  pcall(function() cfgTab:Button({ Title = "Preset: Pretty Legit", Justify = "Center", Callback = function()
    local preset = {
      guestAutoBlockAudioOn = true,
      blockM1Detect = "Sound",
      blockDetectMode = "Cone",
      a742pLenScale = 1.65,
      a742pWidScale = 1.3,
      guestVerifyFacingCheckOn = true,
      guestVisionRange = 10.5,
      guestVisionAngle = 57,
      guestShowVisionRange = true,
      guestBlockDelay = 0,
      guestBlockCooldown = 0.35,
      guestAutoPunchOn = true,
      guestAutoPunchDelay = 0.3,
      guestAimPunchActive = true,
      guestAimPunchDuration = 0.5,
      guestPunchPrediction = 2.3,
      guestHDTKeoThan = true,
      guestHDTSpeed = 12,
      noHDTCooldown = false,
      hdtCooldownChecker = false,
      guestAutoChargeOn = false,
      chargeAimOn = true,
      chargeMaxRangeVal = 20,
      a720VisAbility = true,
      a720VisKiller = true,
      a720VisSurv = true,
      a720VisTags = true,
      espPlayerTags = { "Stamina", "Abilities" },
      a720TextSize = 18,
      a720KillerColor = "255,80,80",
      a720SurvColor = "90,255,130",
      a720Telemetry = false,
      a730sCtl = true,
      a730sInf = true,
      a730sMax = "100",
      a730sMin = "0",
      a730sLoss = "10",
      a730sGain = "20",
      a730sSprint = "26",
      a735sView = true,
      a735sMgOn = false,
      a735sMgPct = "10",
      a740gEsp = true,
      a743mFlow = true,
      a743mLock = true,
      a743mConn = true,
      a743mGear = true,
      a743mPace = "0.6",
      a743mJit = "0.5",
      a746ObjMaster = true,
      espObjectTypes = { "Graffiti", "Taph Traps", "Rituals", "Builderman", "Azure Traps" },
      a746ObjAzureR = true,
      a746ObjItems = true,
      a746ObjTags = true,
      a746ProjMark = true,
      a746Windup = true,
      a747ABOn = false,
      a747ABRange = 27,
      a747ABDur = 0.8,
    }
    local nn = 0
    for _, e in ipairs(CFG_REG) do
      if preset[e[2]] ~= nil then
        v2.set(e[2], preset[e[2]])
        e[4](preset[e[2]])
        nn += 1
      end
    end
    uiRepaint()
    cfgNotify("loaded Pretty Legit (" .. nn .. " keys) — live & cooking")
  end }) end)
  pcall(function() cfgTab:Button({ Title = "Reset-Default", Justify = "Center", Callback = function()
    for _, e in ipairs(CFG_REG) do v2.set(e[2], e[5]) e[4](e[5]) end
    uiRepaint()
    cfgNotify("reset to defaults — squeaky clean")
  end }) end)
  pcall(function()
    local codeInput = ""
    cfgTab:Input({ Title = "Paste config code", Value = "", Placeholder = "VP1 code... (empty = from clipboard)",
      Callback = function(v) codeInput = tostring(v or "") end })
    cfgTab:Button({ Title = "Load config code", Justify = "Center", Callback = function()
      local src = codeInput
      if (not src or src == "") and getclipboard then pcall(function() src = getclipboard() end) end
      src = tostring(src or ""):gsub("^%s+", ""):gsub("%s+$", "")
      if src:sub(1, 4) ~= "VP1|" then cfgNotify("invalid code (missing VP1| — old code or clipboard junk)") return end
      local body = src:sub(5)
      local jsonS = body
      if not body:find("{", 1, true) then
        local okD, d = pcall(function()
          return (base64_decode and base64_decode(body)) or (crypt and crypt.base64_decode and crypt.base64_decode(body)) or (crypt and crypt.base64 and crypt.base64.decode and crypt.base64.decode(body))
        end)
        if okD and d then jsonS = d end
      end
      local ok, tbl = pcall(function() return httpService:JSONDecode(jsonS) end)
      if not ok or type(tbl) ~= "table" then cfgNotify("couldn't decode that code") return end
      -- Intelligent backward-compatibility bridge for legacy r38 keys:
      if tbl["espPlayerTags"] == nil and (tbl["a720TagName"] ~= nil or tbl["a720TagStamina"] ~= nil or tbl["a720TagAbilities"] ~= nil) then
        local tagsList = {}
        if tbl["a720TagName"] then table.insert(tagsList, "Name") end
        if tbl["a720TagRole"] then table.insert(tagsList, "Role") end
        if tbl["a720TagHealth"] then table.insert(tagsList, "Health") end
        if tbl["a720TagDistance"] then table.insert(tagsList, "Distance") end
        if tbl["a720TagStamina"] then table.insert(tagsList, "Stamina") end
        if tbl["a720TagVelocity"] then table.insert(tagsList, "Velocity") end
        if tbl["a720TagDevice"] then table.insert(tagsList, "Device") end
        if tbl["a720TagAbilities"] then table.insert(tagsList, "Abilities") end
        tbl["espPlayerTags"] = tagsList
      end
      if tbl["espObjectTypes"] == nil and (tbl["a746ObjGraffiti"] ~= nil or tbl["a746ObjAzure"] ~= nil or tbl["a746ObjTaph"] ~= nil) then
        local objsList = {}
        if tbl["a746ObjGraffiti"] then table.insert(objsList, "Graffiti") end
        if tbl["a746ObjTaph"] then table.insert(objsList, "Taph Traps") end
        if tbl["a746ObjRitual"] then table.insert(objsList, "Rituals") end
        if tbl["a746ObjBman"] then table.insert(objsList, "Builderman") end
        if tbl["a746ObjAzure"] then table.insert(objsList, "Azure Traps") end
        tbl["espObjectTypes"] = objsList
      end
      if tbl["a742pHitboxMode"] ~= nil and tbl["blockDetectMode"] == nil then
        tbl["blockDetectMode"] = tbl["a742pHitboxMode"] and "Hitbox" or "Cone"
      end
      if tbl["a742oAnimM1"] ~= nil and tbl["blockM1Detect"] == nil then
        tbl["blockM1Detect"] = tbl["a742oAnimM1"] and "Animation" or "Sound"
      end
      if tbl["guestChargeAimOn"] ~= nil and tbl["chargeAimOn"] == nil then
        tbl["chargeAimOn"] = tbl["guestChargeAimOn"]
      end
      if tbl["chargeMaxRangeVal"] == nil then
        tbl["chargeMaxRangeVal"] = 20
      end

      local nn = 0
      for _, e in ipairs(CFG_REG) do
        if tbl[e[2]] ~= nil then v2.set(e[2], tbl[e[2]]) e[4](tbl[e[2]]) nn += 1 end
      end
      uiRepaint()
      cfgNotify("loaded " .. nn .. " keys — live & cooking")
    end })
  end)end)

a665UiKey = userInputService.InputBegan:Connect(function(input, gp)
  if gp then return end
  if input.KeyCode == Enum.KeyCode.Minus and v1PRBLOCKWindow then
    pcall(function()
      if v1PRBLOCKWindow.Closed then v1PRBLOCKWindow:Open() if v2.get("a720Telemetry", false) then print("[NERG] ui back on screen") end
      else v1PRBLOCKWindow:Close() if v2.get("a720Telemetry", false) then print("[NERG] ui hidden ('-' to bring back)") end end
    end)
  end
end)

function nergUnloadAll(lydo)
  local n = 0
  _G.__NERG_KILLED = true
  __PLUS_GEN_ALIVE = false
  v33 = false

  pcall(function() if _G.NERG_ESP_SHUTDOWN then _G.NERG_ESP_SHUTDOWN() n += 1 end end)
  pcall(function() if _G.NERG_ABS then _G.NERG_ABS.stop() n += 1 end end)
  pcall(function() if _G.NERG_DODGE then _G.NERG_DODGE.stop() n += 1 end end)
  pcall(function() if _G.NERG_NOLI then _G.NERG_NOLI.stop() n += 1 end end)
  pcall(function() if _G.__NERG_CAM_RELEASE then _G.__NERG_CAM_RELEASE() n += 1 end end)
  pcall(function() if _G.NERG_OBJ and _G.NERG_OBJ.shutdown then _G.NERG_OBJ.shutdown() n += 1 end end)
  pcall(function() if _G.NERG_ITEM_MAP and _G.NERG_ITEM_MAP.shutdown then _G.NERG_ITEM_MAP.shutdown() n += 1 end end)
  pcall(function() if _G.NERG_PROJ and _G.NERG_PROJ.shutdown then _G.NERG_PROJ.shutdown() n += 1 end end)
  pcall(function() if _G.NERG_WINDUP and _G.NERG_WINDUP.shutdown then _G.NERG_WINDUP.shutdown() n += 1 end end)
  pcall(function() if _G.NERG_HUD and _G.NERG_HUD.shutdown then _G.NERG_HUD.shutdown() n += 1 end end)
  pcall(function() if _G.NERG_GFX and _G.NERG_GFX.shutdown then _G.NERG_GFX.shutdown() n += 1 end end)
  pcall(function() if type(StopESPSystem) == "function" then StopESPSystem() n += 1 end end)
  pcall(function()
    if stamCore then
      if stamCore.stop then stamCore.stop() end
      if stamCore.viewStop then stamCore.viewStop() end
      if stamCore.mgmtStop then stamCore.mgmtStop() end
      n += 1
    end
  end)
  pcall(function()
    if genCore then
      genCore.espStop()
      n += 1
    end
  end)
  pcall(function()
    if genA743 then
      genA743.flow.on = false
      genA743.lock.on = false
      genA743.conn.on = false
      if genA743.gearStop then genA743.gearStop() end
      if genA743.restoreHooks then genA743.restoreHooks() end
      n += 1
    end
  end)

  pcall(function() if _G.__NERG_HARVEST_STOP then _G.__NERG_HARVEST_STOP() n += 1 end end)
  pcall(function() if _G.__NERG_AUTOPUNCH_STOP then _G.__NERG_AUTOPUNCH_STOP() n += 1 end end)
  pcall(function() if a724MainCharConn then a724MainCharConn:Disconnect() a724MainCharConn = nil n += 1 end end)
  pcall(function() if a742uVisConn then a742uVisConn:Disconnect() a742uVisConn = nil n += 1 end end)
  pcall(function() if a724AimConn then a724AimConn:Disconnect() a724AimConn = nil n += 1 end end)
  pcall(function() if a742pHeart then a742pHeart:Disconnect() a742pHeart = nil n += 1 end end)
  pcall(function() if a742jConn then a742jConn:Disconnect() a742jConn = nil n += 1 end end)
  pcall(function() if a655EarConn then a655EarConn:Disconnect() a655EarConn = nil n += 1 end end)
  pcall(function() if a665UiKey then a665UiKey:Disconnect() a665UiKey = nil end end)
  pcall(function() if connect then connect:Disconnect() connect = nil end end)
  pcall(function() if clearKillerSoundConns then clearKillerSoundConns() n += 1 end end)
  if a655FolderConns then
    for i = #a655FolderConns, 1, -1 do
      local fc = a655FolderConns[i]
      a655FolderConns[i] = nil
      pcall(function() fc:Disconnect() end)
    end
  end
  for k9, c9 in pairs(animEarConns) do pcall(function() c9:Disconnect() end) pcall(function() k9:SetAttribute("__A641_ANIM_EAR", nil) end) end
  table.clear(animEarConns)
  for _, c9s in pairs(a742pSndConns) do pcall(function() c9s:Disconnect() end) end
  for _, c9c in pairs(a742pCharConns) do pcall(function() c9c:Disconnect() end) end
  table.clear(a742pSndConns)
  table.clear(a742pCharConns)
  table.clear(a742pSndTouch)

  table.clear(a724RotLocks)
  a724RotLocked = false
  if walkSpeed3 then
    pcall(function() if humanoid then humanoid.AutoRotate = true end end)
    walkSpeed3, jumpPower, autoRotate2 = nil, nil, nil
  end
  pcall(function() if _G.NERG_CHARGE and _G.NERG_CHARGE.stop then _G.NERG_CHARGE.stop() n += 1 end end)
  chargeAim, chargeCamSteer, autoCharge = false, false, false
  pcall(function()
    local cc = localPlayer.Character
    local hh = cc and cc:FindFirstChildOfClass("Humanoid")
    if hh then
      hh.AutoRotate = true
      pcall(function() hh:Move(Vector3.zero) end)
    end
  end)
  autoBlock, autoPunch, aimPunch, hdtKeo = false, false, false, false
  default = false
  pcall(f18)

  pcall(function() if a742pClearBoxes then a742pClearBoxes() end end)
  pcall(function() if a742pFolder then a742pFolder:Destroy() end end)
  pcall(function() if visFolder then visFolder:Destroy() end end)
  pcall(function() if a742jGui then a742jGui:Destroy() a742jGui = nil end end)

  pcall(function()
    if v1PRBLOCKWindow then
      v1PRBLOCKWindow.Destroyed = true
      if v1PRBLOCKWindow.AcrylicPaint and v1PRBLOCKWindow.AcrylicPaint.Model then
        pcall(function() v1PRBLOCKWindow.AcrylicPaint.Model:Destroy() end)
      end
    end
  end)
  local uirRoots = { (gethui and gethui()), game:GetService("CoreGui"), localPlayer and localPlayer:FindFirstChild("PlayerGui") }
  local nergGuis = {
    ["NergFK_TextTags"] = true, ["NergMobileAB"] = true, ["NergABToggle"] = true,
    ["CinematicText"] = true, ["ForsakenDeviceESP"] = true, ["ForsakenAbilityESP"] = true,
    ["NergAbsGui"] = true, ["NergDodgeGui"] = true, ["NergStaminaView"] = true, ["NergStatusHUD"] = true,
  }
  for _, r in ipairs(uirRoots) do
    if r then
      for _, g in ipairs(r:GetChildren()) do
        pcall(function()
          if (g:IsA("ScreenGui") or g:IsA("Folder")) and (g.Name:find("WindUI") or nergGuis[g.Name]) then
            g:Destroy()
          end
        end)
      end
    end
  end
  pcall(function()
    local oldV = workspaceService:FindFirstChild("PlusVis_DLCHUB")
    if oldV then oldV:Destroy() end
    local oldB = workspaceService:FindFirstChild("NergABBoxes")
    if oldB then oldB:Destroy() end
  end)

  rawset(_G, "__A723_TOKEN", {})
  rawset(_G, "__NERG_BOOT_N", nil)
  rawset(_G, "__NERG_UNLOAD", nil)
  rawset(_G, "__NERG_PLUS_SHUTDOWN", nil)
  print("[NERG] fully unloaded (reason: " .. tostring(lydo or "manual") .. ", items=" .. n .. ")")
  return "NERG_UNLOAD: stopped " .. n .. " subsystems"
end

rawset(_G, "__NERG_UNLOAD", nergUnloadAll)
rawset(_G, "__NERG_PLUS_SHUTDOWN", nergUnloadAll)
rawset(_G, "NERG_KILLALL", nergUnloadAll)

if v2.get("a720Telemetry", false) then print("[NERG] ● NergPlus — Release · lowkey cracked | m1-round ear (M1-ONLY) · vision gate · charge · punch tab | anim-maps=" .. tostring(A641_ANIM_N)) end

print('[A693] LOAD-COMPLETE') print('[A693] LOAD-COMPLETE') print('[A693] LOAD-COMPLETE')
