local traitormod = {}
traitormod.peoplePercentages = {}

traitormod.roundtraitors = {}
traitormod.selectedCodeResponses = {}
traitormod.selectedCodePhrases = {}
traitormod.gamemodes = {}

traitormod.disableRadioChat = false

local endingRound = false
local roundEndDelay = 0

local traitorAssignDelay = 0
local traitorsAssigned = true
local traitorsRoundStartAssigned = false
local warningClients = {}
local setClientCharacterToNil = {}

local config = dofile("Mods/traitormod/Lua/traitorconfig.lua")
local util = dofile("Mods/traitormod/Lua/util.lua")

local assassinationChooseFunc 

if not config.overrideDefaultTraitors then
    Game.OverrideTraitors(config.overrideDefaultTraitors)
    return
end

Game.OverrideTraitors(config.overrideDefaultTraitors) -- shutup old traitors
Game.AllowWifiChat(config.enableWifiChat) -- fixes wifi chat

if config.chooseBotsAsTraitorTargets then
    assassinationChooseFunc = util.GetValidPlayersNoTraitors
else
    assassinationChooseFunc = util.GetValidPlayersNoBotsAndNoTraitors
end

traitormod.config = config

traitormod.setPercentage = function(client, amount)
    if client == nil then return end

    if traitormod.peoplePercentages[client.SteamID] == nil then
        traitormod.peoplePercentages[client.SteamID] = {}
        traitormod.peoplePercentages[client.SteamID].penalty = 1
        traitormod.peoplePercentages[client.SteamID].p =
            config.firstJoinPercentage
    end

    traitormod.peoplePercentages[client.SteamID].p = amount
end

traitormod.addPenalty = function(client, amount)
    if client == nil then return end

    if traitormod.peoplePercentages[client.SteamID] == nil then
        traitormod.peoplePercentages[client.SteamID] = {}
        traitormod.peoplePercentages[client.SteamID].penalty = 1
        traitormod.peoplePercentages[client.SteamID].p =
            config.firstJoinPercentage
    end

    traitormod.peoplePercentages[client.SteamID].penalty = traitormod.peoplePercentages[client.SteamID].penalty + amount
end

traitormod.getPenalty = function(client)
    if client == nil then return 0 end

    if traitormod.peoplePercentages[client.SteamID] == nil then
        traitormod.peoplePercentages[client.SteamID] = {}
        traitormod.peoplePercentages[client.SteamID].penalty = 1
        traitormod.peoplePercentages[client.SteamID].p =
            config.firstJoinPercentage
    end

    return traitormod.peoplePercentages[client.SteamID].penalty
end

traitormod.addPercentage = function(client, amount)
    if client == nil then return end

    if traitormod.peoplePercentages[client.SteamID] == nil then
        traitormod.peoplePercentages[client.SteamID] = {}
        traitormod.peoplePercentages[client.SteamID].penalty = 1
        traitormod.peoplePercentages[client.SteamID].p =
            config.firstJoinPercentage
    end

    traitormod.peoplePercentages[client.SteamID].p =
        traitormod.peoplePercentages[client.SteamID].p + amount
end

traitormod.getPercentage = function(client)
    if client == nil then return 0 end

    if traitormod.peoplePercentages[client.SteamID] == nil then
        traitormod.peoplePercentages[client.SteamID] = {}
        traitormod.peoplePercentages[client.SteamID].penalty = 1
        traitormod.peoplePercentages[client.SteamID].p =
            config.firstJoinPercentage
    end

    return traitormod.peoplePercentages[client.SteamID].p
end

traitormod.resetClientSpecific = function()
    setClientCharacterToNil = {}
    warningClients = {}
end

traitormod.chooseCodes = function()
    local codewords = dofile("Mods/traitormod/Lua/traitorconfig.lua").codewords -- copy

    local amount = config.amountCodewords

    for i = 1, amount, 1 do
        local rand = Random.Range(1, #codewords + 1)
        table.insert(traitormod.selectedCodeResponses, codewords[rand])
        table.remove(codewords, rand)
    end

    for i = 1, amount, 1 do
        local rand = Random.Range(1, #codewords + 1)
        table.insert(traitormod.selectedCodePhrases, codewords[rand])
        table.remove(codewords, rand)
    end

end

traitormod.selectPlayerPercentages = function(ignore)
    local players = util.GetValidPlayersNoBotsAndNoTraitors(
                        traitormod.roundtraitors)

    for i = 1, #players, 1 do
        for key, value in pairs(ignore) do
            if players[i] == value then table.remove(players, i) end
        end
    end

    local total = 0

    for key, value in pairs(players) do
        local client = util.clientChar(value)

        total = total + traitormod.getPercentage(client)
    end

    local rng = Random.Range(0, total)

    local addup = 0

    for key, value in pairs(players) do
        local client = util.clientChar(value)

        local percentage = traitormod.getPercentage(client)

        if rng >= addup and rng <= addup + percentage then return value end

        addup = addup + percentage

    end

    return nil

end

traitormod.chooseTraitors = function(amount)
    local traitors = {}

    for i = 1, amount, 1 do
        local found = traitormod.selectPlayerPercentages(traitors)

        if found == nil then
            print("Not enough players")
            break
        else
            table.insert(traitors, found)
        end
    end

    return traitors
end

traitormod.sendTraitorMessage = function(msg, client, notchatbox)
    if client == nil then return end

    if notchatbox == true then
        Game.SendDirectChatMessage("", msg, nil, 11, client)
    else
        Game.SendDirectChatMessage("", msg, nil, 7, client)
    end

    Game.SendDirectChatMessage("", msg, nil, 1, client)
end

traitormod.assignNormalTraitors = function(amount)
    local traitors = traitormod.chooseTraitors(amount)

    for key, value in pairs(traitors) do traitormod.roundtraitors[value] = {} end

    local targets = assassinationChooseFunc(traitormod.roundtraitors)

    if #targets == 0 then
        for key, value in pairs(traitors) do
            traitormod.sendTraitorMessage("Looks like you are a traitor without targets.", util.clientChar(value))
            traitormod.roundtraitors[value].name = "a traitor without targets"
            traitormod.roundtraitors[value].objectiveType = "nothing"
            return
        end
    end

    for key, value in pairs(traitors) do
        traitormod.roundtraitors[value].objectiveType = "kill"
        traitormod.roundtraitors[value].objectiveTarget =
            targets[Random.Range(1, #targets + 1)]
        traitormod.roundtraitors[value].name = "a Traitor"


        local mess =
            "You are a Traitor! Your secret mission is to assassinate " ..
                traitormod.roundtraitors[value].objectiveTarget.name ..
                "! Avoid being loud, make the death look like an accident. We will provide you more information after you finish your current mission."

        if util.TableCount(traitormod.roundtraitors) > 1 then
            mess = mess ..
                       "\n\nIt is possible that there are other agents on this submarine. You dont know their names, but you do have a method of communication. Use the code words to greet the agent and code response to respond. Disguise such words in a normal-looking phrase so the crew doesn't suspect anything."
            mess = mess .. "\n\n The code words are: "

            for key, va in pairs(traitormod.selectedCodePhrases) do
                mess = mess .. "\"" .. va .. "\" "
            end

            mess = mess .. "\n The code response is: "

            for key, va in pairs(traitormod.selectedCodeResponses) do
                mess = mess .. "\"" .. va .. "\" "
            end
        end

        mess = mess .. "\n\n(You can type !traitor in local chat to check this information again.)"


        Game.Log(value.name ..
                     " Was assigned to be traitor, his first mission is to kill " ..
                     traitormod.roundtraitors[value].objectiveTarget.name, 6)

        traitormod.sendTraitorMessage(mess, util.clientChar(value))

    end
end

traitormod.chooseNextObjective = function(key, value)
    local players = assassinationChooseFunc(traitormod.roundtraitors)

    if #players == 0 then
        traitormod.sendTraitorMessage("Good job agent, You did it.",
                                      util.clientChar(key), true)

        value.needNewObjective = false

        return
    end

    local assassinate = players[Random.Range(1, #players + 1)]

    traitormod.sendTraitorMessage("Your next mission is to assassinate " ..
                                      assassinate.name, util.clientChar(key),
                                  true)

    Game.Log(key.name ..
                 " Was assigned another traitor mission, His mission is to kill " ..
                 assassinate.name, 6)

    value.objectiveTarget = assassinate
    value.objectiveType = "kill"
    value.needNewObjective = false
end

Hook.Add("roundStart", "traitor_start", function()

    Game.SendMessage(
        "We are using TraitorMod by\n EvilFactory and Qunk (https://steamcommunity.com/sharedfiles/filedetails/?id=2559709754)\n Join discord.gg/f9zvNNuxu9",
        3)

    local players = util.GetValidPlayersNoBots()

    for key, value in pairs(players) do
        local client = util.clientChar(value)

        if traitormod.getPenalty(client) > 1 then
            traitormod.addPenalty(client, -1)
        end

        traitormod.addPercentage(client, config.roundEndPercentageIncrease /
                                     traitormod.getPenalty(client))
    end

    traitormod.chooseCodes()

    
    if config.infiltrationEnabled or config.pincerEnabled then
        if Game.GetRespawnSub() == nil then
            Game.SendMessage("TraitorMod Warning: Infiltration or Pincer enabled but respawn shuttle disabled!", 1)
        end
    end


    
    local rng = Random.Range(0, 100)
    local rng2 = Random.Range(0, 100)
    local rng3 = Random.Range(0, 100)

    if (rng < config.infiltrationChance and config.infiltrationEnabled == true) and Game.GetRespawnSub() ~= nil then
        local amount = config.getAmountInfiltrationTraitors(#util.GetValidPlayersNoBots())

        Game.Log("Infiltration Gamemode selected", 6)
        traitormod.gamemodes["Infiltration"] = true

        traitormod.traitorShipRoundStart(amount)

    --#util.GetValidPlayers() >= 2 and
    elseif (rng < config.pincerChance and config.pincerEnabled == true) and config.getAmountPincerOperatives(#util.GetValidPlayersNoBots()) >= 2 and Game.GetRespawnSub() ~= nil then
        local amount = config.getAmountPincerOperatives(#util.GetValidPlayersNoBots())
        Game.Log("Pincer Gamemode selected", 6)
        traitormod.gamemodes["Pincer"] = true

        traitormod.pincerRoundStart(amount)

    elseif (rng3 < config.thethingChance and config.thethingEnabled == true) then
        traitorsAssigned = false
        traitorAssignDelay = Timer.GetTime() + config.traitorSpawnDelay

        Game.Log("The Thing Gamemode was selected", 6)
        traitormod.gamemodes["The Thing"] = true

        if config.infiltrationEnabled and Game.GetRespawnSub() ~= nil then
            traitormod.spawnTraitorShipAndHide()
        end

    elseif config.assassinationEnabled then
        traitorsAssigned = false
        traitorAssignDelay = Timer.GetTime() + config.traitorSpawnDelay

        Game.Log("Assassination Gamemode was selected", 6)
        traitormod.gamemodes["Assassination"] = true

        if (config.infiltrationEnabled or config.pincerEnabled) and Game.GetRespawnSub() ~= nil then
            traitormod.spawnTraitorShipAndHide()
        end
    end

    if config.enableCommunicationsOffline then
        rng = Random.Range(0, 100)

        if rng < config.communicationsOfflineChance then
            traitormod.gamemodes["Offline Communications"] = true
            traitormod.disableRadioChat = true

            Game.SendMessage(
                    "—-radiation closing in on our location, comms down!", 11)

            Game.SendMessage(
                    "—-radiation closing in on our location, comms down!", 3)

            for key, value in pairs(Player.GetAllCharacters()) do
                if value.IsHuman then
                    Player.SetRadioRange(value, 0)
                end
            end
        end
    end


    if config.disableCrewMenu then
        for key, value in pairs(Player.GetAllClients()) do
            if value.Character ~= nil then
                Player.SetCharacterTeam(value.Character, 3)
            end
        end

        botGod = Game.Spawn("human", CreateVector2(0, 0))
        botGod.GodMode = true

        Player.SetCharacterTeam(botGod, 3)

    end

    if config.enableSabotage then
        for key, value in pairs(Player.GetAllClients()) do
            
            if value.Character then
                value.Character.IsTraitor = true 
            end
            
            Game.SendTraitorMessage(value, 'traitor', 'traitor', TraitorMessageType.Objective) -- enable everyone to sabotage
        end
    end

end)

Hook.Add("roundEnd", "traitor_end", function()

    local msg = "Traitors of the round: "

    for key, value in pairs(traitormod.roundtraitors) do
        msg = msg .. "\"" .. key.name .. "\" "
    end

    msg = msg .. "\n\nGamemodes:"

    for key, value in pairs(traitormod.gamemodes) do
            msg = msg .. " \"" .. key .. "\""
    end

    Game.SendMessage(msg, 1)

    for key, value in pairs(traitormod.roundtraitors) do
        local c = util.clientChar(key)
        traitormod.setPercentage(c, config.traitorPercentageSet)
        traitormod.addPenalty(c, config.traitorPenalty)
    end

    traitorsRoundStartAssigned = false
    endingRound = false
    traitormod.roundtraitors = {}
    traitormod.selectedCodeResponses = {}
    traitormod.selectedCodePhrases = {}
    traitormod.gamemodes = {}
    warningClients = {}
    setClientCharacterToNil = {}
end)

Hook.Add("think", "traitor_think", function()
    
    if not traitorsAssigned and traitorAssignDelay < Timer.GetTime() then

        if traitormod.gamemodes["Assassination"] then
            traitormod.assignNormalTraitors(config.getAmountTraitors(#util.GetValidPlayersNoBots()))
        elseif traitormod.gamemodes["The Thing"] then
            traitormod.assignTheThing(config.getAmountTheThings(#util.GetValidPlayersNoBots()))
        end

        traitorsAssigned = true
        traitorsRoundStartAssigned = true
    end

    if endingRound == true and roundEndDelay < Timer.GetTime() then
        Game.ExecuteCommand('endgame')

        endingRound = false
    end

    if traitorsRoundStartAssigned and config.endRoundWhenAllTraitorsDie then
        local num = 0

        for key, value in pairs(traitormod.roundtraitors) do
            if key.IsDead == false then num = num + 1 end
        end

        if num == 0 then
            Game.SendMessage('All traitors died! Ending round in ' .. config.endRoundDelayInSeconds .. ' seconds.', 1)

            endingRound = true
            roundEndDelay = Timer.GetTime() + config.endRoundDelayInSeconds
            traitorsRoundStartAssigned = false
        end
    end


    for key, value in pairs(setClientCharacterToNil) do
        if Timer.GetTime() > value then
            Player.SetClientCharacter(key, nil)
            setClientCharacterToNil[key] = nil
        end
    end

    for key, value in pairs(Player.GetAllClients()) do
        if value.Character ~= nil then

            if warningClients[value] == nil then

                if value.Character.IsDead == true then
                    local attackers = value.Character.LastAttacker
                    if util.characterIsTraitor(attackers, traitormod.roundtraitors) and
                        attackers ~= value.Character then
                        traitormod.sendTraitorMessage(
                            "Your death was caused by a traitor on a secret mission.",
                            value, true)
                    end

                    warningClients[value] = true


                    if config.disableCrewMenu then
                        Player.SetClientCharacter(value, botGod)

                        setClientCharacterToNil[value] = Timer.GetTime() + 0.5
                    end
                end

            end

            
        end
    end

    for key, value in pairs(traitormod.roundtraitors) do
        if key ~= nil and key.IsDead == false then

            if value.needNewObjective == true and Timer.GetTime() >
                value.objectiveTimer then
                traitormod.chooseNextObjective(key, value)
            end

            if value.objectiveTarget ~= nil then

                if value.objectiveTarget.IsDead then
                    traitormod.sendTraitorMessage(
                        "Great job, You killed " .. value.objectiveTarget.name ..
                            ". We will provide you your next mission shortly.",
                        util.clientChar(key), true)

                    value.objectiveTarget = nil

                    value.needNewObjective = true
                    value.objectiveTimer =
                        Timer.GetTime() + config.nextMissionDelay

                end

            end

        end
    end




end)

Hook.Add("chatMessage", "chatcommands", function(msg, client)

    if bit32.band(client.Permissions, 0x40) == 0x40 then

        if msg == "!traitors" then
            local tosend = "Traitors of the round: "

            for key, value in pairs(traitormod.roundtraitors) do
                tosend = tosend .. "\"" .. key.name .. "\" "
            end

            traitormod.sendTraitorMessage(tosend, client)

            return true
        end

        if msg == "!traitoralive" then
            local num = 0

            for key, value in pairs(traitormod.roundtraitors) do
                if key.IsDead == false then num = num + 1 end
            end

            if num > 0 then
                traitormod.sendTraitorMessage("There are traitors alive.",
                                              client)
            else
                traitormod.sendTraitorMessage("All traitors are dead!", client)
            end

            return true
        end

        if msg == "!percentages" then
            local msg = ""
            for key, value in pairs(Player.GetAllClients()) do

                msg = msg .. value.name .. " - " ..
                          math.floor(traitormod.getPercentage(value)) .. "%\n"
            end

            traitormod.sendTraitorMessage(msg, client)

            return true
        end
    end

    if msg == "!percentage" then

        traitormod.sendTraitorMessage("You have " ..
                                          math.floor(
                                              traitormod.getPercentage(client)) ..
                                          "% of being traitor", client)

        return true
    end

    if msg == "!help" then

        
        traitormod.sendTraitorMessage("\nCommands\n!help\n!traitor\n!traitors\n!percentage\n!percentages\n!alive\n\nIf you want to change settings, open the file called traitorconfig.lua and do your changes then open your console (f3) and type in reloadlua (warning: this will reload all scripts and reset all traitors so dont do it while in a round.)", client)

        return true 
    end

    if util.stringstarts(msg, "!traitor") then
        if util.characterIsTraitor(client.Character, traitormod.roundtraitors) then
            local tr = traitormod.roundtraitors[client.Character]
            
            local msg = "You are " .. tr.name .. "."

            if tr.objectiveTarget ~= nil then
                msg = msg .. "\nCurrent Mission: kill " ..
                          traitormod.roundtraitors[client.Character]
                              .objectiveTarget.name
            end
            
            --marking this for later

            if tr.objectiveType == "thething" then
                msg = msg .. "\nCurrent Mission: kill everyone"
            end

            if tr.objectiveType == "infiltration" then
                msg = msg .. "\nCurrent Mission: Exterminate the Main Sub's Crew"
            end

            if tr.objectiveType ~= "thething" and util.TableCount(traitormod.roundtraitors) > 1 then

                msg = msg .. "\n\n The code words are: "

                for key, va in pairs(traitormod.selectedCodePhrases) do
                    msg = msg .. "\"" .. va .. "\" "
                end

                msg = msg .. "\n The code response is: "

                for key, va in pairs(traitormod.selectedCodeResponses) do
                    msg = msg .. "\"" .. va .. "\" "
                end

            end

            traitormod.sendTraitorMessage(msg, client)
        else
            traitormod.sendTraitorMessage("You are not a traitor.", client)
        end

        return true
    end

    if msg == "!fixme" then
        local characters = Player.GetAllCharacters()

        for k, v in pairs(characters) do
            if v.name == client.name then
                Player.SetClientCharacter(client, v)
                break
            end
        end
        
    end

    if msg == "!alive" then
        if client.Character == nil or client.Character.IsDead == true then

            local msg = ""
            for key, value in pairs(Player.GetAllCharacters()) do

                if value.IsHuman then
                    if value.IsDead then
                        msg = msg .. value.name .. " - " .. "-Dead\n"
                    else
                        msg = msg .. value.name .. " - " .. "+Alive\n"
                    end
                end
            end

            traitormod.sendTraitorMessage(msg, client)

            return true
        end

    end
end)

Traitormod = traitormod
