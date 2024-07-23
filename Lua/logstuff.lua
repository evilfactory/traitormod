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
function AddRoundData(newRound)
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
        roundInfo = roundInfo .. string.format("Name: %s, SteamID: %s, Character: %s, Job: %s\n",
            client.name, client.steamId, client.characterName, client.job)
    end

    roundInfo = roundInfo .. "**Traitors:**\n"
    for _, traitor in ipairs(round.traitors) do
        roundInfo = roundInfo .. traitor .. "\n"
    end

    return roundInfo
end

-- Send round information to Discord
function SendRoundInfoToDiscord(round)
    local discordWebHook = "https://discord.com/api/webhooks/1265160570504609792/Aw1Mq3fYIH7v2J6MUc-632sqt3fNyQvtv9yxf7z7gLqpmSw7dKon5RzkYXtq6Et9yRHe"
    local roundInfo = formatRoundInfo(round)
    local escapedMessage = escapeQuotes(roundInfo)
    Networking.RequestPostHTTP(discordWebHook, function(result) end, '{\"content\": \"'..escapedMessage..'\", \"username\": \"'..'Round Logger'..'\"}')
end

-- Initialize variables
local currentRoundId = (#roundData > 0) and (roundData[#roundData].roundId + 1) or 1

-- Hook for round start
Hook.Add("roundStart", "namelogging", function()
    -- Reset variables
    local roundClients = {}
    local roundStartTime = os.time()

    for i, client in pairs(Client.ClientList) do
        local clientData = {
            name = client.Name,
            steamId = client.SteamID,
            characterName = client.Character and client.Character.Name or "N/A",
            job = client.Character and client.Character.JobIdentifier.ToString() or "N/A"
        }
        table.insert(roundClients, clientData)
    end

    -- Save round data
    local newRound = {
        roundId = currentRoundId,
        roundTime = os.time() - roundStartTime,
        clients = roundClients,
        traitors = {} -- No traitor check for now
    }
    AddRoundData(newRound)
    SendRoundInfoToDiscord(newRound)
    print("Round: "..currentRoundId.." data saved")

    -- Increment round ID for next round
    currentRoundId = currentRoundId + 1
end)
