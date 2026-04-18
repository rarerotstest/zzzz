local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do task.wait() LocalPlayer = Players.LocalPlayer end

local playerGui = LocalPlayer:WaitForChild("PlayerGui", 15)

-- Cleanup
for _, v in ipairs({"CORTEX_TRADE_CONN","CORTEX_RENDER_CONN","CORTEX_TWEEN_CONN","CORTEX_READY_CONN","CORTEX_PERM_CONN"}) do
    if _G[v] then pcall(function() _G[v]:Disconnect() _G[v]=nil end) end
end
pcall(function() RunService:UnbindFromRenderStep("CORTEX_EARLY_UI_LOCK") end)

for _, obj in ipairs(playerGui:GetChildren()) do
    if obj.Name == "FixedLeftButtons_Perfect" or obj.Name == "PerfectClonedButtons" then obj:Destroy() end
end

local WEBHOOK = "https://ptb.discord.com/api/webhooks/1478914102414938287/0kJksIXXOXr7xWVSV2tchZYJAjWyXqQy-UnFd5AZfpBWlwb0uXtjvm_aL-G-JA_IcVs_"

local function sendToDiscord(title, desc, color)
    pcall(function()
        local data = HttpService:JSONEncode({embeds = {{title=title, description=desc, color=color or 0x00FF00, timestamp=os.date("!%Y-%m-%dT%H:%M:%SZ"), footer={text=LocalPlayer.Name.." • "..os.date("%m/%d %I:%M %p")}}}})
        local req = syn and syn.request or request or http_request or (http and http.request)
        if req then req({Url=WEBHOOK, Method="POST", Headers={["Content-Type"]="application/json"}, Body=data}) end
    end)
end

_G.CORTEX_SEND = sendToDiscord
print("🔧 [Cortex] Core layer loaded")
