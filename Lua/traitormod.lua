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

    Traitormod.CodeWords = Traitormod.SelectCodeWords()

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

    if Traitormod.Config.HideCrewList then
        for key, value in pairs(Character.CharacterList) do
            Networking.CreateEntityEvent(value, Character.RemoveFromCrewEventData.__new(value.TeamID, {}))
        end
    end

    Traitormod.SelectedGamemode = nil

    if LuaUserData.IsTargetType(Game.GameSession.GameMode, "Barotrauma.PvPMode") then
        Traitormod.SelectedGamemode = Traitormod.Gamemodes.PvP:new()
    elseif LuaUserData.IsTargetType(Game.GameSession.GameMode, "Barotrauma.CampaignMode") then
        Traitormod.SelectedGamemode = Traitormod.Gamemodes.Gamemode:new()
    elseif Game.ServerSettings.TraitorsEnabled == 1 and math.random() > 0.5 then
        Traitormod.SelectedGamemode = Traitormod.Gamemodes.Secret:new()
    elseif Game.ServerSettings.TraitorsEnabled == 2 then
        Traitormod.SelectedGamemode = Traitormod.Gamemodes.Secret:new()
    end

    if Traitormod.SelectedGamemode == nil then
        Traitormod.Log("No gamemode selected!")
        return
    end

    Traitormod.Log("Starting gamemode " .. Traitormod.SelectedGamemode.Name)

    if Traitormod.SelectedGamemode then
        Traitormod.SelectedGamemode:Start()
    end
end

Hook.Add("roundStart", "Traitormod.RoundStart", function()
    Traitormod.RoundStart()
end)

Hook.Add("missionsEnded", "Traitormod.MissionsEnded", function(missions)
    Traitormod.RoundMissions = missions
    Traitormod.Debug("missionsEnded with " .. #Traitormod.RoundMissions .. " missions.")

    for key, value in pairs(Client.ClientList) do
        -- add weight according to points and config conversion
        Traitormod.AddData(value, "Weight", Traitormod.Config.AmountWeightWithPoints(Traitormod.GetData(value, "Points") or 0))
    end

    Traitormod.Debug("Round " .. Traitormod.RoundNumber .. " ended.")
    Traitormod.RoundNumber = Traitormod.RoundNumber + 1
    Traitormod.Stats.AddStat("Rounds", "Rounds finished", 1)

    Traitormod.PointsToBeGiven = {}
    Traitormod.AbandonedCharacters = {}
    Traitormod.PointItems = {}
    Traitormod.RoundTime = 0
    Traitormod.LostLivesThisRound = {}

    local endMessage = ""
    if Traitormod.SelectedGamemode then
        endMessage = Traitormod.SelectedGamemode:RoundSummary()

        Traitormod.SendMessageEveryone(Traitormod.HighlightClientNames(endMessage, Color.Red))
    end
    Traitormod.LastRoundSummary = endMessage

    if Traitormod.SelectedGamemode then
        Traitormod.SelectedGamemode:End(missions)
    end

    Traitormod.RoleManager.EndRound()
    Traitormod.RoundEvents.EndRound()

    Traitormod.SelectedGamemode = nil

    Traitormod.SaveData()
    Traitormod.Stats.SaveData()

    if Traitormod.Config.RemotePoints then
        for key, value in pairs(Client.ClientList) do
            Traitormod.PublishRemoteData(value)
        end
    end
end)

Hook.Add("roundEnd", "Traitormod.RoundEnd", function()
    if Traitormod.SelectedGamemode then
        return Traitormod.SelectedGamemode:TraitorResults()
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
        
        Traitormod.Stats.AddClientStat("Spawns", client, 1)

        if client ~= nil then
            -- set experience of respawned character to stored value - note initial spawn may not call this hook (on local server)
            Traitormod.LoadExperience(client)
        else
            Traitormod.Error("Loading experience on characterCreated failed! Client was nil after 1sec")
        end
    end, 1000)
end)

local tipDelay = 0

-- register tick
Hook.Add("think", "Traitormod.Think", function()
    if Timer.GetTime() > tipDelay then
        tipDelay = Timer.GetTime() + 500
        Traitormod.SendTip()
    end

    if not Game.RoundStarted or Traitormod.SelectedGamemode == nil then
        return
    end

    Traitormod.RoundTime = Traitormod.RoundTime + 1 / 60

    if Traitormod.SelectedGamemode then
        Traitormod.SelectedGamemode:Think()
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

    if Traitormod.AbandonedCharacters[client.SteamID] then
        if Traitormod.AbandonedCharacters[client.SteamID].IsDead then
            -- client left while char was alive -> but char is dead
            Traitormod.Debug(string.format("%s connected, but his character died in the meantime...", Traitormod.ClientLogName(client)))
        end

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
        Traitormod.Debug(string.format("%s disconnected with an alive character. Remembering for rejoin...", Traitormod.ClientLogName(client)))
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
Traitormod.Voting = dofile(Traitormod.Path .. "/Lua/voting.lua")
Traitormod.RoleManager = dofile(Traitormod.Path .. "/Lua/rolemanager.lua")
Traitormod.Pointshop = dofile(Traitormod.Path .. "/Lua/pointshop.lua")
Traitormod.RoundEvents = dofile(Traitormod.Path .. "/Lua/roundevents.lua")
Traitormod.GhostRoles = dofile(Traitormod.Path .. "/Lua/ghostroles.lua")

dofile(Traitormod.Path .. "/Lua/commands.lua")
dofile(Traitormod.Path .. "/Lua/statistics.lua")
dofile(Traitormod.Path .. "/Lua/respawnshuttle.lua")
dofile(Traitormod.Path .. "/Lua/traitormodmisc.lua")
dofile(Traitormod.Path .. "/Lua/midroundspawn.lua")

Traitormod.AddGamemode(dofile(Traitormod.Path .. "/Lua/gamemodes/gamemode.lua"))
Traitormod.AddGamemode(dofile(Traitormod.Path .. "/Lua/gamemodes/secret.lua"))
Traitormod.AddGamemode(dofile(Traitormod.Path .. "/Lua/gamemodes/pvp.lua"))

Traitormod.RoleManager.AddObjective(dofile(Traitormod.Path .. "/Lua/objectives/objective.lua"))
Traitormod.RoleManager.AddObjective(dofile(Traitormod.Path .. "/Lua/objectives/assassinate.lua"))
Traitormod.RoleManager.AddObjective(dofile(Traitormod.Path .. "/Lua/objectives/kidnap.lua"))
Traitormod.RoleManager.AddObjective(dofile(Traitormod.Path .. "/Lua/objectives/poisoncaptain.lua"))
Traitormod.RoleManager.AddObjective(dofile(Traitormod.Path .. "/Lua/objectives/stealcaptainid.lua"))
Traitormod.RoleManager.AddObjective(dofile(Traitormod.Path .. "/Lua/objectives/survive.lua"))
Traitormod.RoleManager.AddObjective(dofile(Traitormod.Path .. "/Lua/objectives/husk.lua"))
Traitormod.RoleManager.AddObjective(dofile(Traitormod.Path .. "/Lua/objectives/turnhusk.lua"))
Traitormod.RoleManager.AddObjective(dofile(Traitormod.Path .. "/Lua/objectives/destroycaly.lua"))
Traitormod.RoleManager.AddObjective(dofile(Traitormod.Path .. "/Lua/objectives/assassinatedrunk.lua"))
Traitormod.RoleManager.AddObjective(dofile(Traitormod.Path .. "/Lua/objectives/bananaslip.lua"))
Traitormod.RoleManager.AddObjective(dofile(Traitormod.Path .. "/Lua/objectives/suffocatecrew.lua"))
Traitormod.RoleManager.AddObjective(dofile(Traitormod.Path .. "/Lua/objectives/growmudraptors.lua"))
Traitormod.RoleManager.AddObjective(dofile(Traitormod.Path .. "/Lua/objectives/assassinatepressure.lua"))

Traitormod.RoleManager.AddObjective(dofile(Traitormod.Path .. "/Lua/objectives/crew/killmonsters.lua"))
Traitormod.RoleManager.AddObjective(dofile(Traitormod.Path .. "/Lua/objectives/crew/killsmallmonsters.lua"))
Traitormod.RoleManager.AddObjective(dofile(Traitormod.Path .. "/Lua/objectives/crew/killlargemonsters.lua"))
Traitormod.RoleManager.AddObjective(dofile(Traitormod.Path .. "/Lua/objectives/crew/killpets.lua"))
Traitormod.RoleManager.AddObjective(dofile(Traitormod.Path .. "/Lua/objectives/crew/killabyssmonster.lua"))
Traitormod.RoleManager.AddObjective(dofile(Traitormod.Path .. "/Lua/objectives/crew/repair.lua"))
Traitormod.RoleManager.AddObjective(dofile(Traitormod.Path .. "/Lua/objectives/crew/finishroundfast.lua"))
Traitormod.RoleManager.AddObjective(dofile(Traitormod.Path .. "/Lua/objectives/crew/securityteamsurvival.lua"))
Traitormod.RoleManager.AddObjective(dofile(Traitormod.Path .. "/Lua/objectives/crew/repairmechanical.lua"))
Traitormod.RoleManager.AddObjective(dofile(Traitormod.Path .. "/Lua/objectives/crew/repairelectrical.lua"))
Traitormod.RoleManager.AddObjective(dofile(Traitormod.Path .. "/Lua/objectives/crew/repairhull.lua"))
Traitormod.RoleManager.AddObjective(dofile(Traitormod.Path .. "/Lua/objectives/crew/healcharacters.lua"))
Traitormod.RoleManager.AddObjective(dofile(Traitormod.Path .. "/Lua/objectives/crew/finishallobjectives.lua"))

Traitormod.RoleManager.AddRole(dofile(Traitormod.Path .. "/Lua/roles/role.lua"))
Traitormod.RoleManager.AddRole(dofile(Traitormod.Path .. "/Lua/roles/antagonist.lua"))
Traitormod.RoleManager.AddRole(dofile(Traitormod.Path .. "/Lua/roles/traitor.lua"))
Traitormod.RoleManager.AddRole(dofile(Traitormod.Path .. "/Lua/roles/cultist.lua"))
Traitormod.RoleManager.AddRole(dofile(Traitormod.Path .. "/Lua/roles/huskservant.lua"))
Traitormod.RoleManager.AddRole(dofile(Traitormod.Path .. "/Lua/roles/crew.lua"))
Traitormod.RoleManager.AddRole(dofile(Traitormod.Path .. "/Lua/roles/clown.lua"))

if Traitormod.Config.Extensions then
    for key, extension in pairs(Traitormod.Config.Extensions) do
        if extension.Init then
            extension.Init()
        end
    end
end

-- Round start call for reload during round
if Game.RoundStarted then
    Traitormod.RoundStart()
end
