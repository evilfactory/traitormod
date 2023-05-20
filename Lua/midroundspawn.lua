-- Originally by MassCraxx, ported to Traitormod.

local textPromptUtils = require("textpromptutils")

local checkDelaySeconds = 10
local spawnDelaySeconds = 0
local giveSpectatorsSpawnOption = false   -- if true, spectating players will be given the option to mid-round spawn
local preventMultiCaptain = true          -- if true, will give securityofficer job to players trying to spawn as additional captain

local checkTime = -1
local hasBeenSpawned = {}
local newPlayers = {}

local m = {}

m.SpawnClientCharacterOnSub = function(submarine, client)
    if not Game.RoundStarted or not client.InGame then return false end 

    local spawned = m.TryCreateClientCharacter(submarine, client)
    hasBeenSpawned[client.SteamID] = spawned

    return spawned
end

m.CrewHasJob = function(job)
    if #Client.ClientList > 1 then
        for key, value in pairs(Client.ClientList) do
            if value.Character and value.Character.HasJob(job) then return true end
        end
    end
    return false
end

m.GetJobVariant = function(jobId)
    local prefab = JobPrefab.Get(jobId)
    return JobVariant.__new(prefab, 0)
end

-- TryCreateClientCharacter inspied by Oiltanker
m.TryCreateClientCharacter = function(submarine, client)
    local session = Game.GameSession
    local crewManager = session.CrewManager

    -- fix client char info
    if client.CharacterInfo == nil then client.CharacterInfo = CharacterInfo("human", client.Name) end

    local jobPreference = client.JobPreferences[1]

    if jobPreference == nil then
        -- if no jobPreference, set assistant
        jobPreference = m.GetJobVariant("assistant")

    elseif preventMultiCaptain and jobPreference.Prefab.Identifier == "captain" then
        -- if crew has a captain, spawn as security
        if m.CrewHasJob("captain") then
            Traitormod.Log(client.Name .. " tried to mid-round spawn as second captain - assigning security instead.")
            -- set jobPreference = security
            jobPreference = m.GetJobVariant("securityofficer")
        end
    end

    client.AssignedJob = jobPreference
    client.CharacterInfo.Job = Job(jobPreference.Prefab, 0, jobPreference.Variant);

    crewManager.AddCharacterInfo(client.CharacterInfo)

    local spawnWayPoints = WayPoint.SelectCrewSpawnPoints({client.CharacterInfo}, submarine)
    local randomIndex = Random.Range(1, #spawnWayPoints)
    local waypoint = spawnWayPoints[randomIndex]

    -- find waypoint the hard way
    if waypoint == nil then
        for i,wp in pairs(WayPoint.WayPointList) do
            if
                wp.AssignedJob ~= nil and
                wp.SpawnType == SpawnType.Human and
                wp.Submarine == submarine and
                wp.CurrentHull ~= nil
            then
                if client.CharacterInfo.Job.Prefab == wp.AssignedJob then
                    waypoint = wp
                    break
                end
            end
        end
    end

    -- none found, go random
    if waypoint == nil then 
        Traitormod.Log("WARN: No valid job waypoint found for " .. client.CharacterInfo.Job.Name.Value .. " - using random")
        waypoint = WayPoint.GetRandom(SpawnType.Human, nil, submarine)
    end

    if waypoint == nil then 
        Traitormod.Log("ERROR: Could not spawn player - no valid waypoint found")
        return false 
    end

    Traitormod.Log("Spawning " .. client.Name .. " as " .. client.CharacterInfo.Job.Name.Value)

    Timer.Wait(function () 
        -- spawn character
        local char = Character.Create(client.CharacterInfo, waypoint.WorldPosition, client.CharacterInfo.Name, 0, true, true)
        char.TeamID = submarine.TeamID
        crewManager.AddCharacter(char)

        client.SetClientCharacter(char)

        char.GiveJobItems(waypoint)
        char.LoadTalents()

        Hook.Call("traitormod.midroundspawn", client, char)
    end, spawnDelaySeconds * 1000)

    return true
end

m.ShowSpawnDialog = function(client, force)
    if not force and client.Character and not client.Character.IsDead then
        Traitormod.Log(client.Name .. " was prevented to midroundspawn due to having an alive character.")
        return
    end

    if LuaUserData.IsTargetType(Game.GameSession.GameMode, "Barotrauma.PvPMode") then
        textPromptUtils.Prompt(Traitormod.Language.MidRoundSpawn, {Traitormod.Language.MidRoundSpawnCoalition, Traitormod.Language.MidRoundSpawnSeparatists, Traitormod.Language.MidRoundSpawnWait}, client, function(option, client) 
            if option == 1 or option == 2 then
                if force or not client.Character or client.Character.IsDead then
                    m.SpawnClientCharacterOnSub(Submarine.MainSubs[option], client)
                else
                    Traitormod.Log(client.Name .. " attempted midroundspawn while having alive character.")
                end
            end
        end)
    else
        textPromptUtils.Prompt(Traitormod.Language.MidRoundSpawn, {Traitormod.Language.MidRoundSpawnMission, Traitormod.Language.MidRoundSpawnWait}, client, function(option, client) 
            if option == 1 then
                if force or not client.Character or client.Character.IsDead then
                    m.SpawnClientCharacterOnSub(Submarine.MainSub, client)
                else
                    Traitormod.Log(client.Name .. " attempted midroundspawn while having alive character.")
                end
            end
        end)
    end
end

Hook.Add("roundStart", "Traitormod.MidRoundSpawn.RoundStart", function ()
    if not Traitormod.Config.MidRoundSpawn then return end

    -- Reset tables
    hasBeenSpawned = {}
    newPlayers = {}

    -- Flag all lobby players as spawned
    for key, client in pairs(Client.ClientList) do
        if not client.SpectateOnly then
            hasBeenSpawned[client.SteamID] = true
        else
            Traitormod.Log(client.Name .. " is spectating.")
        end
    end
end)

Hook.Add("client.connected", "Traitormod.MidRoundSpawn.ClientConnected", function (newClient)
    if not Traitormod.Config.MidRoundSpawn then return end

    -- client connects, round has started and client has not been considered for spawning yet
    if not Game.RoundStarted or hasBeenSpawned[newClient.SteamID] then return end

    if newClient.InGame then
        -- if client for some reason is already InGame (lobby skip?) spawn
        m.SpawnClientCharacterOnSub(newClient)
    else
        -- else store for later spawn 
        Traitormod.Log("Adding new player to spawn list: " .. newClient.Name)
        table.insert(newPlayers, newClient)

        -- inform player about his luck
        Game.SendDirectChatMessage("", Traitormod.Language.MidRoundSpawnWelcome, nil, ChatMessageType.Private, newClient)
    end
end)

Hook.Add("think", "Traitormod.MidRoundSpawn.Think", function ()
    if not Traitormod.Config.MidRoundSpawn then return end

    if Game.RoundStarted and checkTime and Timer.GetTime() > checkTime then
        checkTime = Timer.GetTime() + checkDelaySeconds

        -- check all NewPlayers and if not spawned already and inGame spawn
        for i = #newPlayers, 1, -1 do
            local newClient = newPlayers[i]

            -- if client still valid and not spawned yet, no spectator and has an active connection
            if newClient and not hasBeenSpawned[newClient.SteamID] and (giveSpectatorsSpawnOption or not newClient.SpectateOnly) and newClient.Connection and newClient.Connection.Status == 1 then
                -- wait for client to be ingame, then cpasn
                if newClient.InGame then
                    m.ShowSpawnDialog(newClient)
                    table.remove(newPlayers, i)
                end
            else
                if (not giveSpectatorsSpawnOption and newClient.SpectateOnly) then
                    Traitormod.Log("Removing spectator from spawn list: " .. newClient.Name)
                else
                    Traitormod.Log("Removing invalid player from spawn list: " .. newClient.Name)
                end
                table.remove(newPlayers, i)
            end
        end
    end
end)

Traitormod.AddCommand("!midroundspawn", function (client, args)
    if not Traitormod.Config.MidRoundSpawn then return end

    if client.InGame then
        if (not hasBeenSpawned[client.SteamID] or client.HasPermission(ClientPermissions.ConsoleCommands)) and (not client.Character or client.Character.IsDead) then
            m.ShowSpawnDialog(client)
        else
            Game.SendDirectChatMessage("", "You spawned already.", nil, ChatMessageType.Error, client)
        end
    else
        Game.SendDirectChatMessage("", "You are not in-game.", nil, ChatMessageType.Error, client)
    end

    return true
end)