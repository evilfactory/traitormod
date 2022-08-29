local event = {}

-- Intense, can go from 0 to 1, defines how intense the round needs to be for the event to be triggered, 0 meaning the round is very chill and calm, 1 being that everything that could go wrong, has gone wrong.
-- MinRoundTime, the minimum amount of time that needs to be passed before the event can be triggered.
-- MaxRoundTime, same as above, but for max
-- ChancePerMinute, Every minute, this will roll a random to number to check if the event should be triggered.


event.Enabled = true
event.Name = "CommunicationsOffline"
event.MinRoundTime = 10
event.MinIntensity = 0
event.MaxIntensity = 0.2
event.ChancePerMinute = 0.01
event.OnlyOncePerRound = true

event.AmountTime = 5 -- Communications are offline for 5 minutes


event.Start = function ()

    local text = "Something is interfering with all our communications systems. It's been estimated that communications will be offline for atleast " .. event.AmountTime .. " minutes."

    for key, value in pairs(Client.ClientList) do
        local messageChat = ChatMessage.Create("", text, ChatMessageType.Default, nil, nil)
        messageChat.Color = Color(200, 30, 241, 255)
        Game.SendDirectChatMessage(messageChat, value)

        local messageBox = ChatMessage.Create("", text, ChatMessageType.ServerMessageBoxInGame, nil, nil)
        messageBox.IconStyle = "GameModeIcon.multiplayercampaign"
        Game.SendDirectChatMessage(messageBox, value)
    end

    for key, item in pairs(Item.ItemList) do
        if item ~= nil and item.Prefab.Identifier == "headset" then
            item.GetComponentString("WifiComponent").Range = 0;
        end
    end

    Hook.Add("item.created", "CommunicationsOffline.Item.Created", function (item)
        if item ~= nil and item.Prefab.Identifier == "headset" then
            item.GetComponentString("WifiComponent").Range = 10;
        end
    end)

    Timer.Wait(event.End, event.AmountTime * 60 * 1000)
end

event.End = function (isEndRound)
    Hook.Remove("item.created", "CommunicationsOffline.Item.Created")

    for key, item in pairs(Item.ItemList) do
        if item ~= nil and item.Prefab.Identifier == "headset" then
            item.GetComponentString("WifiComponent").Range = 35000;
        end
    end

    if not isEndRound then
        local text = "Communications are back online."

        for key, value in pairs(Client.ClientList) do
            local messageChat = ChatMessage.Create("", text, ChatMessageType.Default, nil, nil)
            messageChat.Color = Color(200, 30, 241, 255)
            Game.SendDirectChatMessage(messageChat, value)

            local messageBox = ChatMessage.Create("", text, ChatMessageType.ServerMessageBoxInGame, nil, nil)
            messageBox.IconStyle = "GameModeIcon.multiplayercampaign"
            Game.SendDirectChatMessage(messageBox, value)
        end
    end
end

return event