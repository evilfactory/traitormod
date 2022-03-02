local event = {}

event.Name = "CommunicationsOffline"

event.Start = function ()
    for _, item in pairs(Item.ItemList) do
        if item ~= nil and item.Prefab.Identifier == "headset" then
            item.GetComponentString("WifiComponent").Range = 10;
        end
    end

    Game.SendMessage("Some anomaly is stopping the radio from working!", ChatMessageType.ServerMessageBoxInGame)
    
    Game.SendMessage("Some anomaly is stopping the radio from working!", ChatMessageType.Error)
end

event.Think = function ()
    
end

event.End = function ()
    
end

return event