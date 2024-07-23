local json = require("json")

-- Load round data from JSON file
function json.loadRoundData()
    local path = Traitormod.Path .. "/Lua/round_data.json"
    
    if not File.Exists(path) then
        File.Write(path, "[]")
    end

    local content = File.Read(path)
    return json.decode(content) or {}
end

-- Save round data to JSON file
function json.saveRoundData(roundData)
    local path = Traitormod.Path .. "/Lua/round_data.json"
    File.Write(path, json.encode(roundData))
end

-- Initialize round data
local roundData = json.loadRoundData()
local maxRounds = 50

-- Add new round data and manage history
function addRoundData(newRound)
    -- Check for duplicate round IDs
    if #roundData > 0 and newRound.roundId == roundData[#roundData].roundId then
        return
    end

    table.insert(roundData, newRound)

    -- Remove oldest round if exceeding max rounds
    if #roundData > maxRounds then
        table.remove(roundData, 1)
    end

    json.saveRoundData(roundData)
end

-- Escape quotes for Discord webhook
local function escapeQuotes(str)
    return str:gsub("\"", "\\\"")
end

-- Format round information
local function formatRoundInfo(round)
    local roundInfo = string.format("**Round ID:** %d\n**Round Time:** %d seconds\n", round.roundId, round.roundTime)
    roundInfo = roundInfo .. "**Clients:**\n"
    
    for _, client in ipairs(round.clients) do
        local traitorInfo = client.isTraitor and "\n> **Traitor:** Yes" or ""
        roundInfo = roundInfo .. string.format("> **Name:** %s\n> **SteamID:** %s\n> **Character:** %s\n> **Job:** %s%s\n\n",
            client.name, client.steamId, client.characterName, client.job, traitorInfo)
    end

    return roundInfo
end

-- Send round information to Discord
function sendRoundInfoToDiscord(round)
    local discordWebHook = "https://discord.com/api/webhooks/1265160570504609792/Aw1Mq3fYIH7v2J6MUc-632sqt3fNyQvtv9yxf7z7gLqpmSw7dKon5RzkYXtq6Et9yRHe"
    local roundInfo = formatRoundInfo(round)
    local escapedMessage = escapeQuotes(roundInfo)
    
    local payload = json.encode({ content = escapedMessage, username = "Round Logger" })
    
    Networking.RequestPostHTTP(discordWebHook, function(result)
    end, payload)
end

-- Initialize variables
local currentRoundId = (#roundData > 0) and (roundData[#roundData].roundId + 1) or 1
local roundStartTime = 0
local roundClients = {}

-- Hook for round start
Hook.Add("roundStart", "namelogging", function()
    -- Reset variables
    roundClients = {}
    roundStartTime = os.time()

    for i, client in pairs(Client.ClientList) do
        local clientData = {
            name = client.Name,
            steamId = client.SteamID,
            characterName = client.Character and client.Character.Name or "N/A",
            job = client.Character and client.Character.JobIdentifier.ToString() or "N/A",
            isTraitor = false -- Initialize as false
        }
        table.insert(roundClients, clientData)
    end
end)

-- Hook for round end
Hook.Add("roundEnd", "roundEndLogging", function()

    -- Calculate round time
    local roundTime = os.time() - roundStartTime

    -- Update client list with any new clients or characters who joined mid-game
    for i, client in pairs(Client.ClientList) do
        local found = false
        for _, roundClient in ipairs(roundClients) do
            if roundClient.steamId == client.SteamID then
                found = true
                break
            end
        end

        if not found then
            local clientData = {
                name = client.Name,
                steamId = client.SteamID,
                characterName = client.Character and client.Character.Name or "N/A",
                job = client.Character and client.Character.JobIdentifier.ToString() or "N/A",
                isTraitor = false -- Initialize as false
            }
            table.insert(roundClients, clientData)
        end
    end

    -- Check for traitors
    local traitors = {}
    for i, character in pairs(Character.CharacterList) do
        if character.IsTraitor then
            local traitorName = character.Name
            table.insert(traitors, traitorName)
            for _, client in ipairs(roundClients) do
                if client.characterName == traitorName then
                    client.isTraitor = true
                end
            end
        end
    end

    -- Prepare round data
    local newRound = {
        roundId = currentRoundId,
        roundTime = roundTime,
        clients = roundClients,
        traitors = traitors
    }

    -- Save round data and send to Discord
    addRoundData(newRound)
    sendRoundInfoToDiscord(newRound)

    -- Increment round ID for next round
    currentRoundId = currentRoundId + 1
end)
