local event = {}

event.Name = "MedicalDelivery"
event.MinRoundTime = 5
event.MinIntensity = 0.6
event.MaxIntensity = 1
event.ChancePerMinute = 0.03
event.OnlyOncePerRound = false

local cratePrefab = ItemPrefab.GetItemPrefab("mediccrate")
local items = {"antibleeding1", "antibleeding1", "antibleeding1", "antibleeding1","antibleeding1", "antibleeding1", "antibleeding2", "antibleeding2", "antibloodloss1", "antibloodloss1", "antibloodloss1", "alienblood", "alienblood", "alienblood", "antidama1", "antidama1", "antidama1", "stabilozine", "stabilozine", "stabilozine", "stabilozine", "stabilozine", "stabilozine", "stabilozine","stabilozine", "ethanol", "ethanol", "antibiotics", "calyxanide", "calyxanide", "energydrink", "energydrink", "proteinbar", "proteinbar"}

event.Start = function ()
    local position = nil

    for key, value in pairs(Submarine.MainSub.GetWaypoints(true)) do
        if value.AssignedJob and value.AssignedJob.Identifier == "medicaldoctor" then
            position = value.WorldPosition
            break
        end
    end

    if position == nil then
        position = Submarine.MainSub.WorldPosition
    end

    Entity.Spawner.AddItemToSpawnQueue(cratePrefab, position, nil, nil, function(item)
        item.SpriteColor = Color(255, 0, 0, 255)
        local property = item.SerializableProperties[Identifier("SpriteColor")]
        Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(property, item))

        for key, value in pairs(items) do
            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab(value), item.OwnInventory)
        end
    end)

    local text = Traitormod.Language.MedicalDelivery
    Traitormod.RoundEvents.SendEventMessage(text, "GameModeIcon.sandbox")

    event.End()
end


event.End = function ()

end

return event