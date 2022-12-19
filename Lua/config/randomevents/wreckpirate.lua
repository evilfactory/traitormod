local event = {}

event.Enabled = true
event.Name = "WreckPirate"
event.MinRoundTime = 4
event.MaxRoundTime = 15
event.MinIntensity = 0
event.MaxIntensity = 1
event.ChancePerMinute = 0.13
event.OnlyOncePerRound = true

event.AmountPoints = 1200

event.Start = function ()
    if #Level.Loaded.Wrecks == 0 then
        return
    end

    local wreck = Level.Loaded.Wrecks[1]

    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.Prefabs["sonarbeacon"], wreck.WorldPosition, nil, nil, function(item)
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.Prefabs["batterycell"], item.OwnInventory, nil, nil, function(bat)
            bat.Indestructible = true

            local interface = item.GetComponentString("CustomInterface")

            interface.customInterfaceElementList[1].State = true
            interface.customInterfaceElementList[2].Signal = "Last known pirate position"

            item.CreateServerEvent(interface, interface)

        end)
    end)

    local info = CharacterInfo(Identifier("human"))
    info.Job = Job(JobPrefab.Get("securityofficer"))

    local character = Character.Create(info, wreck.WorldPosition, info.Name, 0, false, true)

    character.TeamID = CharacterTeamType.Team2
    character.GiveJobItems(nil)

    for i = 1, 4, 1 do
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("shotgun"), character.Inventory, nil, nil, function (item)
            for i = 1, 6, 1 do
                Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("shotgunshell"), item.OwnInventory)
            end
        end)
    end

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

    local text = "There have been reports about a notorious pirate with a PUCS suit terrorizing these waters, the pirate was detected recently inside a wrecked submarine - eliminate the pirate and the crew shall claim a reward of " .. event.AmountPoints .. " points."
    Traitormod.RoundEvents.SendEventMessage(text, "CrewWalletIconLarge")

    Hook.Add("think", "WreckPirate.Think", function ()
        if character.IsDead then
            event.End()
        end
    end)
end


event.End = function (isEndRound)
    Hook.Remove("think", "WreckPirate.Think")

    if isEndRound then return end

    local text = "The PUCS pirate has been killed, the crew has received a reward of " .. event.AmountPoints .. " points."

    Traitormod.RoundEvents.SendEventMessage(text, "CrewWalletIconLarge")

    for _, client in pairs(Character.Controlled) do
        if client.Character and not client.Character.IsDead then
            Traitormod.AwardPoints(client, event.AmountPoints)
            Traitormod.SendMessage(client, "You have received " .. event.AmountPoints .. " points.", "InfoFrameTabButton.Mission")
        end
    end
end

return event