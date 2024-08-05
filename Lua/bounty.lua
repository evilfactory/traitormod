-- Courtesy of Rei --

-- Notes --
-- Traitormod.AwardPoints(client, refundTable.Price)
-- local points = Traitormod.GetPoints(client)

local price = 500

local killers = {}

Hook.Add("character.death", "playerDeath", function (character)
    --check for character teamtype and if they are human needs to be added here, shouldnt get points for killing allies and monsters
    local killer = character.LastAttacker
    if not killer then return end
    --debug
    print(killer.Name)
    if killer.TeamID ~= 2 and killer.TeamID ~= 0 then
        return
    end
    -- better nested table structure added, prevented duplicate entries
    if not killers[killer] then
        killers[killer] = { RealName = killer.Name, ClientCharacter = Util.FindClientCharacter(killer), Count = 0 }
    end
    killers[killer].Count = killers[killer].Count + 1
end)

Traitormod.AddCommand("!claim", function (client, args)
    if not client.Character then
        print("client character does not exist")
        return false
    end

    for _, killer in pairs(killers) do
        if killer.Character == client.Character then
            local bounty = price * killer.Count
            Traitormod.AwardPoints(client, bounty)
            -- Reset the count after claiming
            killer.Count = 0
            print("awarded "..client.Character.Name.." "..bounty.." points, reset count to 0")
            return true
        end
    end
    print("claim failed")
    return false
end)