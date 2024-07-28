function Traitormod.GetClientByName(sender,inputName)
    inputName = inputName:lower()

    -- Find by client name or SteamID
    for i,client in pairs(Client.ClientList) do
        if type(client.Name) == "string" and client.Name:lower():find(inputName, 1, true) then
            return client
        elseif client.SteamID == inputName then
            return client
        end
    end

    -- Find by character name
    for _, client in pairs(Client.ClientList) do
        if client.Character and type(client.Character.Name) == "string" and client.Character.Name:lower():find(inputName, 1, true) then
            return client
        end
    end

    return nil
end

--testing new search method

-- Levenshtein distance function for fuzzy matching
--[[local function levenshtein(str1, str2)
    local len1 = #str1
    local len2 = #str2
    local matrix = {}
    
    for i = 0, len1 do
        matrix[i] = {[0] = i}
    end
    
    for j = 0, len2 do
        matrix[0][j] = j
    end
    
    for i = 1, len1 do
        for j = 1, len2 do
            local cost = (str1:sub(i, i) == str2:sub(j, j)) and 0 or 1
            matrix[i][j] = math.min(
                matrix[i - 1][j] + 1,      -- deletion
                matrix[i][j - 1] + 1,      -- insertion
                matrix[i - 1][j - 1] + cost -- substitution
            )
        end
    end
    
    return matrix[len1][len2]
end

-- Function to find the best match
local function findBestMatch(input, clients)
    local matches = {}
    local threshold = 7  -- Adjust based on the tolerance for typos
    
    for i, client in pairs(clients) do
        local clientName = client.Name or ""
        local steamId = client.SteamID or ""
        
        -- Check client name and steamid
        if type(clientName) == "string" and levenshtein(input, clientName:lower()) <= threshold then
            table.insert(matches, {type="client", client=client, name=clientName, id=steamId})
        elseif levenshtein(input, steamId) <= threshold then
            table.insert(matches, {type="client", client=client, name=clientName, id=steamId})
        end
        
        -- Check character names associated with the client
        if client.Character and type(client.Character.Name) == "string" and levenshtein(input, client.Character.Name:lower()) <= threshold then
            local characterName = client.Character.Name
            table.insert(matches, {type="character", client=client, name=characterName, id=steamId})
        end
    end
    
    -- Sort matches by Levenshtein distance
    table.sort(matches, function(a, b)
        local a_value = levenshtein(input, a.name:lower())
        local b_value = levenshtein(input, b.name:lower())
        return a_value < b_value
    end)
    
    return matches
end

-- Function to get a client by name with fuzzy matching
function Traitormod.GetClientByName(sender, inputName)
    inputName = inputName:lower()

    -- Assuming these functions return the appropriate lists
    local clients = Client.ClientList or {}

    -- Find the best matches
    local results = findBestMatch(inputName, clients)

    if #results == 1 then
        -- Return the best match if there's only one result
        return results[1].client
    elseif #results > 1 then
        -- Check if multiple results have the same Levenshtein distance
        local closest_distance = levenshtein(inputName, results[1].name:lower())
        local same_distance_count = 0
        
        for _, result in ipairs(results) do
            if levenshtein(inputName, result.name:lower()) == closest_distance then
                same_distance_count = same_distance_count + 1
            else
                break
            end
        end
        
        if same_distance_count == 1 then
            -- If there's only one closest match
            return results[1].client
        else
            -- If multiple matches have the same closest distance
            return nil
        end
    end

    return nil
end]]

