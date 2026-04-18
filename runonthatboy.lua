local CONFIG = {PositionOffset = UDim2.new(0,0,0,0), SizeMultiplier = 0.85}

local fixedGui = nil
local cloned = nil
local original = nil

local function createFixed()
    if fixedGui and fixedGui.Parent then return end
    fixedGui = Instance.new("ScreenGui")
    fixedGui.Name = "FixedLeftButtons_Perfect"
    fixedGui.ResetOnSpawn = false
    fixedGui.DisplayOrder = 99999
    fixedGui.IgnoreGuiInset = true
    fixedGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    fixedGui.Parent = playerGui
end

local function hideOriginal()
    if not original then return end
    original.Visible = false
    original.BackgroundTransparency = 1
    for _, ch in ipairs(original:GetDescendants()) do
        if ch:IsA("GuiObject") then
            ch.Visible = false
            ch.BackgroundTransparency = 1
            if ch:IsA("ImageLabel") or ch:IsA("ImageButton") then ch.ImageTransparency = 1 end
            if ch:IsA("TextLabel") then ch.TextTransparency = 1 end
        end
    end
end

local function makeClone()
    local leftSG = playerGui:FindFirstChild("LeftCenter") or playerGui:WaitForChild("LeftCenter",10)
    if not leftSG then return end
    local frame = leftSG:FindFirstChild("LeftCenter") or leftSG:WaitForChild("LeftCenter",5)
    if not frame then return end
    original = frame:FindFirstChild("Buttons")
    if not original then return end

    createFixed()
    if cloned then cloned:Destroy() end

    cloned = original:Clone()
    cloned.Name = "PerfectClonedButtons"
    cloned.Parent = fixedGui
    cloned.Visible = true
    cloned.ZIndex = 100000
    cloned.BackgroundTransparency = 1

    for _, desc in ipairs(cloned:GetDescendants()) do
        if desc:IsA("ImageButton") or desc:IsA("ImageLabel") then
            desc.ScaleType = Enum.ScaleType.Fit
            desc.ZIndex = 100010
            desc.Visible = true
        elseif desc:IsA("TextLabel") then
            desc.ZIndex = 100050
            desc.Visible = true
            desc.TextTransparency = 0
        end
    end

    hideOriginal()
    _G.CLONE_ORIGINAL_BUTTONS = original
    _G.CLONE_CLONED_BUTTONS = cloned
    print("✅ [Button Clone] Perfect clone active")
end

task.delay(0.6, function()
    if playerGui:FindFirstChild("LeftCenter") then
        makeClone()
    else
        playerGui.ChildAdded:Connect(function(ch) if ch.Name=="LeftCenter" then task.delay(0.7, makeClone) end end)
    end
end)
