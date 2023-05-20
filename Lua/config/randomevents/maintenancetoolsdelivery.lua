local event = {}

event.Name = "MaintenanceToolsDelivery"
event.MinRoundTime = 5
event.MinIntensity = 0.6
event.MaxIntensity = 1
event.ChancePerMinute = 0.03
event.OnlyOncePerRound = false

local cratePrefab = ItemPrefab.GetItemPrefab("metalcrate")
local items = {"fixfoamgrenade", "fixfoamgrenade", "fixfoamgrenade", "fixfoamgrenade", "fixfoamgrenade", "fixfoamgrenade", "fixfoamgrenade", "fixfoamgrenade", "repairpack", "repairpack", "repairpack", "repairpack", "repairpack", "repairpack", "repairpack", "repairpack", "weldingtool", "weldingfueltank"}

event.Start = function ()
    local position = nil

    for key, value in pairs(Submarine.MainSub.GetWaypoints(true)) do
        if value.SpawnType == SpawnType.Cargo then
            position = value.WorldPosition
            break
        end
    end

    if position == nil then
        position = Submarine.MainSub.WorldPosition
    end

    Entity.Spawner.AddItemToSpawnQueue(cratePrefab, position, nil, nil, function(item)
        item.SpriteColor = Color(255, 255, 0, 255)
        local property = item.SerializableProperties[Identifier("SpriteColor")]
        Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(property, item))

        for key, value in pairs(items) do
            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab(value), item.OwnInventory)
        end
    end)

    local text = Traitormod.Language.MaintenanceToolsDelivery
    Traitormod.RoundEvents.SendEventMessage(text, "GameModeIcon.sandbox")

    event.End()
end


event.End = function ()

end

return event