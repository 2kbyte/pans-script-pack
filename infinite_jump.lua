getgenv().jumpHeight = 50

if not getgenv().jumpEnabled then
    getgenv().jumpEnabled = true
else
    getgenv().jumpEnabled = false
end

local uis = game:GetService("UserInputService")

function Action(Object, Function)
    if Object ~= nil then
        Function(Object)
    end
end

uis.InputBegan:Connect(function(UserInput)
    if jumpEnabled and UserInput.UserInputType == Enum.UserInputType.Keyboard and UserInput.KeyCode == Enum.KeyCode.Space then
        Action(game:GetService("Players").LocalPlayer.Character.Humanoid, function(self)
            if self:GetState() == Enum.HumanoidStateType.Jumping or self:GetState() == Enum.HumanoidStateType.Freefall then
                Action(self.Parent.HumanoidRootPart, function(self)
                    self.Velocity = Vector3.new(0, jumpHeight, 0)
                end)
            end
        end)
    end
end)