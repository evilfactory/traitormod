-- Courtesy of Rei --

-- Notes --
-- Traitormod.AwardPoints(client, refundTable.Price)
-- local points = Traitormod.GetPoints(client)

local price = 500

local killers = {
    RName = {},
    CName = {},
    Count = {}
}

Hook.Add("character.death", "playerDeath", function (character)
    local killerName = character.LastAttacker
    if killerName.TeamID ~= CharacterTeamType.Team2 or killerName.TeamID ~= CharacterTeamType.Team0 then return end
    
    killers.RName[killerName] = killerName
    killers.CName[killerName] = Util.FindClientCharacter(killerName)
    killers.Count[killerName] += 1
end)

Traitormod.AddCommand("!claim", function (client, args) 
    local found = nil
    local bounty = nil
    for i=1, killers.CName do
        if killers.CName[i] == client then
            bounty = price * killers.Count[killers.RName[i]]
            Traitormod.AwardPoints(killers.CName[i], bounty)
            break
        end
    end
    return true
end)