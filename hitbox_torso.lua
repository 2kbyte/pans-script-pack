getgenv().torsoSize = 15

if not getgenv().torsoEnabled then
    getgenv().torsoEnabled = true
else
    getgenv().torsoEnabled = false
end

local plrs = game:GetService("Players")
local lplr = plrs.LocalPlayer

if torsoEnabled then
    getgenv().torsoLoop = game:GetService("RunService").RenderStepped:Connect(function()
        for i, v in pairs(plrs:GetPlayers()) do
            if v.Name ~= lplr.Name then
                pcall(function()
                    v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really blue")
                    v.Character.HumanoidRootPart.CanCollide = false
                    v.Character.HumanoidRootPart.Material = "Neon"
                    v.Character.HumanoidRootPart.Size = Vector3.new(torsoSize, torsoSize, torsoSize)
                    v.Character.HumanoidRootPart.Transparency = 0.7
                end)
            end
        end
    end)
else
    torsoLoop:Disconnect()
    for i, v in pairs(plrs:GetPlayers()) do
        if v.Name ~= lplr.Name then
            pcall(function()
                v.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                v.Character.HumanoidRootPart.Transparency = 1
            end)
        end
    end
end