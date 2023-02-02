--Game: https://www.roblox.com/games/10700669209/RAID-Control-Army
loadstring(game:HttpGet("https://raw.githubusercontent.com/2kbyte/public/main/uwuware-lib-fork.lua/proxima-lib.lua", true))()

local Player = game:GetService("Players").LocalPlayer
local Character = game:GetService("Players").LocalPlayer.Character
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GetServiceModule = require(ReplicatedStorage.GetService)
syn_context_set(2)
local DataService = GetServiceModule("DataServiceClient")
syn_context_set(7)

local GeneralTab = library:AddTab("General")
local GeneralColumn1 = GeneralTab:AddColumn()
local GeneralColumn2 = GeneralTab:AddColumn()

local AutoSection = GeneralColumn1:AddSection("Automatic")
AutoSection:AddToggle({text = "Auto Sell", callback = function(State)
    if State and library.flags["Auto Sell"] then
        library:AddConnection(RunService.RenderStepped, "Auto Sell", function()
            if library.flags["Auto Sell"] then
                local Meter = Character.Backpack:WaitForChild("Bar").SurfaceGui.Meter
                if not Plot then
                    for i, v in pairs(Workspace:GetChildren()) do
                        if v.Name:match("Plot") then
                            if v.PLAYERNAME.SurfaceGui.TextLabel.Text == Player.Name then
                                getgenv().Plot = v
                            else
                                if v.PLAYERNAME.SurfaceGui.TextLabel.Text == "Unclaimed" then
                                    ReplicatedStorage.RemoteEvent:FireServer("ClaimPlot", v.Name)
                                end
                            end
                        end
                    end
                end
                if Meter then
                    if Meter.BackgroundColor3.R * 100 > library.flags["Sell At"] then
                        repeat
                            wait()
                            Character.HumanoidRootPart.CFrame = Plot.ZONE.CFrame + Vector3.new(0, -10, 0)
                        until Meter.BackgroundColor3.R == 0
                    end
                end
            else
                library.connections["Auto Sell"]:Disconnect()
            end
        end)
    end
end}):AddSlider({text = "Sell At", min = 5, max = 100, value = 90, suffix = "%"})

AutoSection:AddToggle({text = "Auto Claim Dispensers", callback = function(State)
    if State and library.flags["Auto Claim Dispensers"] then
        library.options["Claim Dispensers"].callback()
        library:AddConnection(RunService.RenderStepped, "Auto Claim", function()
            if library.flags["Auto Claim Dispensers"] then
                for i, v in pairs(Workspace.Dispensers:GetChildren()) do
                    if Workspace:GetServerTimeNow() - (DataService:Get(v.Name .. "_D")) > 300 then
                        ReplicatedStorage.RemoteEvent:FireServer("Dispenser", v.Name)
                    end
                end
            else
                library.connections["Auto Claim"]:Disconnect()
            end
        end)
    end
end})
function GetClosest()
    local Closest = nil
    local ShortestDistance = math.huge

    for i, v in pairs(Workspace.Objects:GetChildren()) do
        local Distance = (Character.HumanoidRootPart.Position - v:FindFirstChildWhichIsA("Part").Position).Magnitude
        if Distance < library.flags["Aura Range"] and Distance < ShortestDistance and v.HP.Value ~= 0 then
            Closest = v
            ShortestDistance = Distance
        end
    end

    return Closest
end

AutoSection:AddToggle({text = "Hit Aura", callback = function(State)
    if State and library.flags["Hit Aura"] then
        getgenv().Tool = Character:FindFirstChildWhichIsA("Tool")

        while library.flags["Hit Aura"] do
            wait(.4)
            if Tool.Name:match("Wand") then

                local Object = GetClosest()
                if not Object or Object.HP.Value == 0 then
                    Object = GetClosest()
                end
                ReplicatedStorage.RemoteEvent:FireServer("Attack", Object)
            end
        end
    end
end}):AddSlider({text = "Aura Range", min = 10, max = 60, value = 25, suffix = " studs"})

local MiscSection = GeneralColumn1:AddSection("Misc")
MiscSection:AddButton({text = "Claim Codes", callback = function()
    for i, v in pairs(Workspace:GetChildren()) do
        if v:FindFirstChild("Code") then
            ReplicatedStorage.RemoteFunction:InvokeServer("UseCode", v.Code.TextLabel.Text)
        end
    end
end})

MiscSection:AddButton({text = "Claim Dispensers", callback = function()
    for i, v in pairs(Workspace.Dispensers:GetChildren()) do
        local TimeLeft = Workspace:GetServerTimeNow() - (DataService:Get(v.Name .. "_D"))
        if TimeLeft > 300 then
            ReplicatedStorage.RemoteEvent:FireServer("Dispenser", v.Name)
        else
            library:SendNotification(2, "Dispeners on cooldown:\n" .. math.round(300 - TimeLeft) .. " seconds left")
            break
        end
    end
end})

MiscSection:AddButton({text = "Collect Gems", callback = function()
    for i, v in pairs(Workspace.GemSpawns:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            for i = 1, 10 do
                Character.HumanoidRootPart.CFrame = CFrame.new(v.Parent.Position) + Vector3.new(0, 2, 0)
                wait(0.05)
                fireproximityprompt(v)
            end
            v:Destroy()
        end
    end
end})

MiscSection:AddButton({text = "Remove Doors", callback = function()
    for i, v in pairs(Workspace.Doors:GetChildren()) do
        v.CanCollide = false    
    end
    for i, v in pairs(Workspace.Maps:GetDescendants()) do
        if v:IsA("TouchTransmitter") then
            v:Remove()
            v.Parent.CanCollide = false
        end
    end
end})

local ShopSection = GeneralColumn2:AddSection("Shops")
local function OpenShop(shop)
    Character.HumanoidRootPart.CFrame = Workspace[shop].HIT.CFrame + Vector3.new(0, -3, 0)
    for i = 1, 2 do
        repeat wait() until Player.PlayerGui.MainUI.TopSide.Interact.CONTAINER.Icon.AbsolutePosition.Y > 0
        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
        wait(.05)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end
end

ShopSection:AddButton({text = "Bag Shop", callback = function()
    OpenShop("BagShop")
end})
ShopSection:AddButton({text = "Tool Shop", callback = function()
    OpenShop("ToolShop")
end})
ShopSection:AddButton({text = "Army Shop", callback = function()
    OpenShop("BarackShop")
end})
ShopSection:AddButton({text = "Weapon Shop", callback = function()
    OpenShop("WeaponShop")
end})
ShopSection:AddButton({text = "Armor Shop", callback = function()
    OpenShop("ArmorShop")
end})
ShopSection:AddButton({text = "Basic Gear Shop", callback = function()
    OpenShop("BasicGearShop")
end})
ShopSection:AddButton({text = "Good Gear Shop", callback = function()
    OpenShop("GoodGearShop")
end})
ShopSection:AddButton({text = "Ouroboros Shop", callback = function()
    OpenShop("ouroborosshop")
end})
ShopSection:AddButton({text = "Aqua Shop", callback = function()
    OpenShop("AquaShop")
end})
ShopSection:AddButton({text = "Mushroom Shop", callback = function()
    OpenShop("MushroomShop")
end})
ShopSection:AddButton({text = "Magic Forest Shop", callback = function()
    OpenShop("magicforestshop")
end})

local NPCSection = GeneralColumn2:AddSection("NPCs")
local function OpenNPC(part)
    Character.HumanoidRootPart.CFrame = part.CFrame
    repeat wait() until Player.PlayerGui.MainUI.TopSide.Interact.CONTAINER.Icon.AbsolutePosition.Y > 0
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
    wait(.05)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

NPCSection:AddButton({text = "Sell NPC", callback = function()
    OpenNPC(Workspace["I'll buy your stuff"]:WaitForChild("HumanoidRootPart"))
end})
NPCSection:AddButton({text = "Enchanter NPC", callback = function()
    OpenNPC(Workspace.Enchanter.Enchanter:WaitForChild("HumanoidRootPart"))
end})
NPCSection:AddButton({text = "Crafter NPC", callback = function()
    OpenNPC(Workspace.Crafter.Crafter:WaitForChild("HumanoidRootPart"))
end})

library:Init()
library:selectTab(library.tabs[1])
