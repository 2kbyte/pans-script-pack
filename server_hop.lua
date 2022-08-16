local servers = {}
local req = syn.request({Url = string.format("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100", game.PlaceId)})
local body = game:GetService("HttpService"):JSONDecode(req.Body)
if body and body.data then
    for i, v in next, body.data do
        if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
            table.insert(servers, 1, v.id)
        end
    end
    if #servers > 0 then
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], game:GetService("Players").LocalPlayer)
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Server Hop", Text = "Couldn't find a server.", Duration = 5})
    end
end