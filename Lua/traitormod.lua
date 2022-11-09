dofile(Traitormod.Path .. "/Lua/traitormodutil.lua")

Game.OverrideTraitors(true)

if Traitormod.Config.RagdollOnDisconnect ~= nil then
    Game.DisableDisconnectCharacter(not Traitormod.Config.RagdollOnDisconnect)
end

if Traitormod.Config.EnableControlHusk ~= nil then
    Game.EnableControlHusk(Traitormod.Config.EnableControlHusk)
end

math.randomseed(os.time())

Traitormod.Gamemodes = {}

Traitormod.AddGamemode = function(gamemode)
    Traitormod.Gamemodes[gamemode.Name] = gamemode

    if Traitormod.Config.GamemodeConfig[gamemode.Name] ~= nil then
        for key, value in pairs(Traitormod.Config.GamemodeConfig[gamemode.Name]) do
            gamemode[key] = value
        end
    end
end

if not File.Exists(Traitormod.Path .. "/Lua/data.json") then
    File.Write(Traitormod.Path .. "/Lua/data.json", "{}")
end

Traitormod.RoundNumber = 0
Traitormod.RoundTime = 0
Traitormod.LostLivesThisRound = {}
Traitormod.Commands = {}

local pointsGiveTimer = -1

Traitormod.LoadData()

if Traitormod.Config.RemotePoints then
    for key, value in pairs(Client.ClientList) do
        Traitormod.LoadRemoteData(value)
    end
end

Traitormod.RoundStart = function()
    Traitormod.Log("Starting traitor round - Traitor Mod v" .. Traitormod.VERSION)
    pointsGiveTimer = Timer.GetTime() + Traitormod.Config.ExperienceTimer

    -- give XP to players based on stored points
    for key, value in pairs(Client.ClientList) do
        if value.Character ~= nil then
            Traitormod.SetData(value, "Name", value.Character.Name)
        end

        if not value.SpectateOnly then
            Traitormod.LoadExperience(value)
        else
            Traitormod.Debug("Skipping load experience for spectator " .. value.Name)
        end

        -- Send Welcome message
        Traitormod.SendWelcome(value)
    end

    local function startsWith(String, Start)
        return string.sub(String, 1, string.len(Start)) == Start
    end

    if Traitormod.Config.RemoveSkillBooks then
        for key, value in pairs(Item.ItemList) do
            if startsWith(value.Prefab.Identifier.Value, "skillbook") then
                Entity.Spawner.AddEntityToRemoveQueue(value)
            end
        end
    end


    Traitormod.SelectedGamemode = Traitormod.Gamemodes.Secret:new()
    Traitormod.Log("Starting gamemode " .. Traitormod.SelectedGamemode.Name)

    if Traitormod.SelectedGamemode then
        Traitormod.SelectedGamemode.Start()
    end
end

Hook.Add("roundStart", "Traitormod.RoundStart", function()
    Traitormod.RoundStart()
end)

Hook.Add("missionsEnded", "Traitormod.MissionsEnded", function(missions)
    Traitormod.Debug("missionsEnded with " .. #missions .. " missions.")
    -- send LastRoundSummary
    local crewReachedEnd = false
    local crewMissionsComplete = Traitormod.AllCrewMissionsCompleted(missions)

    -- handle stored player lives and weight
    for key, value in pairs(Client.ClientList) do
        -- add weight according to points and config conversion
        Traitormod.AddData(value, "Weight",
            Traitormod.Config.AmountWeightWithPoints(Traitormod.GetData(value, "Points") or 0))

        if value.Character ~= nil
            and value.Character.IsHuman
            and not value.SpectateOnly
            and not value.Character.IsDead
        then
            local role = Traitormod.RoleManager.GetRoleByCharacter(value.Character)

            local wasAntagonist = false
            if role ~= nil then
                wasAntagonist = role.IsAntagonist
            end

            -- if client was no traitor, and in reach of end position, gain a live
            if not wasAntagonist and Traitormod.EndReached(value.Character) then
                crewReachedEnd = true

                local msg = ""

                -- award points for mission completion
                if crewMissionsComplete then
                    local points = Traitormod.AwardPoints(value, Traitormod.Config.PointsGainedFromCrewMissionsCompleted
                        , true)
                    msg = msg ..
                        Traitormod.Language.CrewWins ..
                        " " .. string.format(Traitormod.Language.PointsAwarded, points) .. "\n\n"
                end

                local lifeMsg, icon = Traitormod.AdjustLives(value,
                    (Traitormod.Config.LivesGainedFromCrewMissionsCompleted or 1))
                if lifeMsg then
                    msg = msg .. lifeMsg .. "\n\n"
                end

                if msg ~= "" then
                    Traitormod.SendMessage(value, msg, icon)
                end
            end
        end
    end

    local endMessage = ""

    if Traitormod.SelectedGamemode then
        endMessage = endMessage .. "Gamemode: " .. Traitormod.SelectedGamemode.Name .. "\n\n"

        endMessage = Traitormod.SelectedGamemode:RoundSummary()

        Traitormod.SendMessageEveryone(endMessage)
    end

    if crewReachedEnd then
        Traitormod.Stats.AddStat("Rounds", "Crew reached end", 1)
    end
        
    Traitormod.LastRoundSummary = endMessage

    Traitormod.SelectedGamemode = nil
    Traitormod.SelectedRandomEvents = {}

    Traitormod.SaveData()
    Traitormod.Stats.SaveData()

    if Traitormod.Config.RemotePoints then
        for key, value in pairs(Client.ClientList) do
            Traitormod.PublishRemoteData(value)
        end
    end
end)

Hook.Add("roundEnd", "Traitormod.RoundEnd", function()
    Traitormod.Debug("Round " .. Traitormod.RoundNumber .. " ended.")
    Traitormod.RoundNumber = Traitormod.RoundNumber + 1
    Traitormod.Stats.AddStat("Rounds", "Rounds finished", 1)

    Traitormod.PointsToBeGiven = {}
    Traitormod.AbandonedCharacters = {}
    Traitormod.PointItems = {}
    Traitormod.RoundTime = 0
    Traitormod.LostLivesThisRound = {}


    if Traitormod.SelectedGamemode then
        return Traitormod.SelectedGamemode.End()
    end
end)

Hook.Add("characterCreated", "Traitormod.CharacterCreated", function(character)
    -- if character is valid player
    if character == nil or
        character.IsBot == true or
        character.IsHuman == false or
        character.ClientDisconnected == true then
        return
    end

    -- delay handling, otherwise client won't be found
    Timer.Wait(function()
        local client = Traitormod.FindClientCharacter(character)
        --Traitormod.Debug("Character spawned: " .. character.Name .. " client: " .. tostring(client))

        if Traitormod.SelectedGamemode and Traitormod.SelectedGamemode.OnCharacterCreated then
            Traitormod.SelectedGamemode.OnCharacterCreated(client, character)
        end

        Traitormod.Stats.AddClientStat("Spawns", client, 1)

        if client ~= nil then
            -- set experience of respawned character to stored value - note initial spawn may not call this hook (on local server)
            Traitormod.LoadExperience(client)
        else
            Traitormod.Error("Loading experience on characterCreated failed! Client was nil after 1sec")
        end
    end, 1000)
end)

Hook.Add("characterDeath", "Traitormod.DeathByTraitor", function(character, affliction)
    if Traitormod.SelectedGamemode == nil then
        return
    end

    local client = Traitormod.FindClientCharacter(character)

    -- if character is valid player
    if client == nil or
        character == nil or
        character.IsHuman == false or
        character.ClientDisconnected == true or
        character.TeamID == 0 then
        return
    end

    local deathMsg, deathIcon
    if Traitormod.SelectedGamemode.OnCharacterDied then
        deathMsg, deathIcon = Traitormod.SelectedGamemode.OnCharacterDied(client, affliction)
    end

    if Traitormod.RoundTime < Traitormod.Config.MinRoundTimeToLooseLives then
        return
    end

    if Traitormod.LostLivesThisRound[client.SteamID] == nil then
        Traitormod.LostLivesThisRound[client.SteamID] = true
    else
        return
    end

    -- loose one live. if gamemode provided no icon, use icon from life adjustment
    local lifeMsg, lifeIcon = Traitormod.AdjustLives(client, -1)
    if not deathIcon then
        deathIcon = lifeIcon
    end

    if deathMsg and lifeMsg then
        deathMsg = deathMsg .. "\n\n" .. lifeMsg
    elseif lifeMsg then
        deathMsg = lifeMsg
    end

    Traitormod.SendMessage(client, deathMsg, deathIcon)
end)

-- register tick
Hook.Add("think", "Traitormod.Think", function()
    if not Game.RoundStarted or Traitormod.SelectedGamemode == nil then
        return
    end

    Traitormod.RoundTime = Traitormod.RoundTime + 1 / 60

    if Traitormod.SelectedGamemode then
        Traitormod.SelectedGamemode.Think()
    end

    -- every 60s, if a character has 100+ PointsToBeGiven, store added points and send feedback
    if pointsGiveTimer and Timer.GetTime() > pointsGiveTimer then
        for key, value in pairs(Traitormod.PointsToBeGiven) do
            if value > 100 then
                local points = Traitormod.AwardPoints(key, value)
                if Traitormod.GiveExperience(key.Character, Traitormod.Config.AmountExperienceWithPoints(points)) then
                    local text = Traitormod.Language.SkillsIncreased ..
                        "\n" .. string.format(Traitormod.Language.PointsAwarded, math.floor(points))
                    Game.SendDirectChatMessage("", text, nil, Traitormod.Config.ChatMessageType, key)

                    Traitormod.PointsToBeGiven[key] = 0
                end
            end
        end

        -- if configured, give temporary experience to all characters
        if Traitormod.Config.FreeExperience and Traitormod.Config.FreeExperience > 0 then
            for key, value in pairs(Client.ClientList) do
                Traitormod.GiveExperience(value.Character, Traitormod.Config.FreeExperience)
            end
        end

        pointsGiveTimer = Timer.GetTime() + Traitormod.Config.ExperienceTimer
    end
end)

-- when a character gains skill level, add PointsToBeGiven according to config
Traitormod.PointsToBeGiven = {}
Hook.HookMethod("Barotrauma.CharacterInfo", "IncreaseSkillLevel", function(instance, ptable)
    if not ptable or ptable.gainedFromAbility or instance.Character == nil or instance.Character.IsDead then return end

    local client = Traitormod.FindClientCharacter(instance.Character)

    if client == nil then return end

    local points = Traitormod.Config.PointsGainedFromSkill[tostring(ptable.skillIdentifier)]

    if points == nil then return end

    points = points * ptable.increase

    Traitormod.PointsToBeGiven[client] = (Traitormod.PointsToBeGiven[client] or 0) + points
end)

Traitormod.AbandonedCharacters = {}
-- new player connected to the server
Hook.Add("clientConnected", "Traitormod.ClientConnected", function (client)
    if Traitormod.Config.RemotePoints then
        Traitormod.LoadRemoteData(client, function ()
            Traitormod.SendWelcome(client)
        end)
    else
        Traitormod.SendWelcome(client)
    end

    if Traitormod.AbandonedCharacters[client.SteamID] and Traitormod.AbandonedCharacters[client.SteamID].IsDead then
        -- client left while char was alive -> but char is dead, so adjust life
        Traitormod.Debug(string.format("%s connected, but his character died in the meantime...",
            Traitormod.ClientLogName(client)))

        local lifeMsg, lifeIcon = Traitormod.AdjustLives(client, -1)
        Traitormod.SendMessage(client, lifeMsg, lifeIcon)

        Traitormod.AbandonedCharacters[client.SteamID] = nil
    end
end)

-- player disconnected from server
Hook.Add("clientDisconnected", "Traitormod.ClientDisconnected", function (client)
    if Traitormod.Config.RemotePoints then
        Traitormod.PublishRemoteData(client)
    end

    -- if character was alive while disconnecting, make sure player looses live if he rejoins the round
    if client.Character and not client.Character.IsDead and client.Character.IsHuman then
        Traitormod.Debug(string.format("%s disconnected with an alive character. Remembering for rejoin...",
            Traitormod.ClientLogName(client)))
        Traitormod.AbandonedCharacters[client.SteamID] = client.Character
    end
end)

-- Traitormod.Commands hook
Hook.Add("chatMessage", "Traitormod.ChatMessage", function(message, client)
    local split = Traitormod.ParseCommand(message)

    if #split == 0 then return end

    local command = string.lower(table.remove(split, 1))

    if Traitormod.Commands[command] then
        Traitormod.Log(Traitormod.ClientLogName(client) .. " used command: " .. message)
        return Traitormod.Commands[command].Callback(client, split)
    end
end)


LuaUserData.MakeMethodAccessible(Descriptors["Barotrauma.Item"], "set_InventoryIconColor")

Traitormod.PointItems = {}
Traitormod.SpawnPointItem = function(inventory, amount, text, onSpawn, onUsed)
    text = text or ""

    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("logbook"), inventory, nil, nil, function(item)
        Traitormod.PointItems[item] = {}
        Traitormod.PointItems[item].Amount = amount
        Traitormod.PointItems[item].OnUsed = onUsed

        local terminal = item.GetComponentString("Terminal")
        terminal.ShowMessage = text ..
            "\nThis LogBook contains " .. amount .. " points. Type \"claim\" into it to claim the points."
        terminal.SyncHistory()

        item.set_InventoryIconColor(Color(0, 0, 255))
        item.SpriteColor = Color(0, 0, 255, 255)
        item.Scale = 0.5

        local color = item.SerializableProperties[Identifier("SpriteColor")]
        Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(color, item))

        local scale = item.SerializableProperties[Identifier("Scale")]
        Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(scale, item))

        local invColor = item.SerializableProperties[Identifier("InventoryIconColor")]
        Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(invColor, item))

        if onSpawn then
            onSpawn(item)
        end
    end)
end

Hook.Patch("Barotrauma.Items.Components.Terminal", "ServerEventRead", function(instance, ptable)
    local msg = ptable["msg"]
    local client = ptable["c"]

    local rewindBit = msg.BitPosition
    local output = msg.ReadString()
    msg.BitPosition = rewindBit -- this is so the game can still read the net message, as you cant read the same bit twice

    if output ~= "claim" then return end

    local item = instance.Item
    local data = Traitormod.PointItems[item]

    if data == nil then return end

    Traitormod.AwardPoints(client, data.Amount)
    Traitormod.SendMessage(client, "You have received " .. data.Amount .. " points.", "InfoFrameTabButton.Mission")

    if data.OnUsed then
        data.OnUsed(client)
    end

    local terminal = item.GetComponentString("Terminal")
    terminal.ShowMessage = "Claimed by " .. client.Name
    terminal.SyncHistory()

    Traitormod.PointItems[item] = nil

end, Hook.HookMethodType.Before)


if Traitormod.Config.OverrideRespawnSubmarine then
    Traitormod.SubmarineBuilder = dofile(Traitormod.Path .. "/Lua/submarinebuilder.lua")
end

Traitormod.StringBuilder = dofile(Traitormod.Path .. "/Lua/stringbuilder.lua")
Traitormod.RoleManager = dofile(Traitormod.Path .. "/Lua/rolemanager.lua")
Traitormod.Pointshop = dofile(Traitormod.Path .. "/Lua/pointshop.lua")
Traitormod.RoundEvents = dofile(Traitormod.Path .. "/Lua/roundevents.lua")
Traitormod.GhostRoles = dofile(Traitormod.Path .. "/Lua/ghostroles.lua")
dofile(Traitormod.Path .. "/Lua/commands.lua")
dofile(Traitormod.Path .. "/Lua/statistics.lua")
dofile(Traitormod.Path .. "/Lua/respawnshuttle.lua")
dofile(Traitormod.Path .. "/Lua/traitormodmisc.lua")

Traitormod.AddGamemode(dofile(Traitormod.Path .. "/Lua/gamemodes/gamemode.lua"))
Traitormod.AddGamemode(dofile(Traitormod.Path .. "/Lua/gamemodes/secret.lua"))

Traitormod.RoleManager.AddObjective(dofile(Traitormod.Path .. "/Lua/objectives/objective.lua"))
Traitormod.RoleManager.AddObjective(dofile(Traitormod.Path .. "/Lua/objectives/assassinate.lua"))
Traitormod.RoleManager.AddObjective(dofile(Traitormod.Path .. "/Lua/objectives/kidnap.lua"))
Traitormod.RoleManager.AddObjective(dofile(Traitormod.Path .. "/Lua/objectives/poisoncaptain.lua"))
Traitormod.RoleManager.AddObjective(dofile(Traitormod.Path .. "/Lua/objectives/stealcaptainid.lua"))
Traitormod.RoleManager.AddObjective(dofile(Traitormod.Path .. "/Lua/objectives/survive.lua"))

Traitormod.RoleManager.AddRole(dofile(Traitormod.Path .. "/Lua/roles/role.lua"))
Traitormod.RoleManager.AddRole(dofile(Traitormod.Path .. "/Lua/roles/traitor.lua"))

-- Round start call for reload during round
if Game.RoundStarted then
    Traitormod.RoundStart()
end
