-- Courtesy of Rei --

-- Notes --
-- Traitormod.AwardPoints(client, refundTable.Price)
-- local points = Traitormod.GetPoints(client)

local price = 500

local killers = {}

Hook.Add("character.death", "playerDeath", function (character)
    -- Check for character team type and if they are human
    if character.TeamID ~= CharacterTeamType.Team1 and character.TeamID ~= CharacterTeamType.Team2 then
        return
    end

    local killer = character.LastAttacker
    if not killer then
        print("killer does not exist")
        return
    end

    -- Debug
    print(killer.Name .. " killed " .. character.Name)

    if killer.TeamID == character.TeamID or not killer.IsM then
        print(killer.Name .. "'s team is " .. killer.TeamID .. ", no points awarded for killing allies.")
        return
    end

    -- Better nested table structure added, prevented duplicate entries
    local killerID = killer.ID -- Use a unique identifier
    if not killers[killerID] then
        killers[killerID] = { RealName = killer.Name, ClientCharacter = Util.FindClientCharacter(killer), Count = 0 }
    end
    killers[killerID].Count = killers[killerID].Count + 1
end)

Traitormod.AddCommand("!claim", function (client, args)
    if not client.Character then
        print("client character does not exist")
        return false
    end

    local found = false
    for _, killer in pairs(killers) do
        if killer.ClientCharacter == client.Character then
            local bounty = price * killer.Count
            Traitormod.AwardPoints(client, bounty)
            -- Reset the count after claiming
            killer.Count = 0
            print("awarded " .. client.Character.Name .. " " .. bounty .. " points, reset count to 0")
            found = true
            return true
        end
    end

    if not found then
        print("No entries for " .. client.Character.Name .. " existed out of " .. #killers .. " entries.") -- Debug
        for _, killer in pairs(killers) do
            print(killer.RealName)
        end
    end

    return false
end)