local event = {}

event.Enabled = true
event.Name = "PirateCrew"
event.MinRoundTime = 0
event.MaxRoundTime = 0
event.MinIntensity = 0
event.MaxIntensity = 0
event.ChancePerMinute = 0
event.OnlyOncePerRound = true

event.AmountPoints = 900

event.Init = function ()
    if Traitormod.SubmarineBuilder == nil then return end

    event.SubmarineID = Traitormod.SubmarineBuilder.AddSubmarine(Traitormod.Path .. "/Submarines/DugongPirate.sub", "Pirate Submarine")
end

event.Start = function ()
    if event.SubmarineID == nil then return end
    if not Traitormod.SubmarineBuilder.IsActive then return end

    local submarine = Traitormod.SubmarineBuilder.FindSubmarine(event.SubmarineID)
    event.Submarine = submarine

    submarine.GodMode = false

    local closestToOutpost = Vector2.Zero

    local minDistance = 25000

    for _, spawnPosition in pairs(Level.Loaded.PositionsOfInterest) do
        if spawnPosition.PositionType == Level.PositionType.MainPath then
            local position = spawnPosition.Position.ToVector2()
            local distance = Vector2.Distance(position, Level.Loaded.EndOutpost.WorldPosition)

            if distance > minDistance then
                if distance < Vector2.Distance(closestToOutpost, Level.Loaded.EndOutpost.WorldPosition) then
                    closestToOutpost = position
                end
            end
        end
    end

    if closestToOutpost == Vector2.Zero then
        closestToOutpost = Level.Loaded.EndOutpost.WorldPosition - Vector2(0, 5000)
    end

    for key, item in pairs(submarine.GetItems(false)) do
        if item.HasTag("reactor") then
            item.GetComponentString("Reactor").PowerUpImmediately()
            event.Reactor = item
        end

        item.Condition = item.MaxCondition

        local repairable = item.GetComponentString("Repairable")
        if repairable then repairable.ResetDeterioration() end

        local powerContainer = item.GetComponentString("PowerContainer")
        if powerContainer then powerContainer.Charge = powerContainer.Capacity end
    end

    submarine.SetPosition(closestToOutpost)
    Traitormod.SubmarineBuilder.ResetSubmarineSteering(submarine)

    event.Pirates = {}

    local crew = {"mechanic", "engineer", "captain", "securityofficer"}
    for k, v in pairs(crew) do
        local info = CharacterInfo(Identifier("human"))
        info.Name = "Pirate " .. info.Name
        info.Job = Job(JobPrefab.Get(v))

        local character = Character.Create(info, submarine.WorldPosition, info.Name, 0, false, true)

        table.insert(event.Pirates, character)

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

        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("shotgun"), character.Inventory, nil, nil, function (item)
            for i = 1, 6, 1 do
                Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("shotgunshell"), item.OwnInventory)
            end
        end)
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("smg"), character.Inventory, nil, nil, function (item)
            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("smgmagazine"), item.OwnInventory)
        end)

        for i = 1, 4, 1 do
            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("antibiotics"), character.Inventory)
        end

        local oldClothes = character.Inventory.GetItemInLimbSlot(InvSlotType.InnerClothes)
        oldClothes.Drop()
        Entity.Spawner.AddEntityToRemoveQueue(oldClothes)

        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("pirateclothes"), character.Inventory, nil, nil, function (item)
            character.Inventory.TryPutItem(item, character.Inventory.FindLimbSlot(InvSlotType.InnerClothes), true, false, character)
        end)

        Traitormod.GhostRoles.Ask("Pirate Crew " .. k, function (client)
            Traitormod.LostLivesThisRound[client.SteamID] = false
            client.SetClientCharacter(character)

            Traitormod.SendMessageCharacter(character, Traitormod.Language.PirateCrewYou, "InfoFrameTabButton.Mission")
        end, character)
    end

    local text = string.format(Traitormod.Language.PirateCrew, event.AmountPoints)
    Traitormod.RoundEvents.SendEventMessage(text, "CrewWalletIconLarge")

    Hook.Add("think", "PirateCrew.Think", function ()
        local allDead = true
        for key, value in pairs(event.Pirates) do
            if not value.IsDead then
                allDead = false
            end
        end
        if event.Reactor.Condition <= 0 or allDead then
            event.End()
        end
    end)
end


event.End = function (isEndRound)
    Hook.Remove("think", "PirateCrew.Think")

    if isEndRound then
        return
    end

    local text = string.format(Traitormod.Language.PirateCrewSuccess, event.AmountPoints)

    Traitormod.RoundEvents.SendEventMessage(text, "CrewWalletIconLarge")

    for _, client in pairs(Client.ClientList) do
        if client.Character and not client.Character.IsDead and client.Character.TeamID == CharacterTeamType.Team1 then
            Traitormod.AwardPoints(client, event.AmountPoints)
            Traitormod.SendMessage(client, string.format(Traitormod.Language.ReceivedPoints, event.AmountPoints), "InfoFrameTabButton.Mission")
        end
    end
end

return event