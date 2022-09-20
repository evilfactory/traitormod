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

    event.SubmarineID = Traitormod.SubmarineBuilder.AddSubmarine(Traitormod.Path .. "/Submarines/BulblitKeras.sub", "???")
end


event.Start = function ()
    if event.SubmarineID == nil then return end

    local submarine = Traitormod.SubmarineBuilder.FindSubmarine(event.SubmarineID)
    submarine.GodMode = false

    submarine.SetPosition(Vector2(-5000, Level.Loaded.BottomPos + 10000))
    submarine.RealWorldCrushDepth = 10000
    Traitormod.SubmarineBuilder.ResetSubmarineSteering(submarine)

    local boom = Explosion(1000, 15, 20, 40, 20, 0)
    boom.Explode(submarine.WorldPosition)

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

    local points = math.floor(submarine.RealWorldDepth) * 3

    local text = "Incoming Distress Call... H---! -e-----uck i- --e abys-- W- n--d -e-- A l--her dr---e- us d--- her-. ---se -e a-e of--ring ----thing w- -ave, inclu--- our ---0 -o------"
    Traitormod.RoundEvents.SendEventMessage(text, "UnlockPathIcon")

    Traitormod.RoundEvents.SendEventMessage("The transmission cuts out right after.", "UnlockPathIcon")

    event.Phase = 1
    event.Timer = Timer.GetTime()

    Hook.Add("think", "AbyssHelp.Check", function ()
        if character == nil then return end

        if character.IsDead then
            local failurePoints = points / 2
            Traitormod.SpawnPointItem(character.Inventory, failurePoints, "I guess that's how it ends...\n\n This PDA contains " .. failurePoints .. " points.")

            event.End()
            character = nil

            return
        end

        if event.Phase == 2 and character.WorldPosition.Y > Level.Loaded.AbyssStart - 500 and character.CanSpeak then
            event.Phase = 3

            character.Speak("I can't believe we made it out alive, thank you so much! Here are the points I promised, take this cargo scooter and the LogBook inside. The LogBook should contain the points I promised.", nil, 0, '', 0)

            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("cargoscooter"), character.Inventory, nil, nil, function (item)
                Traitormod.SpawnPointItem(item.OwnInventory, points)
                
                Timer.Wait(function() item.Drop() end, 3000)
            end)

            event.End()
            return
        end

        local closestCharacter = nil

        for key, value in pairs(Client.ClientList) do
            if value.Character ~= nil and not value.Character.IsDead and event.Phase == 1 and Vector2.Distance(value.Character.WorldPosition, character.WorldPosition) < 400 and character.CanSpeak then
                event.Phase = 2

                character.Speak("Holy shit! Someone came! Thank you so much! Please find a way to get us out here, I'll give you " .. points .. " of my points if you can get me out alive.", nil, 0, '', 0)

                Timer.Wait(function ()
                    character.Speak("You could try to get a new battery for this submarine and fix it up.", nil, 0, '', 0)
                end, 4000)

                break
            end

            if event.Phase == 2 and value.Character ~= nil and not value.Character.IsDead then
                if closestCharacter == nil or Vector2.Distance(value.Character.WorldPosition, character.WorldPosition) < Vector2.Distance(closestCharacter.WorldPosition, character.WorldPosition) then
                    closestCharacter = value.Character
                end
            end
        end

        if event.Phase == 2 and closestCharacter ~= nil and Timer.GetTime() > event.Timer then
            local orderPrefab = OrderPrefab.Prefabs["follow"]
            local order = Order(orderPrefab, nil, closestCharacter).WithManualPriority(CharacterInfo.HighestManualOrderPriority)
            character.SetOrder(order, true, false, true)

            event.Timer = Timer.GetTime() + 10
        end
    end)
end


event.End = function ()
    Hook.Remove("think", "AbyssHelp.Check")
end

return event