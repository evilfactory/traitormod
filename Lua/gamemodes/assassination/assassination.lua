local assassination = {}

assassination.Name = "Assassination"
assassination.Completed = false

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
    local delay = math.random(assassination.Config.StartDelayMin, assassination.Config.StartDelayMax)
    Traitormod.Log("Traitors will be chosen in " .. delay .. "s")
    Timer.Wait(function ()
        if assassination.CurrentRoundNumber ~= Traitormod.RoundNumber then return end
        assassination.SelectTraitors()
    end, delay * 1000)
end

local thinkTimer = 0

-- register tick
assassination.Think = function ()
    if Timer.GetTime() < thinkTimer then return end
    thinkTimer = Timer.GetTime() + 0.1

    -- check traitor objectives every 100ms
    for character, traitor in pairs(assassination.Traitors) do
        if not character.IsDead and not traitor.Failed then
            assassination.CheckObjectives(character, traitor)
        end
    end
end

assassination.End = function ()
    dofile(Traitormod.Path .. "/Lua/gamemodes/assassination/cleanup.lua")
    local noTraitors = true
    -- award points for completed EndRoundObjectives
    for character, traitor in pairs(assassination.Traitors) do
        noTraitors = false
        for _, objective in pairs(traitor.SubObjectives) do
            if objective.EndRoundObjective and objective.IsCompleted() and not objective.Awarded then
                local client = Traitormod.FindClientCharacter(character)
            
                if client then
                    local xp = Traitormod.AwardPoints(client, objective.Config.AmountPoints, false, true)
                    Traitormod.SendObjectiveCompleted(client,  objective, xp)
                end
                
                objective.Awarded = true
            end
        end
    end

    if noTraitors then 
        message = lang.NoTraitors
    else
        message = assassination.GetRoundSummary()
    end

    return message
end

assassination.GetRoundSummary = function ()
    local title = lang.TraitorsRound .. "\n"
    local summary = nil

    for character, traitor in pairs(assassination.Traitors) do
        summary = (summary or "") .. assassination.GetTraitorObjectiveSummary(character, true) .. "\n"
    end

    if not summary then
        summary = Traitormod.Language.NoTraitors
    end

    return title .. summary
end

assassination.GetTraitorObjectiveSummary = function (character, roundSummary)
    local traitor = assassination.Traitors[character]

    -- if given character was no traitor, return no traitor.
    if traitor == nil or character.IsDead or traitor.Failed then 
        return Traitormod.Language.NoTraitor
    end

    local mainObjectiveText = ""
    for key, value in pairs(traitor.MainObjectives) do
        mainObjectiveText = mainObjectiveText .. "  >  " .. value.ObjectiveText

        if value.Awarded then
            mainObjectiveText = mainObjectiveText .. lang.Completed .. "\n"
        elseif not roundSummary then
            local xp = math.floor(Traitormod.Config.AmountExperienceWithPoints(value.Config.AmountPoints))
            mainObjectiveText = mainObjectiveText .. string.format(lang.Experience, xp) .. "\n"
        else
            mainObjectiveText = mainObjectiveText .. "\n"
        end
    end

    local subObjectivesText = ""
    if #traitor.SubObjectives == 0 then
        subObjectivesText = subObjectivesText .. "  >  " .. lang.NoObjectives .. "\n"
    else
        for key, value in pairs(traitor.SubObjectives) do
            subObjectivesText = subObjectivesText .. "  >  " .. value.ObjectiveText
        
            if value.Awarded then
                subObjectivesText = subObjectivesText .. lang.Completed .. "\n"
            elseif not roundSummary then
                local xp = math.floor(Traitormod.Config.AmountExperienceWithPoints(value.Config.AmountPoints))
                subObjectivesText = subObjectivesText .. string.format(lang.Experience, xp) .. "\n"
            else
                subObjectivesText = subObjectivesText .. "\n"
            end
        end
    end

    if roundSummary then
        local prefix = "Crew member"
        if character.Info and character.Info.Job then
            prefix = tostring(TextManager.Get("jobname." .. tostring(character.Info.Job.Prefab.Identifier)))
        end

        local traitorName = character.Name
        if traitor.Deaths > 0 then
            traitorName = traitorName.." (Died)"
        end
        
        return string.format("- %s %s\n\n%s\n%s\n%s\n%s", prefix, traitorName, lang.Objective, mainObjectiveText, lang.SubObjective, subObjectivesText)
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

    return string.format("%s\n\n%s\n%s\n%s\n%s\n%s", lang.ObjectiveText, lang.Objective, mainObjectiveText, lang.SubObjective, subObjectivesText, codewordText)
end

-- rerturns traitor information including objectives and codewords for MultiTraitor, used for command !traitor, only usable by traitors
assassination.ShowInfo = function (character)
    local summary = assassination.GetTraitorObjectiveSummary(character)
    Traitormod.SendMessageCharacter(character, summary)
end

-- returns a summary of the current gamemode, used for admin command !roundinfo
assassination.ShowRoundInfo = function (client)
    Traitormod.SendMessage(client, assassination.GetRoundSummary())
end

local hasBeenTargeted = {}

-- returns a random valid assassination target for a given role filter
assassination.GetValidTarget = function (roleFilter, sideObjective)
    local targets = {}
    local debug = ""
    for key, value in pairs(Character.CharacterList) do
        -- if character is not a traitor, is a human and is not dead and matches the rolefilter
        if value ~= botGod and assassination.Traitors[value] == nil and value.IsHuman and not value.IsDead and 
        (roleFilter == nil or roleFilter[tostring(value.Info.Job.Prefab.Identifier)]) then
            if assassination.Config.SelectPiratesAsTargets or not string.startsWith(value.Name, tostring(TextManager.Get("missiontype.pirate"))) then
                if not value.IsBot or assassination.Config.SelectBotsAsTargets then
                    -- if the character has not already been targeted or it is a side objective target
                    if not hasBeenTargeted[value] or sideObjective then
                        -- add the character as a possible target
                        table.insert(targets, value)
                        -- set hasBeenTargeted to true if not sideobjective
                        hasBeenTargeted[value] = not sideObjective
                        debug = debug.." | "..value.Name.."("..tostring(value.Info.Job.Prefab.Identifier)..")"
                    end
                end
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
    traitor.Deaths = 0
    traitor.Kills = 0

    local greet = ""

    if not assassination.MultiTraitor or assassination.Config.TraitorMethodCommunication == "None"  then
        greet = string.format("%s\n\n%s", lang.TraitorWelcome, lang.AgentNoticeOnlyTraitor)
    elseif assassination.Config.TraitorMethodCommunication == "Codewords" then
        greet = string.format("%s\n\n%s", lang.TraitorWelcome, lang.AgentNoticeCodewords)
    elseif assassination.Config.TraitorMethodCommunication == "Names" then
        greet = string.format("%s\n\n%s", lang.TraitorWelcome, lang.AgentNoticeNoCodewords)
    end

    -- send greeting
    Traitormod.SendTraitorMessageBox(character, greet)
    
    -- assign missions
    assassination.AssignInitialMissions(character)

    -- set mission objective
    local objectiveSummary = assassination.GetTraitorObjectiveSummary(character)
    Traitormod.SendTraitorMessageBox(character, objectiveSummary)
    Traitormod.UpdateVanillaTraitor(character, true, objectiveSummary)
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
        local objective = Traitormod.GetObjective(value)
            
        -- if sub objective AlwaysActive start right away, else add to available choices
        if objective.Config.AlwaysActive then
            if objective.Start(character) then
                table.insert(traitor.SubObjectives, objective)
                Traitormod.Log("AlwaysActive Sub objective "..objective.Name.. " started.")
            else
                Traitormod.Error("AlwaysActive Sub objective "..objective.Name.. " could not be started!")
            end
        else
            table.insert(objectivesAvaiable, objective)
        end
    end

    for i = 1, math.random(assassination.Config.MinSubObjectives, assassination.Config.MaxSubObjectives), 1 do
        if #objectivesAvaiable == 0 then
            return
        end
        local rng = math.random(1, #objectivesAvaiable)
        local objective = objectivesAvaiable[rng]
        local subTarget = assassination.GetValidTarget(objective.RoleFilter, true)
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

    if not character.IsDead then 
        -- give feedback about new target
        Traitormod.SendMessageCharacter(character, string.format(lang.AssassinationNewObjective, target.Name), "GameModeIcon.pvp")

        Traitormod.UpdateVanillaTraitor(character, true)
    end
end

-- check if objectives have been completed
assassination.CheckObjectives = function (character, traitor)
    
    -- MainObjectives
    for _, objective in pairs(traitor.MainObjectives) do
        if not objective.EndRoundObjective and objective.IsCompleted() and not objective.Awarded then
            -- award points for main objection completion
            objective.Awarded = true

            local client = Traitormod.FindClientCharacter(character)
            if client == nil then 
                Traitormod.Error("Couldn't award assassination points for " + character.Name)
            else
                local xp = Traitormod.AwardPoints(client, objective.Config.AmountPoints)
                Traitormod.SendObjectiveCompleted(client, objective, xp)
            end

            -- choose next target after configured time passed
            local delay = math.random(assassination.Config.NextDelayMin, assassination.Config.NextDelayMax)
            Traitormod.Log("Choosing new target in " .. delay .. "s")
            Timer.Wait(function ()
                if assassination.CurrentRoundNumber ~= Traitormod.RoundNumber then return end

                Traitormod.Debug("Next GetValidTarget for assassination")
                local target = assassination.GetValidTarget()

                if target == nil and not character.IsDead then
                    -- if no new target found, give feedback and return
                    Traitormod.SendMessageCharacter(character, lang.AssassinationEveryoneDead, "InfoFrameTabButton.Reputation")
                    assassination.Completed = true
                    if assassination.Config.EndOnComplete then
                        Game.EndGame()
                    end
                    return
                end

                assassination.RenewAssassinationObjective(character, traitor, target)

            end, delay * 1000)
        end
    end

    -- SubObjectives
    for _, objective in pairs(traitor.SubObjectives) do
        if not objective.EndRoundObjective and objective.IsCompleted() and not objective.Awarded then
            objective.Awarded = true

            -- award points for sub objection completion
            local client = Traitormod.FindClientCharacter(character)
            if client == nil then 
                Traitormod.Error("Couldn't award sub objective points for " + character.Name)
            else
                local xp = Traitormod.AwardPoints(client, objective.Config.AmountPoints)
                Traitormod.SendObjectiveCompleted(client, objective, xp)
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
            Traitormod.Log("Chose " .. index.Character.Name.. " as traitor. Weight: " .. math.floor(clientWeight[index] * 100) / 100)
            assassination.GreetTraitor(index.Character)
            clientWeight[index] = nil
            -- if traitor chosen reset stored weight to 0
            Traitormod.SetData(index, "Weight", 0)
        end
    end
end

assassination.GetAmountTraitors = function ()
    local i = 0
    for key, value in pairs(assassination.Traitors) do
        i = i + 1
    end
    return i
end

function string.startsWith(String,Start)
    return string.sub(String,1,string.len(Start))==Start
 end
 


return assassination