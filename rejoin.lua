local tps = game:GetService("TeleportService")
local plrs = game:GetService("Players")
local lplr = plrs.LocalPlayer

if #plrs:GetPlayers() <= 1 then
    lplr:Kick("Rejoining...")
    wait()
    tps:Teleport(game.PlaceId, lplr)
else
    tps:TeleportToPlaceInstance(game.PlaceId, game.JobId, lplr)
end
