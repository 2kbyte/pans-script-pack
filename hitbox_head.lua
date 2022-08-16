getgenv().headSize = 5

if not headEnabled then
    getgenv().headEnabled = true
else
    getgenv().headEnabled = false
end

local plrs = game:GetService("Players")
local lplr = plrs.LocalPlayer

if headEnabled then
    getgenv().headLoop = game:GetService("RunService").RenderStepped:Connect(function()
        for i, v in pairs(plrs:getPlayers()) do
            if v.Name ~= lplr.Name then
                pcall(function()
                    v.Character.Head.Size = Vector3.new(headSize, headSize, headSize)
                end)
            end
        end
    end)
else
    headLoop:Disconnect()
    for i, v in pairs(plrs:GetPlayers()) do
        if v.Name ~= lplr.Name then
            pcall(function()
                v.Character.Head.Size = Vector3.new(2, 1, 1)
            end)
        end
    end
end