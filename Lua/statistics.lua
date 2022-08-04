local statistics = {}
statistics.stats = {}
local textPromptUtils = require("textpromptutils")

local itemLimit = 30 -- should not be much more than 50

if Traitormod.Config.PermanentStatistics and not File.Exists(Traitormod.Path .. "/Lua/stats.json") then
    File.Write(Traitormod.Path .. "/Lua/stats.json", "{}")
end 

local json = dofile(Traitormod.Path .. "/Lua/json.lua")
statistics.LoadData = function ()
    if Traitormod.Config.PermanentStatistics then
        statistics.stats = json.decode(File.Read(Traitormod.Path .. "/Lua/stats.json")) or {}
    else
        statistics.stats = {}
    end
end

statistics.SaveData = function ()
    if Traitormod.Config.PermanentStatistics then
        File.Write(Traitormod.Path .. "/Lua/stats.json", json.encode(statistics.stats))
    end
end

statistics.SetStat = function (category, key, value)
    if statistics.stats[category] == nil then statistics.stats[category] = {} end
    statistics.stats[category][key] = value
end

statistics.AddStat = function (category, key, value)
    if statistics.stats[category] == nil then statistics.stats[category] = {} end
    statistics.SetStat(category, key, (statistics.stats[category][key] or 0) + value)
    return statistics.stats[category][key]
end

statistics.GetStat = function (category, key)
    return statistics.stats[category][key]
end

statistics.SetListStat = function (category, description, key, value, name)
    if statistics.stats[category] == nil then 
        statistics.stats[category] = {}
        --statistics.stats[category].Topic = description
    end

    if statistics.stats[category][key] == nil then 
        statistics.stats[category][key] = {} 
    end

    statistics.stats[category][key].Name = name or key
    statistics.stats[category][key].Score = value
    statistics.stats[category][key].Topic = description
end

statistics.AddListStat = function (category, description, key, value, name)
    local oldValue = 0
    if statistics.stats[category] and statistics.stats[category][key] then
        oldValue = statistics.stats[category][key].Score or 0
    end
    statistics.SetListStat(category, description, key, (oldValue + value), name)
end

statistics.AddClientStat = function(category, description, client, value)
    statistics.AddListStat(category, description, client.SteamID, value, client.Name)
end

statistics.ShowStats = function(client, category)
    local text = "No stats found."
    local elem = statistics.stats[category]

    if elem then
        local firstKey = next(elem)
        if firstKey ~= nil then
            local compare = function(t,a,b) return t[b] < t[a] end
            local isTable = false
            local topic = ""
            text = ""

            if elem[firstKey] and type(elem[firstKey]) == "table" and elem[firstKey].Score ~= nil then
                compare = function(t,a,b) return t[b].Score < t[a].Score end
                isTable = true
            end

            for key, value in spairs(elem, compare) do
                if isTable then
                    if topic == "" then
                        topic = category .. " - " .. value.Topic
                    end
                    text = text .. "\n" .. value.Score .. " - " .. (value.Name or key)
                else
                    topic = category
                    text = text .. "\n" .. value .. " - " ..  key
                end

                itemLimit = itemLimit - 1
                if itemLimit == 0 then
                    break
                end
            end

            text = topic .. ":\n" .. text
        end
    end

    Traitormod.SendMessage(client, text)
end

Traitormod.AddCommand("!stats", function (client, args)
    if #args > 0 then
        statistics.ShowStats(client, args[1])
    else
        local text = "Available stats:\n"

        if next(statistics.stats) == nil  then
            text = "No statistics available yet. Go start a round to collect stats."
        else
            local options = {}
            if client.InGame then
                -- if in game show convenient prompt
                for key, value in pairs(statistics.stats) do
                    table.insert(options, key)
                end
                
                textPromptUtils.Prompt(text, options, client, function (id, client2)
                    statistics.ShowStats(client2, options[id])
                end)

                return
            else
                -- else offer inconvenient cmd option
                for key, value in pairs(statistics.stats) do
                    text = text .. "\n>> " .. key
                end
                text = text .. "\n\nType '!stats [option]' to show stats or join a game to use a prompt."
            end
        end

        Traitormod.SendMessage(client, text)
    end

    return true
end)

function spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

statistics.LoadData()
Traitormod.Stats = statistics