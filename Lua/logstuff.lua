local json = require("json")

-- Load round data from JSON file
function json.loadRoundData()
    local path = Traitormod.Path .. "/Lua/round_data.json"
    
    if not File.Exists(path) then
        File.Write(path, "{}")
    end

    local content = File.Read(path)
    return json.decode(content)
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
    table.insert(roundData, newRound)

    -- Remove oldest round if exceeding max rounds
    if #roundData > maxRounds then
        table.remove(roundData, 1)
    end

    json.saveRoundData(roundData)
end

Hook.Add("roundStart", "namelogging", function()
    local roundId = (#roundData > 0) and (roundData[#roundData].roundId + 1) or 1
    local roundStartTime = os.time()
    local roundClients = {}
    local traitors = {}

    for i, client in pairs(Client.ClientList) do
        local clientData = {
            name = client.Name,
            steamId = client.SteamID,
            characterName = client.Character.Name or "N/A"
        }
        table.insert(roundClients, clientData)
    end

    -- Delay to check for traitors
    Timer.Wait(function()
        for i, client in pairs(Client.ClientList) do
            if client.Character and client.Character.IsTraitor then
                table.insert(traitors, client.Name)
            end
        end

        -- Save round data after traitor information is collected
        local newRound = {
            roundId = roundId,
            roundTime = os.time() - roundStartTime,
            clients = roundClients,
            traitors = traitors
        }
        AddRoundData(newRound)

    end, 120000) -- 2 minutes delay to check for traitor status
end)
