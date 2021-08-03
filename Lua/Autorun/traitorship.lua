local traitormod = Traitormod
local respawnshuttle = nil
local loadedpeople = {}

local config = dofile("Mods/traitormod/Lua/traitorconfig.lua")
local util = dofile("Mods/traitormod/Lua/util.lua")

Game.OverrideRespawnSub(config.infiltrationEnabled)

Hook.Add("think", "traitorShip", function()
    if respawnshuttle ~= nil then

        local pos1 = Submarine.MainSub.WorldPosition
        local pos2 = respawnshuttle.WorldPosition

        if Vector2.Distance(pos1, pos2) < config.infiltrationShipGodModeDistance then
            respawnshuttle.GodMode = false
        end

        for key, value in pairs(traitormod.roundtraitors) do
            local client = util.clientChar(key)

            if client ~= nil then
                if client.InGame == true and loadedpeople[key] == nil then
                    loadedpeople[key] = {}
                    loadedpeople[key].next = Timer.GetTime() + 15
                elseif loadedpeople[key] ~= nil and Timer.GetTime() <
                    loadedpeople[key].next then
                    Player.SetClientCharacter(client, key)
                end

            end
        end

    end
end)

Hook.Add("roundEnd", "traitorShipRemove", function()
    respawnshuttle = nil

    loadedpeople = {}
end)

traitormod.spawnTraitorShipAndHide = function()

    Game.SetRespawnSubTeam(2)
    Game.DispatchRespawnSub()

    local sub = Game.GetRespawnSub()
    sub.ShowSonarMarker = false

    sub.GodMode = true

    local steering = Game.GetSubmarineSteering(sub)
    steering.AutoPilot = false

    sub.SetPosition({0, Level.Loaded.BottomPos + 1000})

    return sub
end

traitormod.spawnTraitorShip = function()
    Game.SetRespawnSubTeam(2)
    Game.DispatchRespawnSub()

    local sub = Game.GetRespawnSub()
    respawnshuttle = sub

    sub.ShowSonarMarker = false

    local positions = Level.Loaded.PositionsOfInterest

    local goodpositions = {}

    for key, value in ipairs(positions) do
        if value.PositionType == PositionType.MainPath then
            table.insert(goodpositions, value)
        end
    end

    -- sub.SetPosition({Level.Loaded.EndPosition[1], Level.Loaded.EndPosition[2] - 10000})
    sub.SetPosition(goodpositions[math.floor(#goodpositions / 2)].Position.ToVector2())
    -- sub.SetPosition(CreateVector2(0, Level.Loaded.BottomPos + 1000))

    sub.GodMode = true

    local steering = Game.GetSubmarineSteering(sub)

    steering.AutoPilot = false

    return sub
end

traitormod.traitorShipRoundStart = function(maxplayers)
    local sub = traitormod.spawnTraitorShip()

    local assignedNowTraitors = traitormod.chooseTraitors(maxplayers)

    for index, value in pairs(assignedNowTraitors) do
        traitormod.roundtraitors[value] = {}
        traitormod.roundtraitors[value].name = "an Infiltration Traitor"
        traitormod.roundtraitors[value].objectiveType = "infiltration"

        local mess =
            "You are a Infiltration Traitor! Your mission is to exterminate the Main Sub's Crew, cooperate with your fellow agents."

        mess = mess ..
                   "\n\nUse the codewords to communicate with the other agents."
        mess = mess .. "\n\n The code words are: "

        for key, va in pairs(traitormod.selectedCodePhrases) do
            mess = mess .. "\"" .. va .. "\" "
        end

        mess = mess .. "\n The code response is: "

        for key, va in pairs(traitormod.selectedCodeResponses) do
            mess = mess .. "\"" .. va .. "\" "
        end

        mess = mess .. "\n\n(You can type in local chat !traitor, to check this information again.)"

        Game.Log(value.name .. " Was assigned to be Infiltration traitor", 6)

        local cl = util.clientChar(value)

        traitormod.sendTraitorMessage(mess, cl)

        local waypoint = WayPoint.GetRandom(SpawnType.Human, nil, sub)

        value.TeleportTo(waypoint.WorldPosition)
        -- Player.SetClientCharacter(cl, value)
    end
end
