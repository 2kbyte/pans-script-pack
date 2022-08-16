if not spyEnabled then
    getgenv().spyEnabled = true
else
    getgenv().spyEnabled = false
end

getgenv().spyOnMyself = false
getgenv().public = false
getgenv().privateProperties = {
    Color = Color3.fromRGB(189, 147, 249),
    Font = Enum.Font.SourceSansBold,
    TextSize = 18
}

local sgui = game:GetService("StarterGui")
local plrs = game:GetService("Players")
local lplr = plrs.LocalPlayer or plrs:GetPropertyChangedSignal("LocalPlayer"):Wait() or plrs.LocalPlayer
local saymsg = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest")
local getmsg = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("OnMessageDoneFiltering")
local instance = (getgenv().chatSpyInstance or 0) + 1
getgenv().chatSpyInstance = instance

local function onChatted(plr, msg)
    if getgenv().chatSpyInstance == instance then
        if plr == lplr and msg:lower():sub(1, 6) == "/e spy" then
            getgenv().spyEnabled = not getgenv().spyEnabled
            wait(.2)
            privateProperties.Text = "{SPY "..(spyEnabled and "EN" or "DIS").."ABLED}"
            sgui:SetCore("ChatMakeSystemMessage", privateProperties)
        elseif spyEnabled and (spyOnMyself == true or plr ~= lplr) then
            msg = msg:gsub("[\n\r]", ''):gsub("\t", ' '):gsub("[ ]+", ' ')
            local hidden = true
            local conn = getmsg.OnClientEvent:Connect(function(packet, channel)
                if packet.SpeakerUserId == plr.UserId and packet.Message == msg:sub(#msg - #packet.Message + 1) and (channel == "All" or (channel == "Team" and public == false and plr.Team == lplr.Team)) then
                    hidden = false
                end
            end)
            wait(1)
            conn:Disconnect()
            if hidden and spyEnabled then
                privateProperties.Text = "{SPY} [".. plr.Name .."]: "..msg
                sgui:SetCore("ChatMakeSystemMessage", privateProperties)
            end
        end
    end
end

for i, v in ipairs(plrs:GetPlayers()) do
    v.Chatted:Connect(function(msg) onChatted(v, msg) end)
end
plrs.PlayerAdded:Connect(function(plr)
    plr.Chatted:Connect(function(msg) onChatted(plr, msg) end)
end)

privateProperties.Text = "{SPY "..(spyEnabled and "EN" or "DIS").."ABLED}"
sgui:SetCore("ChatMakeSystemMessage", privateProperties)