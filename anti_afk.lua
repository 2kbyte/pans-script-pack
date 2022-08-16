for i, v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do
    if v["Disabled"] then
        v["Disable"](v)
    elseif v["Disconnect"] then
        v["Disconnect"](v)
    end
end