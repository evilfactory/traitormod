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

local function checkCommandQueue()
    local api_endpoint = 'http://165.22.185.236:8080/commandqueue'
    local data = {
        api_key = api_key
    }
    
    Networking.RequestGetHTTP(api_endpoint .. "?api_key=" .. api_key, function(result)
        if result ~= "" then
            local commands = json.decode(result)
            if #commands > 0 then
                for _, command in ipairs(commands) do
                    if not Starts_with_special_char(command.content) then
                        print("Received command from " .. command.author .. ": " .. command.content)
                        for client in Client.ClientList do
                            if client.Character == nil or client.Character.IsDead then
                                Traitormod.SendChatMessage(client, "(Discord) "..command.author .. ": " .. command.content)
                            end
                        end
                    end
                end
            end
        end
    end)
end

-- Add this to your existing timer or create a new one
local CommandQueueTick = 0
Hook.Add("Think", "CommandQueueTimer", function()
    CommandQueueTick = CommandQueueTick + 1
    if CommandQueueTick >= 180 then  -- Check every 10 seconds (adjust as needed)
        checkCommandQueue()
        CommandQueueTick = 0
    end
end)

-- Add this function to your existing Lua script
--[[function Traitormod.SendChatToDiscord(sender, message)
    local chat_endpoint = 'http://165.22.185.236:8080/chat'
    local data = {
        api_key = api_key,
        sender = sender,
        message = message
    }
    
    local payload = json.encode(data)
    Networking.RequestPostHTTP(chat_endpoint, function(result)
        if result == "Message sent to Discord" then
            print("Chat message successfully sent to Discord")
        else
            print("Failed to send chat message to Discord: " .. tostring(result))
        end
    end, payload)
end

-- Example usage:
-- You can call this function whenever you want to send a chat message to Discord
-- For example, you might hook it into your game's chat system
Hook.Add("chatMessage", "SendToDiscord", function(message, client)
    local alive = "Alive"
    if client.Character == nil or client.Character.IsDead then
        alive = "Dead"
    end

    if not Starts_with_special_char(message) then
        Traitormod.SendChatToDiscord(client.Name .. " (" .. alive .. ")", message)
    end
end)

function Starts_with_special_char(str)
    if str:match("^[/:!;><]") then
        return true
    else
        return false
    end
end

Auth_codes = {}

Traitormod.AddCommand("!discord", function (client, args)
    if #args < 1 then
        Traitormod.SendMessage(client, "Usage: !Discord \"yourdiscordid\"")
        return true
    end

    local discordid = table.remove(args, 1)
    local auth_code = tostring(math.random(1000, 9999))
    Auth_codes[client.SteamID] = {code = auth_code, discord_id = discordid}

    -- Send authentication request to the bot
    local auth_endpoint = 'http://165.22.185.236:8080/auth_request'
    local data = {
        api_key = api_key,
        steam_id = client.SteamID,
        discord_id = discordid,
        auth_code = auth_code
    }
    
    local payload = json.encode(data)
    Networking.RequestPostHTTP(auth_endpoint, function(result)
        if result == "Authentication request sent" then
            Traitormod.SendMessage(client, "Your authentication code is " .. auth_code.. ", enter it in the discord dms", nil)
        else
            Traitormod.SendMessage(client, "Failed to send authentication request. Please try again later.")
        end
    end, payload)

    return true
end)]]

Hook.Add("chatMessage", "content filter", function(message, client)
    -- Load words from words.json
    local words = {}
    local content = File.Read(Traitormod.Path .. "/Lua/words.json")
    if content then
        words = json.decode(content)
    end

    -- Check if any word from words.json is in the message
    for _, word in ipairs(words) do
        if string.match(message:lower(), word:lower()) then
            if client.Character then
                client.Character.Kill()
            end
            Traitormod.SendMessage(client, "You have been warned for violating the content filter.")
           return true
        end
    end
end)

--[[function Traitormod.SendMessageToDiscord(message, client, channel)
    local data = {
        api_key = api_key,
        data_type = "chat",
        data = {
            sender = client.Name,
            message = message,
            channel = channel
        }
    }

    local payload = json.encode(data)
    print("Sending chat message to Discord: " .. payload)  -- Add this line for debugging
    Networking.RequestPostHTTP(api_endpoint, function(result)
        print("Received response for chat message: " .. tostring(result))
    end, payload)
end]]

