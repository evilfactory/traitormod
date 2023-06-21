local timer = Timer.GetTime()

local huskBeacons = {}

Traitormod.AddHuskBeacon = function (item, time)
    huskBeacons[item] = time
end


local peopleInOutpost = 0
local ghostRoleNumber = 1
Hook.Add("think", "Traitormod.MiscThink", function ()
    if timer > Timer.GetTime() then return end
    if not Game.RoundStarted then return end

    for item, _ in pairs(huskBeacons) do
        local interface = item.GetComponentString("CustomInterface")
        if interface.customInterfaceElementList[1].State then
            huskBeacons[item] = huskBeacons[item] - 5
        end

        if huskBeacons[item] <= 0 then
            for i = 1, 4, 1 do
                Entity.Spawner.AddCharacterToSpawnQueue("husk", item.WorldPosition)
            end

            Entity.Spawner.AddEntityToRemoveQueue(item)
            huskBeacons[item] = nil
        end
    end

    timer = Timer.GetTime() + 5

    if Traitormod.Config.GhostRoleConfig.Enabled then
        for key, character in pairs(Character.CharacterList) do
            local client = Traitormod.FindClientCharacter(character)
            if not Traitormod.GhostRoles.IsGhostRole(character) and not client then
                if Traitormod.Config.GhostRoleConfig.MiscGhostRoles[character.SpeciesName.Value] then
                    Traitormod.GhostRoles.Ask(character.Name .. " " .. ghostRoleNumber, function (client)
                        client.SetClientCharacter(character)
                    end, character)
                    ghostRoleNumber = ghostRoleNumber + 1
                end
            end
        end
    end

    if not Traitormod.RoundEvents.EventExists("OutpostPirateAttack") then return end
    if Traitormod.RoundEvents.IsEventActive("OutpostPirateAttack") then return end
    if Traitormod.SelectedGamemode == nil or Traitormod.SelectedGamemode.Name ~= "Secret" then return end

    local targets = {}
    local outpost = Level.Loaded.EndOutpost.WorldPosition

    for key, character in pairs(Character.CharacterList) do
        if character.IsRemotePlayer and character.IsHuman and not character.IsDead and Vector2.Distance(character.WorldPosition, outpost) < 5000 then
            table.insert(targets, character)
        end
    end

    if #targets > 0 then
        peopleInOutpost = peopleInOutpost + 1
    end

    if peopleInOutpost > 30 then
        Traitormod.RoundEvents.TriggerEvent("OutpostPirateAttack")
    end
end)

Hook.Add("roundEnd", "Traitormod.MiscEnd", function ()
    peopleInOutpost = 0
    ghostRoleNumber = 1
    huskBeacons = {}
end)

if Traitormod.Config.DeathLogBook then
    local messages = {}

    Hook.Add("roundEnd", "Traitormod.DeathLogBook", function ()
        messages = {}
    end)

    Hook.Add("character.death", "Traitormod.DeathLogBook", function (character)
        if messages[character] == nil then return end

        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("logbook"), character.Inventory, nil, nil, function(item)
            local terminal = item.GetComponentString("Terminal")

            local text = ""
            for key, value in pairs(messages[character]) do
                text = text .. value .. "\n"
            end

            terminal.TextColor = Color.MidnightBlue
            terminal.ShowMessage = text
            terminal.SyncHistory()
        end)
    end)

    Traitormod.AddCommand("!write", function (client, args)
        if client.Character == nil or client.Character.IsDead or client.Character.SpeechImpediment > 0 or not client.Character.IsHuman then
            Traitormod.SendChatMessage(client, "You are unable to write to your death logbook.", Color.Red)
            return true
        end

        if messages[client.Character] == nil then
            messages[client.Character] = {}
        end

        if #messages[client.Character] > 255 then return end

        local message = table.concat(args, " ")
        table.insert(messages[client.Character], message)

        Traitormod.SendChatMessage(client, "Wrote \"" .. message .. "\" to the death logbook.", Color.Green)

        return true
    end)
end

Traitormod.CountAliveConvictsInsideMainSub = function ()
    local count = 0
    for key, plr in pairs(Client.ClientList) do
        if plr.Character and not plr.Character.IsDead and plr.Character.IsHuman and plr.Character.JobIdentifier == "convict" and plr.Character.Submarine == Submarine.MainSub then
            count = count + 1
        end
    end
    return count
end

Hook.Add("roundStart", "MessagesOnRoundStart", function ()
    Timer.Wait(function ()
        for key, value in pairs(Client.ClientList) do
            if value.Character and value.Character.JobIdentifier == "warden" then
                local text = "You are the warden! Issue announcements with the '!announce' command. You are the administrator of the station, make sure everything goes smoothly. You have full command over all staff."
                Traitormod.SendClientMessage(text, "TalentPointNotification", Color.LightBlue, value)
            elseif value.Character and value.Character.JobIdentifier == "headguard" then
                local text = "You are the head guard! Make sure those guards aren't slacking off. You're loyal to the warden. Your first order of business should be making sure the prisoners are behaving."
                Traitormod.SendClientMessage(text, "TalentPointNotification", Color.Crimson, value)
            elseif value.Character and value.Character.JobIdentifier == "guard" then
                local text = "You're a guard! Listen to the head guard. You're only allowed to use lethal force if the warden or head guard allows it. Warden has authority over the head guard, so listen to him over the head guard. GET THOSE PRISONERS IN CHECK!"
                Traitormod.SendClientMessage(text, "TalentPointNotification", Color.Blue, value)
            elseif value.Character and value.Character.JobIdentifier == "prisondoctor" then
                local text = "You're one of the prison doctors. Make sure the crew and prisoners are healthy. (OOC: If you do not understand neurotrauma, please consult the neurotrauma official trello.)"
                Traitormod.SendClientMessage(text, "TalentPointNotification", Color.IndianRed, value)
            elseif value.Character and value.Character.JobIdentifier == "staff" then
                local text = "You're a maintenance worker! Make sure the walls are welded, and the electrical and mechnical devices are in working order."
                Traitormod.SendClientMessage(text, "TalentPointNotification", Color.Ivory, value)
            elseif value.Character and value.Character.JobIdentifier == "janitor" then
                local text = "You're the janitor! Make sure those walls are clean. Use the sprayer to clean stains. You should also clean any deceased crew with those body bags.."
                Traitormod.SendClientMessage(text, "TalentPointNotification", Color.DarkViolet, value)
            elseif value.Character and value.Character.JobIdentifier == "convict" then
                local text = "You're a convict! Work closely with the traitors to escape. You're an ally of pirates, so make sure to identify yourself when you encounter one. You'll be rewarded if you're out of the station and alive at the end of the round."
                Traitormod.SendClientMessage(text, "TalentPointNotification", Color.OrangeRed, value)
            elseif value.Character and value.Character.JobIdentifier == "he-chef" then
                local text = "You're a chef! Prepare food for the prisoners and crew. Try not to dismember your fellow crewmates."
                Traitormod.SendClientMessage(text, "TalentPointNotification", Color.Gold, value)
            end
        end
    end, 25000)

    Timer.Wait(function ()
        Traitormod.RoundEvents.SendEventMessage("Remember, NLR! You don't remember anything about your past lives.", "GameModeIcon.pvp", Color.Red)
    end, 37000)
end)
