if not getgenv().tpEnabled then
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