-- Courtesy of Rei --

-- Notes --
-- Traitormod.AwardPoints(client, refundTable.Price)
-- local points = Traitormod.GetPoints(client)

--[[local price = 500

local killers = {}

Hook.Add("character.death", "playerDeath", function (character)
    -- Check for character team type and if they are human
    if character.TeamID ~= CharacterTeamType.Team1 and character.TeamID ~= CharacterTeamType.Team2 then
        return
    end

    local killer = character.LastAttacker
    if not killer then
        return
    end




    if killer.TeamID == character.TeamID then
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
        return false
    end

    local found = false
    for _, killer in pairs(killers) do
        if killer.ClientCharacter == client.Character then
            local bounty = price * killer.Count
            Traitormod.AwardPoints(client, bounty)
            -- Reset the count after claiming
            killer.Count = 0
            found = true
            return true
        end
    end

    if not found then
        for _, killer in pairs(killers) do

        end
    end

    return false
end)]]
