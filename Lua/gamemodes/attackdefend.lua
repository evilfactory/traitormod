local weightedRandom = dofile(Traitormod.Path .. "/Lua/weightedrandom.lua")
local gm = Traitormod.Gamemodes.Gamemode:new()

gm.Name = "AttackDefend"

function gm:Start()
    local teams = {} 
    teams[1] = {}
    teams[1].Members = {}
    teams[1].Spawns = {}
    teams[2] = {}
    teams[2].Members = {}
    teams[2].Spawns = {}


    for key, value in pairs(Item.ItemList) do
        if value.GetComponentString("Reactor") then
            if value.HasTag("redteam") then
                teams[1].Reactor = value
            elseif value.HasTag("blueteam") then
                teams[2].Reactor = value
            end
        end
    end

    for index, client in ipairs(Client.ClientList) do
        if not client.SpectateOnly and client.Character then
            if client.PreferredJob == "captain" or client.PreferredJob == "securityofficer" or client.PreferredJob == "medicaldoctor" then
                table.insert(teams[1].Members, client)
                client.Character.TeamID = CharacterTeamType.Team1
            else
                table.insert(teams[2].Members, client)
                client.Character.TeamID = CharacterTeamType.Team2
            end
        end
    end

    for key, value in pairs(Submarine.GetWaypoints(true)) do
        if value.AssignedJob.Identifier == "mechanic" then
            table.insert(teams[1].Spawns, value)
        elseif value.AssignedJob.Identifier == "engineer" then
            table.insert(teams[2].Spawns, value)
        end
    end

    for _, team in pairs(teams) do
        for _, member in pairs(teams.Members) do
            member.Character.TeleportTo(team.Spawns[math.random(1, #team.Spawns)].WorldPosition)
        end
    end
end

function gm:AwardPoints()

end

function gm:End()
    if #Client.ClientList >= self.MinimumPlayersForPoints then
        self:AwardPoints()
    end

    -- first arg = mission id, second = message, third = completed, forth = list of characters
    return nil
end

function gm:Think()

end

return gm
