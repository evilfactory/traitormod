local event = {}

event.Name = "BeaconPirate"
event.MinRoundTime = 3
event.MaxRoundTime = 20
event.MinIntensity = 0
event.MaxIntensity = 1
event.ChancePerMinute = 0.12
event.OnlyOncePerRound = true

event.AmountPoints = 800
event.AmountPointsPirate = 500

event.Start = function ()
    local beacon = Level.Loaded.BeaconStation

    if beacon == nil then
        return
    end

    local index = 0
    for key, value in pairs(Character.CharacterList) do
        if value.IsHuman and value.TeamID == CharacterTeamType.None and value.Submarine == beacon then
            value.Info.Name = "Pirate " .. value.Info.Name
            value.SetOriginalTeam(CharacterTeamType.Team2)
            value.UpdateTeam()
            value.CanSpeak = false

            Traitormod.GhostRoles.Ask("Beacon Pirate Helper " .. index, function (client)
                Traitormod.LostLivesThisRound[client.SteamID] = false
                client.SetClientCharacter(value)
            end, value)
            index = index + 1
        end
    end

    for key, wall in pairs(Structure.WallList) do
        if wall.Submarine == beacon then
            for i = 0, wall.SectionCount, 1 do
                wall.MaxHealth = wall.MaxHealth * 5
                wall.AddDamage(i, -1000000)
            end
        end
    end

    local info = CharacterInfo(Identifier("human"))
    info.Name = "Pirate " .. info.Name
    info.Job = Job(JobPrefab.Get("mechanic"))

    local character = Character.Create(info, beacon.WorldPosition, info.Name, 0, false, true)
    event.Character = character
    event.Beacon = beacon
    event.EnteredMainSub = false

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

    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.Prefabs["sonarbeacon"], beacon.WorldPosition, nil, nil, function(item)
        item.NonInteractable = true

        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.Prefabs["batterycell"], item.OwnInventory, nil, nil, function(bat)
            bat.Indestructible = true

            local interface = item.GetComponentString("CustomInterface")

            interface.customInterfaceElementList[1].State = true
            interface.customInterfaceElementList[2].Signal = "Last known pirate position"

            item.CreateServerEvent(interface, interface)
        end)
    end)

    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("shotgun"), character.Inventory, nil, nil, function (item)
        for i = 1, 6, 1 do
            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("shotgunshell"), item.OwnInventory)
        end
    end)

    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("smg"), character.Inventory, nil, nil, function (item)
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("smgmagazinedepletedfuel"), item.OwnInventory)
    end)

    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("smgmagazine"), character.Inventory)
    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("smgmagazine"), character.Inventory)

    for i = 1, 12, 1 do
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("shotgunshell"), character.Inventory)
    end

    for i = 1, 4, 1 do
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("antibiotics"), character.Inventory)
    end
    local toolbelt = character.Inventory.GetItemInLimbSlot(InvSlotType.Bag)
    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("antidama1"), toolbelt.OwnInventory)
    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("antidama1"), toolbelt.OwnInventory)
    for i = 1, 6, 1 do
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("antibleeding1"), toolbelt.OwnInventory)
    end
    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("alienblood"), toolbelt.OwnInventory)
    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("fuelrod"), toolbelt.OwnInventory)
    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("underwaterscooter"), toolbelt.OwnInventory, nil, nil, function (item)
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("batterycell"), item.OwnInventory)
    end)
    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("handheldsonar"), toolbelt.OwnInventory, nil, nil, function (item)
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("batterycell"), item.OwnInventory)
    end)

    local oldClothes = character.Inventory.GetItemInLimbSlot(InvSlotType.InnerClothes)
    oldClothes.Drop()
    Entity.Spawner.AddEntityToRemoveQueue(oldClothes)

    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("pirateclothes"), character.Inventory, nil, nil, function (item)
        character.Inventory.TryPutItem(item, character.Inventory.FindLimbSlot(InvSlotType.InnerClothes), true, false, character)
    end)

    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("pucs"), character.Inventory, nil, nil, function (item)
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("combatstimulantsyringe"), item.OwnInventory)
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("oxygenitetank"), item.OwnInventory)
    end)

    event.ItemReward = character.Inventory.GetItemInLimbSlot(InvSlotType.Card)

    local text = string.format(Traitormod.Language.BeaconPirate, event.AmountPoints)
    Traitormod.RoundEvents.SendEventMessage(text, "CrewWalletIconLarge")

    Traitormod.GhostRoles.Ask("Beacon Pirate", function (client)
        Traitormod.LostLivesThisRound[client.SteamID] = false
        client.SetClientCharacter(character)
    end, character)

    Hook.Add("think", "BeaconPirate.Think", function ()
        if character.IsDead then
            event.End()
        end

        if character.Submarine == Submarine.MainSub and not event.EnteredMainSub then
            event.EnteredMainSub = true
            Traitormod.RoundEvents.SendEventMessage(Traitormod.Language.PirateInside)
        end
    end)
end


event.End = function (isEndRound)
    Hook.Remove("think", "BeaconPirate.Think")

    if isEndRound then
        if event.Character and not event.Character.IsDead and event.Character.Submarine == event.Beacon then
            local client = Traitormod.FindClientCharacter(event.Character)
            if client then
                Traitormod.AwardPoints(client, event.AmountPointsPirate)
                Traitormod.SendMessage(client, string.format(Traitormod.Language.ReceivedPoints, event.AmountPointsPirate), "InfoFrameTabButton.Mission")
            end
        end

        return
    end

    local text = string.format(Traitormod.Language.PirateKilled, event.AmountPoints)

    Traitormod.RoundEvents.SendEventMessage(text, "CrewWalletIconLarge")

    for _, client in pairs(Client.ClientList) do
        if client.Character and not client.Character.IsDead and client.Character.TeamID == CharacterTeamType.Team1 then
            Traitormod.AwardPoints(client, event.AmountPoints)
            Traitormod.SendMessage(client, string.format(Traitormod.Language.ReceivedPoints, event.AmountPoints), "InfoFrameTabButton.Mission")
        end
    end
end

return event