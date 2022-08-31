local event = {}

event.Enabled = true
event.Name = "FixFoamDelivery"
event.MinRoundTime = 0
event.MinIntensity = 0.6
event.MaxIntensity = 1
event.ChancePerMinute = 0.06
event.OnlyOncePerRound = false

local fixFoamPrefab = ItemPrefab.GetItemPrefab("fixfoamgrenade")
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
        item.SpriteColor = Color(255, 255, 0, 255)
        local property = item.SerializableProperties[Identifier("SpriteColor")]
        Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(property))

        for i = 1, 8, 1 do
            Entity.Spawner.AddItemToSpawnQueue(fixFoamPrefab, item.OwnInventory) 
        end
    end)

    local text = "A delivery of Fix Foam Grenades has been made into the cargo area of the ship, the Fix Foam Grenades are inside a yellow crate."
    Traitormod.RoundEvents.SendEventMessage(text, "GameModeIcon.sandbox")

    event.End()
end


event.End = function ()

end

return event