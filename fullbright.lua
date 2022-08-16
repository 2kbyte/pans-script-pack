local lgt = game:GetService("Lighting")
pcall(function()
    lgt.Changed:Connect(function()
        lgt.ClockTime = 12
		lgt.FogEnd = 786543
		lgt.GlobalShadows = false
		lgt.Ambient = Color3.fromRGB(178, 178, 178)
    end)
end)