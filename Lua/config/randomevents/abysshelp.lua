local event = {}

event.Enabled = true
event.Name = "AbyssHelp"
event.MinRoundTime = 2
event.MaxRoundTime = 20
event.MinIntensity = 0
event.MaxIntensity = 1
event.ChancePerMinute = 0.01
event.OnlyOncePerRound = true

event.Init = function ()
    if Traitormod.SubmarineBuilder == nil then return end

    event.SubmarineID = Traitormod.SubmarineBuilder.AddSubmarine(Traitormod.Path .. "/Submarines/Borebug.sub", "???")
end


event.Start = function ()
    if event.SubmarineID == nil then return end

    local submarine = Traitormod.SubmarineBuilder.FindSubmarine(event.SubmarineID)
    submarine.GodMode = false

    submarine.SetPosition(Vector2(-5000, Level.Loaded.BottomPos + 10000))
    submarine.RealWorldCrushDepth = 10000
    Traitormod.SubmarineBuilder.ResetSubmarineSteering(submarine)

    local info = CharacterInfo(Identifier("human"))
    info.Job = Job(JobPrefab.Get("captain"))
    info.TeamID = CharacterTeamType.FriendlyNPC
    local character = Character.Create(info, submarine.WorldPosition, info.Name, 0, false, true)
    character.GiveJobItems(nil)

    local headset = character.Inventory.GetItemInLimbSlot(InvSlotType.Headset)
    headset.GetComponentString("WifiComponent").TeamID = CharacterTeamType.Team1

    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("combatdivingsuit"), character.Inventory, nil, nil, function (item)
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("combatstimulantsyringe"), item.OwnInventory)
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("oxygenitetank"), item.OwnInventory)
    end)

    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("revolver"), character.Inventory, nil, nil, function (item)
        for i = 1, 6, 1 do
            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("revolverround"), item.OwnInventory)
        end
    end)

    for i = 1, 4, 1 do
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("oxygenitetank"), character.Inventory)   
    end

    local points = math.floor(submarine.RealWorldDepth)

    local text = "Incoming Distress Call... H---! -e-----uck i- --e abys-- W- n--d -e-- A l--her dr---e- us d--- her-. ---se -e a-e of--ring ----thing w- -ave, inclu--- our ---0 -o------"
    Traitormod.RoundEvents.SendEventMessage(text, "UnlockPathIcon")

    Traitormod.RoundEvents.SendEventMessage("The transmission cuts out right after.", "UnlockPathIcon")

    event.Phase = 1

    Hook.Add("think", "AbyssHelp.Check", function ()
        if character.IsDead then
            local failurePoints = points / 2
            Traitormod.SpawnPointItem(character.Inventory, failurePoints, "I guess that's how it ends...\n\n This PDA contains " .. failurePoints .. " points.")

            event.End()
            return
        end

        if event.Phase == 2 and character.WorldPosition.Y > Level.Loaded.AbyssStart - 500 then
            character.Speak("I can't believe we made out alive, thank you so much! Here is the points i promised, i dropped for you a cargo scooter with a PDA inside, containing the points i promised.", nil, 0, '', 0)

            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("cargoscooter"), character.Inventory, nil, nil, function (item)
                Traitormod.SpawnPointItem(item.OwnInventory, points, "This PDA contains " .. points .. " points.")
                
                Timer.Wait(function() item.Drop() end, 3000)
            end)

            event.Phase = 3

            event.End()
            return
        end

        for key, value in pairs(Client.ClientList) do
            if value.Character ~= nil and not value.Character.IsDead and event.Phase == 1 and Vector2.Distance(value.Character.WorldPosition, character.WorldPosition) < 500 then
                character.Speak("Holy shit! Someone came! Thank you so much! Please find a way to get us out here, i'm gonna give you " .. points .. " of my points if i get out alive.", nil, 0, '', 0)

                local orderPrefab = OrderPrefab.Prefabs["follow"]
                local order = Order(orderPrefab, nil, value.Character).WithManualPriority(CharacterInfo.HighestManualOrderPriority)
                character.SetOrder(order, true, false, true)

                event.Phase = 2
                break
            end


        end
    end)
end


event.End = function ()
    Hook.Remove("think", "AbyssHelp.Check")
end

return event