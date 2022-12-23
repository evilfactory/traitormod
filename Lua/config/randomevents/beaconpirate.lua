local event = {}

event.Enabled = true
event.Name = "BeaconPirate"
event.MinRoundTime = 3
event.MaxRoundTime = 20
event.MinIntensity = 0
event.MaxIntensity = 1
event.ChancePerMinute = 0.15
event.OnlyOncePerRound = true

event.AmountPoints = 1500
event.AmountPointsPirate = 1300

event.Start = function ()
    local beacon = Level.Loaded.BeaconStation

    if beacon == nil then
        return
    end

    local info = CharacterInfo(Identifier("human"))
    info.Name = "Pirate " .. info.Name
    info.Job = Job(JobPrefab.Get("mechanic"))

    local character = Character.Create(info, beacon.WorldPosition, info.Name, 0, false, true)
    event.Character = character
    event.Beacon = beacon

    character.CanSpeak = false
    character.TeamID = CharacterTeamType.Team2
    character.GiveJobItems(nil)

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

    for i = 1, 2, 1 do
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("shotgun"), character.Inventory, nil, nil, function (item)
            for i = 1, 6, 1 do
                Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("shotgunshell"), item.OwnInventory)
            end
        end)
    end

    for i = 1, 2, 1 do
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("smg"), character.Inventory, nil, nil, function (item)
            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("smgmagazine"), item.OwnInventory)
        end)
    end

    for i = 1, 4, 1 do
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("antibiotics"), character.Inventory)
    end
    local toolbelt = character.Inventory.GetItemInLimbSlot(InvSlotType.Bag)
    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("antidama1"), toolbelt.OwnInventory)
    for i = 1, 4, 1 do
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

    local text = "There have been reports about a notorious pirate with a PUCS suit terrorizing these waters, the pirate was detected recently inside a beacon station - eliminate the pirate to claim a reward of " .. event.AmountPoints .. " points for the entire crew."
    Traitormod.RoundEvents.SendEventMessage(text, "CrewWalletIconLarge")

    Traitormod.GhostRoles.Ask("Beacon Pirate", function (client)
        Traitormod.LostLivesThisRound[client.SteamID] = true
        client.SetClientCharacter(character)

        Traitormod.SendMessageCharacter(character, "You are a pirate! Protect the beacon station from any filthy coalitions trying to get what is yours! \n\nSurviving inside the beacon station until the end of the round will grant you " .. event.AmountPointsPirate .." points.", "InfoFrameTabButton.Mission")
    end, character)

    Hook.Add("think", "BeaconPirate.Think", function ()
        if character.IsDead then
            event.End()
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
                Traitormod.SendMessage(client, "You have received " .. event.AmountPointsPirate .. " points.", "InfoFrameTabButton.Mission")
            end
        end

        return
    end

    local text = "The PUCS pirate has been killed, the crew has received a reward of " .. event.AmountPoints .. " points."

    Traitormod.RoundEvents.SendEventMessage(text, "CrewWalletIconLarge")

    for _, client in pairs(Client.ClientList) do
        if client.Character and not client.Character.IsDead and client.Character.TeamID == CharacterTeamType.Team1 then
            Traitormod.AwardPoints(client, event.AmountPoints)
            Traitormod.SendMessage(client, "You have received " .. event.AmountPoints .. " points.", "InfoFrameTabButton.Mission")
        end
    end
end

return event