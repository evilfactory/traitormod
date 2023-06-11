local event = {}

event.Enabled = true
event.Name = "EmergencyTeam"
event.MinRoundTime = 5
event.MinIntensity = 0.8
event.MaxIntensity = 1
event.ChancePerMinute = 0.05
event.OnlyOncePerRound = true

event.Start = function()
    local areas = {}

    for key, value in pairs(Submarine.MainSub.GetHulls(true)) do
        if value.IsTaggedAirlock() then
            table.insert(areas, value)
        end
    end

    if #areas == 0 then
        table.insert(areas, Submarine.MainSub)
    end

    local area = areas[math.random(#areas)]

    for i = 1, 4, 1 do
        local info = CharacterInfo(Identifier("human"))
        info.Job = Job(JobPrefab.Get("staff"))

        local character = Character.Create(info, area.WorldPosition, info.Name, 0, false, true)

        character.GiveJobItems(nil)
        character.CanSpeak = false
        local idcard = character.Inventory.FindItemByIdentifier("idcard")
        idcard.AddTag("staff")
        idcard.AddTag("eng")

        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("divingsuit"), character.Inventory, nil, nil, function (item)
            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("oxygenitetank"), item.OwnInventory)
        end)

        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("weldingtool"), character.Inventory, nil, nil, function (item)
            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("weldingfueltank"), item.OwnInventory)
        end)

        local repairOrderPrefab = OrderPrefab.Prefabs["repairsystems"]
        local repairOrder = Order(repairOrderPrefab, nil, nil).WithManualPriority(CharacterInfo.HighestManualOrderPriority)
        character.SetOrder(repairOrder, true, false, true)

        local leakOrderPrefab = OrderPrefab.Prefabs["fixleaks"]
        local leakOrder = Order(leakOrderPrefab, nil, nil).WithManualPriority(CharacterInfo.HighestManualOrderPriority)
        character.SetOrder(leakOrder, true, false, true)
        character.TeamID = CharacterTeamType.FriendlyNPC
    end

    local text = "A group of maintenance workers have entered the submarine to assist with repairs."
    Traitormod.RoundEvents.SendEventMessage(text, "GameModeIcon.sandbox")

    event.End()
end



event.End = function()

end

return event
