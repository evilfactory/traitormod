local event = {}

event.Enabled = true
event.Name = "RepairPackDelivery"
event.MinRoundTime = 0
event.MinIntensity = 0.7
event.MaxIntensity = 1
event.ChancePerMinute = 0.08
event.OnlyOncePerRound = false

local repairPackPrefab = ItemPrefab.GetItemPrefab("repairpack")
local metalCratePrefab = ItemPrefab.GetItemPrefab("metalcrate")

event.Start = function ()
    local cargoPosition = nil

    for key, value in pairs(Submarine.MainSub.GetWaypoints(true)) do
        if value.SpawnType == SpawnType.Cargo then
            cargoPosition = value.WorldPosition
            break
        end
    end

    if cargoPosition == nil then
        cargoPosition = Submarine.MainSub.WorldPosition
    end

    Entity.Spawner.AddItemToSpawnQueue(metalCratePrefab, cargoPosition, nil, nil, function(item)
        item.SpriteColor = Color(0, 0, 255, 255)
        local property = item.SerializableProperties[Identifier("SpriteColor")]
        Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(property))

        for i = 1, 16, 1 do
            Entity.Spawner.AddItemToSpawnQueue(repairPackPrefab, item.OwnInventory)
        end
    end)

    local text = "A delivery of Repair Packs has been made into the cargo area of the ship, the Repair Packs are inside a blue crate."

    for key, value in pairs(Client.ClientList) do
        local messageChat = ChatMessage.Create("", text, ChatMessageType.Default, nil, nil)
        messageChat.Color = Color(200, 30, 241, 255)
        Game.SendDirectChatMessage(messageChat, value)

        local messageBox = ChatMessage.Create("", text, ChatMessageType.ServerMessageBoxInGame, nil, nil)
        messageBox.IconStyle = "GameModeIcon.sandbox"
        Game.SendDirectChatMessage(messageBox, value)
    end
end


event.End = function ()

end

return event