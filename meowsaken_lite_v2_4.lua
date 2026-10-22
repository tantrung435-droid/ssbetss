-- Trash Script idk ? 
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
  for _, r in ipairs(uirRoots) do
    if r then
      for _, g in ipairs(r:GetChildren()) do
        pcall(function()
          if g:IsA("ScreenGui") and (g.Name:find("WindUI") or g.Name == "NergFK_TextTags" or g.Name == "NergMobileAB") then
            g:Destroy()
          end
        end)
      end
    end
  end
  rawset(_G, "__NERG_BOOT_N", nil)
end

local v1 = {
  hasFolder = isfolder or function() return false end,
  makeFolder = makefolder or function() end,
  write = writefile or function() end,
  hasFile = isfile or function() return false end,
  read = readfile or function() return "" end,
}

local v2 = {}

local function f1()
  if not v1.hasFolder("NergBlock") then
    v1.makeFolder("NergBlock")
  end
end

function v2.load()
end

function v2.save()
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
  return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)()

if not windUI then
  error("WindUI failed to load")
end

pcall(function()
  windUI:AddTheme({
    Name = "DeepBlue",
    Accent = Color3.fromHex("#0e2a3f"),
    Background = Color3.fromHex("#081420"),
    Outline = Color3.fromHex("#38bdf8"),
    Text = Color3.fromHex("#eaf6ff"),
    Placeholder = Color3.fromHex("#5e8db0"),
    Button = Color3.fromHex("#0369a1"),
    Icon = Color3.fromHex("#7dd3fc"),
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
pcall(function() v1PRBLOCKWindow:Tag({ Title = "NergPlus", Icon = "waves", Color = Color3.fromHex("#38bdf8"), Radius = 13 }) end)
pcall(function()
  v1PRBLOCKWindow:EditOpenButton({
    Title = "", Icon = "monitor",
    CornerRadius = UDim.new(0, 16), StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromHex("#7dd3fc"), Color3.fromHex("#0369a1")),
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
local v13 = v2.get("guestBetterDetectionEnabled", false)
local hitboxX = v2.get("guestBetterDetectionX", 3)
local hitboxY = v2.get("guestBetterDetectionY", 2.5)
local v14 = v2.get("guestBetterDetectionZ", 4)
local multiplier = v2.get("guestBetterDetectionMultiplier", 2.4)
local segments = v2.get("guestBetterDetectionSegments", 14)
local startDistance = v2.get("guestBetterStartDist", 2.2)
local stepDistance = v2.get("guestBetterStepDist", 0.05)
local v15 = v2.get("guestBetterPreDelay", 0.15)
local staggerS = v2.get("guestBetterStagger", 0.03)
local predictionForward = v2.get("guestBetterPredForward", 1.1)
local predictionTurn = v2.get("guestBetterPredTurn", 1.2)
local enableReverse = v2.get("guestReverseEnabled", false)
local default2 = v2.get("guestLegacyFacingEnabled", false)
local visionRange2 = v2.get("guestLegacyVisionRange", 13.5)
local visionAngle2 = v2.get("guestLegacyVisionAngle", 85)
local default3 = v2.get("guestLegacyShowVisionRange", false)
local v16 = v2.get("guestCinematicTextEnabled", false)
local textContent = v2.get("guestCinematicText", "PARRY!")
local smartDelay = v2.get("guestSmartDelayEnabled", false)
local manualDrag = v2.get("guestManualDragEnabled", false)
local default4 = v2.get("pingCheckerEnabled", false)
local v17 = v2.get("noHDTCooldown", false)
local default5 = v2.get("hdtCooldownChecker", false)
local noclip = v2.get("noclipEnabled", false)
local v18 = v2.get("noclipOnlyWhenBlockReady", false)
local default6 = v2.get("fpsCounterEnabled", false)
local v19 = v2.get("customPunchSoundId", 0)
local v20 = v2.get("punchMobilityEnabled", false)
local chargeControl = v2.get("chargeControlEnabled", false)
local lungeBoost = v2.get("lungeBoostEnabled", false)
local lungeMultiplier = v2.get("lungeMultiplier", 1)
local v21 = v2.get("chargeSpeedCapEnabled", false)
local v22 = v2.get("chargeSpeedLimit", 12)
local enableHDT = v2.get("guestHitboxDraggingOn", false)
local hdtMode = v2.get("guestHitboxMode", "Blatant")
a742pHitboxMode = v2.get("a742pHitboxMode", false)
local v23 = v2.get("guestHitboxFaceKiller", false)
local v24 = v2.get("guestHitboxVisual", false)
local targetMode = v2.get("guestHitboxTargetMode", "Root")
local dragDuration = v2.get("guestHitboxDragDuration", 1)
local triggerRadius = v2.get("guestHitboxTriggerRadius", 15)
local v25 = false
local v26 = v2.get("hdtPredictTime", 0.12)
local v27 = v2.get("hdtSwitchDist", 8)
local enableLineblock = v2.get("lineBlockEnabled", false)
local lineLength = v2.get("lineBlockLength", 15)
local lineRadius = v2.get("lineBlockRadius", 1.5)
local v28 = v2.get("lineBlockDelay", 0.05)
local v29 = v2.get("lineBlockFacingDuration", 0.1)
local facingSensitivity = v2.get("lineBlockMinDot", 0.5)
local v30 = {}

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

do
  local function doGuestHarvest()
    pcall(function()
      local rs = game:GetService("ReplicatedStorage")
      local assets = rs:FindFirstChild("Assets")
      if not assets then return end

      local function harvest(cfgMod)
        if not (cfgMod and cfgMod:IsA("ModuleScript")) then return end
        local ok, mod = pcall(require, cfgMod)
        if not (ok and type(mod) == "table" and type(mod.Animations) == "table") then return end
        for k, v in pairs(mod.Animations) do
          if type(v) == "string" then
            local num = v:match("%d+")
            if num then
              if k == "Block" then
                HDT_BLOCK_LOOKUP[num] = true
                if HDT_BLOCK_ANIMS and not table.find(HDT_BLOCK_ANIMS, num) then
                  table.insert(HDT_BLOCK_ANIMS, num)
                end
              elseif k:find("Punch") or k:find("Parry") then
                v32[num] = true
              end
            end
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
  task.delay(2, doGuestHarvest)
end

local v33 = false
local v34 = 0

local a724RotLocked = false
local function a724RotLock(hum)
	if a724RotLocked then return end
	a724RotLocked = true
end
local function a724RotUnlock(hum)
	if not a724RotLocked then return end
	a724RotLocked = false
	if hum and hum.Parent then hum.AutoRotate = true end
	pcall(function()
		local cam = workspace.CurrentCamera
		local ch = hum and hum.Parent
		local hrp2 = ch and ch:FindFirstChild("HumanoidRootPart")
		if cam and hrp2 then
			local lv = cam.CFrame.LookVector
			local f = Vector3.new(lv.X, 0, lv.Z)
			if f.Magnitude > 0.01 then hrp2.CFrame = CFrame.new(hrp2.Position, hrp2.Position + f.Unit) end
		end
	end)
end
local v36 = {}
local v37 = 0
local v39 = false
local v40 = false
local v41 = false
local v42 = {}
local v43 = {}
local remoteEvent = replicatedStorage.Modules.Network.Network:FindFirstChild("RemoteEvent")

if not remoteEvent then
  remoteEvent = replicatedStorage.Modules.Network.Network:WaitForChild("RemoteEvent", 10)
end

local function f2()
  local character = localPlayer.Character
  return character and character:FindFirstChild("HumanoidRootPart")
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
	a724RotUnlock(humanoid)
	if walkSpeed3 and humanoid then
		humanoid.WalkSpeed = walkSpeed3
		humanoid.JumpPower = jumpPower
		walkSpeed3 = nil
		jumpPower = nil
	end
end

local hdtKeo = v2.get("guestHDTKeoThan", true)
local hdtSpeed = v2.get("guestHDTSpeed", 12)
local HDT_InProgress = false
local hdtCdPer = {}

local function startHDT(killerModel)
  if HDT_InProgress or not hdtKeo then return end
  local c = localPlayer.Character
  local hrp = c and c:FindFirstChild("HumanoidRootPart")
  local hum = c and c:FindFirstChildOfClass("Humanoid")
  local tr = killerModel and killerModel:FindFirstChild("HumanoidRootPart")
  if not (hrp and hum and tr) or hum.Health <= 0 then return end
  HDT_InProgress = true
  if v2.get("a720Telemetry", false) then print("[NERG] ★ HDT fired (pull " .. tostring(killerModel.Name) .. " · 0.8s)") end
  a724RotLock(hum)
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
      a724RotUnlock(hum)
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
    if not animId then return end

    -- 1. HDT Body Pull on Block (Frame 0, Zero-Delay)
    if hdtKeo and not HDT_InProgress and HDT_BLOCK_LOOKUP[animId] then
      if v2.get("a720Telemetry", false) then
        print("[NERG] block-anim detected: " .. tostring(animId) .. " (HDT trigger)")
      end
      local myRoot = v45 or (character2 and character2:FindFirstChild("HumanoidRootPart"))
      local kf = workspaceService:FindFirstChild("Players") and workspaceService.Players:FindFirstChild("Killers")
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
    if aimPunch and v32[animId] then
      v34 = tick()
      v33 = true
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
  end)
end

local function f5(p4)
  if not p4 then
    return nil
  else
    local v46 = tostring(p4.SoundId)
    local d = v46:match("%d+")

    if d then
      return d
    else
      local hash = v46:match("[&%?]hash=([^&]+)")

      if hash then
        return "&hash=" .. hash
      else
        local rbxassetSounds = v46:match("rbxasset://sounds/.+")

        if rbxassetSounds then
          return rbxassetSounds
        end

        return nil
      end
    end
  end
end

local function f6()
  local character3 = localPlayer.Character
  return character3 and character3:FindFirstChild("Humanoid")
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

local function f8(betterDetection, position)
  if not betterDetection or not position then
    return false
  else
    local pointToObjectSpace = betterDetection.CFrame:PointToObjectSpace(position)
    local v47 = betterDetection.Size * 0.5

    return math.abs(pointToObjectSpace.X) <= v47.X + 0.001
      and math.abs(pointToObjectSpace.Y) <= v47.Y + 0.001
      and math.abs(pointToObjectSpace.Z) <= v47.Z + 0.001
  end
end

local function f9(p6)
  if not p6 then
    return nil
  else
    local model = p6:FindFirstAncestorOfClass("Model")

    if model and model:FindFirstChildOfClass("Humanoid") then
      local killers = workspaceService:FindFirstChild("Players")
        and workspaceService.Players:FindFirstChild("Killers")

      if killers and model:IsDescendantOf(killers) then
        return model
      end

      return nil
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

local function f10(p7)
  local hitboxes = workspaceService:FindFirstChild("Hitboxes")

  if hitboxes then
    local v48 = 0
    local v49 = nil

    for index2, value3 in ipairs(hitboxes:GetChildren()) do
      if value3:IsA("BasePart") then
        local v50 = value3.Size.X * value3.Size.Y * value3.Size.Z

        if v50 > v48 then
          v49 = value3
          v48 = v50
        end
      end
    end

    if v49 then
      return v49
    end
  end

  local hitboxes2 = p7:FindFirstChild("Hitboxes")

  if hitboxes2 then
    for index3, value4 in ipairs(hitboxes2:GetChildren()) do
      if value4:IsA("BasePart") then
        return value4
      end
    end

    for index4, value5 in ipairs(p7:GetDescendants()) do
      if value5:IsA("BasePart") and value5.Name:lower():find("hitbox") then
        return value5
      end
    end

    return nil
  end

  for index5, value6 in ipairs(p7:GetDescendants()) do
    if value6:IsA("BasePart") and value6.Name:lower():find("hitbox") then
      return value6
    end
  end

  return nil
end

local part

local function makePart()
  if not v25 or not v45 then
    if part then
      part:Destroy()
      part = nil
    end

    return
  else
    if not part then
      part = Instance.new("Part")
      part.Anchored = true
      part.CanCollide = false
      part.Shape = Enum.PartType.Ball
      part.Transparency = 0.5
      part.Color = Color3.fromRGB(255, 255, 0)
      part.Material = Enum.Material.ForceField
      part.Parent = workspaceService
    end

    local v51 = triggerRadius

    part.Size = Vector3.new(v51 * 2, v51 * 2, v51 * 2)
    part.CFrame = CFrame.new(v45.Position)

    return
  end
end

local function f11(p8)
  if not p8 then
    return nil
  end

  if p8.Parent and p8.Parent:IsA("BasePart") then
    return p8.Parent.Position, p8.Parent
  end

  if p8.Parent and p8.Parent:IsA("Attachment") and p8.Parent.Parent
    and p8.Parent.Parent:IsA("BasePart") then
    return p8.Parent.Parent.Position, p8.Parent.Parent
  else
    local findFirstChildWhichIsA = p8.Parent
      and p8.Parent:FindFirstChildWhichIsA("BasePart", true)

    if findFirstChildWhichIsA then
      return findFirstChildWhichIsA.Position, findFirstChildWhichIsA
    end

    return nil, nil
  end
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

local v53

local function f13()
  if not v41 then
    return
  end

  pcall(function()
    local v54 = require(replicatedStorage.Modules.Network)

    if v53 then
      v54.FireConnection = v53
    end
  end)

  v41 = false
  v53 = nil
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

local v56, connect2

local function f15()
  pcall(function() runService:UnbindFromRenderStep("PunchMobility") end)
  pcall(function() runService:UnbindFromRenderStep("LungeBoost") end)

  v40 = false

  for key4, value7 in pairs(v42) do
  end

  v42 = {}

  if connect2 then
    connect2:Disconnect()
    connect2 = nil
  end

  if v56 then
    task.cancel(v56)
    v56 = nil
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

  local function stopChargeAim(reason)
    if chargeAimConn then
      chargeAimConn:Disconnect()
      chargeAimConn = nil
      chargeDetachCount += 1
      lastDetachReason = tostring(reason or "stopped")
      pcall(function()
        local c = localPlayer.Character
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if hum then
          hum.AutoRotate = true
          hum:Move(Vector3.zero)
        end
      end)
      if v2.get("a720Telemetry", false) then
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

    if chargeAimConn then
      chargeAimConn:Disconnect()
      chargeAimConn = nil
    end

    local startT = os.clock()
    local sm = c:FindFirstChild("SpeedMultipliers")
    local sawMult = (sm and sm:FindFirstChild("Guest1337Charge") ~= nil) or false
    hum.AutoRotate = false

    -- Ghi đè unbind ngay lúc bắt đầu aim để giải phóng giới hạn 2 rad/s của game gốc
    pcall(function() runService:UnbindFromRenderStep("GuestCharging") end)

    -- Frame-0 Pre-Snap: bẻ hướng và di chuyển ngay lập tức tại frame gọi (cả auto lẫn manual charge)
    local kHrp0 = target:FindFirstChild("HumanoidRootPart")
    if kHrp0 then
      local lookAtPos0 = Vector3.new(kHrp0.Position.X, myHrp.Position.Y, kHrp0.Position.Z)
      myHrp.CFrame = CFrame.lookAt(myHrp.Position, lookAtPos0)
      hum:Move((lookAtPos0 - myHrp.Position).Unit)
    end

    if v2.get("a720Telemetry", false) then
      print("[NERG] ★ ChargeAim locked -> " .. tostring(target.Name) .. " (" .. tostring(srcTag or "charge") .. ")")
    end

    chargeAimConn = runService.RenderStepped:Connect(function()
      if not __PLUS_GEN_ALIVE or _G.__NERG_KILLED or not chargeAim then
        stopChargeAim("disabled")
        return
      end
      -- Unbind liên tục mỗi frame đề phòng game re-bind lại
      pcall(function() runService:UnbindFromRenderStep("GuestCharging") end)

      local elapsed = os.clock() - startT
      if elapsed >= 1.2 then
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
      elseif sawMult or elapsed > 0.40 then
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

      local flat = Vector3.new(offset.X, 0, offset.Z)
      if flat.Magnitude > 0.01 then
        hum.AutoRotate = false
        myHrp.CFrame = CFrame.lookAt(myHrp.Position, Vector3.new(kHrp.Position.X, myHrp.Position.Y, kHrp.Position.Z))
        hum:Move(flat.Unit)
      end
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
      hum.AutoRotate = false
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
    end
    return true
  end

  local function bindSpeedMultipliers(ch)
    if chargeSmConn then chargeSmConn:Disconnect() chargeSmConn = nil end
    if not ch then return end
    task.spawn(function()
      local sm = ch:FindFirstChild("SpeedMultipliers") or ch:WaitForChild("SpeedMultipliers", 5)
      if not (sm and __PLUS_GEN_ALIVE and not _G.__NERG_KILLED) then return end
      chargeSmConn = sm.ChildAdded:Connect(function(child)
        if child.Name == "Guest1337Charge" and chargeAim and not chargeAimConn then
          local nearK = findNearestKiller((chargeMaxRange or 20) * 1.5)
          if nearK then
            startChargeAim(nearK, "manual-charge")
          end
        end
      end)
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
      if chargeSmConn then chargeSmConn:Disconnect() chargeSmConn = nil end
    end,
  })
end

local function f17(p10)
  local character5

  if not autoBlock then
    return
  elseif not f12() then
    if autoCharge and chargeReady() then
      fireCharge(p10)
    end
    return
  else
    character5 = localPlayer.Character
    local humanoidRootPart6 = character5 and character5:FindFirstChild("HumanoidRootPart")

    if not humanoidRootPart6 or not p10 then
      return
    end

    if not p10:FindFirstChild("HumanoidRootPart") then
      return
    end

    local function doBlockOrFallback()
      if not character5:FindFirstChild("HumanoidRootPart") or not p10.Parent then
        return
      elseif not f12() then
        if autoCharge and chargeReady() then
          fireCharge(p10)
        end
        return
      else
        local v89 = f14(p10)
        if not v89 then
          return
        end
        if not a742pHitboxMode then
          local magnitude = (v89 - humanoidRootPart6.Position).Magnitude
          if magnitude > (visionRange or 13.5) * 1.18 then
            return
          end
        end
        f3()
        v37 = tick()
        makeTextLabel()
      end
    end

    if (blockDelay or 0) <= 0 then
      doBlockOrFallback()
    else
      task.delay(blockDelay, doBlockOrFallback)
    end

    return
  end
end

HDT_BLOCK_ANIMS = {
  "98105697395689", "100926346851492", "140671644163156", "72182155407310", "72722244508749",
  "95802026624883", "88557287105521", "123548100869928", "82605295530067", "120748030255574",
  "88287038085804", "96959123077498", "115706752305794", "82036084568393", "127040663332045",
}
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
    if cachedCd.Text ~= "" then return false end
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
    local kf = workspaceService:FindFirstChild("Players")
      and workspaceService.Players:FindFirstChild("Killers")
    local ckRoot, bd = nil, 15
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
      if v2.get("a720Telemetry", false) then
        print("[NERG] ★ punch fired (" .. tostring(srcTag or "parry") .. " + range)")
      end
      makeSound()
    end
  end

  local function onParrySignal(srcTag)
    if not autoPunch then return end
    if not isParryState() then return end
    tryFireParryPunch(srcTag)
    if not transientWatcher then
      local startT = os.clock()
      transientWatcher = runService.Heartbeat:Connect(function()
        if not __PLUS_GEN_ALIVE or not autoPunch or os.clock() - startT > 0.85 or not isParryState() then
          stopTransientWatcher()
          return
        end
        tryFireParryPunch("transient")
      end)
    end
  end

  local function hookStroke(st)
    if not (st and st:IsA("UIStroke")) then return end
    parryConns[#parryConns + 1] = st:GetPropertyChangedSignal("Color"):Connect(function()
      onParrySignal("stroke-color")
    end)
    parryConns[#parryConns + 1] = st:GetPropertyChangedSignal("Enabled"):Connect(function()
      onParrySignal("stroke-enabled")
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

  local pg = localPlayer:WaitForChild("PlayerGui", 10)
  if pg then
    pg.DescendantAdded:Connect(function(desc)
      if desc.Name == "Punch" and desc.Parent and desc.Parent.Name == "AbilityContainer" then
        task.defer(resolveAndBindPunch)
      end
    end)
  end

  localPlayer.CharacterAdded:Connect(function()
    task.delay(0.5, resolveAndBindPunch)
    task.delay(1.5, resolveAndBindPunch)
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
a742uVisConn = runService.RenderStepped:Connect(function(delta930)
  if not __PLUS_GEN_ALIVE or _G.__NERG_KILLED then
    if a742uVisConn then a742uVisConn:Disconnect() a742uVisConn = nil end
    return
  end
  if not default or not localPlayer.Character then
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
  local killers4 = workspaceService:FindFirstChild("Players")
    and workspaceService.Players:FindFirstChild("Killers")
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
end)

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
      local v103, v104 = pcall(function()
        local dot3 = humanoidRootPart8.CFrame.LookVector:Dot((humanoidRootPart7.Position
          - humanoidRootPart8.Position).Unit)

        local v105 = math.cos(math.rad(visionAngle / 2))
        return v98 < 25 or dot3 >= v105
      end)

      if not v103 or not v104 then
        return
      end
    end
  end

  if v13 then
    v37 = tick()

  else
    f17(v97)
  end

  v36[p11] = tick() + 0.5
end

A655_SWING = {}

local M1_ROLE_OVERRIDE = { Azure = "Slash", Nosferatu = "SlashGround", ["#Nosferatwo"] = "SlashGround" }
local function a655ScanM1(kname)
  local as = replicatedStorage:FindFirstChild("Assets")
  local ks = as and as:FindFirstChild("Killers")
  local dir = ks and (ks:FindFirstChild(kname or "") or ks:FindFirstChild((kname or ""):gsub("^[!#]", "")))
  local cfg = dir and dir:FindFirstChild("Config")
  if not cfg then return nil, nil end
  local ok, tab = pcall(function() return require(cfg) end)
  if not ok or type(tab) ~= "table" then return nil, nil end
  local so = (type(tab.Sounds) == "table" and tab.Sounds) or tab
  local order = M1_ROLE_OVERRIDE[kname] and { M1_ROLE_OVERRIDE[kname] } or { "Swing", "Bite", "Slash", "SlashGround" }
  for _, role in ipairs(order) do
    local v = so[role]
    local id = type(v) == "string" and v:match("%d+")
    if not id and type(v) == "table" and v[1] ~= nil then id = tostring(v[1]):match("%d+") end
    if id then return id, role end
  end

  local base = (kname or ""):gsub("^[!#]", "")
  if base ~= kname then return (a655ScanM1(base)) end
  return nil, nil
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
  for _, role2 in ipairs({ "Swing", "Bite", "Slash", "SlashGround" }) do
    local v2 = sso[role2]
    local id2 = type(v2) == "string" and v2:match("%d+")
    if not id2 and type(v2) == "table" and v2[1] ~= nil then id2 = tostring(v2[1]):match("%d+") end
    if id2 then return id2 end
  end
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
	local order = { "Attack", "Slash", "SlashAir", "EnragedSlash", "Bite", "Stab", "SlashGround" }
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
		local so = a742oAnimIdsFromConfig(skinDir and skinDir:FindFirstChild("Config"), { "Attack", "Slash", "SlashAir", "EnragedSlash", "Bite", "Stab", "SlashGround" })
		if #so > 0 then out = so end
	end
	return out
end
local function a655ScanRound()
  local newMap = {}
  A655_SKINS = {}
  local kf = workspaceService:FindFirstChild("Players") and workspaceService.Players:FindFirstChild("Killers")
  if not kf then return end
  for _, m in ipairs(kf:GetChildren()) do
    local id, role = a655ScanM1(m.Name)
    local skin = m:GetAttribute("SkinName")
    if skin and skin ~= "" then
      local basename = m.Name:gsub("^[!#]", "")
      local sid = a655SkinM1(basename, skin)
      if sid and sid ~= id then
        newMap[sid] = m.Name
        A655_SKINS[sid] = skin
        if v2.get("a720Telemetry", false) then print("[NERG] scan-skin: killer=" .. m.Name .. " skin=" .. skin .. " m1-id=" .. sid) end
      elseif id then
        A655_SKINS[id] = skin
      end
    end
    if id then
      newMap[id] = m.Name
      A663_LOG("SCAN", id, m.Name, role)
    else
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
  local ks = workspaceService:FindFirstChild("Players") and workspaceService.Players:FindFirstChild("Killers")
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

clearKillerSoundConns = function()
  for i = #killerSoundConns, 1, -1 do
    local c = killerSoundConns[i]
    killerSoundConns[i] = nil
    pcall(function() c:Disconnect() end)
  end
end

a655ArmSound = function(d)
  local id = tostring(d.SoundId):match("%d+")
  if not (id and A655_SWING[id]) then return end
  if not a663Seen[id] then a663Seen[id] = true A663_LOG("FIRST", id, A655_SWING[id], "swing") end
  if d:GetAttribute("__A655_ARMED") then return end
  A663_LOG("ARM", id, A655_SWING[id], "swing")
  d:SetAttribute("__A655_ARMED", true)
  local function strike663(nhan)
    if a742oAnimM1 then return end
    local km663 = a655ResolveKiller(d)
    A663_LOG(nhan or (autoBlock and "FIRE" or "NGAT(AB-off)"), id, km663 and km663.Name or A655_SWING[id], "swing")
    if not autoBlock then return end

    if km663 then
      if a742pHitboxMode and f12() then a742pSpawnBox(km663) else task.spawn(f19, "swing", km663) end
    end
  end
  local sig = d:GetPropertyChangedSignal("IsPlaying"):Connect(function()
    if d.IsPlaying then strike663(nil) end
  end)
  killerSoundConns[#killerSoundConns + 1] = sig
  if d.IsPlaying then strike663(nil) end
end

a655MountEar = function()
  if a655EarConn then a655EarConn:Disconnect() a655EarConn = nil end
  local pf = workspaceService:FindFirstChild("Players")
  local kf = pf and pf:FindFirstChild("Killers")
  if kf then
    a655EarConn = kf.DescendantAdded:Connect(function(d)
      if d:IsA("Sound") then task.spawn(a655ArmSound, d) end
    end)
    for _, d in ipairs(kf:GetDescendants()) do
      if d:IsA("Sound") then task.spawn(a655ArmSound, d) end
    end
  end
end

do
  local pf = workspaceService:FindFirstChild("Players")
  local kf = pf and pf:FindFirstChild("Killers")
  local function hookKiller(k)
    clearKillerSoundConns()
    a655ScanRound()
    a655MountEar()
    k.ChildAdded:Connect(function()
      a655ScanRound()
      task.delay(0.2, a655MountEar)
      task.delay(1, a655ScanRound)
    end)
    k.ChildRemoved:Connect(function()
      if #k:GetChildren() == 0 then
        clearKillerSoundConns()
      end
      a655ScanRound()
    end)
  end
  if kf then
    hookKiller(kf)
  elseif pf then
    pf.ChildAdded:Connect(function(c)
      if c.Name == "Killers" then
        task.delay(0.5, function()
          local k2 = pf:FindFirstChild("Killers")
          if k2 then hookKiller(k2) end
        end)
      end
    end)
  end
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
local function GetAnimationType(ID)
  for i, v in AllAnimations do
    for animtype, animId in v do
      if type(animId) == "table" then
        for i2, v2 in animId do
          if type(v2) == "string" and v2:find(tostring(ID)) then return animtype, i, i2 end
        end
      elseif type(animId) == "string" and animId:find(tostring(ID)) then
        return animtype, i
      end
    end
  end
end
animEarConns = {}
a742pSndTouch, a742pSndConns, a742pCharConns = {}, {}, {}
local function mountAnimEar(k)
  if k:GetAttribute("__A641_ANIM_EAR") then return end
  local hum = k:FindFirstChildOfClass("Humanoid")
  local an = hum and hum:FindFirstChildOfClass("Animator")
  if not (hum and an) then return end
  k:SetAttribute("__A641_ANIM_EAR", true)
  animEarConns[k] = an.AnimationPlayed:Connect(function(Track)
    if not a742oAnimM1 then return end
    local aid = Track and Track.Animation and tostring(Track.Animation.AnimationId):match("%d+")
    if aid and A742o_ANIM and A742o_ANIM[aid] and autoBlock then
      A663_LOG("ANIM-FIRE", aid, k.Name, "anim-m1")
      local nowL = os.clock()
      for s, t0 in pairs(a742pSndTouch) do
        if not s.Parent then
          a742pSndTouch[s] = nil
          local c0 = a742pSndConns[s]
          if c0 then pcall(function() c0:Disconnect() end) a742pSndConns[s] = nil end
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
  local function hookSound(s)
    if s and s:IsA("Sound") and not a742pSndConns[s] then
      a742pSndTouch[s] = 0
      a742pSndConns[s] = s:GetPropertyChangedSignal("SoundId"):Connect(function()
        a742pSndTouch[s] = os.clock()
      end)
    end
  end
  for _, d in ipairs(k:GetDescendants()) do hookSound(d) end
  a742pCharConns[k] = k.DescendantAdded:Connect(function(d)
    task.wait(0.05)
    hookSound(d)
  end)
end
local function f22()
  task.spawn(function()
    local players2 = workspaceService:FindFirstChild("Players")
    if not players2 then players2 = workspaceService:WaitForChild("Players", 30) end
    if not players2 then return end
    local killers3 = players2:FindFirstChild("Killers")
    if not killers3 then killers3 = players2:WaitForChild("Killers", 30) end
    if not killers3 then
      warn("[NERG][preview] Players.Killers not found — anim ear silent")
      return
    end
    for _, k in ipairs(killers3:GetChildren()) do pcall(mountAnimEar, k) end
    killers3.ChildAdded:Connect(function(child)
      task.wait(0.1)
      if child.Parent then pcall(mountAnimEar, child) end
    end)
  end)
end
pcall(f22)
-- A742p: AB detect "Hitbox đen" (mode-Anti-Bait) — nghe-đòn ⇒ sinh-hộp-kích-thước-TỔ trước killer; block CHỈ-khi-hộp-chạm-người
A742P_SIZES = { Noli = Vector3.new(5, 7, 8), Slasher = Vector3.new(5, 7, 8), c00lkidd = Vector3.new(5, 7, 5.5), ["1x1x1x1"] = Vector3.new(5, 7, 8), JohnDoe = Vector3.new(5, 7, 8), Sixer = Vector3.new(5, 7, 8), Nosferatu = Vector3.new(5, 7, 8), Azure = Vector3.new(5, 7, 8) }
A742P_ZOFF = { Noli = -1.7, Slasher = -2.1, c00lkidd = -0.3, ["1x1x1x1"] = -2, JohnDoe = -2.5, Sixer = 0, Nosferatu = -2 }
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
function a742pSpawnBox(k)
  if not (k and k.Parent) then return end
  local hrp = k:FindFirstChild("HumanoidRootPart")
  if not hrp then return end
  local base = (k.Name or ""):gsub("^[!#]", "")
  local now = os.clock()
  local b = a742pBoxes[k]
  if b and b.part and b.part.Parent then
    b.untilT = now + 0.55
    if b.firedAt and now - b.firedAt >= 0.5 then b.fired, b.firedAt = nil, nil end
    return
  end
  local part = Instance.new("Part")
  part.Name = "NergABHitbox"
  part.Anchored, part.CanCollide, part.CanTouch, part.CanQuery, part.CastShadow = true, false, false, false, false
  part.Material = Enum.Material.ForceField
  part.Color = A742P_COLOR
  part.Transparency = 0.15
  local a742pB = A742P_SIZES[base] or A742P_FALLBACK
  part.Size = Vector3.new(a742pB.X * (a742pWidScale or 1), a742pB.Y, a742pB.Z * (a742pLenScale or 1))
  local hl = Instance.new("Highlight")
  hl.Name = "NergABOutline"
  hl.FillColor = A742P_COLOR
  hl.FillTransparency = 0.7
  hl.OutlineTransparency = 0
  hl.OutlineColor = A742P_OUTLINE
  hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
  hl.Parent = part
  part.Parent = a742pFolder
  a742pBoxes[k] = { part = part, hl = hl, untilT = now + 0.55, zoff = A742P_ZOFF[base] or -1.2, baseZ = a742pB.Z, fired = nil, firedAt = nil }
  A663_LOG("GEOM-BOX", base, k.Name, "hitbox")
  if not a742pHeart then
    a742pHeart = runService.Heartbeat:Connect(function()
      local ch = localPlayer.Character
      a742pOverlap.FilterDescendantsInstances = ch and { ch } or {}
      local now2 = os.clock()
      for kb, bb in pairs(a742pBoxes) do
        if not (kb and kb.Parent) or now2 > bb.untilT then
          pcall(function() bb.part:Destroy() end)
          a742pBoxes[kb] = nil
        else
          local h9 = kb:FindFirstChild("HumanoidRootPart")
          if h9 then
            local look = h9.CFrame.LookVector
            local flat = Vector3.new(look.X, 0, look.Z)
            flat = (flat.Magnitude > 0.01 and flat.Unit) or Vector3.new(0, 0, -1)
            local pos = h9.Position + flat * (bb.zoff + 2 + (bb.part.Size.Z - (bb.baseZ or bb.part.Size.Z)) / 2)
            bb.part.CFrame = CFrame.lookAt(pos, pos + flat)
            local touches = #workspaceService:GetPartsInPart(bb.part, a742pOverlap) > 0
            bb.hl.OutlineColor = touches and VIS_RED or A742P_OUTLINE
            if touches and not bb.fired then
              bb.fired = true
              bb.firedAt = now2
              A663_LOG("GEOM-FIRE", kb.Name, kb.Name, "hitbox")
              task.spawn(f19, "swing", kb)
            end
          end
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
  if a742pHeart then a742pHeart:Disconnect() a742pHeart = nil end
  for _, c in ipairs(a742pFolder:GetChildren()) do c:Destroy() end
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
			return setmetatable({}, {
				__index = function(_, k)
					if k == "Remove" or k == "Destroy" then
						return function() pcall(function() tl:Destroy() end) end
					end
					local b = bag[k]
					if b ~= nil then return b end
					local ok, val = pcall(function() return tl[k] end)
					if ok then return val end
					return nil
				end,
				__newindex = function(_, k, v)
					if k == "Position" then pos = v; place()
					elseif k == "Center" then centered = v; place()
					elseif k == "Outline" then tl.TextStrokeTransparency = (v == true and 0) or (v == false and 1) or (type(v) == "number" and v) or 0
					elseif k == "OutlineColor" then tl.TextStrokeColor3 = v
					elseif k == "Color" then tl.TextColor3 = v
					elseif k == "Size" and type(v) == "number" then tl.TextSize = v
					elseif k == "Text" or k == "Visible" or k == "Size" or k == "Font" or k == "FontFace" or k == "TextSize" or k == "TextScaled" or k == "ZIndex" or k == "Name" then pcall(function() tl[k] = v end)
					else bag[k] = v
					end
				end,
			})
		end
	end

local tbl7, fn16

do
	local fn17 = gethui and gethui or function()
		return CoreGui
	end

	local flag = false
	tbl7 = {}
	local tbl8 = {}
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

	local function fn20(arg, arg2)
		if arg:GetAttribute("FootstepOverride") == "GolemFootsteps" then
			return true
		end

		if arg2 and arg2.AbilityState and arg2.AbilityState.Animator then
			for _, v3 in ipairs(arg2.AbilityState.Animator:GetPlayingAnimationTracks()) do
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
			return { MaxStamina = 50, StaminaGain = 20, StaminaLoss = 10, MinStamina = 0, PenaltyTime = 2 }
		end
		local str2 = arg.Parent and arg.Parent.Name == "Survivors" and "Survivors" or "Killers"
		local name = arg.Name
		if str2 == "Survivors" then
			return tbl10
		end
		local v3 = fn16({ "Killers", name, "Config" })

		if v3 then
			return {
				MaxStamina = v3.MaxStamina or 100,
				StaminaGain = v3.StaminaGain or 20,
				StaminaLoss = v3.StaminaLoss or 10,
				MinStamina = 0,
				PenaltyTime = 2,
			}
		end

		return tbl10
	end

	local function fn22(arg, arg2, arg3)
		local str2 = arg.Parent and arg.Parent.Name == "Survivors" and "Survivors" or "Killers"
		local name = arg.Name
		local attribute = arg:GetAttribute("SkinName") or ""
		local str3 = arg3 and "GolemRun" or arg2 and "InjuredRun" or "Run"

		if attribute ~= "" then
			local v3 = fn16({ "Skins", str2, name, attribute, "Config" })
			if v3 and v3.Animations and v3.Animations[str3] then
				return v3.Animations[str3]
			end
		end

		local v3 = fn16({ str2, name, "Config" })
		if v3 and v3.Animations and v3.Animations[str3] then
			return v3.Animations[str3]
		end

		if arg3 then
			return "rbxassetid://130480436367274"
		end

		if arg2 then
			local v4 = fn16({ str2, name, "Config" })
			if v4 and v4.Animations and v4.Animations.Run then
				return v4.Animations.Run
			end
		end

		return arg2 and "rbxassetid://115946474977409" or "rbxassetid://136252471123500"
	end

	local function fn23(arg, arg2)
		if not arg then
			return false
		end

		for _, v3 in ipairs(arg:GetPlayingAnimationTracks()) do
			if v3.Animation and v3.Animation.AnimationId then
				local v4 = string.match(tostring(v3.Animation.AnimationId), "%d+")
				if arg2 and v4 == arg2 and v3.WeightCurrent > 0.45 then
					return true
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
		for k, v3 in pairs(tbl8) do
			if v3.Type == "Survivor" and k.Parent then
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

		local uid690 = arg:GetAttribute("__ESP_UID")
		if not uid690 then
			uid690 = tostring(math.floor(os.clock() * 1000000)) .. "_" .. tostring(math.random(100000, 999999))
			arg:SetAttribute("__ESP_UID", uid690)
		end
		local name = arg.Name .. "_" .. uid690
		local billboardGui = forsakenAbilityESP:FindFirstChild(name)
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
		local str2 = arg.Parent and arg.Parent.Name == "Survivors" and "Survivor" or "Killer"
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

				if arg.Name == "Slasher" then
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

							if v15 then
								local v16 = string.match(tostring(v15), "%d+")

								if v16 then
									enragedAnimIds[v16] = true
								end
							end
						end
					end

					abilityState.EnragedAnimIds = enragedAnimIds
				end

				if arg.Name == "Veeronica" then
					local v13 = fn16({ "Survivors", "Veeronica", "Config" })

					if v13 and v13.Animations then
						local sk8Skating = v13.Animations.Sk8Skating
						local sk8Start = v13.Animations.Sk8Start

						if sk8Skating then
							tbl15.Sk8SkatingAnimId = string.match(tostring(sk8Skating), "%d+")
							abilityState.Sk8SkatingAnimId = tbl15.Sk8SkatingAnimId
						end

						if sk8Start then
							abilityState.Sk8StartAnimId = string.match(tostring(sk8Start), "%d+")
						end
					end
				end

				if arg.Name == "TwoTime" then
					local function fn31()
						tbl15.IsCrouching = arg:GetAttribute("Crouching") == true
					end

					fn31()
					tbl15.CrouchAttrListener = arg:GetAttributeChangedSignal("Crouching"):Connect(fn31)
				end
			end
		end

		tbl15.AbilityState = abilityState
		tbl8[arg] = tbl15
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

		if isGolem and arg2.AbilityState and arg2.AbilityState.Animator then
			for _, v4 in ipairs(arg2.AbilityState.Animator:GetPlayingAnimationTracks()) do
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

		local position = humanoidRootPart.Position
		local magnitude = (Vector3.new(position.X, 0, position.Z) - Vector3.new(arg2.LastPosition.X, 0, arg2.LastPosition.Z)).Magnitude
		local n5 = magnitude / arg3

		if n2 < n5 then
			n5 = arg2.CurrentSpeed
		end

		arg2.CurrentSpeed = arg2.CurrentSpeed * (1 - n) + n5 * n
		arg2.LastPosition = position
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
		local animator = arg2.AbilityState and arg2.AbilityState.Animator
		local flag5 = false

		if animator then
			flag5 = fn23(arg2.AbilityState.Animator, golemRunAnimationIdStr)
		end

		local animator2 = arg2.Sk8SkatingAnimId and arg2.AbilityState and arg2.AbilityState.Animator
		local isSkating = false

		if animator2 then
			isSkating = fn23(arg2.AbilityState.Animator, arg2.Sk8SkatingAnimId)
		end

		arg2.IsSkating = isSkating
		local n6 = 1
		local n7 = 1

		if isSkating then
			n6 = 0
			n7 = 1.35
		end

		isSkating = isSkating or flag5 and flag4

		if arg2.Type == "Killer" and isSkating and not fn25(position) then
			isSkating = false
		end

		if arg2.IsEnraged and arg2.Name == "Slasher" then
			local enragedAnimIds = arg2.AbilityState and arg2.AbilityState.EnragedAnimIds
			local flag6 = false

			if enragedAnimIds then
				for _, v5 in ipairs(arg2.AbilityState.Animator:GetPlayingAnimationTracks()) do
					if v5.Animation and v5.Animation.AnimationId then
						local v6 = string.match(tostring(v5.Animation.AnimationId), "%d+")
						if v6 and arg2.AbilityState.EnragedAnimIds[v6] then
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

		local maxStamina = arg2.Stats.MaxStamina

		if arg2.IsEnraged and arg2.Name == "Slasher" then
			maxStamina = arg2.Stats.MaxStamina + (70 - arg2.Stats.MaxStamina) * math.clamp((tick() - (arg2.EnrageStartTime or tick())) / 6.5, 0, 1)
		end

		if arg2.NoobEffects then
			local now3 = tick()
			arg2.BloxyColaActive = arg2.NoobEffects.BloxyCola and now3 < arg2.NoobEffects.BloxyCola or false
			arg2.SlateskinPotionActive = arg2.NoobEffects.SlateskinPotion and now3 < arg2.NoobEffects.SlateskinPotion or false
			arg2.GhostburgerActive = arg2.NoobEffects.Ghostburger and now3 < arg2.NoobEffects.Ghostburger or false
		end

		if isSkating then
			arg2.IsSprinting = true
			arg2.MovementState = arg2.IsInjured and "INJURED_RUN" or "RUN"

			if not arg2.IsStaminaFrozen then
				arg2.TimeUntilRecovery = math.clamp(arg2.TimeUntilRecovery + arg3 * 0.05, 0.2, 3)
				arg2.CurrentStamina = math.clamp(arg2.CurrentStamina - arg2.Stats.StaminaLoss * n7 * arg3, arg2.Stats.MinStamina, maxStamina)

				if arg2.CurrentStamina <= arg2.Stats.MinStamina then
					arg2.IsSprinting = false
					arg2.StaminaPenaltyActive = true
					arg2.TimeUntilRecovery = arg2.Stats.PenaltyTime
				end
			end
		else
			if arg2.IsSprinting == true then
				arg2.TimeUntilRecovery = math.max(arg2.TimeUntilRecovery, 0.11)
			end

			arg2.IsSprinting = false
			arg2.MovementState = arg2.CurrentSpeed > 2 and "WALK" or "IDLE"

			if not arg2.IsStaminaFrozen then
				arg2.TimeUntilRecovery = math.clamp(arg2.TimeUntilRecovery - arg3, 0, 3)

				if arg2.StaminaPenaltyActive then
					if arg2.TimeUntilRecovery <= 0 then
						arg2.StaminaPenaltyActive = false
					end
				elseif arg2.TimeUntilRecovery <= 0 then
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
		if arg:GetAttribute("Username") == name then
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
		for char, st in pairs(tbl8) do
			if not char.Parent then pcall(function() RemovePlayerTagDrawing(char) end) continue end
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
						local dS2 = math.clamp(1.0 - dTag / 140, 0.40, 1.0)
						local dN2 = math.clamp(math.floor(20 * dS2 + 0.5), 8, 20)
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

	StopESPSystem = function()
		flag = false

		if connection2 then
			connection2:Disconnect()
			connection2 = nil
		end


		for _, v3 in ipairs(tbl9) do
			v3:Disconnect()
		end

		tbl9 = {}

if not tbl.PlayersTagsEsp then
		for k in pairs(tbl7) do
			RemovePlayerTagDrawing(k)
		end

		tbl8 = {}

		if forsakenDeviceESP then
			forsakenDeviceESP:Destroy()
			forsakenDeviceESP = nil
		end

				end

		if forsakenAbilityESP then
			forsakenAbilityESP:Destroy()
			forsakenAbilityESP = nil
		end
	end

	StartESPSystem = function()
		if flag then
			return
		end
		flag = true

		if not forsakenDeviceESP then
			forsakenDeviceESP = CoreGui:FindFirstChild("ForsakenDeviceESP") or Instance.new("ScreenGui")
			forsakenDeviceESP.Name = "ForsakenDeviceESP"
			forsakenDeviceESP:SetAttribute("GEN", 4)
			forsakenDeviceESP.DisplayOrder = 10
			forsakenDeviceESP.Parent = fn17()
		end

		if not forsakenAbilityESP then
			forsakenAbilityESP = CoreGui:FindFirstChild("ForsakenAbilityESP") or Instance.new("Folder")
			forsakenAbilityESP.Name = "ForsakenAbilityESP"
			forsakenAbilityESP:SetAttribute("GEN", 4)
			forsakenAbilityESP.Parent = fn17()
		end

		local function fn34(child)
			task.spawn(function()
				if child:IsA("Model") then
					if child == localPlayer.Character then return end
					local humanoidRootPart = child:WaitForChild("HumanoidRootPart", 10)
					local humanoid = child:WaitForChild("Humanoid", 10)
					local head = child:WaitForChild("Head", 10)

					if humanoidRootPart and humanoid and child.Parent then
if tbl.PlayersTagsEsp then
						CreatePlayerTagDrawing(child, child.Parent.Name == "Killers" and tbl.EspKillerColor or tbl.EspSurvivorsColor, humanoidRootPart, humanoid)
end
						fn30(child, humanoidRootPart, head, humanoid)
					end
				end
			end)
		end

		local function fn35(arg)
			if not arg then
				return
			end

			for _, child in ipairs(arg:GetChildren()) do
				fn34(child)
			end

			table.insert(tbl9, arg.ChildAdded:Connect(fn34))
			table.insert(tbl9, arg.ChildRemoved:Connect(RemovePlayerTagDrawing))
		end

		local players2 = workspace:WaitForChild("Players", 5)

		if players2 then
			fn35(players2:WaitForChild("Survivors", 5))
			fn35(players2:WaitForChild("Killers", 5))
		end

		if connection2 then
			connection2:Disconnect()
		end

		connection2 = RunService.RenderStepped:Connect(fn33)
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
	local a723MyTok = _G.__A723_TOKEN
	task.spawn(function()
		while _G.__A723_TOKEN == a723MyTok do
			task.wait(0.3)
			pcall(function()
				local n = tbl.EspIconSize or 50
				local nd = math.clamp(math.floor(n * 0.48 + 0.5), 12, 64)
				a723IconSweep(n, nd)
			end)
		end
	end)
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
			for _, v in pairs(tbl8) do if v.Type == "Killer" and v.MainText then pcall(function() v.MainText.Color = c end) end end
			pcall(killerEspColorUpdate)
		end,
		color_surv = function(c) tbl.EspSurvivorsColor = c
			for _, v in pairs(tbl8) do if v.Type ~= "Killer" and v.MainText then pcall(function() v.MainText.Color = c end) end end
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
				elseif not _G.NERG_ABILITY_ESP then
					StopESPSystem()
				else
					for k in pairs(tbl7) do RemovePlayerTagDrawing(k) end
					tbl8 = {}
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
				if st.DeviceGuiFrame then
					pcall(function() st.DeviceGuiFrame.Size = UDim2.new(0, nd, 0, nd) end)
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
	task.spawn(function() while true do if _G.__NERG_KILLED then break end task.wait(2) pcall(purgeOldESP) end end)
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
				for _, d in ipairs(ig:GetDescendants()) do
					if isOurHL(d) then pcall(function() d:Destroy() end) end
				end
			end
		end
	end
	local lastK5, lastS5
	task.spawn(function()
		while true do
			if _G.__NERG_KILLED then break end
			task.wait(5)
			pcall(function()
				if tbl.KillerEsp then pcall(killerEsp) else pcall(nergEspSweepTeam, "Killers") end
				if tbl.SurvivorsEsp then pcall(survivorsEsp) else pcall(nergEspSweepTeam, "Survivors") end
				if tbl.KillerEsp ~= lastK5 or tbl.SurvivorsEsp ~= lastS5 then
					lastK5, lastS5 = tbl.KillerEsp, tbl.SurvivorsEsp
					pcall(function() if v2.get("a720Telemetry", false) then print("[NERG] esp state: K=" .. tostring(tbl.KillerEsp) .. " S=" .. tostring(tbl.SurvivorsEsp) .. " (changed)") end end)
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
				if name == "GroundBulbModel" or name == "GroundBulb" then return 20 end
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
		if d:IsA("Model") then return d.PrimaryPart or d:FindFirstChildWhichIsA("BasePart") end
		if d:IsA("BasePart") then return d end
		return nil
	end

	local function findEntry(d)
		for _, e in ipairs(REG) do
			local ok, res = pcall(e.match, d)
			if ok and res then return e end
		end
		return nil
	end

	local function applyHL(target, color)
		local hl = target:FindFirstChild(HLNAME)
		if not hl then
			hl = Instance.new("Highlight")
			hl.Name = HLNAME
			hl.FillTransparency = 0.45
			hl.OutlineTransparency = 0
			hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			hl.Adornee = target
			hl.Parent = target
		end
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
		if not rec then
			rec = { entry = entry }
			reg[inst] = rec
			if entry.trans and inst:IsA("BasePart") then
				rec.trans = true
				rec.savedT = inst.Transparency
				pcall(function() inst.Transparency = 0 end)
			end
		end
		rec.hl = applyHL(inst, OBJ.colors[entry.key])
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
			local bp = baseOf(inst)
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
		local active = OBJ.master and OBJ.itemsOn and ITEM_MATCH[tool.Name] == true
		local rec = items[tool]
		if not active then
			if rec then rmItem(tool) end
			return
		end
		if not rec then
			rec = {}
			items[tool] = rec
		end
		rec.hl = applyHL(tool, OBJ.colors.Items)
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

	local function ensureConns()
		local mp = workspace:FindFirstChild("Map")
		local ing = mp and mp:FindFirstChild("Ingame")
		if ing == ingame then return end
		for inst in pairs(reg) do rmReg(inst) end
		for tool in pairs(items) do rmItem(tool) end
		ingame = ing
		detachConns()
		if not ingame then return end
		conns.added = ingame.DescendantAdded:Connect(function(d)
			task.defer(function()
				if not d.Parent then return end
				local e = findEntry(d)
				if e then
					applyReg(d, e)
					return
				end
				if d:IsA("Tool") and ITEM_MATCH[d.Name] == true then applyItem(d) end
			end)
		end)
		conns.rem = ingame.DescendantRemoving:Connect(function(d)
			if reg[d] then rmReg(d) end
			if items[d] then rmItem(d) end
		end)
		for _, d in ipairs(ingame:GetDescendants()) do
			local e = findEntry(d)
			if e then
				applyReg(d, e)
			elseif d:IsA("Tool") and ITEM_MATCH[d.Name] == true then
				applyItem(d)
			end
		end
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
					bp = tool:FindFirstChild("ItemRoot") or tool:FindFirstChild("Handle") or tool.PrimaryPart
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

	local function rescanAll()
		for inst, rec in pairs(reg) do
			if rec.entry then applyReg(inst, rec.entry) end
		end
		for tool in pairs(items) do
			applyItem(tool)
		end
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
		setTagLoop(false)
		for inst in pairs(reg) do rmReg(inst) end
		for tool in pairs(items) do rmItem(tool) end
		detachConns()
		ingame = nil
	end

		local MAX_OBJ_HL, MAX_ITEM_HL = 12, 8
	local function cullFar()
		local lp = players.LocalPlayer
		local ch = lp and lp.Character
		local myHRP = ch and ch:FindFirstChild("HumanoidRootPart")
		if not myHRP then return end
		local myList = {}
		for inst, rec in pairs(reg) do
			if OBJ.master and rec.entry then
				local bp = rec.bp
				if bp == nil or bp.Parent == nil then
					bp = baseOf(inst)
					rec.bp = bp
				end
				if bp and bp.Parent then
					local okD, d = pcall(function() return (bp.Position - myHRP.Position).Magnitude end)
					if okD and d then
						if d > 120 then
							if rec.hl then pcall(function() rec.hl:Destroy() end) rec.hl = nil end
						else
							myList[#myList + 1] = { d = d, inst = inst, rec = rec }
						end
					end
				end
			end
		end
		table.sort(myList, function(a, b) return a.d < b.d end)
		for i, e in ipairs(myList) do
			if i <= MAX_OBJ_HL then
				if not e.rec.hl then
					e.rec.hl = applyHL(e.inst, OBJ.colors[e.rec.entry.key])
				end
			else
				if e.rec.hl then pcall(function() e.rec.hl:Destroy() end) e.rec.hl = nil end
			end
		end
		local iList = {}
		for tool, rec in pairs(items) do
			if OBJ.master and OBJ.itemsOn then
				local bp = rec.bp
				if bp == nil or bp.Parent == nil then
					bp = tool:FindFirstChild("ItemRoot") or tool:FindFirstChild("Handle") or tool.PrimaryPart
					rec.bp = bp
				end
				if bp and bp.Parent then
					local okD, d = pcall(function() return (bp.Position - myHRP.Position).Magnitude end)
					if okD and d then
						if d > 120 then
							if rec.hl then pcall(function() rec.hl:Destroy() end) rec.hl = nil end
						else
							iList[#iList + 1] = { d = d, inst = tool, rec = rec }
						end
					end
				end
			end
		end
		table.sort(iList, function(a, b) return a.d < b.d end)
		for i, e in ipairs(iList) do
			if i <= MAX_ITEM_HL then
				if not e.rec.hl then
					e.rec.hl = applyHL(e.inst, OBJ.colors.Items)
				end
			else
				if e.rec.hl then pcall(function() e.rec.hl:Destroy() end) e.rec.hl = nil end
			end
		end
	end

	local accObj = 0
	supConn = rs.Heartbeat:Connect(function(dt)
		if _G.__NERG_KILLED then
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
			pcall(function() part:Destroy() end)
			markers[id] = nil
		end
	end

	local function ensureMods()
		if m1 and m2 then return true end
		local ok1, r1 = pcall(function() return require(game:GetService("ReplicatedStorage").Systems.Player.Game.ProjectileReplication) end)
		local ok2, r2 = pcall(function() return require(game:GetService("ReplicatedStorage").Modules.Gameplay.PredictProjectile) end)
		if ok1 and type(r1) == "table" and type(r1.Projectiles) == "table" then m1 = r1 end
		if ok2 and type(r2) == "table" and type(r2.FindLeadShot) == "function" then m2 = r2 end
		return m1 ~= nil
	end

	local function landingOf(p)
		local cf = p.InitialCFrame
		local vel = p.InitialVelocity
		if typeof(cf) ~= "CFrame" or typeof(vel) ~= "Vector3" then return nil end
		local pos = cf.Position
		local land = nil
		if m2 then
			pcall(function()
				land = m2.FindLeadShot(pos, vel, vel.Magnitude, pos, Vector3.zero, 1)
			end)
		end
		if typeof(land) ~= "Vector3" or land == pos then
			local g = tonumber(p.Gravity) or 0
			land = pos + vel * 2 - Vector3.new(0, math.abs(g) * 4.5, 0)
		end
		return land
	end

	local function projPoll()
		if not P.on then return end
		if not ensureMods() then return end
		local live = m1.Projectiles
		local liveN = 0
		for _ in pairs(live) do liveN += 1 end
				local maxAge = tonumber(P.maxAge) or 0.95
		local nowP = os.clock()
		for id, part in pairs(markers) do
			local b = births[id]
			local age = b and (nowP - b) or 999
			if live[id] == nil or age >= maxAge then
				pcall(function() part:Destroy() end)
				markers[id] = nil
				births[id] = nil
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
			elseif markers[id] ~= nil then
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

	P.hbConn = rs.Heartbeat:Connect(function(dt)
		if _G.__NERG_KILLED or not __PLUS_GEN_ALIVE then
			pcall(function() P.shutdown() end)
			return
		end
		if not P.on then return end
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
			if not scfg then return nil end
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
						local e = buildEntry(child, child:GetAttribute("CharacterName") or child.Name, child:GetAttribute("SkinName") or "")
						if e then reg[child] = e end
					end
				end
			end
		end
		local n = 0
		for _ in pairs(reg) do n += 1 end
		W.dbg = { t = os.clock(), n = n, f = folder and folder.Parent ~= nil or false }
	end

	local function stepModel(mdl, e, dt)
		local hum = mdl:FindFirstChildOfClass("Humanoid")
		local root = mdl:FindFirstChild("HumanoidRootPart")
		local anim = hum and hum:FindFirstChildOfClass("Animator")
		local alive = mdl:IsDescendantOf(workspace) and hum ~= nil and hum.Health > 0
		local tracks = anim and anim:GetPlayingAnimationTracks() or {}
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
				if _G.__NERG_KILLED then
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

	local killers, ingame, survivors
	local function resolveFolders()

		local kp = workspace:FindFirstChild("Players")
		killers = kp and kp:FindFirstChild("Killers")
		survivors = kp and kp:FindFirstChild("Survivors")
		local mp = workspace:FindFirstChild("Map")
		ingame = mp and mp:FindFirstChild("Ingame")
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
	local function espHlSweep()
		local kp = workspace:FindFirstChild("Players")
		if not kp then return end
		local kf = kp:FindFirstChild("Killers")
		if kf then
			for _, d in ipairs(kf:GetDescendants()) do
				if hlIsOurs(d) then pcall(function() d:Destroy() end) end
			end
		end
		local sf = kp:FindFirstChild("Survivors")
		if sf then
			for _, d in ipairs(sf:GetDescendants()) do
				if hlIsOurs(d) then pcall(function() d:Destroy() end) end
			end
		end
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
			if _G.__NERG_KILLED then break end
			task.wait(0.25)
			pcall(function()
				pcall(reconcileTeam, "Killers", tbl.KillerEsp == true, tbl.EspKillerColor)
				pcall(reconcileTeam, "Survivors", tbl.SurvivorsEsp == true, tbl.EspSurvivorsColor)
				local cam = workspace.CurrentCamera
				if not cam then return end
				local cp = cam.CFrame.Position
				local base = tbl.HFillTransparency or 0.25
				for mdl in pairs(tbl6) do
					if not mdl.Parent then
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
	end)

	createHighlight2 = function(adornee, fillColor)
		if not adornee or not adornee.Parent then
			return
		end
		local name2 = localPlayer.Name
		if adornee:GetAttribute("Username") == name2 then
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
					if descendant.Enabled then descendant.Enabled = false end
					local saved = tbl6saved[adornee]
					if not saved then saved = {} tbl6saved[adornee] = saved end
					local dup = false
					for _, h in ipairs(saved) do if h == descendant then dup = true break end end
					if not dup then saved[#saved + 1] = descendant end
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
						if child.Enabled then child.Enabled = false end
						local saved = tbl6saved[adornee]
						if not saved then saved = {} tbl6saved[adornee] = saved end
						local dup = false
						for _, h in ipairs(saved) do if h == child then dup = true break end end
						if not dup then saved[#saved + 1] = child end
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

	killerEsp = function()
		resolveFolders()
		local v3 = killers
		pcall(function() if v2.get("a720Telemetry", false) then print("[NERG] killerEsp: folder=" .. tostring(v3 and v3.Name or "nil") .. " children=" .. (v3 and #v3:GetChildren() or 0) .. " ON=" .. tostring(tbl.KillerEsp)) end end)
		if not v3 then
			if not tbl.KillerEsp then hlSweepTeam("Killers") end
			return
		end

		if connection2 then
			connection2:Disconnect()
		end

		if connection3 then
			connection3:Disconnect()
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
				elseif string.sub(child.Name, -12) == "JohnDoeTrail" then
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

					createHighlight2(trailESPModel, tbl.EspKillerColor)
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
					child.ChildAdded:Connect(function(child2)
						if child2.Name == "Shadow" then
							child2.Transparency = 0
							createHighlight2(child2, tbl.EspKillerSupportColor)
						end
					end)
				elseif string.sub(child.Name, -12) == "JohnDoeTrail" then
					local model = Instance.new("Model")
					model.Name = "TrailESPModel"
					model.Parent = child

					for _, child2 in ipairs(child:GetChildren()) do
						if child2:IsA("BasePart") then
							child2.Transparency = 0
							child2.Parent = model
						end
					end

					createHighlight2(model, tbl.EspKillerColor)
				end
			end)
		else
			for _, child in ipairs(killers:GetChildren()) do
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

			for _, descendant in ipairs(safeDesc(ingame)) do
				if descendant.Name == name then
					descendant:Destroy()
				end

				if descendant.Name == "Shadow" then
					descendant.Transparency = 1
				end
			end

			hlSweepTeam("Killers")

			for _, child in ipairs(ingame:GetChildren()) do
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
		resolveFolders()
		local survivors2 = survivors
		if not survivors2 then
			if not tbl.SurvivorsEsp then hlSweepTeam("Survivors") end
			return
		end

		if connection then
			connection:Disconnect()
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

local connect8

local function f23()
  if connect8 then
    connect8:Disconnect()
    connect8 = nil
  end

  local character7 = localPlayer.Character

  if character7 then
    for index8, value13 in ipairs(character7:GetDescendants()) do
      if value13:IsA("BasePart") then
        value13.CanCollide = true
      end
    end
  end
end

local function f24()
  if not localPlayer.Character then
    return
  end

  if connect8 then
    connect8:Disconnect()
  end

  connect8 = runService.Stepped:Connect(function()
    if not noclip then
      connect8:Disconnect()
      connect8 = nil
      return
    end

    if v18 and not f12() then
      return
    end

    if not localPlayer.Character then
      return
    end

    for index9, value14 in ipairs(localPlayer.Character:GetDescendants()) do
      if value14:IsA("BasePart") then
        value14.CanCollide = false
      end
    end
  end)
end

local function f25(p12)
  local v107 = not p12 or not p12:IsA("NumberValue")
  local connect9

  if v107 then
    return
  elseif p12.Value <= 1.01 then
    return
  else
    pcall(function()
      p12.Value = 1
      tweenService:Create(p12, TweenInfo.new(0), { Value = 1 }):Play()
    end)

    connect9 = nil

    connect9 = p12:GetPropertyChangedSignal("Value"):Connect(function()
      if not v39 or not v21 then
        pcall(function() connect9:Disconnect() end)
        return
      end

      if p12.Value > 1 then
        pcall(function() p12.Value = 1 end)
      end
    end)

    table.insert(v43, connect9)
    return
  end
end

local function f26(p13)
  local v108 = not p13 or not p13:IsA("NumberValue")
  local connect10

  if v108 then
    return
  elseif p13.Value > 1.01 then
    return
  else
    pcall(function()
      p13.Value = 1
      tweenService:Create(p13, TweenInfo.new(0), { Value = 1 }):Play()
    end)

    connect10 = nil

    connect10 = p13:GetPropertyChangedSignal("Value"):Connect(function()
      if not v20 then
        pcall(function() connect10:Disconnect() end)
        return
      end

      if p13.Value < 1 then
        pcall(function() p13.Value = 1 end)
      end
    end)

    table.insert(v42, connect10)
    return
  end
end

local f27

local function f28()
  f15()
  local character8 = localPlayer.Character

  if not character8 then
    return
  end

  for index10, value15 in ipairs(character8:GetDescendants()) do
    if value15:IsA("NumberValue") then
      f26(value15)
    end
  end

  connect2 = character8.DescendantAdded:Connect(function(descendant2)
    if not v20 then
      return
    end

    if descendant2:IsA("NumberValue") then
      task.defer(function()
        if descendant2.Name == "PunchAbility" then
          if lungeBoost then
            if v56 then
              task.cancel(v56)
            end

            v56 = task.delay(0.7, function()
              v56 = nil
              f27()
            end)
          end
        end

        f26(descendant2)
      end)
    end
  end)

  runService:BindToRenderStep("PunchMobility", Enum.RenderPriority.Character.Value + 10, function()
    if v40 then
      return
    else
      local v109 = f6()

      if not v109 then
        return
      end

      if v109.WalkSpeed < 12 then
        v109.WalkSpeed = 12
      end

      return
    end
  end)
end

function f27()
  local vector, v110, v111

  if not lungeBoost then
    return
  elseif v40 then
    return
  else
    local v112 = f2()

    if not v112 then
      return
    else
      local lookVector2 = v112.CFrame.LookVector
      vector = Vector3.new(lookVector2.X, 0, lookVector2.Z)

      if vector.Magnitude == 0 then
        return
      end

      vector = vector.Unit
      v40 = true
      v110 = 40 * lungeMultiplier
      v111 = 0

      runService:BindToRenderStep("LungeBoost", Enum.RenderPriority.Character.Value + 20, function(index11)
        v111 = v111 + index11
        local v113 = f2()

        if not v113 or v111 >= 0.3 then
          pcall(function() runService:UnbindFromRenderStep("LungeBoost") end)
          v40 = false
          return
        end

        v113.AssemblyLinearVelocity = vector * (v110 * (1 - v111 / 0.3))
          + Vector3.new(0, v113.AssemblyLinearVelocity.Y, 0)
      end)

      return
    end
  end
end

local f29
local connect11

local function f30()
  f29()
  local character9 = localPlayer.Character

  if not character9 then
    return
  end

  for index12, value16 in ipairs(character9:GetDescendants()) do
    f25(value16)
  end

  connect11 = character9.DescendantAdded:Connect(function(descendant3)
    if not v39 or not v21 then
      return
    end

    if descendant3:IsA("NumberValue") then
      task.defer(function() f25(descendant3) end)
    end
  end)

  runService:BindToRenderStep("ChargeCap", Enum.RenderPriority.Character.Value + 20, function()
    if not v39 or not v21 then
      pcall(function() runService:UnbindFromRenderStep("ChargeCap") end)
      return
    else
      local v114 = f6()

      if v114 and v114.WalkSpeed > 12 then
        v114.WalkSpeed = 12
      end

      return
    end
  end)
end

local function f31()
  function v3884()
    runService:UnbindFromRenderStep("ChargeLock")
  end

  v39 = false
  pcall(function() runService:UnbindFromRenderStep("ChargeSpeedLimit") end)
  f29()
end

function f29()
  pcall(function() runService:UnbindFromRenderStep("ChargeCap") end)

  if connect11 then
    connect11:Disconnect()
    connect11 = nil
  end

  for key12, value17 in pairs(v43) do
  end

  v43 = {}
end

local connect12, f32

local function f33(character10)
  if connect12 then
    connect12:Disconnect()
    connect12 = nil
  end

  f31()
  f15()

  connect12 = character10:GetAttributeChangedSignal("GuestCharging"):Connect(function()
    if not chargeControl then
      return
    end

    if character10:GetAttribute("GuestCharging") then
      f32()
    else
      f31()
    end
  end)
end

function f32()
  pcall(function() runService:UnbindFromRenderStep("ChargeLock") end)
  pcall(function() runService:UnbindFromRenderStep("ChargeSpeedLimit") end)

  v39 = true

  runService:BindToRenderStep("ChargeLock", Enum.RenderPriority.Character.Value + 2, function()
    local v115 = f6()

    if not v115 then
      return
    else
      local lookVector3 = workspaceService.CurrentCamera.CFrame.LookVector
      local vector2 = Vector3.new(lookVector3.X, 0, lookVector3.Z)

      if vector2.Magnitude > 0 then
        v115:Move(vector2.Unit)
      end

      return
    end
  end)

  runService:BindToRenderStep("ChargeSpeedLimit", Enum.RenderPriority.Character.Value + 20, function()
    if not v39 then
      pcall(function() runService:UnbindFromRenderStep("ChargeSpeedLimit") end)
      return
    else
      local v116 = f6()

      if v116 and v116.WalkSpeed ~= v22 then
        v116.WalkSpeed = v22
      end

      return
    end
  end)

  if v21 then
    f30()
  end
end

walkSpeed3, jumpPower, autoRotate2 = nil

a724AimConn = runService.RenderStepped:Connect(function()
  if not __PLUS_GEN_ALIVE or _G.__NERG_KILLED then
    if a724AimConn then a724AimConn:Disconnect() a724AimConn = nil end
    return
  end

  if v33 and (not aimPunch or not humanoid or not v45 or tick() - v34 > v10) then
    v33 = false
    a724RotUnlock(humanoid)
    if walkSpeed3 then
      humanoid.WalkSpeed = walkSpeed3
      humanoid.JumpPower = jumpPower
      walkSpeed3 = nil
      jumpPower = nil
      autoRotate2 = nil
    end
  end
  if aimPunch and humanoid and v45 and v33 and tick() - v34 <= v10 then
    if not walkSpeed3 then
      walkSpeed3 = humanoid.WalkSpeed
      jumpPower = humanoid.JumpPower
    end

      a724RotLock(humanoid)
      humanoid.AutoRotate = false
      v45.AssemblyAngularVelocity = Vector3.zero
      local players3 = workspaceService:FindFirstChild("Players")

      local killers5 = players3
      killers5 = players3 and workspaceService.Players:FindFirstChild("Killers")

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

  makePart()
end)

localPlayer.CharacterAdded:Connect(function(character11)
  task.delay(0.5, function()
    f18()
    f4(character11)
    f33(character11)

    if noclip then
      f24()
    end

    if v20 then
      f28()
    end
  end)
end)

if localPlayer.Character then
  f4(localPlayer.Character)
  f33(localPlayer.Character)
end

if noclip then
  f24()
end

if v20 then
  f28()
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

  local function absTrigger(pos)
    if not abs.on or abs.locked then return end
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
      pcall(function()
        local deadline = os.clock() + abs.duration
        local hp0 = hum and hum.Health
        while os.clock() < deadline and abs.on do
          local ch2 = localPlayer.Character
          local r2 = ch2 and ch2:FindFirstChild("HumanoidRootPart")
          local hum2 = ch2 and ch2:FindFirstChildOfClass("Humanoid")
          if hp0 and hum2 and hum2.Health < hp0 - 0.5 then break end
          if not r2 or not ttRoot.Parent then break end
          local p2 = r2.Position
          local t2 = ttRoot.Position
          if (p2 - t2).Magnitude < 0.05 then break end
          r2.CFrame = CFrame.lookAt(p2, Vector3.new(t2.X, p2.Y, t2.Z))
          runService.RenderStepped:Wait()
        end
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
    if abs.soundConns[snd] then return end
    abs.soundConns[snd] = snd:GetPropertyChangedSignal("SoundId"):Connect(function() absCheckSound(snd) end)
    absTrack(snd.Played:Connect(function() absCheckSound(snd) end))
  end

  local function absScanSounds(root)
    if not root then return end
    for _, d in ipairs(root:GetDescendants()) do
      if d:IsA("Sound") then absBindSound(d) end
    end
  end

  local function absHookAnim(model)
    if abs.animConns[model] then return end
    local hum = model:FindFirstChildOfClass("Humanoid")
    local animator = hum and hum:FindFirstChildOfClass("Animator")
    if not animator then return end
    abs.animConns[model] = animator.AnimationPlayed:Connect(function(track)
      local ok, aid = pcall(function() return track.Animation.AnimationId end)
      if not ok or not aid then return end
      local num = aid:match("%d+")
      if not num or not ABS_ANIM_IDS[num] then return end
      local hrp = model:FindFirstChild("HumanoidRootPart")
      absTrigger(hrp and hrp.Position)
    end)
  end

  local function absScanTick()
    local pl = workspace:FindFirstChild("Players")
    if pl then
      for _, folder in ipairs(pl:GetChildren()) do
        for _, model in ipairs(folder:GetChildren()) do
          if model:IsA("Model") and model.Name == ABS_MODEL_NAME then
            absRing(model)
            absHookAnim(model)
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
      while abs.on do
        pcall(absScanTick)
        task.wait(1)
      end
      scanThread = nil
    end)
  end

  local absStop

  local function absStart()
    absDropConns()
    absTrack(workspace.DescendantAdded:Connect(function(obj)
      if obj:IsA("Sound") then absBindSound(obj) end
      if abs.on and obj:IsA("Model") and obj.Name == ABS_MODEL_NAME then
        task.defer(function() pcall(absRing, obj) end)
      end
    end))
    pcall(absScanSounds, workspace)
    pcall(absScanSounds, soundService)
    absStartScan()
    pcall(absScanTick)
  end

  absStop = function()
    abs.on = false
    absDropConns()
    if scanThread then pcall(task.cancel, scanThread) scanThread = nil end
    absRingsClear()
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

  -- boot purge: don rac cua lan chay truoc
  pcall(function()
    for _, d in ipairs(workspace:GetDescendants()) do
      if d:IsA("Part") and d.Name == "NergAbsRing" then d:Destroy() end
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

      local function harvest(cfgMod, sName)
        if not (cfgMod and cfgMod:IsA("ModuleScript")) then return end
        local ok, mod = pcall(require, cfgMod)
        if not (ok and type(mod) == "table") then return end
        if type(mod.Animations) == "table" then
          for aKey, aVal in pairs(mod.Animations) do
            if type(aVal) == "string" then
              local num = aVal:match("%d+")
              if num and (aKey:find("Punch") or aKey:find("Slash") or aKey:find("Stab") or aKey:find("Lunge") or aKey:find("AimGun") or aKey:find("GunFire") or aKey:find("Hatchet") or aKey:find("Axe")) then
                STUN_ANIMS[num] = { char = sName, skill = aKey }
              end
            end
          end
        end
        if type(mod.Sounds) == "table" then
          for sKey, sVal in pairs(mod.Sounds) do
            if type(sVal) == "string" then
              local num = sVal:match("%d+")
              if num and (sKey:find("Punch") or sKey:find("Slash") or sKey:find("Stab") or sKey:find("Gun") or sKey:find("Hatchet") or sKey:find("Axe")) then
                STUN_SOUNDS[num] = { char = sName, skill = sKey }
              end
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
    if not (model and model:IsA("Model")) then return end
    if autoDodge.survConns[model] then return end
    autoDodge.survConns[model] = {}

    local hum = model:FindFirstChildOfClass("Humanoid")
    local an = hum and hum:FindFirstChildOfClass("Animator")
    if an then
      local c = an.AnimationPlayed:Connect(function(track)
        local aid = track and track.Animation and track.Animation.AnimationId
        local num = aid and aid:match("%d+")
        if num and STUN_ANIMS[num] then
          tryAutoDodge(STUN_ANIMS[num], model)
        end
      end)
      table.insert(autoDodge.survConns[model], c)
    end

    local sc = model.DescendantAdded:Connect(function(d)
      if d:IsA("Sound") then
        local num = d.SoundId and tostring(d.SoundId):match("%d+")
        if num and STUN_SOUNDS[num] then
          tryAutoDodge(STUN_SOUNDS[num], model)
        end
      end
    end)
    table.insert(autoDodge.survConns[model], sc)
  end

  local function unhookSurvivor(model)
    local conns = autoDodge.survConns[model]
    if conns then
      for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
      autoDodge.survConns[model] = nil
    end
  end

  local function autoDodgeStart()
    buildDynamicCatalog()
    local pl = workspace:FindFirstChild("Players")
    local sv = pl and pl:FindFirstChild("Survivors")
    if sv then
      for _, m in ipairs(sv:GetChildren()) do
        if m:IsA("Model") then hookSurvivor(m) end
      end
      if not autoDodge.conns["svChildAdded"] then
        autoDodge.conns["svChildAdded"] = sv.ChildAdded:Connect(function(c)
          task.wait(0.1)
          if c:IsA("Model") then hookSurvivor(c) end
        end)
      end
      if not autoDodge.conns["svChildRemoved"] then
        autoDodge.conns["svChildRemoved"] = sv.ChildRemoved:Connect(function(c)
          if c:IsA("Model") then unhookSurvivor(c) end
        end)
      end
    end
  end

  local function autoDodgeStop()
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

  -- Background refresh loop while active
  task.spawn(function()
    while __PLUS_GEN_ALIVE do
      task.wait(2.0)
      if autoDodge.on then
        local pl = workspace:FindFirstChild("Players")
        local sv = pl and pl:FindFirstChild("Survivors")
        if sv then
          for _, m in ipairs(sv:GetChildren()) do
            if m:IsA("Model") and not autoDodge.survConns[m] then
              hookSurvivor(m)
            end
          end
        end
      end
    end
    autoDodgeStop()
  end)

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

local SPlayer = v1PRBLOCKWindow:Section({ Title = "Player", Opened = true })
local visualTab = SPlayer:Tab({ Title = "Visual", Icon = "eye" })
local staminaTab = SPlayer:Tab({ Title = "Stamina", Icon = "zap" })
local genAutoTab = SPlayer:Tab({ Title = "Auto Gen", Icon = "cpu" })
local camTab = SPlayer:Tab({ Title = "Camera", Icon = "camera" })
local camCore = { fov = 70, zoom = 12, keep = false, on = false, bound = false, prevFov = nil }
pcall(function()
  local pd = localPlayer:FindFirstChild("PlayerData")
  local fv = pd and pd:FindFirstChild("FieldOfView", true)
  local cam = workspace.CurrentCamera
  if fv and fv:IsA("NumberValue") then
    camCore.fov = math.floor(fv.Value)
  elseif cam then
    camCore.fov = math.floor(cam.FieldOfView)
  end
  camCore.fov = math.clamp(camCore.fov, 60, 120)
  camCore.zoom = game:GetService("StarterPlayer").CameraMaxZoomDistance
end)
local function camPushFov()
  if localPlayer:GetAttribute("FOVMultipliersDisabled") then return end
  local c0 = workspace.CurrentCamera
  if c0 and c0.FieldOfView ~= camCore.fov then c0.FieldOfView = camCore.fov end
end
function camCore.set(v)
  local want = v and true or false
  local cam = workspace.CurrentCamera
  if want then
    if not cam then return end
    if not camCore.on then camCore.prevFov = cam.FieldOfView end
    camCore.on = true
    if not camCore.bound then
      camCore.bound = true
      pcall(function()
        runService:BindToRenderStep("NergCamFov", Enum.RenderPriority.Camera.Value + 1, function()
          if camCore.on then camPushFov() end
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
    if camCore.prevFov then
      local f0 = camCore.prevFov
      camCore.prevFov = nil
      if cam and not localPlayer:GetAttribute("FOVMultipliersDisabled") then pcall(function() cam.FieldOfView = f0 end) end
    end
  end
end
rawset(_G, "__NERG_CAM_RELEASE", function()
  pcall(function() camCore.set(false) end)
  pcall(function() camCore.keep = false end)
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
  localPlayer:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(function()
    if camCore.keep and localPlayer.CameraMaxZoomDistance < camCore.zoom then
      pcall(function() localPlayer.CameraMaxZoomDistance = camCore.zoom end)
    end
  end)
end

SCombat = v1PRBLOCKWindow:Section({ Title = "Combat", Opened = true })
blockTab = SCombat:Tab({ Title = "AutoBlock", Icon = "shield" })
hdtTab = SCombat:Tab({ Title = "HDT", Icon = "magnet" })
local punchTab = SCombat:Tab({ Title = "Punch", Icon = "hand-fist" })
local stamCore = { run = false, conns = {}, neg = nil, memo = { m = nil, t = 0 }, fire = { v = nil, t = 0 }, val = { max = 100, loss = 10, gain = 20, min = 0, sprint = 26, inf = false }, view = { conn = nil, gui = nil, lbl = nil, lastV = nil, lastM = nil }, mgmt = { conn = nil, on = false, pct = 10 } }
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
function stamCore.apply(mod)
	local effMax, effLoss, effGain, effSprint = stamCore.val.max, stamCore.val.loss, stamCore.val.gain, stamCore.val.sprint
	local chA = localPlayer.Character
	if chA and chA.Parent and chA.Parent.Name == "Killers" and stamCore.val.max == 100 and stamCore.val.loss == 10 and stamCore.val.gain == 20 and stamCore.val.sprint == 26 then
		effMax, effLoss, effGain = 110, 9.5, 21
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
		local nv = stamCore.neg or 0
		if nv > 0 then nv = 0 end
		if moving then
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
	if not stamCore.run or stamCore.guard() then return end
	local mod = stamCore.mod()
	if mod and mod.DefaultsSet then stamCore.apply(mod) end
end
function stamCore.resetDefaults()
	stamCore.val.max, stamCore.val.loss, stamCore.val.gain = 100, 10, 20
	stamCore.val.min, stamCore.val.sprint, stamCore.val.inf = 0, 26, false
	stamCore.mgmt.on = false
	stamCore.mgmtStop()
	stamCore.viewStop()
	stamCore.stop()
end
function stamCore.viewStop()
	if stamCore.view.conn then pcall(function() stamCore.view.conn:Disconnect() end) stamCore.view.conn = nil end
	if stamCore.view.gui then pcall(function() stamCore.view.gui:Destroy() end) stamCore.view.gui = nil stamCore.view.lbl = nil end
	stamCore.view.lastV, stamCore.view.lastM = nil, nil
	stamCore.view.sim = nil
end
function stamCore.viewStart()
	if stamCore.view.conn then return end
	local gui = Instance.new("ScreenGui")
	gui.Name = "NergStaminaView"
	gui.ResetOnSpawn = false
	gui.Parent = (gethui and gethui()) or game:GetService("CoreGui")
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0, 160, 0, 30)
	lbl.AnchorPoint = Vector2.new(0.5, 0.5)
	lbl.Position = UDim2.new(0.5, 0, 0.5, 0)
	lbl.BackgroundTransparency = 0.5
	lbl.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	lbl.TextSize = 18
	lbl.Font = Enum.Font.GothamBold
	lbl.Text = "..."
	lbl.Visible = false
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = lbl
	lbl.Parent = gui
	stamCore.view.gui, stamCore.view.lbl = gui, lbl
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
			local sLoss, sGain = stamCore.val.loss, stamCore.val.gain
			if ch and ch.Parent and ch.Parent.Name == "Killers" and stamCore.val.loss == 10 and stamCore.val.gain == 20 then
				sLoss, sGain = 9.5, 21
			end
			if root then
				local moving = root.Velocity.Magnitude > 0.4
				local sprinting = mod.IsSprinting == true
				local canSprint = true
				if ch.Parent and ch.Parent.Name == "Killers" then
					canSprint = false
					local pos = root.Position
					for _, pl in ipairs(players:GetPlayers()) do
						if pl ~= localPlayer and pl.Character and pl.Character.Parent and pl.Character.Parent.Name == "Survivors" then
							local r2 = pl.Character:FindFirstChild("HumanoidRootPart")
							if r2 and (r2.Position - pos).Magnitude <= 100 then
								canSprint = true
								break
							end
						end
					end
				end
				local isSpr = sprinting and moving and canSprint
				if isSpr then
					sv.tur = math.clamp((sv.tur or 0) + dt * 0.05, 0.2, 3)
					sv.v = math.clamp(sv.v - sLoss * dt, 0, m)
					if sv.v <= 0 then
						sv.v = 0
						sv.pen = true
						sv.tur = 2
					end
				else
					if sv.wasSpr then
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
			if f18 then pcall(f18) end
		else
			local shouldCone = (not a742pHitboxMode)
			default = shouldCone
			v2.set("guestShowVisionRange", shouldCone)
			if not shouldCone and f18 then pcall(f18) end
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
	abBtn.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if not abStart then return end
			local d = input.Position - abStart
			if math.abs(d.X) + math.abs(d.Y) > 8 then abMoved = true end
			if abDrag and abMoved then
				abBtn.Position = UDim2.new(abPos0.X.Scale, abPos0.X.Offset + d.X, abPos0.Y.Scale, abPos0.Y.Offset + d.Y)
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
	infoTab:Paragraph({
		Title = "NergPlus - Version : 2.0",
		Desc = "Make you look more way like a Pro Player ( if you know how to use it , ofc )",
		Image = "zap",
		ImageSize = 24,
		Thumbnail = "rbxassetid://132674328665734",
		ThumbnailSize = 196,
		Color = Color3.fromRGB(56, 189, 248),
		Buttons = {
			{
				Title = "Copy Discord",
				Icon = "link",
				Callback = function()
					if setclipboard then pcall(setclipboard, "https://discord.gg/frM8Zcq3kE") end
					pcall(function()
						windUI:Notify({ Title = "NergPlus", Content = "Discord link copied to clipboard!", Duration = 4, Icon = "paw-print" })
					end)
				end,
			},
		},
	})
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
	esp = false,
	conns = {}, hl = {}, tags2 = {}, bars = {}, colr = {}, cap = 6,
	charge = { on = false, conn = nil, t = 1.05, rnd = false, rmin = 4, rmax = 10, rndConn = nil },
	closeUI = false, closeConns = {},
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
		if okv and type(vv) == "number" then return vv end
	end
	local bar = genCore.bars[child]
	if bar ~= nil and not bar.Parent then
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
local function genIsFake(name)
	return string.find(name, "^FakeGenerator") ~= nil
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

local function genGetColor(inst)
	if inst.Name == "FakeGenerator" then return Color3.fromRGB(255, 165, 0) end
	if genProgressOf(inst) >= 100 then return Color3.fromRGB(0, 255, 0) end
	return Color3.fromRGB(255, 255, 0)
end
local function genDone(inst)
	return genProgressOf(inst) >= 100
end
function genCore.clearAll()
	for _, h in pairs(genCore.hl) do pcall(function() h:Destroy() end) end
	genCore.hl = {}
	for _, d in pairs(genCore.tags2) do pcall(function() d:Remove() end) end
	genCore.tags2 = {}
	genCore.bars = {}
	genCore.colr = {}
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
		if not child.Parent or genDone(child) then
			genCore.hl[child] = nil
			genCore.colr[child] = nil
			pcall(function() h:Destroy() end)
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
	task.spawn(function()
		while genCore.esp do
			task.wait(1)
			if genCore.esp then
				pcall(function() genCore.espApply() end)
			end
		end
	end)
	end
function genCore.espStop()
	genCore.esp = false
	for _, c in ipairs(genCore.conns) do pcall(function() c:Disconnect() end) end
	genCore.conns = {}
	genCore.clearAll()
end
function genCore.chargeRandomApply()
	if genCore.charge.rnd then
		if genCore.charge.rndConn then return end
		local rng = Random.new()
		genCore.charge.rndConn = task.spawn(function()
			while genCore.charge.rnd do
				local v = rng:NextNumber(genCore.charge.rmin, genCore.charge.rmax)
				genCore.charge.t = v
				task.wait(math.max(0.1, v * 0.5))
			end
		end)
	else
		if genCore.charge.rndConn then pcall(function() genCore.charge.rndConn:Disconnect() end) genCore.charge.rndConn = nil end
	end
end
function genCore.closeUIStop()
	for _, c in ipairs(genCore.closeConns) do pcall(function() c:Disconnect() end) end
	genCore.closeConns = {}
	pcall(function()
		local pg = players.LocalPlayer:FindFirstChild("PlayerGui")
		if pg then
			local pui = pg:FindFirstChild("PuzzleUI")
			if pui then pui.Enabled = true end
			local tui = pg:FindFirstChild("TemporaryUI")
			local bgui = tui and tui:FindFirstChild("BackgroundUI")
			if bgui then bgui.Enabled = true end
		end
	end)
end
function genCore.closeUIStart()
	genCore.closeUIStop()
	genCore.closeUI = true
	local lp = players.LocalPlayer
	local pg = lp and lp:FindFirstChild("PlayerGui")
	if not pg then return end
	local function hide()
		pcall(function()
			local pui = pg:FindFirstChild("PuzzleUI")
			if pui then pui.Enabled = false end
			local tui = pg:FindFirstChild("TemporaryUI")
			local bgui = tui and tui:FindFirstChild("BackgroundUI")
			if bgui and bgui:FindFirstChild("Background") and bgui.Background:FindFirstChild("BarHolder") then bgui.Enabled = false end
		end)
	end
	hide()
	table.insert(genCore.closeConns, pg.ChildAdded:Connect(function(child)
		if child.Name == "PuzzleUI" and genCore.closeUI then task.wait(0.05) child.Enabled = false end
	end))
	table.insert(genCore.closeConns, pg.ChildAdded:Connect(function(child)
		if child.Name == "TemporaryUI" and genCore.closeUI then
			task.wait(0.05)
			pcall(function()
				local bgui = child:FindFirstChild("BackgroundUI")
				if bgui and bgui:FindFirstChild("Background") and bgui.Background:FindFirstChild("BarHolder") then bgui.Enabled = false end
			end)
		end
	end))
end
function genCore.chargeStop()
	if genCore.charge.conn then pcall(function() genCore.charge.conn:Disconnect() end) genCore.charge.conn = nil end
	if genCore.charge.rndConn then pcall(function() genCore.charge.rndConn:Disconnect() end) genCore.charge.rndConn = nil end
end
function genCore.chargeStart()
	if genCore.charge.conn then return end
	genCore.charge.conn = task.spawn(function()
		while genCore.charge.on do
			local lp = players.LocalPlayer
			local pg = lp and lp:FindFirstChild("PlayerGui")
			local puzzleOpen = pg and pg:FindFirstChild("PuzzleUI")
			if puzzleOpen then
				local ch = lp.Character
				local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
				if hrp then
				local didF = false
				for _, entry in ipairs(genCore.findMaps()) do
					if didF then break end
					for _, child in ipairs(entry.gens) do
							if genProgressOf(child) < 100 then
								local main = child:FindFirstChild("Main")
								if main and main:IsA("BasePart") and (hrp.Position - main.Position).Magnitude < 10 then
									local promptP = main:FindFirstChild("Prompt") or main:FindFirstChildOfClass("ProximityPrompt")
									if promptP and promptP.Enabled then
										pcall(function()
											promptP:InputHoldBegin()
											task.wait(0.3)
											promptP:InputHoldEnd()
										end)
										didF = true
									end
								end
							end
						end
					end
				end
			end
			local slept = 0
			while genCore.charge.on and slept < genCore.charge.t do
				task.wait(0.05)
				slept = slept + 0.05
			end
		end
	end)
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
      local m = RSA.Systems.Player.Game.Minigames:FindFirstChild(name)
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
        for _, v in ipairs(a) do
          if type(v) == "table" and type(v.Network) == "table" then
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
        return cur(table.unpack(a))
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
        local b, inp
        for _ = 1, 14 do
          inp = ses.__input
          b = inp and inp.Board
          if b and not inp.Ended then break end
          task.wait(0.5)
        end
        if not (b and inp and not inp.Ended) then return end
        task.wait(0.9)
        if inp.Ended or not mod.flow.on then return end
        local s = b.Size
        local function rc(c) return math.ceil(c / s), (c - 1) % s + 1 end
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
          local pr = b.Pairs[i]
          local d = math.abs(math.ceil(pr[1] / s) - math.ceil(pr[2] / s)) + math.abs((pr[1] - 1) % s - (pr[2] - 1) % s)
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
          local onp = { [a2] = true }
          local cells = { a2 }
          local function dfs(c)
            nodes += 1
            if nodes > 500000 or success then return end
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
            for _, nx in ipairs(neighbors(c)) do
              if not onp[nx] and not used[nx] and (nx == z2 or not endpointBlocked(nx, i2)) then
                onp[nx] = true
                cells[#cells + 1] = nx
                dfs(nx)
                cells[#cells] = nil
                onp[nx] = nil
                if nodes > 500000 or success then return end
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
    local espFolder, espConn, hlPool, bbPool, tracked = nil, nil, {}, {}, {}
    local MAXD, CAP = 200, 8
      local accA743 = 0
      local idleG = 0
    local function espClean()
      for _, e in pairs(tracked) do
        if e.hl then e.hl.Enabled = false end
        if e.bb then e.bb.Enabled = false end
        e.hl, e.bb = nil, nil
      end
      table.clear(tracked)
    end
    local function espBuild()
      if espFolder then return end
      espFolder = Instance.new("Folder")
      espFolder.Name = "NergPlus_A743_GearESP"
      espFolder.Parent = workspace
      for i = 1, CAP do
        local hl = Instance.new("Highlight")
        hl.Name = "NergPlus_A743_GearHL"
        hl.FillColor = Color3.fromRGB(255, 200, 0)
        hl.OutlineColor = Color3.fromRGB(180, 130, 0)
        hl.FillTransparency = 0.65
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Enabled = false
        hl.Parent = espFolder
        hlPool[i] = hl
        local bb = Instance.new("BillboardGui")
        bb.Name = "NergPlus_A743_GearTag"
        bb.Size = UDim2.fromOffset(140, 22)
        bb.StudsOffsetWorldSpace = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop = true
        bb.Enabled = false
        local tl = Instance.new("TextLabel")
        tl.Size = UDim2.fromScale(1, 1)
        tl.BackgroundTransparency = 1
        tl.Font = Enum.Font.GothamBold
        tl.TextScaled = true
        tl.TextColor3 = Color3.fromRGB(255, 220, 80)
        tl.TextStrokeTransparency = 0.4
        tl.Text = ""
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
      local interval = (not mod.gear.on and next(active)) and 3 or 1
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
      local chr = LPA.Character
      local hrp = chr and chr:FindFirstChild("HumanoidRootPart")
      if not hrp then
        espClean()
        return
      end
      local seen = {}
      local n = 0
      local ing = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ingame")
      local scanRoot = ing or workspace
      for _, d in ipairs(scanRoot:GetDescendants()) do
        if n >= CAP then break end
        if d:IsA("Model") and d.Name == "Gear" then
          local realG = false
          if d:FindFirstChild("GearHighlight") then
            realG = true
          else
            local prompt = d:FindFirstChildWhichIsA("ProximityPrompt", true)
            if prompt and prompt.Enabled then
              local act = tostring(prompt.ActionText):lower()
              local obj = tostring(prompt.ObjectText):lower()
              if act:find("pick") or act:find("take") or act:find("grab") or act:find("collect")
                 or obj:find("gear") or act == "" then
                realG = true
              end
            end
          end
          if realG then
            local ok, pv = pcall(function() return d:GetPivot().Position end)
            if ok and pv then
              local kc = (hrp.Position - pv).Magnitude
              if kc <= (tracked[d] and MAXD or 185) then
                seen[d] = true
                local entry = tracked[d]
                if not entry then
                  n += 1
                  entry = { hl = hlPool[n], bb = bbPool[n], dist = kc }
                  tracked[d] = entry
                  entry.hl.Adornee = d
                  entry.hl.Enabled = true
                  entry.bb.Adornee = d
                  entry.bb.Enabled = true
                else
                  entry.dist = kc
                end
                entry.bb.TextLabel.Text = "Gear"
              end
            end
          end
        end
      end
      for d, entry in pairs(tracked) do
        if seen[d] and d.Parent then
          entry.miss = 0
        else
          entry.miss = (entry.miss or 0) + 1
          if entry.miss >= 3 then
            if entry.hl then entry.hl.Enabled = false end
            if entry.bb then entry.bb.Enabled = false end
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
      espClean()
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
      if f18 then pcall(f18) end
    else
      local shouldCone = (not a742pHitboxMode)
      default = shouldCone
      v2.set("guestShowVisionRange", shouldCone)
      if not shouldCone and f18 then pcall(f18) end
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
      if f18 then pcall(f18) end
    else
      local shouldCone = (not a742pHitboxMode)
      default = shouldCone
      v2.set("guestShowVisionRange", shouldCone)
      if not shouldCone and f18 then pcall(f18) end
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
      if isHitbox and f18 then pcall(f18) end
    else
      default = false
      v2.set("guestShowVisionRange", false)
      if f18 then pcall(f18) end
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
do
  local HttpService = game:GetService("HttpService")
  local function cfgNotify(msg)
    pcall(function()
      windUI:Notify({ Title = "PLUS-MASTER", Content = tostring(msg), Duration = 3, Icon = "waves" })
    end)
  end
  local CFG_REG = {
    { "Auto Block", "guestAutoBlockAudioOn", function() return autoBlock end, function(v) autoBlock = v if a742jPaint then pcall(a742jPaint) end end, true, "AutoBlock" },
    { "M1 Detection", "blockM1Detect", function() return a742oAnimM1 and "Animation" or "Sound" end, function(v) a742oAnimM1 = (v == "Animation") end, "Sound", "ABM1Detect" },
    { "Block Detection", "blockDetectMode", function() return a742pHitboxMode and "Hitbox" or "Cone" end, function(v) local isHb = (v == "Hitbox") a742pHitboxMode = isHb default = not isHb if not isHb and a742pClearBoxes then pcall(a742pClearBoxes) end end, "Cone", "ABBlockMode" },
    { "Hitbox Length Scale", "a742pLenScale", function() return a742pLenScale end, function(v) a742pLenScale = v end, 1, "ABHbLen" },
    { "Hitbox Width Scale", "a742pWidScale", function() return a742pWidScale end, function(v) a742pWidScale = v end, 1, "ABHbWid" },
    { "Auto Punch", "guestAutoPunchOn", function() return autoPunch end, function(v) autoPunch = v end, true, "AutoPunch" },
    { "Auto Punch Delay (s)", "guestAutoPunchDelay", function() return v12 end, function(v) v12 = v end, 0.3, "AutoDelay" },
    { "Verify Facing", "guestVerifyFacingCheckOn", function() return v8 end, function(v) v8 = v end, true, "Facing" },
    { "Vision Cone", "guestShowVisionRange", function() return default end, function(v) default = v end, false, "VisionCone" },
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
    { "Player Tags (text trên đầu)", "a720VisTags", function() return ESP_SET.get("TagsEsp") end, function(v) pcall(function() ESP_SET.tags(v) end) end, false, "VisTagsEsp" },
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
  end)end

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
  pcall(function() if _G.__NERG_CAM_RELEASE then _G.__NERG_CAM_RELEASE() n += 1 end end)
  pcall(function() if _G.NERG_OBJ and _G.NERG_OBJ.shutdown then _G.NERG_OBJ.shutdown() n += 1 end end)
  pcall(function() if _G.NERG_PROJ and _G.NERG_PROJ.shutdown then _G.NERG_PROJ.shutdown() n += 1 end end)
  pcall(function() if _G.NERG_WINDUP and _G.NERG_WINDUP.shutdown then _G.NERG_WINDUP.shutdown() n += 1 end end)
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
      genCore.chargeStop()
      genCore.closeUIStop()
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

  pcall(function() if a742uVisConn then a742uVisConn:Disconnect() a742uVisConn = nil n += 1 end end)
  pcall(function() if a724AimConn then a724AimConn:Disconnect() a724AimConn = nil n += 1 end end)
  pcall(function() if a742pHeart then a742pHeart:Disconnect() a742pHeart = nil n += 1 end end)
  pcall(function() if a742jConn then a742jConn:Disconnect() a742jConn = nil n += 1 end end)
  pcall(function() if a742wHeart then a742wHeart:Disconnect() a742wHeart = nil n += 1 end end)
  pcall(function() if a655EarConn then a655EarConn:Disconnect() a655EarConn = nil n += 1 end end)
  pcall(function() if a665UiKey then a665UiKey:Disconnect() a665UiKey = nil end end)
  pcall(function() if connect8 then connect8:Disconnect() connect8 = nil end end)
  pcall(function() if clearKillerSoundConns then clearKillerSoundConns() n += 1 end end)
  for k9, c9 in pairs(animEarConns) do pcall(function() c9:Disconnect() end) pcall(function() k9:SetAttribute("__A641_ANIM_EAR", nil) end) end
  for _, c9s in pairs(a742pSndConns) do pcall(function() c9s:Disconnect() end) end
  for _, c9c in pairs(a742pCharConns) do pcall(function() c9c:Disconnect() end) end
  a742pSndConns, a742pCharConns, a742pSndTouch = {}, {}, {}

  if walkSpeed3 then
    pcall(function() if humanoid then humanoid.AutoRotate = autoRotate2 end end)
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
  for _, r in ipairs(uirRoots) do
    if r then
      for _, g in ipairs(r:GetChildren()) do
        pcall(function()
          if g:IsA("ScreenGui") and (g.Name:find("WindUI") or g.Name == "NergFK_TextTags" or g.Name == "NergMobileAB") then
            g:Destroy()
          end
        end)
      end
    end
  end

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
