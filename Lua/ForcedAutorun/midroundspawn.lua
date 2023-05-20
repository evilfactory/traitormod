-- MidRoundSpawn v9 - offers newly joined players the option to spawn mid-round
-- by MassCraxx

if CLIENT then return end

-- CONFIG
local CheckDelaySeconds = 10
local SpawnDelaySeconds = 0
local GiveSpectatorsSpawnOption = false   -- if true, spectating players will be given the option to mid-round spawn
local PreventMultiCaptain = true          -- if true, will give securityofficer job to players trying to spawn as additional captain

local CheckTime = -1
local HasBeenSpawned = {}
local NewPlayers = {}

MidRoundSpawn = {}
MidRoundSpawn.Log = function (message)
    Game.Log("[MidRoundSpawn] " .. message, 6)
end

MidRoundSpawn.SpawnClientCharacterOnSub = function(client)
    if not Game.RoundStarted or not client.InGame then return false end 

    local spawned = MidRoundSpawn.TryCreateClientCharacter(client)
    HasBeenSpawned[client.SteamID] = spawned

    return spawned
end

MidRoundSpawn.CrewHasJob = function(job)
    if #Client.ClientList > 1 then
        for key, value in pairs(Client.ClientList) do
            if value.Character and value.Character.HasJob(job) then return true end
        end
    end
    return false
end

MidRoundSpawn.GetJobVariant = function(jobId)
    local prefab = JobPrefab.Get(jobId)
    return JobVariant.__new(prefab, 0)
end

-- TryCreateClientCharacter inspied by Oiltanker
MidRoundSpawn.TryCreateClientCharacter = function(client)
    local session = Game.GameSession
    local crewManager = session.CrewManager

    -- fix client char info
    if client.CharacterInfo == nil then client.CharacterInfo = CharacterInfo.__new('human', client.Name) end

    local jobPreference = client.JobPreferences[1]

    if jobPreference == nil then
        -- if no jobPreference, set assistant
<<<<<<< HEAD
        jobPreference = MidRoundSpawn.GetJobVariant("convict")
=======
        jobPreference = MidRoundSpawn.GetJobVariant("assistant")
>>>>>>> parent of 9c0d28b (using new version of midroundjoin)

    elseif PreventMultiCaptain and jobPreference.Prefab.Identifier == "warden" or jobPreference.Prefab.Identifier == "headguard" then
        -- if crew has a captain, spawn as security
        if MidRoundSpawn.CrewHasJob("warden") or MidRoundSpawn.CrewHasJob("headguard") then
            MidRoundSpawn.Log(client.Name .. " tried to mid-round spawn as second captain - assigning security instead.")
            -- set jobPreference = security
<<<<<<< HEAD
            jobPreference = MidRoundSpawn.GetJobVariant("guard")
=======
            jobPreference = MidRoundSpawn.GetJobVariant("convict")
>>>>>>> parent of 9c0d28b (using new version of midroundjoin)
        end
    end

    client.AssignedJob = jobPreference
    client.CharacterInfo.Job = Job.__new(jobPreference.Prefab, 0, jobPreference.Variant);

    crewManager.AddCharacterInfo(client.CharacterInfo)

    local spawnWayPoints = WayPoint.SelectCrewSpawnPoints({client.CharacterInfo}, Submarine.MainSub)
    local randomIndex = Random.Range(1, #spawnWayPoints)
    local waypoint = spawnWayPoints[randomIndex]

    -- find waypoint the hard way
    if waypoint == nil then
        for i,wp in pairs(WayPoint.WayPointList) do
            if
                wp.AssignedJob ~= nil and
                wp.SpawnType == SpawnType.Human and
                wp.Submarine == Submarine.MainSub and
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
        MidRoundSpawn.Log("WARN: No valid job waypoint found for " .. client.CharacterInfo.Job.Name.Value .. " - using random")
        waypoint = WayPoint.GetRandom(SpawnType.Human, nil, Submarine.MainSub)
    end

    if waypoint == nil then 
        MidRoundSpawn.Log("ERROR: Could not spawn player - no valid waypoint found")
        return false 
    end

    MidRoundSpawn.Log("Spawning " .. client.Name .. " as " .. client.CharacterInfo.Job.Name.Value)

    Timer.Wait(function () 
        -- spawn character
<<<<<<< HEAD
        local char = Character.Create(client.CharacterInfo, waypoint.WorldPosition, client.CharacterInfo.Name, 0, true, true)
        char.TeamID = CharacterTeamType.FriendlyNPC
        crewManager.AddCharacter(char)

        client.SetClientCharacter(char)
        
        char.GiveJobItems(waypoint)
        char.LoadTalents()
        char.GiveIdCardTags(waypoint, true)
=======
        local char = Character.Create(client.CharacterInfo, waypoint.WorldPosition, client.CharacterInfo.Name, 0, true, true);
        char.TeamID = CharacterTeamType.FriendlyNPC;
        crewManager.AddCharacter(char)

        client.SetClientCharacter(char)
        --mcm_client_manager:set(client, char)
        
        char.GiveJobItems(waypoint)
        char.LoadTalents()
        char.GiveIdCardTags(waypoint, false)
>>>>>>> parent of 9c0d28b (using new version of midroundjoin)
    end, SpawnDelaySeconds * 1000)
    return true
end

MidRoundSpawn.CreateDialog = function()
    local c = {}

    local promptIDToCallback = {}

    local function SendEventMessage(msg, options, id, eventSprite, fadeToBlack, client)
        local message = Networking.Start()
        message.WriteByte(Byte(18)) -- net header
        message.WriteByte(Byte(0)) -- conversation
    
        message.WriteUInt16(UShort(id)) -- ushort identifier 0
        message.WriteString(eventSprite) -- event sprite
        message.WriteByte(Byte(0)) -- dialog Type
        message.WriteBoolean(false) -- continue conversation
    
        message.WriteUInt16(UShort(0)) -- speak Id
        message.WriteString(msg)
        message.WriteBoolean(fadeToBlack or false) -- fade to black
        message.WriteByte(Byte(#options))
        for key, value in pairs(options) do
            message.WriteString(value)
        end
        message.WriteByte(Byte(#options))
        for i = 0, #options - 1, 1 do
            message.WriteByte(Byte(i))
        end

        Networking.Send(message, client.Connection, DeliveryMethod.Reliable)
    end


    Hook.Add("netMessageReceived", "MidRoundSpawn.promptResponse", function (msg, header, client)
        if header == ClientPacketHeader.EVENTMANAGER_RESPONSE then 
            local id = msg.ReadUInt16()
            local option = msg.ReadByte()

            if promptIDToCallback[id] ~= nil then
                promptIDToCallback[id](option, client)
            end
            msg.BitPosition = msg.BitPosition - (8 * 3) -- rewind 3 bytes from the message, so it can be read again
        end
    end)

    c.Prompt = function (message, options, client, callback, eventSprite)
        local currentPromptID = math.floor(math.random(0,65535))

        promptIDToCallback[currentPromptID] = callback
        SendEventMessage(message, options, currentPromptID, eventSprite, false, client)
    end

    return c
end

MidRoundSpawn.ShowSpawnDialog = function(client, force)
    if not force and client.Character and not client.Character.IsDead then
        MidRoundSpawn.Log(client.Name .. " was prevented to midroundspawn due to having an alive character.")
        return
    end
    local dialog = MidRoundSpawn.CreateDialog()
    dialog.Prompt("Do you want to spawn instantly or wait for the next respawn?\n", {"> Spawn", "> Wait"}, client, function(option, client) 
        if option == 0 then
            if force or not client.Character or client.Character.IsDead then
                MidRoundSpawn.SpawnClientCharacterOnSub(client)
            else
                MidRoundSpawn.Log(client.Name .. " attempted midroundspawn while having alive character.")
            end
        end
    end)
end

Hook.Add("roundStart", "MidRoundSpawn.roundStart", function ()
    -- Reset tables
    HasBeenSpawned = {}
    NewPlayers = {}

    -- Flag all lobby players as spawned
    for key, client in pairs(Client.ClientList) do
        if not client.SpectateOnly then
            HasBeenSpawned[client.SteamID] = true
        else
            MidRoundSpawn.Log(client.Name .. " is spectating.")
        end
    end
end)

Hook.Add("clientConnected", "MidRoundSpawn.clientConnected", function (newClient)
    -- client connects, round has started and client has not been considered for spawning yet
    if not Game.RoundStarted or HasBeenSpawned[newClient.SteamID] then return end

    if newClient.InGame then
        -- if client for some reason is already InGame (lobby skip?) spawn
        MidRoundSpawn.SpawnClientCharacterOnSub(newClient)
    else
        -- else store for later spawn 
        MidRoundSpawn.Log("Adding new player to spawn list: " .. newClient.Name)
        table.insert(NewPlayers, newClient)

        -- inform player about his luck
        Game.SendDirectChatMessage("", ">> MidRoundSpawn active! <<\nThe round has already started, but you can spawn instantly!", nil, ChatMessageType.Private, newClient)
    end
end)

Hook.Add("think", "MidRoundSpawn.think", function ()
    if Game.RoundStarted and CheckTime and Timer.GetTime() > CheckTime then
        CheckTime = Timer.GetTime() + CheckDelaySeconds
        
        -- check all NewPlayers and if not spawned already and inGame spawn
        for i = #NewPlayers, 1, -1 do
            local newClient = NewPlayers[i]
            
            -- if client still valid and not spawned yet, no spectator and has an active connection
            if newClient and not HasBeenSpawned[newClient.SteamID] and (GiveSpectatorsSpawnOption or not newClient.SpectateOnly) and newClient.Connection and newClient.Connection.Status == 1 then
                -- wait for client to be ingame, then cpasn
                if newClient.InGame then
                    MidRoundSpawn.ShowSpawnDialog(newClient)
                    table.remove(NewPlayers, i)
                --else
                    --MidRoundSpawn.Log(newClient.Name .. " waiting in lobby...")
                end
            else
                if (not GiveSpectatorsSpawnOption and newClient.SpectateOnly) then
                    MidRoundSpawn.Log("Removing spectator from spawn list: " .. newClient.Name)
                else
                    MidRoundSpawn.Log("Removing invalid player from spawn list: " .. newClient.Name)
                end
                table.remove(NewPlayers, i)
            end
        end
    end
end)

-- Commands hook
Hook.Add("chatMessage", "MidRoundSpawn.ChatMessage", function (message, client)

    if message == "!midroundspawn" then
        if client.InGame then
            if (not HasBeenSpawned[client.SteamID] or client.HasPermission(ClientPermissions.ConsoleCommands)) and (not client.Character or client.Character.IsDead) then
                MidRoundSpawn.ShowSpawnDialog(client)
            else
                Game.SendDirectChatMessage("", "You spawned already.", nil, ChatMessageType.Error, client)
            end
        else
            Game.SendDirectChatMessage("", "You are not in-game.", nil, ChatMessageType.Error, client)
        end
        return true
    end
<<<<<<< HEAD
end)
=======
end)
>>>>>>> parent of 9c0d28b (using new version of midroundjoin)
