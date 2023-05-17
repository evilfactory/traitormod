local event = {}

event.Name = "Prisoner"
event.MinRoundTime = 0
event.MaxRoundTime = 5
event.MinIntensity = 0
event.MaxIntensity = 0.3
event.ChancePerMinute = 0.07
event.OnlyOncePerRound = true
event.Award = 1500

event.Start = function ()
    local position = nil

    for key, value in pairs(Submarine.MainSub.GetWaypoints(true)) do
        if value.AssignedJob and value.AssignedJob.Identifier == "securityofficer" then
            position = value.WorldPosition
            break
        end
    end

    if position == nil then
        position = Submarine.MainSub.WorldPosition
    end

    local info = CharacterInfo(Identifier("human"))
    info.Name = "Prisoner " .. info.Name
    info.Job = Job(JobPrefab.Get("assistant"))

    local character = Character.Create(info, position, info.Name, 0, false, true)

    event.Character = character

    character.TeamID = CharacterTeamType.Team2
    character.GiveJobItems(nil)

    local oldClothes = character.Inventory.GetItemInLimbSlot(InvSlotType.InnerClothes)
    oldClothes.Drop()
    Entity.Spawner.AddEntityToRemoveQueue(oldClothes)

    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("prisonerclothes"), character.Inventory, nil, nil, function (item)
        character.Inventory.TryPutItem(item, character.Inventory.FindLimbSlot(InvSlotType.InnerClothes), true, false, character)
    end)

    for key, value in pairs(character.Inventory.AllItemsMod) do
        if value.Prefab.Identifier == "screwdriver" or value.Prefab.Identifier == "wrench" then
            value.Drop()
            Entity.Spawner.AddEntityToRemoveQueue(value)
        end
    end

    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("handcuffs"), character.Inventory, nil, nil, function (item)
        Timer.Wait(function (...)
            character.Inventory.TryPutItem(item, character.Inventory.FindLimbSlot(InvSlotType.LeftHand), true, true, nil)            
        end, 1000)
    end)


    local text = "A prisoner is aboard the submarine, keep the prisoner alive and handcuffed until the submarine arrives at it's destination for the crew to receive " .. tostring(event.Award) .. " Points."
    Traitormod.RoundEvents.SendEventMessage(text, "GameModeIcon.sandbox", Color.Yellow)

    Traitormod.GhostRoles.Ask("Prisoner", function (client)
        Traitormod.LostLivesThisRound[client.SteamID] = false
        client.SetClientCharacter(character)

        Traitormod.SendMessageCharacter(character, "You are a prisoner! If you manage to get 500 meters away from the submarine, you will be rewarded with " .. event.Award .." points.", "InfoFrameTabButton.Mission")
    end, character)

    Hook.Add("think", "Prisoner.Think", function ()
        if character.IsDead then
            event.End()
            return
        end

        if event.Character.Submarine == Submarine.MainSub then return end
        if Vector2.Distance(event.Character.WorldPosition, Submarine.MainSub.WorldPosition) < 5000 then return end

        local client = Traitormod.FindClientCharacter(event.Character)
        if client then
            Traitormod.AwardPoints(client, event.Award)
            Traitormod.SendMessage(client, "You have received " .. event.Award .. " points.", "InfoFrameTabButton.Mission")
        end

        event.End()
    end)
end


event.End = function (isEndRound)
    Hook.Remove("think", "Prisoner.Think")

    if event.Character and event.Character.IsDead then
        return
    end

    if isEndRound and Traitormod.EndReached(event.Character, 8000) then
        local text = "The prisoner has been successfully transported, the crew has received a reward of " .. event.Award .. " points."

        Traitormod.RoundEvents.SendEventMessage(text, "CrewWalletIconLarge")

        for _, client in pairs(Client.ClientList) do
            if client.Character and not client.Character.IsDead and client.Character.TeamID == CharacterTeamType.Team1 then
                if not Traitormod.RoleManager.IsAntagonist(client.Character) then
                    Traitormod.AwardPoints(client, event.Award)
                    Traitormod.SendMessage(client, "You have received " .. event.Award .. " points.", "InfoFrameTabButton.Mission")
                end
            end
        end
    else
        local text = "The prisoner has escaped and the transportation reward has been cancelled."
        Traitormod.RoundEvents.SendEventMessage(text, "InfoFrameTabButton.Mission", Color.Yellow)
    end
end

return event