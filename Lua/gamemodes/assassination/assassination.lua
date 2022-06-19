local assassination = {}

assassination.Name = "Assassination"

local lang = Traitormod.Language

assassination.Start = function ()
    assassination.Traitors = {}
    assassination.KilledTargets = {}
    assassination.Completed = false

    assassination.MultiTraitor = false

    local words = Traitormod.SelectCodeWords()
    assassination.Codewords = words[1]
    assassination.Coderesponses = words[2]

    assassination.CurrentRoundNumber = Traitormod.RoundNumber

    dofile(Traitormod.Path .. "/Lua/gamemodes/assassination/commands.lua")
    dofile(Traitormod.Path .. "/Lua/gamemodes/assassination/hooks.lua")

    -- select traitor
    assassination.SelectTraitors()
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
                    local xp = Traitormod.AwardPoints(client, objective.Config.AmountPoints)
                    local lives = Traitormod.AdjustLives(client, objective.Config.AmountLives)
                    
                    Traitormod.SendObjectiveCompleted(client,  objective.ObjectiveText, xp, lives)
                end
                
                objective.Awarded = true
            end
        end
    end

    local message
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
        if summary ~= nil then
            summary = summary .. "\n\n"
        end
        summary = (summary or "") .. assassination.GetTraitorObjectiveSummary(character, true)
    end

    if not summary then
        summary = Traitormod.Language.NoTraitors
    end

    return title .. summary
end

assassination.GetTraitorObjectiveSummary = function (character, roundSummary)
    local traitor = assassination.Traitors[character]

    -- if given character was no traitor, return no traitor.
    if not roundSummary and (traitor == nil or traitor.Failed) then 
        return Traitormod.Language.NoTraitor
    end

    local mainObjectiveText = ""
    if #traitor.MainObjectives == 0 then 
        mainObjectiveText = "  >  " .. lang.NoObjectivesYet .. " " .. lang.AssassinationNextTarget
    else
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
    end

    local subObjectivesText = nil
    if #traitor.SubObjectives == 0 then
        subObjectivesText = "  >  " .. lang.NoObjectives
    else
        for key, value in pairs(traitor.SubObjectives) do
            local br = "\n"
            if not subObjectivesText then
                br = ""
            end
            subObjectivesText = (subObjectivesText or "") .. br ..  "  >  " .. value.ObjectiveText
        
            if value.Awarded then
                subObjectivesText = subObjectivesText .. lang.Completed
            elseif not roundSummary then
                local xp = math.floor(Traitormod.Config.AmountExperienceWithPoints(value.Config.AmountPoints))
                subObjectivesText = subObjectivesText .. string.format(lang.Experience, xp)
            end
        end
    end

    if roundSummary then
        local prefix = Traitormod.GetJobString(character)

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
        
        codewordText = "\n\n" .. string.format(lang.Codewords, codeWords) .. "\n" .. string.format(lang.CodeResponses, codeResponses)
    elseif assassination.Config.TraitorMethodCommunication == "Names" then
        local names = ""

        for character, traitor in pairs(assassination.Traitors) do
            names = names .. "\"" .. character.Name .. "\" "
        end

        codewordText = "\n\n" .. string.format(lang.OtherTraitors, names)
    end

    return string.format("%s\n\n%s\n%s\n%s\n%s%s", lang.ObjectiveText, lang.Objective, mainObjectiveText, lang.SubObjective, subObjectivesText, codewordText)
end

-- returns a random valid assassination target for a given role filter
assassination.GetValidTarget = function (roleFilter, sideObjective)
    local targets = {}
    local debug = ""
    for key, value in pairs(Character.CharacterList) do
        -- if character is not a traitor, is a human and is not dead and matches the rolefilter
        if value ~= botGod and assassination.Traitors[value] == nil and value.IsHuman and not value.IsDead and 
        (roleFilter == nil or roleFilter[value.Info.Job.Prefab.Identifier.Value]) then
            if assassination.Config.SelectPiratesAsTargets or value.TeamID ~= CharacterTeamType.None then
                if assassination.Config.SelectBotsAsTargets or not value.IsBot then
                    -- if the character has not already been killed or it is a side objective target
                    if not assassination.Config.SelectUniqueTargets or sideObjective or not assassination.KilledTargets[value] then
                        -- add the character as a possible target
                        table.insert(targets, value)
                        debug = debug.." | "..value.Name.." ("..tostring(value.Info.Job.Prefab.Identifier)..value.TeamID..")"
                    end
                end
            end
        end
    end
    
    Traitormod.Debug("Selecting new random target out of "..#targets.." possible candidates"..debug)
    if #targets > 0 then
        local chosenTarget = targets[math.random(1, #targets)]
        return chosenTarget
    end

    return nil
end

assassination.InitTraitor = function (character)
    if character == nil then
        Traitormod.Error("InitTraitor failed! Character was nil.")
    end

    local traitor = {}
    assassination.Traitors[character] = traitor

    traitor.MainObjectives = {}
    traitor.SubObjectives = {}
    traitor.Deaths = 0
    traitor.Kills = 0
end

-- initially choose objectives and targets. If no targets are available, will retry after configured NextDelay
assassination.AssignInitialMissions = function (targetsAvailable)
    if targetsAvailable == nil then
        -- if no valid target but respawn is on, retry later
        if Game.ServerSettings.AllowRespawn or MidRoundSpawn then  
            local thisRoundNumber = Traitormod.RoundNumber
            local delay = math.random(assassination.Config.NextDelayMin, assassination.Config.NextDelayMax)
            Traitormod.Log("No valid main objectives found (all valid players dead?), retrying in " .. delay .. "s")

            Timer.Wait(function ()
                if thisRoundNumber ~= Traitormod.RoundNumber or not Game.RoundStarted then return end
                -- check if there are valid traitor victims
                Traitormod.Debug("Check if there are targets...")
                local validTarget = assassination.GetValidTarget()
                assassination.AssignInitialMissions(validTarget)
            end, delay * 1000)
        else
            -- if no respawn on there is nothing else to do
            Traitormod.Error("No valid main objectives found (all valid players dead?)")
        end
    else
        for character, traitor in pairs(assassination.Traitors) do
            Traitormod.Debug("GetValidTarget for " .. character.Name .. " MainObjective...")
            local target = assassination.GetValidTarget()
            Traitormod.Log("Chose assassination target " .. target.Name)
            traitor.MainObjectives[1] = Traitormod.GetObjective("Assassinate")
            traitor.MainObjectives[1].Start(character, target)
    
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
                Traitormod.Debug("GetValidTarget for ".. objective.Name)
                local subTarget = assassination.GetValidTarget(objective.RoleFilter, true)
                if objective.Start(character, subTarget) then
                    table.insert(traitor.SubObjectives, objective)
                    Traitormod.Log("Sub objective "..objective.Name.. " started with target " .. subTarget.Name)
                end
    
                table.remove(objectivesAvaiable, rng)
            end
        
            -- set mission objective
            local objectiveSummary = assassination.GetTraitorObjectiveSummary(character)    
            local client = Traitormod.FindClientCharacter(character)

            Traitormod.SendTraitorMessageBox(client, objectiveSummary)
            Traitormod.UpdateVanillaTraitor(client, true, objectiveSummary)
        end
    end
end

-- add new assassination objective
assassination.RenewAssassinationObjective = function(client, traitor, target)
    if target == nil then
        return
    end
    local newObjective = Traitormod.GetObjective("Assassinate")
    newObjective.Start(traitor, target)
    table.insert(traitor.MainObjectives, newObjective)

    -- give feedback about new target
    Traitormod.SendMessage(client, string.format(lang.AssassinationNewObjective, target.Name), "GameModeIcon.pvp")

    Traitormod.UpdateVanillaTraitor(client, true)
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
                Traitormod.Error("Couldn't award assassination points for " .. character.Name)
            else
                -- flag character as killed, so it wont be targeted again
                assassination.KilledTargets[client.Character] = true

                -- inform traitor victim (hook is too unreliable)
                local icon = "InfoFrameTabButton.Traitor"
                Traitormod.SendMessageCharacter(objective.ToKill, lang.KilledByTraitor, icon)
                
                traitor.Kills = (traitor.Kills or 0) + 1
                local xp = Traitormod.AwardPoints(client, objective.Config.AmountPoints)
                local objectiveText = objective.ObjectiveText .. "\n" .. Traitormod.Language.AssassinationNextTarget
                
                Traitormod.SendObjectiveCompleted(client, objectiveText, xp)

                -- check if all objectives completed, but dont save target just yet
                if assassination.GetNextAssassinationTarget(client, traitor, false) ~= nil then

                    -- choose next target after configured time passed
                    local delay = math.random(assassination.Config.NextDelayMin, assassination.Config.NextDelayMax)
                    local thisRoundNumber = assassination.CurrentRoundNumber
                    Traitormod.Log("Choosing new target in " .. delay .. "s")
                    Timer.Wait(function ()
                        if not Game.RoundStarted or thisRoundNumber ~= Traitormod.RoundNumber or traitor.Failed or assassination.Completed then return end
                    
                        local target = assassination.GetNextAssassinationTarget(client, traitor, true)
                        assassination.RenewAssassinationObjective(client, traitor, target)
                    end, delay * 1000)
                end
            end
        end
    end

    -- SubObjectives
    for _, objective in pairs(traitor.SubObjectives) do
        if not objective.EndRoundObjective and objective.IsCompleted() and not objective.Awarded then
            objective.Awarded = true

            -- award points for sub objection completion
            local client = Traitormod.FindClientCharacter(character)
            if client == nil then 
                Traitormod.Error("Couldn't award sub objective points for " .. character.Name)
            else
                local xp = Traitormod.AwardPoints(client, objective.Config.AmountPoints)
                Traitormod.SendObjectiveCompleted(client, objective.ObjectiveText, xp)
            end
        end
    end
end

assassination.GetNextAssassinationTarget = function(client, traitor, realTarget)
    Traitormod.Debug("GetValidTarget after assassination.")
    local target = assassination.GetValidTarget(nil, realTarget)

    if target == nil and not client.Character.IsDead then
    -- if no new target found, end round or give feedback and return
        assassination.Completed = true
        if assassination.Config.EndOnComplete then
            local delay = (assassination.Config.EndGameDelaySeconds or 0)

            Traitormod.SendMessageEveryone(lang.TraitorsWin)
            Traitormod.Log("Assassination complete. Ending round in " .. delay)

            Timer.Wait(function ()
                Game.EndGame()
            end, delay * 1000)
        else
            Traitormod.SendMessage(client, lang.AssassinationEveryoneDead, "InfoFrameTabButton.Reputation")
        end
        return
    end
    return target
end

local weightedRandom = dofile(Traitormod.Path .. "/Lua/weightedrandom.lua")

assassination.SelectTraitors = function (fast)
        -- select traitor after configured time has passed
        local thisRoundNumber = Traitormod.RoundNumber
        local delay = 0
        if fast then
            delay = math.random(assassination.Config.NextDelayMin, assassination.Config.NextDelayMax)
        else
            delay = math.random(assassination.Config.StartDelayMin, assassination.Config.StartDelayMax)
        end
        Traitormod.Log("New Traitors will be chosen in " .. delay .. "s")

        Timer.Wait(function ()
            if thisRoundNumber ~= Traitormod.RoundNumber or not Game.RoundStarted then return end
            if #Client.ClientList == 0 then
                Traitormod.Log("No reason to look for traitors in a round without players... Ending round.") 
                Game.EndGame()
                return
            end
            
            -- load clientWeight table from stored values
            local clientWeight = {}
            local traitorChoices = 0
            local playerInGame = 0
            for key, value in pairs(Client.ClientList) do
                -- valid traitor choices must be ingame, player was spawned before (has a character), is no spectator
                if value.InGame and value.Character and not value.SpectateOnly then
                    -- filter by config
                    if assassination.Config.TraitorFilter(value) then
                        -- players are alive or if respawning is on and config allows dead traitors (not supported yet)
                        if not value.Character.IsDead or (Game.ServerSettings.AllowRespawn and assassination.Config.AllowDeadTraitors) then
                            clientWeight[value] = Traitormod.GetData(value, "Weight") or 0
                            traitorChoices = traitorChoices + 1
                        end
                    end

                    playerInGame = playerInGame + 1
                end
            end
        
            -- no valid traitors to choose
            if traitorChoices == 0 then 
                if Game.ServerSettings.AllowRespawn or MidRoundSpawn then
                    -- if more players to come, retry
                    Traitormod.Debug("Currently no valid player characters to assign traitors. Retrying...") 
                    assassination.SelectTraitors(true)
                else
                    -- else this will never change, abort
                    Traitormod.Log("No players to assign traitors") 
                end
                return
            end
        
            local amountTraitors = assassination.Config.AmountTraitors(playerInGame)
            if amountTraitors > traitorChoices then
                amountTraitors = traitorChoices
                Traitormod.Log("Not enough valid players to assign all traitors... New amount: " .. tostring(amountTraitors)) 
            end
            if amountTraitors > 1 then
                assassination.MultiTraitor = true
            end
        
            -- choose and initialize traitors
            for i = 1, amountTraitors, 1 do
                local index = weightedRandom.Choose(clientWeight)
            
                if index ~= nil then
                    Traitormod.Log("Chose " .. index.Character.Name.. " as traitor. Weight: " .. math.floor(clientWeight[index] * 100) / 100)
                    assassination.InitTraitor(index.Character)
                    clientWeight[index] = nil
                    -- if traitor chosen reset stored weight to 0
                    Traitormod.SetData(index, "Weight", 0)
                end
            end
        
            -- greet traitors afterwards, so we have all infos about existing traitors
        
            -- check if there are valid traitor victims
            Traitormod.Debug("Check if there are targets...")
            local targetsAvailable = assassination.GetValidTarget()
        
            for character, traitor in pairs(assassination.Traitors) do
                local greet = ""

                if not assassination.MultiTraitor or assassination.Config.TraitorMethodCommunication == "None"  then
                    greet = string.format("%s\n\n%s", lang.TraitorWelcome, lang.AgentNoticeOnlyTraitor)
                elseif assassination.Config.TraitorMethodCommunication == "Codewords" then
                    greet = string.format("%s\n\n%s", lang.TraitorWelcome, lang.AgentNoticeCodewords)
                elseif assassination.Config.TraitorMethodCommunication == "Names" then
                    greet = string.format("%s\n\n%s", lang.TraitorWelcome, lang.AgentNoticeNoCodewords)
                end
            
                local client = Traitormod.FindClientCharacter(character)
            
                -- if no target is available, inform player and set vanilla traitor prematurely
                if targetsAvailable == nil then
                    greet = greet .. "\n\n" .. lang.NoObjectivesYet .. " " .. lang.AssassinationNextTarget
                    Traitormod.UpdateVanillaTraitor(client, true)
                end
                -- send greeting
                Traitormod.SendTraitorMessageBox(client, greet)
            end
        
            -- assign missions, if no targets available, will retry delayed internally
            assassination.AssignInitialMissions(targetsAvailable)

        end, delay * 1000)
end

assassination.SetupTraitors = function()
    
end

assassination.GetAmountTraitors = function ()
    local i = 0
    for key, value in pairs(assassination.Traitors) do
        i = i + 1
    end
    return i
end

return assassination