if Traitormod.SubmarineBuilder == nil then
    return
end

Traitormod.DisableRespawnShuttle = false

if Traitormod.Config.RespawnEnabled == false then return end

local sb = Traitormod.SubmarineBuilder
local submarineId = sb.AddSubmarine(Traitormod.Config.RespawnSubmarineFile)

local timerActive = false
local transporting = false
local respawnTimer = 0
local transportTimer = 0

local lastTimerDisplay = 0

local function RespawnMessage(msg)
    for key, client in pairs(Client.ClientList) do
        local chatMessage = ChatMessage.Create("", msg, ChatMessageType.Default, nil, nil)
        chatMessage.Color = Color(178, 35, 199, 255)
        Game.SendDirectChatMessage(chatMessage, client)
    end

    Traitormod.Log(msg)
end

local function GetRespawnClients()
    local clients = {}
    for key, value in pairs(Client.ClientList) do
        if value.Character == nil or value.Character.IsDead then
            table.insert(clients, value)
        end
    end

    return clients
end

local function IsCloseToOtherSubmarines(position)
    for key, value in pairs(Submarine.Loaded) do
        if Vector2.Distance(value.WorldPosition, position) < 10000 then
            return true
        end
    end

    return false
end

local function FindSpawnPosition()
    local potentialSpawnPositions = {}

    for _, spawnPosition in pairs(Level.Loaded.PositionsOfInterest) do
        if spawnPosition.PositionType == Level.PositionType.MainPath then
            local position = spawnPosition.Position.ToVector2()
            if not IsCloseToOtherSubmarines(position) then
                table.insert(potentialSpawnPositions, position)
            end
        end
    end

    local bestPosition = potentialSpawnPositions[1]

    if bestPosition == nil then
        Traitormod.Error("Couldn't find a good spawn position for the respawn shuttle!")
        return Vector2(Level.Loaded.Size.X / 2, Level.Loaded.Size.Y / 2)
    end

    for key, value in pairs(potentialSpawnPositions) do
        if Vector2.Distance(Submarine.MainSub.WorldPosition, value) < Vector2.Distance(Submarine.MainSub.WorldPosition, bestPosition) then
            bestPosition = value
        end
    end

    return bestPosition
end

local function SpawnCharacter(client, submarine)
    if client.SpectateOnly or client.CharacterInfo == nil then return false end

    local spawnWayPoints = WayPoint.SelectCrewSpawnPoints({client.CharacterInfo}, submarine)

    local potentialPosition = submarine.WorldPosition

    if spawnWayPoints[1] == nil then
        for i, waypoint in pairs(WayPoint.WayPointList) do
            if waypoint.Submarine == submarine and waypoint.CurrentHull ~= nil then
                potentialPosition = waypoint.WorldPosition
                break
            end
        end
    else
        potentialPosition = spawnWayPoints[1].WorldPosition
    end

    local character = Character.Create(client.CharacterInfo, potentialPosition, client.CharacterInfo.Name, 0, true, true)

    character.TeamID = Traitormod.Config.RespawnTeam

    client.SetClientCharacter(character)

    character.GiveJobItems()
    character.LoadTalents()

    Traitormod.RespawnedCharacters[character] = client

    if Traitormod.Config.RespawnedPlayersDontLooseLives then
        Traitormod.LostLivesThisRound[client.SteamID] = true
    end
end

local function ResetSubmarine(submarine)
    for key, item in pairs(submarine.GetItems(true)) do
        item.Condition = item.MaxCondition

        local repairable = item.GetComponentString("Repairable")
        if repairable then repairable.ResetDeterioration() end

        local powerContainer = item.GetComponentString("PowerContainer")
        if powerContainer then powerContainer.Charge = powerContainer.Capacity end
    end

    for key, hull in pairs(Hull.HullList) do
        if hull.Submarine == submarine then
            hull.OxygenPercentage = 100
            hull.WaterVolume = 0
            if hull.BallastFlora then
                hull.BallastFlora.Remove()
            end
        end
    end

    for key, wall in pairs(Structure.WallList) do
        if wall.Submarine == submarine then
            for i = 0, wall.SectionCount, 1 do
                wall.AddDamage(i, -1000000)
            end
        end
    end

    for key, character in pairs(Character.CharacterList) do
        if character.Submarine == submarine then
            Entity.Spawner.AddEntityToRemoveQueue(character)            
        end
    end
end

Hook.Add("think", "RespawnShuttle.Think", function ()
    if Traitormod.DisableRespawnShuttle then return end
    if not Game.RoundStarted then return end
    if not Traitormod.SubmarineBuilder.IsActive() then return end

    local ratio = #GetRespawnClients() / #Client.ClientList

    if #Client.ClientList == 0 then
        ratio = 0
    end

    if ratio > Game.ServerSettings.MinRespawnRatio then
        if not timerActive and not transporting then
            timerActive = true
            respawnTimer = Game.ServerSettings.RespawnInterval
            lastTimerDisplay = respawnTimer
            RespawnMessage(string.format(Traitormod.Config.RespawnText, math.ceil(respawnTimer)))
        end
    else
        timerActive = false
    end

    if timerActive then
        respawnTimer = respawnTimer - (1 / 60)
    end

    if transporting then
        transportTimer = transportTimer - (1 / 60)
    end

    local timerDisplayMax = 15

    if respawnTimer < 10 then
        timerDisplayMax = 1
    end

    if timerActive and (lastTimerDisplay - respawnTimer) > timerDisplayMax then
        lastTimerDisplay = respawnTimer
        RespawnMessage(string.format(Traitormod.Config.RespawnText, math.ceil(respawnTimer)))
    end

    if transportTimer <= 0 and not timerActive and transporting then
        transporting = false
        timerActive = false
    end

    if respawnTimer <= 0 and timerActive and not transporting then
        transporting = true
        timerActive = false

        local submarine = sb.FindSubmarine(submarineId)
        submarine.GodMode = false
        submarine.TeamID = Traitormod.Config.RespawnTeam

        ResetSubmarine(submarine)
        local position = FindSpawnPosition()
        submarine.SetPosition(position)

        sb.ResetSubmarineSteering(submarine)

        local clients = GetRespawnClients()

        for key, client in pairs(clients) do
            SpawnCharacter(client, submarine)
        end

        transportTimer = Game.ServerSettings.MaxTransportTime
    end
end)

Hook.Add("roundEnd", "RespawnShuttle.RoundEnd", function ()
    timerActive = false
    transporting = false
    respawnTimer = 0
    transportTimer = 0
    lastTimerDisplay = 0
    Traitormod.DisableRespawnShuttle = false
end)

Hook.Add("character.death", "RespawnShuttle.CharacterDeath", function (character)
    if Traitormod.Config.RespawnOnKillPoints == 0 then return end
    if not Traitormod.RespawnedCharacters[character] then return end

    if not character.CauseOfDeath then return end
    if not character.CauseOfDeath.Killer then return end

    local killer = character.CauseOfDeath.Killer
    local killerClient = Traitormod.FindClientCharacter(character.CauseOfDeath.Killer)

    if not killerClient then return end

    if killer.IsHuman and killer.TeamID == CharacterTeamType.Team1 and not killer.IsDead and not Traitormod.RespawnedCharacters[killer] then
        Traitormod.AwardPoints(killerClient, Traitormod.Config.RespawnOnKillPoints)
        Traitormod.SendMessage(killerClient, string.format(Traitormod.Language.ReceivedPoints, Traitormod.Config.RespawnOnKillPoints), "InfoFrameTabButton.Mission")
    end
end)