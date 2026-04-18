print("🔍 [Brainrot Hider] Waiting for Plots...")

local plots = workspace:WaitForChild("Plots", 20)
if plots then
    local myPlot = nil
    local attempt = 0
    repeat
        attempt += 1
        for _, plot in ipairs(plots:GetChildren()) do
            local sign = plot:FindFirstChild("PlotSign")
            if sign then
                local sg = sign:FindFirstChild("SurfaceGui")
                if sg then
                    local f = sg:FindFirstChild("Frame")
                    local lbl = f and f:FindFirstChildWhichIsA("TextLabel")
                    if lbl and (lbl.Text:find(LocalPlayer.Name) or lbl.Text:find(LocalPlayer.DisplayName)) then
                        myPlot = plot
                        break
                    end
                end
                local yb = sign:FindFirstChild("YourBase")
                if yb and yb:IsA("BillboardGui") and yb.Enabled then myPlot = plot break end
            end
        end
        if not myPlot then task.wait(0.5) end
    until myPlot or attempt >= 30

    if myPlot then
        local skip = {AnimalPodiums=true, Laser=true, Purchases=true, Decorations=true, PlotSign=true, FriendPanel=true, CashPad=true, Model=true, Multiplier=true}
        local function isBrainrot(obj)
            return obj:IsA("Model") and not skip[obj.Name] and obj:FindFirstChildOfClass("Humanoid") ~= nil
        end
        local function safeHide(obj)
            pcall(function()
                if obj:IsA("MeshPart") or obj:IsA("BasePart") then obj.Transparency=1 obj.CastShadow=false
                elseif obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then obj.Enabled=false
                elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then obj.Enabled=false
                elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency=1 end
            end)
        end

        local RADIUS = 25
        local function getPositions()
            local pos = {}
            for _, o in ipairs(myPlot:GetChildren()) do
                if isBrainrot(o) then
                    local root = o:FindFirstChild("RootPart") or o:FindFirstChildWhichIsA("BasePart")
                    if root then table.insert(pos, root.Position) end
                end
            end
            return pos
        end

        local function hideOverheads()
            local debris = workspace:FindFirstChild("Debris")
            if not debris then return end
            local myPos = getPositions()
            for _, obj in ipairs(debris:GetChildren()) do
                if obj.Name == "FastOverheadTemplate" then
                    local tPos = obj.Position
                    for _, p in ipairs(myPos) do
                        if (tPos - p).Magnitude <= RADIUS then
                            for _, d in ipairs(obj:GetDescendants()) do
                                pcall(function() if d:IsA("SurfaceGui") or d:IsA("BillboardGui") then d.Enabled=false end end)
                            end
                            break
                        end
                    end
                end
            end
        end

        _G.BRAINROT_PLOT = myPlot
        _G.BRAINROT_IS_BRAINROT = isBrainrot
        _G.BRAINROT_SAFE_HIDE = safeHide
        _G.BRAINROT_HIDE_OVERHEADS = hideOverheads
        print("✅ [Brainrot Hider] Ready (radius="..RADIUS..")")
    end
end
