--https://www.roblox.com/games/10407295078/x2-Cash-Plushie-Tycoon-SANRIO
local library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wall%20v3')))()
local window = library:CreateWindow("AutoFarm")
local main = window:CreateFolder("Main")
local auto = window:CreateFolder("Auto")

local ws = game:GetService("Workspace")
local plrs = game:GetService("Players")
local lplr = plrs.LocalPlayer
local runs = game:GetService("RunService")
local humanoid = lplr.Character.HumanoidRootPart

main:Button("Teleport Obby", function()
    previous = humanoid.CFrame
    humanoid.CFrame = CFrame.new(317.338501, 0.644921541, 120.250023, 1, 0, 0, 0, 1, 0, 0, 0, 1)
    wait(.5)
    humanoid.CFrame = previous
end)

main:Button("Teleport Tyccon", function()
    for i, v in pairs(game:GetService("Workspace").Tycoons:GetDescendants()) do
        if v.Name == "Owner" and v.Value == game:GetService("Players").LocalPlayer.Name then
            humanoid.CFrame = v.Parent.ClaimPad.CFrame * CFrame.new(0, 5, 0)
        end
    end
end)

main:Button("Anti AFK", function()
    for i, v in pairs(getconnections(lplr.Idled)) do
        if v["Disabled"] then
            v["Disable"](v)
        elseif v["Disconnect"] then
            v["Disconnect"](v)
        end
    end
end)

main:Toggle("Click Tp", function(enabled)
    if enabled then
        getgenv().tpEnabled = true 
    else
        getgenv().tpEnabled = false
    end

    local mouse = game:GetService("Players").LocalPlayer:GetMouse()

    mouse.Button1Down:Connect(function()
        if tpEnabled and game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) and mouse.Target then
            game:GetService("Players").LocalPlayer.Character:MoveTo(mouse.Hit.p)
        end
    end)
end)

main:Slider("Walkspeed", {
    min = 16,
    max = 50,
}, function(value)
    game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

auto:Toggle("Auto Money", function(enabled)
    if enabled then
        previous = humanoid.CFrame
        getgenv().teleportLoop = game:GetService("RunService").RenderStepped:Connect(function()
            humanoid.CFrame = CFrame.new(317.338501, 0.644921541, 120.250023, 1, 0, 0, 0, 1, 0, 0, 0, 1)
        end)
    else
        teleportLoop:Disconnect()
        wait(.5)
        humanoid.CFrame = previous
    end
end)

auto:Toggle("Auto Obby", function(enabled)
    if enabled then
        getgenv().autoObby = runs.RenderStepped:Connect(function()
            if game:GetService("Players").LocalPlayer.PlayerGui.Main.Obby.Visible == false then
                previous = humanoid.CFrame
                humanoid.CFrame = CFrame.new(317.338501, 0.644921541, 120.250023, 1, 0, 0, 0, 1, 0, 0, 0, 1)
                wait(.5)
                humanoid.CFrame = previous
                wait(1)
            end
        end)
    else
        autoObby:Disconnect()
    end
end)

auto:Toggle("Auto Clicker", function(enabled)
    if enabled then
        for i, v in pairs(ws.Tycoons:GetChildren()) do
            if v.ClassName == "Folder" then
                for i, v in pairs(v:GetChildren()) do
                    if v.Name == "Owner" and v.Value == lplr.Name then
                        click = v.Parent.Clicker.ClickDetector
                    end
                end
            end
        end
        getgenv().clickLoop = runs.RenderStepped:Connect(function()
            if click.Parent.SurfaceGui.Frame.AbsoluteSize == Vector2.new(0, 37.5) then
                fireclickdetector(click)
            end
        end)
    else
        clickLoop:Disconnect()
    end
end)

auto:Toggle("Auto Collect", function(enabled)
    if enabled then
        for i, v in pairs(ws.Tycoons:GetChildren()) do
            if v.ClassName == "Folder" then
                for i, v in pairs(v:GetChildren()) do
                    if v.Name == "Owner" and v.Value == lplr.Name then
                        sell = v.Parent.SellCollector
                    end
                end
            end
        end
        getgenv().collectLoop = runs.RenderStepped:Connect(function()
            pcall(function()
                if sell.OverheadGUI.Frame.BuyName.Text ~= "$0" then
                    firetouchinterest(humanoid, sell, 0)
                    wait()
                    firetouchinterest(humanoid, sell, 1)
                end
            end)
        end)
    else
        collectLoop:Disconnect()
    end
end)

--[[
auto:Toggle("Auto-Click Whitelisted", function(enabled)
    if enabled then
        whiltelist = true
        for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Main.Profile.Whitelist:GetChildren()) do
            if v.ClassName == "TextButton" then
                if v.BackgroundColor3 == Color3.new(0.258824, 0.258824, 0.258824) then
                    if v.Name ~= game:GetService("Players").LocalPlayer.Name then
                        print(v.Name)
                    end
                end
            end
        end
    else
        whiltelist = false
    end
end)]]

auto:DestroyGui()
