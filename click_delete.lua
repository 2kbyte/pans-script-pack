if not getgenv().delEnabled then
    getgenv().delEnabled = true 
else
    getgenv().delEnabled = false
end

local mouse = game:GetService("Players").LocalPlayer:GetMouse()

mouse.Button1Down:Connect(function()
    if delEnabled and game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftAlt) and mouse.Target then
        mouse.Target:Destroy()
    end
end)