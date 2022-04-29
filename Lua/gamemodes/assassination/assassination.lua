local assassination = {}

assassination.Name = "Assassination"

local lang = Traitormod.Language

assassination.Start = function ()
    assassination.Traitors = {}

    assassination.MultiTraitor = false

    local words = Traitormod.SelectCodeWords()
    assassination.Codewords = words[1]
    assassination.Coderesponses = words[2]

    assassination.CurrentRoundNumber = Traitormod.RoundNumber

    dofile(Traitormod.Path .. "/Lua/gamemodes/assassination/commands.lua")
    dofile(Traitormod.Path .. "/Lua/gamemodes/assassination/hooks.lua")

    -- select traitor after configured time has passed
    Timer.Wait(function ()
        if assassination.CurrentRoundNumber ~= Traitormod.RoundNumber then return end
        assassination.SelectTraitors()
    end, assassination.Config.SelectionDelay * 1000)
end

local thinkTimer = 0

-- register tick
assassination.Think = function ()
    if Timer.GetTime() < thinkTimer then return end
    thinkTimer = Timer.GetTime() + 0.1

    -- check traitor objectives every 100ms
    for character, traitor in pairs(assassination.Traitors) do
        if not character.IsDead then
            assassination.CheckObjectives(character, traitor)
        end
    end
end

assassination.End = function ()
    dofile(Traitormod.Path .. "/Lua/gamemodes/assassination/cleanup.lua")

    -- award points for completed EndRoundObjectives
    for character, traitor in pairs(assassination.Traitors) do
        for _, objective in pairs(traitor.SubObjectives) do
            if objective.EndRoundObjective and objective.IsCompleted() and not objective.Awarded then
                local client = Traitormod.FindClientCharacter(character)

                if client then
                    Traitormod.AddData(client, "Points", objective.Config.AmountPoints)
                end
                
                objective.Awarded = true
            end
        end
    end

    -- return round summary
    local message = lang.TraitorsRound

    if assassination.GetAmountTraitors() == 0 then 
        message = message .. " " .. lang.NoTraitors
    else
        message = message .. "\n"
    end
    
    for character, traitor in pairs(assassination.Traitors) do
        local mainObjectiveText = ""
        for key, value in pairs(traitor.MainObjectives) do
            mainObjectiveText = mainObjectiveText .. "  >  " .. value.ObjectiveText
            
            if value.Awarded then
                mainObjectiveText = mainObjectiveText .. lang.Completed .. "\n"
            else
                mainObjectiveText = mainObjectiveText .. "\n"
            end
        end

        local subObjectivesText = ""
        for key, value in pairs(traitor.SubObjectives) do
            subObjectivesText = subObjectivesText .. "  >  " .. value.ObjectiveText

            if value.Awarded then
                subObjectivesText = subObjectivesText .. lang.Completed .. "\n"
            else
                subObjectivesText = subObjectivesText .. "\n"
            end
        end

        if #traitor.SubObjectives == 0 then
            subObjectivesText = subObjectivesText .. "  >  " .. lang.NoObjectives .. "\n"
        end

        message = message .. string.format("\n%s\n%s\n%s\n%s\n%s", string.format(lang.CharacterName, character.Name), lang.Objective, mainObjectiveText, lang.SubObjective, subObjectivesText)
    end

    return message
end

-- rerturns traitor information including objectives and codewords for MultiTraitor, used for command !traitor, only usable by traitors
assassination.ShowInfo = function (character)
    local traitor = assassination.Traitors[character]

    if traitor == nil or character.IsDead then 
        Traitormod.SendMessageCharacter(character, Traitormod.Language.NoTraitor)
        return 
    end

    local mainObjectiveText = ""
    for key, value in pairs(traitor.MainObjectives) do
        mainObjectiveText = mainObjectiveText .. "  >  " .. value.ObjectiveText

        if value.Awarded then
            mainObjectiveText = mainObjectiveText .. lang.Completed .. "\n"
        else
            mainObjectiveText = mainObjectiveText .. " " .. string.format(lang.Points, value.Config.AmountPoints) .. "\n"
        end
    end

    local subObjectivesText = ""
    for key, value in pairs(traitor.SubObjectives) do
        subObjectivesText = subObjectivesText .. "  >  " .. value.ObjectiveText

        if value.Awarded then
            subObjectivesText = subObjectivesText .. lang.Completed .. "\n"
        else
            subObjectivesText = subObjectivesText .. " " .. string.format(lang.Points, value.Config.AmountPoints) .. "\n"
        end
    end

    if #traitor.SubObjectives == 0 then
        subObjectivesText = subObjectivesText .. "  >  " .. lang.NoObjectives .. "\n"
    end

    local codewordText = ""

    if not assassination.MultiTraitor then
        
    elseif assassination.Config.TraitorMethodCommunication == "Codewords" then
        local codeWords = ""
        local codeResponses = ""
    
        for key, value in pairs(assassination.Codewords) do
            codeWords = codeWords .. " '" .. value .. "' "
        end
    
        for key, value in pairs(assassination.Coderesponses) do
            codeResponses = codeResponses .. " '" .. value .. "' "
        end
        
        codewordText = string.format(lang.Codewords, codeWords) .. "\n" .. string.format(lang.CodeResponses, codeResponses)
    elseif assassination.Config.TraitorMethodCommunication == "Names" then
        local names = ""

        for character, traitor in pairs(assassination.Traitors) do
            names = names .. "\"" .. character.Name .. "\" "
        end

        codewordText = string.format(lang.OtherTraitors, names)
    end

    local missions = string.format("%s\n\n%s\n\n%s\n\n%s\n%s\n%s\n%s", lang.TraitorWelcome, codewordText, lang.ObjectiveText, lang.Objective, mainObjectiveText, lang.SubObjective, subObjectivesText)
    
    Traitormod.SendMessageCharacter(character, missions)
end

-- returns a summary of the current gamemode, used for admin command !roundinfo
assassination.ShowRoundInfo = function (client)
    local message = lang.TraitorsRound .. "\n"
    
    for character, traitor in pairs(assassination.Traitors) do
        local mainObjectiveText = ""
        for key, value in pairs(traitor.MainObjectives) do
            mainObjectiveText = mainObjectiveText .. "  >  " .. value.ObjectiveText .. "\n"
        end

        local subObjectivesText = ""
        for key, value in pairs(traitor.SubObjectives) do
            subObjectivesText = subObjectivesText .. "  >  " .. value.ObjectiveText .. "\n"
        end

        message = message .. string.format("\n%s\n%s\n%s\n%s\n%s", string.format(lang.CharacterName, character.Name), lang.Objective, mainObjectiveText, lang.SubObjective, subObjectivesText)
    end

    Traitormod.SendMessage(client, message)
end

-- returns a random valid assassination target for a given role filter
assassination.GetValidTarget = function (roleFilter)
    local targets = {}
    local debug = ""
    for key, value in pairs(Character.CharacterList) do
        if value ~= botGod and assassination.Traitors[value] == nil and value.IsHuman and not value.IsDead and 
        (roleFilter == nil or roleFilter[value.Info.Job.Prefab.Identifier]) then
            if not value.IsBot or assassination.Config.SelectBotsAsTargets then
                table.insert(targets, value)
                debug = debug.." | "..value.Name.."("..tostring(value.Info.Job.Prefab.Identifier)..")"
            end
        end
    end
    Traitormod.Debug("Selecting new random target out of "..#targets.." possible candidates"..debug)
    return targets[math.random(1, #targets)]
end

-- registers a character as traitor and sends an info message
assassination.GreetTraitor = function (character)
    local traitor = {}
    assassination.Traitors[character] = traitor

    traitor.MainObjective = nil
    traitor.SubObjectives = {}

    local greet = ""

    if not assassination.MultiTraitor or assassination.Config.TraitorMethodCommunication == "None"  then
        greet = string.format("%s\n\n%s", lang.TraitorWelcome, lang.AgentNoticeOnlyTraitor)
    elseif assassination.Config.TraitorMethodCommunication == "Codewords" then
        greet = string.format("%s\n\n%s", lang.TraitorWelcome, lang.AgentNoticeCodewords)
    elseif assassination.Config.TraitorMethodCommunication == "Names" then
        greet = string.format("%s\n\n%s", lang.TraitorWelcome, lang.AgentNoticeNoCodewords)
    end

    Traitormod.SendMessageCharacter(character, greet)
end

-- initially choose objectives and targets
assassination.AssignInitialMissions = function (character)
    local traitor = assassination.Traitors[character]

    traitor.MainObjectives = {}

    Traitormod.Debug("GetValidTarget for assassination")
    local target = assassination.GetValidTarget()
    Traitormod.Log("Chose assassination target " .. target.Name)

    if target ~= nil then
        traitor.MainObjectives[1] = Traitormod.GetObjective("Assassinate")
        traitor.MainObjectives[1].Start(character, target)
    end

    local objectivesAvaiable = {}
    for key, value in pairs(assassination.Config.SubObjectives) do
        objectivesAvaiable[key] = value
    end

    for i = 1, math.random(assassination.Config.MinSubObjectives, assassination.Config.MaxSubObjectives), 1 do
        local rng = math.random(1, #objectivesAvaiable)
        local objective = Traitormod.GetObjective(objectivesAvaiable[rng])
        Traitormod.Debug("GetValidTarget for ".. objective.Name)
        local subTarget = assassination.GetValidTarget(objective.RoleFilter)
        if objective.Start(character, subTarget) then
            table.insert(traitor.SubObjectives, objective)
            Traitormod.Log("Sub objective "..objective.Name.. " started with target " .. subTarget.Name)
        end

        table.remove(objectivesAvaiable, rng)    
    end
end

-- add new assassination objective
assassination.RenewAssassinationObjective = function(character, traitor, target)
    local newObjective = Traitormod.GetObjective("Assassinate")
    newObjective.Start(traitor, target)
    table.insert(traitor.MainObjectives, newObjective)

    Traitormod.SendMessageCharacter(character, string.format(lang.AssassinationNewObjective, target.Name), true, "GameModeIcon.pvp")
end

-- check if objectives have been completed
assassination.CheckObjectives = function (character, traitor)
    
    -- MainObjectives
    for _, objective in pairs(traitor.MainObjectives) do
        if not objective.EndRoundObjective and objective.IsCompleted() and not objective.Awarded then

            Traitormod.SendMessageCharacter(character, string.format(lang.ObjectiveCompleted, objective.ObjectiveText), true, "MissionCompletedIcon")

            -- choose next target after NextTargetDelay seconds
            Timer.Wait(function ()
                if assassination.CurrentRoundNumber ~= Traitormod.RoundNumber then return end

                Traitormod.Debug("GetValidTarget for assassination")
                local target = assassination.GetValidTarget()

                if target == nil and not character.IsDead then
                    -- if no new target found, give feedback and return
                    Traitormod.SendMessageCharacter(character, lang.AssassinationEveryoneDead, true, "InfoFrameTabButton.Reputation")

                    return
                end

                local newObjective = Traitormod.GetObjective("Assassinate")
                newObjective.Start(character, target)
                table.insert(traitor.MainObjectives, newObjective)

                
                if not character.IsDead then 
                    -- give feedback about new target
                    Traitormod.SendMessageCharacter(character, string.format(lang.AssassinationNewObjective, target.Name), true, "GameModeIcon.pvp")
                end

            end, assassination.Config.NextTargetDelay * 1000)

            -- award points for main objection completion
            objective.Awarded = true

            local client = Traitormod.FindClientCharacter(character)
            if client == nil then 
                Traitormod.Error("Couldn't award assassination points for " + character.Name)
            else
                Traitormod.AddData(client, "Points", objective.Config.AmountPoints)

                Traitormod.SendMessage(client, string.format(lang.PointsAwarded, objective.Config.AmountPoints), true, "InfoFrameTabButton.Mission")

            end
        end
    end

    -- SubObjectives
    for _, objective in pairs(traitor.SubObjectives) do
        if not objective.EndRoundObjective and objective.IsCompleted() and not objective.Awarded then
            Traitormod.SendMessageCharacter(character, objective.ObjectiveText, true, "MissionCompletedIcon")

            objective.Awarded = true

            -- award points for sub objection completion
            local client = Traitormod.FindClientCharacter(character)
            if client == nil then 
                Traitormod.Error("Couldn't award sub objective points for " + character.Name)
            else

                Traitormod.AddData(client, "Points", objective.Config.AmountPoints)

                Traitormod.SendMessage(client, string.format(lang.PointsAwarded, objective.Config.AmountPoints), true, "InfoFrameTabButton.Mission")
            end

        end
    end
end

local weightedRandom = dofile(Traitormod.Path .. "/Lua/weightedrandom.lua")

assassination.SelectTraitors = function ()
    -- load clientWeight table from stored values
    local clientWeight = {}
    for key, value in pairs(Client.ClientList) do
        if value.Character and assassination.Config.TraitorFilter(value) then
            clientWeight[value] = Traitormod.GetData(value, "Weight") or 0
        end
    end

    if #Client.ClientList == 0 then 
        Traitormod.Log("No players to assign traitors") 
        return
    end

    if assassination.Config.AmountTraitors(#Client.ClientList) > 1 then
        assassination.MultiTraitor = true
    end

    for i = 1, assassination.Config.AmountTraitors(#Client.ClientList), 1 do
        local index = weightedRandom.Choose(clientWeight)

        if index ~= nil then
            Traitormod.Log("Chose "..index.Character.Name.. " as traitor. Weight: "..clientWeight[index])
            assassination.GreetTraitor(index.Character)
            clientWeight[index] = nil
            -- if traitor chosen reset stored weight to 0
            Traitormod.SetData(index, "Weight", 0)
        end
    end

    -- assign missions to successfully registered traitors
    for character, traitor in pairs(assassination.Traitors) do
        assassination.AssignInitialMissions(character)
        assassination.ShowInfo(character)
    end
end

assassination.GetAmountTraitors = function ()
    local i = 0
    for key, value in pairs(assassination.Traitors) do
        i = i + 1
    end
    return i
end


return assassination