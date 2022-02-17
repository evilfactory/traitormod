local assassination = {}

assassination.Name = "Assassination"

assassination.MultiTraitor = false

local lang = Traitormod.Language

assassination.Start = function ()
    assassination.Traitors = {}

    local words = Traitormod.SelectCodeWords()
    assassination.Codewords = words[1]
    assassination.Coderesponses = words[2]

    local currentRoundNumber = Traitormod.RoundNumber

    Timer.Wait(function ()
        if currentRoundNumber ~= Traitormod.RoundNumber then return end
        assassination.SelectTraitors()
    end, assassination.Config.SelectionDelay * 1000)
end

local thinkTimer = 0

assassination.Think = function ()
    if Timer.GetTime() < thinkTimer then return end
    thinkTimer = Timer.GetTime() + 0.1

    for character, traitor in pairs(assassination.Traitors) do
        if not character.IsDead then
            assassination.CheckObjectives(character, traitor)
        end
    end
end

assassination.End = function ()
    for character, traitor in pairs(assassination.Traitors) do
        for _, objective in pairs(traitor.SubObjectives) do
            if objective.EndRoundObjective and objective.CheckCompleted() and not objective.Awarded then
                objective.Award(character)
            end
        end
    end

    local message = lang.TraitorsRound

    if assassination.GetAmountTraitors() == 0 then 
        message = message .. " " .. lang.NoTraitors
    else
        message = message .. "\n"
    end
    
    for character, traitor in pairs(assassination.Traitors) do
        local mainObjectiveText = ""
        for key, value in pairs(traitor.MainObjectives) do
            mainObjectiveText = mainObjectiveText .. "  >  " .. value.GetListText(true) .. "\n"
        end

        local subObjectivesText = ""
        for key, value in pairs(traitor.SubObjectives) do
            subObjectivesText = subObjectivesText .. "  >  " .. value.GetListText(true) .. "\n"
        end

        if #traitor.SubObjectives == 0 then
            subObjectivesText = subObjectivesText .. "  >  " .. lang.NoObjectives .. "\n"
        end

        message = message .. string.format("\n%s\n%s\n%s\n%s\n%s", string.format(lang.CharacterName, character.Name), lang.Objective, mainObjectiveText, lang.SubObjective, subObjectivesText)
    end

    return message
end

assassination.ShowInfo = function (character)
    local traitor = assassination.Traitors[character]

    if traitor == nil or character.IsDead then 
        Traitormod.SendMessageCharacter(character, Traitormod.Language.NoTraitor)
        return 
    end

    local mainObjectiveText = ""
    for key, value in pairs(traitor.MainObjectives) do
        mainObjectiveText = mainObjectiveText .. "  >  " .. value.GetListText() .. "\n"
    end

    local subObjectivesText = ""
    for key, value in pairs(traitor.SubObjectives) do
        subObjectivesText = subObjectivesText .. "  >  " .. value.GetListText() .. "\n"
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

assassination.ShowRoundInfo = function (client)
    local message = lang.TraitorsRound .. "\n"
    
    for character, traitor in pairs(assassination.Traitors) do
        local mainObjectiveText = ""
        for key, value in pairs(traitor.MainObjectives) do
            mainObjectiveText = mainObjectiveText .. "  >  " .. value.GetListText() .. "\n"
        end

        local subObjectivesText = ""
        for key, value in pairs(traitor.SubObjectives) do
            subObjectivesText = subObjectivesText .. "  >  " .. value.GetListText() .. "\n"
        end

        message = message .. string.format("\n%s\n%s\n%s\n%s\n%s", string.format(lang.CharacterName, character.Name), lang.Objective, mainObjectiveText, lang.SubObjective, subObjectivesText)
    end

    Traitormod.SendMessage(client, message)
end

assassination.TraitorAlive = function ()
    for character, traitor in pairs(assassination.Traitors) do
        if not character.IsDead then
            return lang.TraitorsAlive
        end
    end

    return lang.AllTraitorsDead
end

assassination.GetValidTarget = function ()
    local targets = {}
    for key, value in pairs(Character.CharacterList) do
        if assassination.Traitors[value] == nil and value.IsHuman and not value.IsDead then
            if not value.IsBot or assassination.Config.SelectBotsAsTargets then
                table.insert(targets, value)
            end
        end
    end

    return targets[Random.Range(1, #targets + 1)]
end

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

assassination.AssignInitialMissions = function (character)
    local traitor = assassination.Traitors[character]

    traitor.MainObjectives = {}

    local target = assassination.GetValidTarget()

    if target ~= nil then
        traitor.MainObjectives[1] = Traitormod.GetObjective("Assassinate")
        traitor.MainObjectives[1].Start(character, target)
    end

    local objectivesAvaiable = {}
    for key, value in pairs(assassination.Config.SubObjectives) do
        objectivesAvaiable[key] = value
    end

    for i = 1, Random.Range(assassination.Config.MinSubObjectives, assassination.Config.MaxSubObjectives + 1), 1 do
        local rng = Random.Range(1, #objectivesAvaiable + 1)
        local objective = Traitormod.GetObjective(objectivesAvaiable[rng])
        
        if objective.Start(character, assassination.GetValidTarget()) then
            table.insert(traitor.SubObjectives, objective)
            table.remove(objectivesAvaiable, rng)    
        end
    end
end

assassination.RenewAssassinationObjective = function(character, traitor, target)
    local newObjective = Traitormod.GetObjective("Assassinate")
    newObjective.Start(traitor, target)
    table.insert(traitor.MainObjectives, newObjective)

    Traitormod.SendMessageCharacter(character, string.format(lang.AssassinationNewObjective, target.Name), true, "GameModeIcon.pvp")
end

assassination.CheckObjectives = function (character, traitor)
    for _, objective in pairs(traitor.MainObjectives) do
        if not objective.EndRoundObjective and objective.CheckCompleted() and not objective.Awarded then

            Traitormod.SendMessageCharacter(character, objective.GetCompletedText(), true, "MissionCompletedIcon")

            Timer.Wait(function ()
                local target = assassination.GetValidTarget()

                if target == nil and not character.IsDead then
                    Traitormod.SendMessageCharacter(character, lang.AssassinationEveryoneDead, true, "InfoFrameTabButton.Reputation")

                    return
                end

                local newObjective = Traitormod.GetObjective("Assassinate")
                newObjective.Start(character, target)
                table.insert(traitor.MainObjectives, newObjective)

                
                if not character.IsDead then 
                    Traitormod.SendMessageCharacter(character, string.format(lang.AssassinationNewObjective, target.Name), true, "GameModeIcon.pvp")
                end

            end, assassination.Config.NextTargetDelay * 1000)

            objective.Award(character)
        end
    end

    for _, objective in pairs(traitor.SubObjectives) do
        if not objective.EndRoundObjective and objective.CheckCompleted() and not objective.Awarded then
            Traitormod.SendMessageCharacter(character, objective.GetCompletedText(), true, "MissionCompletedIcon")

            objective.Award(character)
        end
    end
end

local weightedRandom = dofile("Mods/traitormod/Lua/weightedrandom.lua")

assassination.SelectTraitors = function ()
    local clientWeight = {}
    for key, value in pairs(Client.ClientList) do
        if value.Character and assassination.Config.TraitorFilter(value) then
            clientWeight[value] = Traitormod.GetData(value, "Weight") or 0
        end
    end

    if #Client.ClientList == 0 then 
        print("Traitormod: Not enough players to assign traitors.") 
        return
    end

    if assassination.Config.AmountTraitors(#Client.ClientList) > 1 then
        assassination.MultiTraitor = true
    end

    for i = 1, assassination.Config.AmountTraitors(#Client.ClientList), 1 do
        local index = weightedRandom.Choose(clientWeight)
        assassination.GreetTraitor(index.Character)
        clientWeight[index] = nil
        Traitormod.SetData(index, "Weight", 0)
    end

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

Hook.Add("characterDeath", "Traitormod.Assassination.DeathByTraitor", function (character, affliction)
    if character == nil or 
    character.CauseOfDeath == nil or 
    character.CauseOfDeath.Killer == nil or
    character.IsHuman == false or
    character.ClientDisconnected == true or
    character.TeamID == 0 or 
    assassination.Traitors == nil then
        return
    end

    if assassination.Traitors[character] then return end

    local attacker = character.CauseOfDeath.Killer

    if assassination.Traitors[attacker] ~= nil then
        Traitormod.SendMessageCharacter(character, lang.KilledByTraitor, true, "InfoFrameTabButton.Traitor")
    end
end)

return assassination