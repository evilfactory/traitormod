local statistics = {}
statistics.stats = {}

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

statistics.SetClientStat = function (category, description, client, value)
    if statistics[category] == nil then 
        statistics.stats[category] = {}
        --statistics.stats[category].Topic = description
    end

    if statistics.stats[category][client.SteamID] == nil then statistics.stats[category][client.SteamID] = {} end

    statistics.stats[category][client.SteamID].Name = client.Name
    statistics.stats[category][client.SteamID].Score = value
    statistics.stats[category][client.SteamID].Topic = description
end

statistics.AddClientStat = function (category, description, client, value)
    local oldValue = (statistics.stats[category] and statistics.stats[category][client.SteamID] and statistics.stats[category][client.SteamID].Score) or 0
    statistics.SetClientStat(category, description, client, oldValue + value)
end

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

Traitormod.AddCommand("!stats", function (client, args)
    local text = "No stats found."

    if #args > 0 then
        if statistics.stats[args[1]] then
            local itemLimit = 30 -- should not be much more than 50
            local elem = statistics.stats[args[1]]
            local topic = ""
            text = ""

            for key, value in spairs(elem, function(t,a,b) return t[b] < t[a] end) do
                if type(value) == "table" then
                    if topic == "" then
                        topic = args[1] .. " - " .. value.Topic
                    end
                    text = text .. "\n" .. value.Score .. " - " .. (value.Name or key)
                else
                    topic = args[1]
                    text = text .. "\n" .. value .. " - " ..  key
                end

                itemLimit = itemLimit - 1
                if itemLimit == 0 then
                    break
                end
            end

            text = topic .. ":\n" .. text
        end
    else
        -- list categories
        text = "Categories:\n"
        for key, value in pairs(statistics.stats) do
            text = text .. "\n" .. key
        end
    end

    Traitormod.SendMessage(client, text)

    return true
end)

Traitormod.Stats = statistics