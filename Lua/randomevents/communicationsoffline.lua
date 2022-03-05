local event = {}

event.Name = "CommunicationsOffline"

event.Start = function ()
    for _, item in pairs(Item.ItemList) do
        if item ~= nil and item.Prefab.Identifier == "headset" then
            item.GetComponentString("WifiComponent").Range = 10;
        end
    end

    local message = "Some anomaly is stopping the radio from working!"

    Game.SendMessage(message, ChatMessageType.ServerMessageBoxInGame)
    Game.SendMessage(message, ChatMessageType.Error)
end

event.Think = function ()
    
end

event.End = function ()
    
end

return event