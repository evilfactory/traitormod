local traitormod = Traitormod
local respawnshuttle = nil
local loadedpeople = {}

local config = dofile("Mods/traitormod/Lua/traitorconfig.lua")
local util = dofile("Mods/traitormod/Lua/util.lua")

if not config.overrideDefaultTraitors then
    Game.OverrideRespawnSub(false)
    return
end 

Game.OverrideRespawnSub(config.infiltrationEnabled or config.pincerEnabled)

Hook.Add("think", "traitorShip", function()
    if respawnshuttle ~= nil then

        local pos1 = Submarine.MainSub.WorldPosition
        local pos2 = respawnshuttle.WorldPosition

        if Vector2.Distance(pos1, pos2) < config.infiltrationShipGodModeDistance and respawnshuttle.GodMode then
            respawnshuttle.GodMode = false
            Game.SendMessage("Be on the lookout, an unidentified sonar signature has been detected nearby, and it's closing in fast!", 1)
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

    local steering = Game.GetSubmarineSteering(sub)
    steering.AutoPilot = false

    sub.SetPosition(CreateVector2(0, Level.Loaded.BottomPos + 1000))

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
    local goodposition = goodpositions[math.floor(#goodpositions / 2)].Position.ToVector2()
    sub.SetPosition(goodposition)
    Game.Explode(goodposition, 100, 0, 9999, 9999, 0, 0, 0)
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
        traitormod.roundtraitors[value].name = "an Infiltration Agent"
        traitormod.roundtraitors[value].objectiveType = "infiltration"

        local minimess = "."
        if maxplayers >= 2 then
            minimess = ", cooperate with your fellow agents."
        end
        local mess =
            "You are an Infiltration Agent! Your mission is to exterminate the Main Sub's Crew" .. minimess .. " Good Luck, agent."

        mess = mess .. "\n\n(You can type in local chat !traitor to check this information again.)"

        Game.Log(value.name .. " Was assigned to be Infiltration agent", 6)

        local cl = util.clientChar(value)

        traitormod.sendTraitorMessage(mess, cl)

        local waypoint = WayPoint.GetRandom(SpawnType.Human, nil, sub)

        value.TeleportTo(waypoint.WorldPosition)
        -- Player.SetClientCharacter(cl, value)
    end
end

traitormod.pincerRoundStart = function(maxplayers)
    local sub = traitormod.spawnTraitorShip()

    --probably 99999 mistakes with tables cuz i dont know how to use them
    local assignedNowTraitors = traitormod.chooseTraitors(maxplayers)
    local shuttleOperative = assignedNowTraitors[Random.Range(1, maxplayers)]
    local mainOperatives = {}
    --local mainOperatives = assignedNowTraitors.copy
    --table.remove(mainOperatives, shuttleOperative)

    --if desmond explains how copy works, just use the above thing
    for index, value in pairs(assignedNowTraitors) do
        traitormod.roundtraitors[value] = {}
        traitormod.roundtraitors[value].name = "a Pincer Operative"
        traitormod.roundtraitors[value].objectiveType = "Pincer"
        if value ~= shuttleOperative then
            table.insert(mainOperatives, value)
        end
    end

    local codewordmess = "\n\n The code words are: "

    for key, va in pairs(traitormod.selectedCodePhrases) do
        codewordmess = codewordmess .. "\"" .. va .. "\" "
    end

    codewordmess = codewordmess .. "\n The code response is: "

    for key, va in pairs(traitormod.selectedCodeResponses) do
        codewordmess = codewordmess .. "\"" .. va .. "\" "
    end

    --this is for the shuttle operative
    local mess = "You are a Pincer Operative! Your mission is to exterminate the Main Sub's Crew, but be careful, as someone onboard is working for us. Good Luck, agent."

    mess = mess .. "\n\nUse the codewords to communicate with the other operatives."
    mess = mess .. codewordmess
    mess = mess .. "\n\n(You can type !traitor in local chat to check this information again.)"

    Game.Log(shuttleOperative.name .. " Was assigned to be a Pincer Operative", 6)

    local cl = util.clientChar(shuttleOperative)

    traitormod.sendTraitorMessage(mess, cl)

    local waypoint = WayPoint.GetRandom(SpawnType.Human, nil, sub)

    shuttleOperative.TeleportTo(waypoint.WorldPosition)
    -- Player.SetClientCharacter(cl, shuttleOperative)

    -- time for main operatives (player makes more sense to me than value)
    local messparttwo = "You are a Pincer Operative! A fellow operative will be infiltrating the station from outside within minutes, and it is your job to contact and assist them, sabatoging the crew from behind the scenes. Good Luck."
    messparttwo = messparttwo .. "\n\nUse the codewords to communicate with the other operatives."
    messparttwo = messparttwo .. codewordmess
    messparttwo = messparttwo .. "\n\n(You can type !traitor in local chat to check this information again.)"
    for index, player in pairs(mainOperatives) do
        local cl2 = util.clientChar(player)
        traitormod.sendTraitorMessage(messparttwo, cl2)
    end
end