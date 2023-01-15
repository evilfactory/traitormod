local event = {}

event.Name = "OutpostPirateAttack"
event.MinRoundTime = 0
event.MinIntensity = 0
event.MaxIntensity = 1
event.ChancePerMinute = 0
event.OnlyOncePerRound = true

event.Init = function()

end

event.Start = function()
    local outpost = Level.Loaded.EndOutpost.WorldPosition

    local targets = {}

    for key, character in pairs(Character.CharacterList) do
        if character.IsRemotePlayer and character.IsHuman and not character.IsDead and Vector2.Distance(character.WorldPosition, outpost) < 5000 then
            table.insert(targets, character)
        end
    end

    if #targets == 0 then
        event.End()
        return
    end

    -- time to strike...

    event.Pirates = {}

    for i = 1, 2, 1 do
        local info = CharacterInfo(Identifier("human"))
        info.Name = "Pirate " .. info.Name
        info.Job = Job(JobPrefab.Get("securityofficer"))

        local character = Character.Create(info, outpost - Vector2(0, 5000), info.Name, 0, false, true)

        table.insert(event.Pirates, character)

        character.CanSpeak = false
        character.TeamID = CharacterTeamType.Team2
        character.GiveJobItems(nil)

        local idCard = character.Inventory.GetItemInLimbSlot(InvSlotType.Card)
        if idCard then
            idCard.NonPlayerTeamInteractable = true
            local prop = idCard.SerializableProperties[Identifier("NonPlayerTeamInteractable")]
            Networking.CreateEntityEvent(idCard, Item.ChangePropertyEventData(prop, idCard))
        end

        local headset = character.Inventory.GetItemInLimbSlot(InvSlotType.Headset)
        if headset then
            local wifi = headset.GetComponentString("WifiComponent")
            if wifi then
                wifi.TeamID = CharacterTeamType.Team1
            end
        end

        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("pucs"), character.Inventory, nil, nil, function (item)
            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("combatstimulantsyringe"), item.OwnInventory)
            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("oxygenitetank"), item.OwnInventory)
        end)

        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("shotgun"), character.Inventory, nil, nil,
            function(item)
                for i = 1, 6, 1 do
                    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("shotgunshell"), item.OwnInventory)
                end
            end)
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("smg"), character.Inventory, nil, nil,
            function(item)
                Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("smgmagazine"), item.OwnInventory)
            end)

        for i = 1, 4, 1 do
            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("antibiotics"), character.Inventory)
        end

        local oldClothes = character.Inventory.GetItemInLimbSlot(InvSlotType.InnerClothes)
        oldClothes.Drop()
        Entity.Spawner.AddEntityToRemoveQueue(oldClothes)

        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("pirateclothes"), character.Inventory, nil, nil,
            function(item)
                character.Inventory.TryPutItem(item, character.Inventory.FindLimbSlot(InvSlotType.InnerClothes), true,
                    false, character)
            end)
    end

    local function getClosetTarget(position)
        local closestTarget = nil
        for key, value in pairs(targets) do
            if not value.IsDead and (not closestTarget or Vector2.Distance(value.WorldPosition, position) < Vector2.Distance(closestTarget.WorldPosition, position)) then
                closestTarget = value
            end
        end
        return closestTarget
    end

    local timer = 0
    Hook.Add("think", "OutpostPirateAttack.Think", function ()
        if timer > Timer.GetTime() then return end
        timer = Timer.GetTime() + 30

        for key, value in pairs(event.Pirates) do
            local target = getClosetTarget(value.WorldPosition)

            if target == nil then break end

            local orderPrefab = OrderPrefab.Prefabs["follow"]
            local order = Order(orderPrefab, nil, target).WithManualPriority(CharacterInfo.HighestManualOrderPriority)
            value.SetOrder(order, true, false, true)

            if Vector2.Distance(value.WorldPosition, target.WorldPosition) < 50 then
                value.AIController.AddCombatObjective(AIObjectiveCombat.CombatMode.Offensive, target)
            end
        end
    end)
end


event.End = function(isEndRound)

end

return event
