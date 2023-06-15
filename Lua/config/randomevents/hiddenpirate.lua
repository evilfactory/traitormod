local event = {}

event.Name = "HiddenPirate"
event.MinRoundTime = 5
event.MinIntensity = 0
event.MaxIntensity = 0.3
event.ChancePerMinute = 0.018
event.OnlyOncePerRound = true

event.Start = function ()
    local areas = {}
    
    for key, value in pairs(Submarine.MainSub.GetItems(true)) do
        if value.Prefab.Identifier == "pump" then
            table.insert(areas, value)
        end
    end

    if #areas == 0 then return end

    local area = areas[math.random(#areas)]

    local info = CharacterInfo(Identifier("human"))
    info.Name = "Pirate " .. info.Name
    info.Job = Job(JobPrefab.Get("securityofficer"))

    local character = Character.Create(info, area.WorldPosition, info.Name, 0, false, true)

    character.TeamID = CharacterTeamType.Team2
    character.GiveJobItems(nil)

    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("revolver"), character.Inventory, nil, nil, function (item)
        for i = 1, 6, 1 do
            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("revolverround"), item.OwnInventory)
        end
    end)

    local oldClothes = character.Inventory.GetItemInLimbSlot(InvSlotType.InnerClothes)
    oldClothes.Drop()
    Entity.Spawner.AddEntityToRemoveQueue(oldClothes)

    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("pirateclothes"), character.Inventory, nil, nil, function (item)
        character.Inventory.TryPutItem(item, character.Inventory.FindLimbSlot(InvSlotType.InnerClothes), true, false, character)
    end)

    --local text = "An enemy pirate has been detected near the pumps."
    --Traitormod.RoundEvents.SendEventMessage(text, "GameModeIcon.sandbox")

    event.End()
end


event.End = function ()

end

return event