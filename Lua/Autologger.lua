if CLIENT then return end

local api_endpoint = 'http://165.22.185.236:8080/update_data'
local api_key = 'javierbotapikey2'
local json = require 'json'

local function sendPlayerCountToAPI()
    local data = {
        api_key = api_key,
        data_type = "playercount",
        data = {
            player_count = #Client.ClientList,
            max_players = Game.ServerSettings.MaxPlayers,
            server_name = Game.ServerSettings.ServerName,
            map_name = Game.ServerSettings.SelectedSubmarine
        }
    }

    if next(data.data) ~= nil then
        local payload = json.encode(data)
        Networking.RequestPostHTTP(api_endpoint, function(result)
        end, payload)
    end
end

local Timertick = 0
Hook.Add("Think", "Timer", function()
    Timertick = Timertick + 1
    if Timertick >= 600 then
        sendPlayerCountToAPI()
        Timertick = 0
    end
end)


-- for bans
Hook.Patch(
    "Barotrauma.Networking.GameServer",
    "BanClient",
    {
        "Barotrauma.Networking.Client",
        "System.String",
        "System.TimeSpan"
    },

    function(instance, ptable)

      local client = ptable["client"]
      local reason = ptable["reason"]
      local duration = ptable["duration"]



      local data = {
        api_key = api_key,
        data_type = "punishment",
        data = {
            steamid = client.SteamID,
            name = client.Name,
            reason = reason,
            punishment = "Ban",
            tempban_duration = duration,
        }

        }
        local payload = json.encode(data)
        Networking.RequestPostHTTP(api_endpoint, function(result) end, payload)

    end, Hook.HookMethodType.Before)

function Traitormod.RecieveRoleBan(client, jobs, reason)
    -- Ensure jobs is a table (array) of strings
    local jobsArray = {}
    if type(jobs) == "string" then
        -- If jobs is a single string, split it into an array
        for job in jobs:gmatch("%S+") do
            table.insert(jobsArray, job)
        end
    elseif type(jobs) == "table" then
        -- If jobs is already a table, use it as is
        jobsArray = jobs
    else
        -- If jobs is neither a string nor a table, log an error
        print("Error: jobs must be a string or a table")
        return
    end

    local data = {
        api_key = api_key,
        data_type = "punishment",
        data = {
            steamid = client.SteamID,
            name = client.Name,
            reason = reason,
            punishment = "jobban",
            rolebanned_roles = jobsArray,  -- Send as an array
        }
    }

    local payload = json.encode(data)
    print("Sending jobban punishment payload: " .. payload)  -- Add this line for debugging
    Networking.RequestPostHTTP(api_endpoint, function(result)
        print("Received response for jobban punishment: " .. tostring(result))
    end, payload)
end

function Traitormod.RecieveWarn(client, reason)
    local data = {
        api_key = api_key,
        data_type = "punishment",
        data = {
            steamid = client.SteamID,
            name = client.Name,
            reason = reason,
            punishment = "warn",
            -- discordid is optional and can be omitted or set to nil
        }
    }

    local payload = json.encode(data)
    print("Sending warn punishment payload: " .. payload)  -- Add this line for debugging
    Networking.RequestPostHTTP(api_endpoint, function(result)
        print("Received response for warn punishment: " .. tostring(result))
    end, payload)
end

function Traitormod.SteamidToClient(steamid)
    for _, client in pairs(Client.ClientList) do
        if (client.SteamID == steamid) or (client.AccountInfo and client.AccountInfo.AccountId == steamid) then
            return client
        end
    end

    return nil
end

Hook.Patch(
    "Barotrauma.Networking.GameServer",
    "KickClient",
    {
        "Barotrauma.Networking.Client",
        "System.String",
        "System.Boolean"
    },

    function(instance, ptable)

      local client = ptable["client"]
      local reason = ptable["reason"]



      local data = {
        api_key = api_key,
        data_type = "punishment",
        data = {
            steamid = client.SteamID,
            name = client.Name,
            reason = reason,
            punishment = "Kick",
        }

        }
        local payload = json.encode(data)
        Networking.RequestPostHTTP(api_endpoint, function(result) end, payload)

    end, Hook.HookMethodType.Before)

--[[


    local data = {
        api_key = api_key,
        data_type = "punishment",
        data = {
            steamid = data.get('steamid')
            name = data.get('name')
            reason = data.get('reason')
            punishment = data.get('punishment')
            discordid = data.get('discordid')
            rolebanned_roles = data.get('rolebanned_roles')
            tempban_duration_str = data.get('tempban_duration')
        }
    }

]]