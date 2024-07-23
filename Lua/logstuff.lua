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

-- Send round information to Discord
function SendRoundInfoToDiscord(round)
    local discordWebHook = "https://discord.com/api/webhooks/1265160570504609792/Aw1Mq3fYIH7v2J6MUc-632sqt3fNyQvtv9yxf7z7gLqpmSw7dKon5RzkYXtq6Et9yRHe"
    local roundInfo = string.format("Round ID: %d\nRound Time: %d seconds\n", round.roundId, round.roundTime)
    roundInfo = roundInfo .. "Clients:\n"
    
    for _, client in ipairs(round.clients) do
        roundInfo = roundInfo .. string.format("Name: %s, SteamID: %s, Character: %s, Job: %s\n",
            client.name, client.steamId, client.characterName, client.job)
    end

    local escapedMessage = roundInfo:gsub("\"", "\\\"")
    Networking.RequestPostHTTP(discordWebHook, function(result) end, '{\"content\": \"'..escapedMessage..'\", \"username\": \"'..'Round Logger'..'\"}')
end

local currentRoundId = (#roundData > 0) and (roundData[#roundData].roundId + 1) or 1
local roundStartTime = os.time()
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
end)

-- Disabling the round end hook for now
-- Hook.Add("roundEnd", "roundEndLogging", function()
--     roundEnded = true

--     -- Save round data if round ends before 2 minutes
--     for i, client in pairs(Client.ClientList) do
--         if client.Character and client.Character.IsTraitor then
--             table.insert(traitors, client.Name)
--         end
--     end

--     local newRound = {
--         roundId = currentRoundId,
--         roundTime = os.time() - roundStartTime,
--         clients = roundClients,
--         traitors = traitors
--     }
--     addRoundData(newRound)
--     sendRoundInfoToDiscord(newRound)
--     print("Round: "..currentRoundId.." data saved")
-- end)
