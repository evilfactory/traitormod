-- Courtesy of Rei --

-- Notes --
-- Traitormod.AwardPoints(client, refundTable.Price)
-- local points = Traitormod.GetPoints(client)

local price = 500

local killers = {}

Hook.Add("character.death", "playerDeath", function (character)
    --check for character teamtype and if they are human needs to be added here, shouldnt get points for killing allies and monsters
    local killer = character.LastAttacker -- client
    if not killer then return end
    --debug
    print(killer.Name)
    if killer.TeamID ~= 2 and killer.TeamID ~= 0 then
        return
    end
    -- better nested table structure added, prevented duplicate entries
    if not killers[killer] then
        killers[killer] = { RealName = killer.Name, ClientCharacter = Util.FindClientCharacter(killer)--[[Client of Character]], Count = 0 }
    end
    killers[killer].Count = killers[killer].Count + 1
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
            print("awarded "..client.Character.Name.." "..bounty.." points, reset count to 0")
            found = true
            return true
        end
    end

    if not found then
        print("No entries for " .. client.Character.Name .. " existed out of " .. #killers .. " entries.") --debug
        for _, killer in pairs(killers) do
            print(killer.RealName)
        end
    end

    return false
end)
