if not lagEnabled then
    getgenv().lagEnabled = true
else
    getgenv().lagEnabled = false
end

local enabled = true

game:GetService("UserInputService").InputEnded:Connect(function(input, processed)
    if lagEnabled and input.KeyCode == Enum.KeyCode.G and not processed then
        settings():GetService("NetworkSettings").IncomingReplicationLag = enabled and 1000 or 0
        enabled = not enabled
    end
end)