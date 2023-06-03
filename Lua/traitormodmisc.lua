local timer = Timer.GetTime()

local peopleInOutpost = 0

local n = 1
Hook.Add("think", "Traitormod.MiscThink", function ()
    if timer > Timer.GetTime() then return end
    if not Game.RoundStarted then return end

    timer = Timer.GetTime() + 5

    if Traitormod.Config.GhostRoleConfig.Enabled then
        for key, character in pairs(Character.CharacterList) do
            if not Traitormod.GhostRoles.IsGhostRole(character) then
                if Traitormod.Config.GhostRoleConfig.MiscGhostRoles[character.SpeciesName.Value] then
                    Traitormod.GhostRoles.Ask(character.Name .. " " .. n, function (client)
                        client.SetClientCharacter(character)
                    end, character)
                    n = n + 1
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
end)

if Traitormod.Config.NerfSwords then
    local replacement = [[
    <overwrite>
        <Attack targetimpulse="2" severlimbsprobability="0.55" itemdamage="10" structuredamage="1" structuresoundtype="StructureSlash">
            <Affliction identifier="lacerations" strength="5" />
            <Affliction identifier="bleeding" strength="25" />
            <Affliction identifier="stun" strength="0.01" />
        </Attack>
    </overwrite>
    ]]

    local husk = ItemPrefab.GetItemPrefab("ceremonialsword")
    local element = husk.ConfigElement.Element.Element("MeleeWeapon")
    Traitormod.Patching.RemoveAll(element, "Attack")
    Traitormod.Patching.Add(element, replacement)
end

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

function CountAliveConvictsInsideMainSub()
    local count = 0
    for key, plr in pairs(Client.ClientList) do
        if plr.Character and not plr.Character.IsDead and plr.Character.IsHuman and plr.Character.JobIdentifier == "convict" and plr.Character.Submarine == Submarine.MainSub then
            count = count + 1
        end
    end
    return count
end

Hook.Add("roundEnd", "PointsOnRoundEnd", function ()
    for key, plr in pairs(Client.ClientList) do
        if plr.Character and not plr.Character.IsDead and plr.Character.IsHuman and plr.Character.JobIdentifier == "convict" and plr.Character.Submarine ~= Submarine.MainSub then
            Traitormod.AwardPoints(plr, 2100)
            Traitormod.SendMessage(plr, "Congrats on escaping, you have received 2100 points.", "InfoFrameTabButton.Mission")
        end
    end
end)
--the convict counting stuff is made by aketius#5109
Hook.Add("roundEnd", "GuardPointsOnRoundEnd", function ()
    for key, plr in pairs(Client.ClientList) do
        if plr.Character and not plr.Character.IsDead and plr.Character.IsHuman then
            if plr.Character.JobIdentifier == "guard" or plr.Character.JobIdentifier == "warden" or plr.Character.JobIdentifier == "headguard" then
                local count = CountAliveConvictsInsideMainSub()
                local points = 350 * count
                Traitormod.AwardPoints(plr, points)
                if count > 1 then
                   Traitormod.AwardPoints(plr, points)   
                end
                if count > 5 then
                   Traitormod.SendMessage(plr, "You have received " .. points .. " points for each alive prisoner still inside the convict station.", "InfoFrameTabButton.Mission")
                elseif count > 3 then
                   Traitormod.SendMessage(plr, "Good job for keeping a decent amount of the prisoners alive. You've been awarded "..points.." points.", "InfoFrameTabButton.Mission")
                elseif count > 1 then
                   Traitormod.SendMessage(plr, "Terrible job. Barely any of those prisoners were kept alive. Obtained "..points.." points.", "InfoFrameTabButton.Mission")
                elseif count < 2 then
                   Traitormod.SendMessage(plr, "Little to no prisoners were kept alive. No points for you.", "InfoFrameTabButton.Mission")
                end
            end
        end
    end
end)

Hook.Add("roundEnd", "LivesOnRoundEnd", function ()
    Timer.Wait(function ()
        for key, value in pairs(Client.ClientList) do
            if value.Character ~= nil
                and value.Character.IsHuman
                and not value.SpectateOnly
                and not value.Character.IsDead
            then
                -- if client was alive at end of round and human then give points and lives
                local msg = ""
    
                -- award points for round completion
                local points = 325
                msg = msg ..
                "Good job on staying alive!" ..
                " " .. string.format(Traitormod.Language.PointsAwarded, points) .. "\n\n"
    
                local lifeMsg, icon = Traitormod.AdjustLives(value, 1)
                if lifeMsg then
                    msg = msg .. lifeMsg .. "\n\n"
                end
    
                if msg ~= "" then
                    Traitormod.SendMessage(value, msg, icon)
                end
            end
        end
    end, 26000)
end)

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
    end, 36000)
end)
