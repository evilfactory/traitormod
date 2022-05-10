Traitormod.VERSION = "2.1-SNAPSHOT"

print("Traitor Mod v" .. Traitormod.VERSION .. " by Evil Factory")
print("Special thanks to Qunk, Femboy69 and JoneK for helping in the development of this mod.")

Game.OverrideTraitors(true)

Traitormod.Config = dofile(Traitormod.Path .. "/Lua/config.lua")
Traitormod.Languages = {
    dofile(Traitormod.Path .. "/Lua/language/english.lua")
}

Traitormod.Language = Traitormod.Languages[1]

for key, value in pairs(Traitormod.Languages) do
    if Traitormod.Config.Language == value.Name then
        Traitormod.Language = value
    end
end

if Traitormod.Config.EnableControlHusk then
    Game.EnableControlHusk(true)
end

Traitormod.Gamemodes = {
    dofile(Traitormod.Path .. "/Lua/gamemodes/assassination/assassination.lua")
}

Traitormod.EnabledGamemodes = {}
Traitormod.SelectedGamemode = dofile(Traitormod.Path .. "/Lua/gamemodes/nogamemode.lua")

Traitormod.Objectives = {
    Traitormod.Path .. "/Lua/objectives/assassinate.lua",
    Traitormod.Path .. "/Lua/objectives/stealcaptainid.lua",
    Traitormod.Path .. "/Lua/objectives/survive.lua",
    Traitormod.Path .. "/Lua/objectives/kidnapsecurity.lua",
    Traitormod.Path .. "/Lua/objectives/poisoncaptain.lua",
}

Traitormod.RandomEvents = {
    dofile(Traitormod.Path .. "/Lua/randomevents/communicationsoffline.lua"),
    dofile(Traitormod.Path .. "/Lua/randomevents/superballastflora.lua"),
}

Traitormod.EnabledRandomEvents = {}
Traitormod.SelectedRandomEvents = {}

local json = dofile(Traitormod.Path .. "/Lua/json.lua")

if not File.Exists(Traitormod.Path .. "/Lua/data.json") then
    File.Write(Traitormod.Path .. "/Lua/data.json", "{}")
end

Traitormod.RoundNumber = 0
Traitormod.Commands = {}

Traitormod.LoadData = function ()
    if Traitormod.Config.PermanentPoints then
        Traitormod.ClientData = json.decode(File.Read(Traitormod.Path .. "/Lua/data.json")) or {}
    else
        Traitormod.ClientData = {}
    end
end

Traitormod.SaveData = function ()
    if Traitormod.Config.PermanentPoints then
        File.Write(Traitormod.Path .. "/Lua/data.json", json.encode(Traitormod.ClientData))
    end
end

for gmName, _ in pairs(Traitormod.Config.GamemodeConfig) do
    for _, gamemode in pairs(Traitormod.Gamemodes) do
        if Traitormod.Config.GamemodeConfig[gmName].Enabled and gmName == gamemode.Name then
            gamemode.Config = Traitormod.Config.GamemodeConfig[gmName]
            table.insert(Traitormod.EnabledGamemodes, gamemode)
        end
    end
end

for eventName, _ in pairs(Traitormod.Config.RandomEventConfig) do
    for _, event in pairs(Traitormod.RandomEvents) do
        if type(Traitormod.Config.RandomEventConfig[eventName]) == "table" and Traitormod.Config.RandomEventConfig[eventName].Enabled and eventName == event.Name then
            event.Config = Traitormod.Config.RandomEventConfig[eventName]
            table.insert(Traitormod.EnabledRandomEvents, event)
        end
    end
end

Traitormod.FindClientCharacter = function (character)
    for key, value in pairs(Client.ClientList) do
        if character == value.Character then return value end
    end

    return nil
end

Traitormod.SetData = function (client, name, amount)
    if Traitormod.ClientData[client.SteamID] == nil then 
        Traitormod.ClientData[client.SteamID] = {}
    end

    Traitormod.ClientData[client.SteamID][name] = amount
end

Traitormod.GetData = function (client, name)
    if Traitormod.ClientData[client.SteamID] == nil then 
        Traitormod.ClientData[client.SteamID] = {}
    end

    return Traitormod.ClientData[client.SteamID][name]
end

Traitormod.AddData = function(client, name, amount)
    Traitormod.SetData(client, name, math.max((Traitormod.GetData(client, name) or 0) + amount, 0))
end

Traitormod.SendMessageEveryone = function (text, popup)
    if popup then
        Game.SendMessage(text, ChatMessageType.MessageBox)
    end
    Game.SendMessage(text, Traitormod.Config.ChatMessageType)
end

Traitormod.SendMessage = function (client, text, icon)
    if not client or not text or text == "" then
        return
    end
    text = tostring(text)

    if icon then
        Game.SendDirectChatMessage("", text, nil, ChatMessageType.ServerMessageBoxInGame, client, icon)
    else
        Game.SendDirectChatMessage("", text, nil, ChatMessageType.MessageBox, client)
    end

    Game.SendDirectChatMessage("", text, nil, Traitormod.Config.ChatMessageType, client)
end

Traitormod.SendMessageCharacter = function (character, text, icon)
    if character.IsBot then return end
    
    local client = Traitormod.FindClientCharacter(character)

    if client == nil then
        Traitormod.Error("SendMessageCharacter() Client is null, ", character.name, " ", text)
        return
    end

    Traitormod.SendMessage(client, text, icon)
end

local traitorMissionIdentifier =  'easterbunny' -- can be any defined Traitor mission id in vanilla xml, mainly used for icon
Traitormod.SendTraitorMessageBox = function (client, text)
    Game.SendTraitorMessage(client, text, traitorMissionIdentifier, TraitorMessageType.ServerMessageBox);
    Game.SendDirectChatMessage("", text, nil, 1, client)
end

-- set character traitor to enable sabotage, set mission objective text then sync with session
Traitormod.UpdateVanillaTraitor = function (client, enabled, objectiveSummary)
    if not client or not client.Character then
        Traitormod.Error("UpdateVanillaTraitor failed! Client or Character was null!")
        return
    end
    client.Character.IsTraitor = enabled
    local msg = nil
    if enabled and Traitormod.SelectedGamemode then
        msg = objectiveSummary or Traitormod.SelectedGamemode.GetTraitorObjectiveSummary(client.Character)
    end
    client.Character.TraitorCurrentObjective = msg
    Game.SendTraitorMessage(client, msg, traitorMissionIdentifier, TraitorMessageType.Objective)
end

-- send feedback to the character for completing a traitor objective and update vanilla traitor state
Traitormod.SendObjectiveCompleted = function(client, objectiveText, xp, livesText)
    if livesText then
        livesText = "\n" .. livesText
    else
        livesText = ""
    end

    Traitormod.SendMessage(client, 
    string.format(Traitormod.Language.ObjectiveCompleted, objectiveText) .. " \n\n" .. 
    string.format(Traitormod.Language.ExperienceAwarded, xp) .. livesText
    , "MissionCompletedIcon") --InfoFrameTabButton.Mission
    Traitormod.UpdateVanillaTraitor(client, true)
end

Traitormod.SelectCodeWords = function ()
    local copied = {}
    for key, value in pairs(Traitormod.Config.Codewords) do
        copied[key] = value
    end

    local selected = {}
    for i=1, Traitormod.Config.AmountCodeWords, 1 do
        table.insert(selected, copied[Random.Range(1, #copied + 1)])
    end

    local selected2 = {}
    for i=1, Traitormod.Config.AmountCodeWords, 1 do
        table.insert(selected2, copied[Random.Range(1, #copied + 1)])
    end

    return {selected, selected2}
end

Traitormod.GetObjective = function (name)
    for _, value in pairs(Traitormod.Objectives) do
        local obj = dofile(value)
        obj.Config = Traitormod.Config.ObjectiveConfig[obj.Name]
        if obj.Name == name then return obj end
    end
end

Traitormod.GetRandomObjective = function (allowedObjectives)
    if allowedObjectives == nil then
        return Traitormod.Objectives[Random.Range(1, #Traitormod.Objectives + 1)]
    else
        local objectives = {}
        for _, objectivePath in pairs(Traitormod.Objectives) do
            for _, allowedName in pairs(allowedObjectives) do
                local obj = dofile(objectivePath)
                obj.Config = Traitormod.Config.ObjectiveConfig[obj.Name]
                if obj.Name == allowedName and obj.Enabled then table.insert(objectives, obj) end
            end
        end
        
        return objectives[Random.Range(1, #objectives + 1)]
    end
end

Traitormod.ParseCommand = function (text)
    local result = {}

    if text == nil then return result end

    local spat, epat, buf, quoted = [=[^(["])]=], [=[(["])$]=]
    for str in text:gmatch("%S+") do
        local squoted = str:match(spat)
        local equoted = str:match(epat)
        local escaped = str:match([=[(\*)["]$]=])
        if squoted and not quoted and not equoted then
            buf, quoted = str, squoted
        elseif buf and equoted == quoted and #escaped % 2 == 0 then
            str, buf, quoted = buf .. ' ' .. str, nil, nil
        elseif buf then
            buf = buf .. ' ' .. str
        end
        if not buf then result[#result + 1] = str:gsub(spat,""):gsub(epat,"") end
    end

    return result
end

Traitormod.AddCommand = function (commandName, callback)
    local cmd = {}

    Traitormod.Commands[commandName] = cmd
    cmd.Callback = callback;
end

Traitormod.RemoveCommand = function (commandName)
    Traitormod.Commands[commandName] = nil
end

-- when a character gains skill level, add PointsToBeGiven according to config
Traitormod.PointsToBeGiven = {}
Hook.HookMethod("Barotrauma.CharacterInfo", "IncreaseSkillLevel", function (instance, ptable)
    if not ptable or ptable.gainedFromAbility or instance.Character == nil or instance.Character.IsDead then return end

    local client = Traitormod.FindClientCharacter(instance.Character)

    if client == nil then return end

    local points = Traitormod.Config.PointsGainedFromSkill[tostring(ptable.skillIdentifier)]

    if points == nil then return end

    points = points * ptable.increase

    Traitormod.PointsToBeGiven[client] = (Traitormod.PointsToBeGiven[client] or 0) + points
end)

Traitormod.LoadData()

-- type: 6 = Server message, 7 = Console usage, 9 error
Traitormod.Log = function (message)
    Game.Log("[TraitorMod] " .. message, 6)
end

Traitormod.Debug = function (message)
    if Traitormod.Config.DebugLogs then
        Game.Log("[TraitorMod-Debug] " .. message, 6)
    end
end

Traitormod.Error = function (message)
    Game.Log("[TraitorMod-Error] " .. message, 9)
end

Traitormod.AllCrewMissionsCompleted = function (missions)
    if not missions then
        if Game.GameSession == nil or Game.GameSession.Missions == nil then return end
        missions = Game.GameSession.Missions
    end
    for key, value in pairs(missions) do
        if not value.Completed then
            return false
        end
    end
    return true
end

Traitormod.LoadExperience = function (client)
    local amount = Traitormod.Config.AmountExperienceWithPoints(Traitormod.GetData(client, "Points") or 0)
    if amount == client.Character.Info.ExperiencePoints then return end
    Traitormod.Debug("Loading experience from stored points: " .. client.Character.Name .. " -> " .. amount)
    client.Character.Info.SetExperience(amount)
end

Traitormod.GiveExperience = function (character, amount, isMissionXP)
    Traitormod.Debug("Giving experience to character: " .. character.Name .. " -> " .. amount)
    character.Info.GiveExperience(amount, isMissionXP)
end

Traitormod.AwardPoints = function (client, amount, isMissionXP)
    if not Traitormod.Config.TestMode then
        Traitormod.AddData(client, "Points", amount)
    end
    return Traitormod.Config.AmountExperienceWithPoints(amount)
end

Traitormod.AdjustLives = function (client, amount)
    if not amount or amount == 0 then
        return
    end

    local oldLives = Traitormod.GetData(client, "Lives") or Traitormod.Config.MaxLives
    local newLives =  oldLives + amount
    local amountString = Traitormod.Language.ALife
    if amount > 1 then amountString = amount .. Traitormod.Language.Lives end

    local icon = "InfoFrameTabButton.Mission"
    local lifeAdjustMessage = string.format(Traitormod.Language.LivesGained, amountString, newLives, Traitormod.Config.MaxLives)
    if amount < 0 then
        icon = "GameModeIcon.pvp"
        local newLivesString = Traitormod.Language.ALife
        if newLives > 1 then
            newLivesString = newLives .. Traitormod.Language.Lives
        end
        lifeAdjustMessage = string.format(Traitormod.Language.Death, newLivesString)
    end

    if (newLives or 0) <= 0 then
        -- if no lives left, reduce amount of points, reset to maxLives
        Traitormod.Log("Player ".. client.Character.Name .." lost all lives. Reducing points...")
        if not Traitormod.Config.TestMode then  
            Traitormod.SetData(client, "Points", Traitormod.Config.PointsLostAfterNoLives(Traitormod.GetData(client, "Points") or 0))
            Traitormod.LoadExperience(client)
        end
        newLives = Traitormod.Config.MaxLives
        lifeAdjustMessage = string.format(Traitormod.Language.NoLives, newLives)
    elseif (newLives or 0) > Traitormod.Config.MaxLives then
        -- if gained more lives than maxLives, reset to maxLives
        newLives = Traitormod.Config.MaxLives
        lifeAdjustMessage = nil -- no change in lives, no need for feedback
    end
    
    Traitormod.Log("Adjusting lives of player " .. client.Character.Name .. " by " .. amount .. ". New value: " .. newLives)
    Traitormod.SetData(client, "Lives", newLives)
    return lifeAdjustMessage, icon
end

Traitormod.GetDataInfo = function(client, showWeights)
    local weightInfo = ""
    if showWeights then
        local maxPoints = 0
        for index, value in pairs(Client.ClientList) do
            maxPoints = maxPoints + (Traitormod.GetData(value, "Weight") or 0)
        end
    
        local percentage = (Traitormod.GetData(client, "Weight") or 0) / maxPoints * 100
    
        if percentage ~= percentage then
            percentage = 100 -- percentage is NaN, set it to 100%
        end

        weightInfo = "\n\n" .. string.format(Traitormod.Language.TraitorInfo, math.floor(percentage))
    end

    return string.format(Traitormod.Language.PointsInfo, math.floor(Traitormod.GetData(client, "Points") or 0), Traitormod.GetData(client, "Lives") or Traitormod.Config.MaxLives, Traitormod.Config.MaxLives) .. weightInfo
end

Traitormod.GetJobString = function(character)
    local prefix = "Crew member"
    if character.Info and character.Info.Job then
        prefix = tostring(TextManager.Get("jobname." .. tostring(character.Info.Job.Prefab.Identifier)))
    end
    return prefix
end

-- returns true if character has reached the end of the level
Traitormod.EndReached = function(character)
    if LevelData and LevelData.LevelType and LevelData.LevelType.Outpost then
        return true
    end

    if Level.Loaded.EndOutpost == nil then
        return Submarine.MainSub.AtEndExit
    end

    local characterInsideOutpost = not character.IsDead and character.Submarine == Level.Loaded.EndOutpost
    -- character is inside or docked to outpost 
    return characterInsideOutpost or Vector2.Distance(character.WorldPosition, Level.Loaded.EndPosition) < Traitormod.Config.DistanceToEndOutpostRequired
end

local weightedRandom = dofile(Traitormod.Path .. "/Lua/weightedrandom.lua")

local traitorsEnabled = -1
local pointsGiveTimer

Hook.Add("roundStart", "Traitormod.RoundStart", function ()
    Traitormod.Log("Starting traitor round - Traitor Mod v" .. Traitormod.VERSION)
    pointsGiveTimer = Timer.GetTime() + Traitormod.Config.ExperienceTimer

    -- give XP to players based on stored points
    for key, value in pairs(Client.ClientList) do
        if value.Character ~= nil and value.Character.Info ~= nil then
            Traitormod.SetData(value, "Name", value.Character.Name)

            Traitormod.LoadExperience(value)

            -- Send Welcome message
            if Traitormod.Config.SendWelcomeMessage or Traitormod.Config.SendWelcomeMessage == nil then
                Game.SendDirectChatMessage("", "| Traitor Mod v" .. Traitormod.VERSION .. " |\n" .. Traitormod.GetDataInfo(value), nil, ChatMessageType.Server, value)
            end
        end
    end
    
    traitorsEnabled = Game.ServerSettings.TraitorsEnabled
    if traitorsEnabled == 0 then
        Traitormod.Log("Traitors are disabled.")
        return
    elseif traitorsEnabled == 1 then
        local rng = math.random()
        if rng < 0.5 then
            traitorsEnabled = 0
            Traitormod.Log("No traitors on this mission...")
            return
        end
    end

    -- choose a gamemode
    if #Traitormod.EnabledGamemodes == 0 then return end
    local result = weightedRandom.Choose(Traitormod.EnabledGamemodes, "Config", "WeightChance")
    Traitormod.SelectedGamemode = Traitormod.EnabledGamemodes[result]
    Traitormod.Log("Starting gamemode " .. Traitormod.SelectedGamemode.Name)
    Traitormod.SelectedGamemode.Start()

    -- check for event
    if Random.Range(0, 100) < Traitormod.Config.RandomEventConfig.AnyRandomEventChance then
        local result = weightedRandom.Choose(Traitormod.EnabledRandomEvents, "Config", "WeightChance")

        if result ~= nil then
            Traitormod.Log("Starting event " .. Traitormod.EnabledRandomEvents[result].Name)
            table.insert(Traitormod.SelectedRandomEvents, Traitormod.EnabledRandomEvents[result])
            Traitormod.EnabledRandomEvents[result].Start()
        end
    end
end)

Hook.Add("roundEnd", "Traitormod.RoundEnd", function ()
    Traitormod.RoundNumber = Traitormod.RoundNumber + 1

    local gameModeMessage = Traitormod.SelectedGamemode.End()

    -- show vanilla round summary
    local traitorMissionResult = nil
    local traitorCharacters = {}
    if Traitormod.SelectedGamemode.Traitors then
        for character, traitor in pairs(Traitormod.SelectedGamemode.Traitors) do
            table.insert(traitorCharacters, character)
        end
    end

    if #traitorCharacters > 0 then
        -- first arg = mission id, second = message, third = completed, forth = list of characters
        traitorMissionResult = {TraitorMissionResult(traitorMissionIdentifier, gameModeMessage, Traitormod.SelectedGamemode.Completed or false, traitorCharacters)} 
    end

    return traitorMissionResult
end)

Hook.Add("missionsEnded", "Traitormod.MissionsEnded", function (missions)
    -- send LastRoundSummary
    local endMessage
    local crewReachedEnd = false
    local crewMissionsComplete = Traitormod.AllCrewMissionsCompleted(missions)
    
    -- handle stored player lives and weight
    for key, value in pairs(Client.ClientList) do
        -- add weight according to points and config conversion
        Traitormod.AddData(value, "Weight", Traitormod.Config.AmountWeightWithPoints(Traitormod.GetData(value, "Points") or 0))
    
        if value.Character ~= nil then
            local wasTraitor = nil

            if Traitormod.SelectedGamemode then
                local traitors = Traitormod.SelectedGamemode.Traitors

                if traitors then
                    wasTraitor = traitors[value.Character]

                    -- tryhard fix for traitor not being found
                    if not wasTraitor then
                        for character, traitor in pairs(traitors) do
                            if  character.Name == value.Character.Name then
                                wasTraitor = traitor
                            end
                        end
                    end
                end
            end
        
            -- if client was no traitor, and in reach of end position, gain a live
            if wasTraitor == nil and Traitormod.EndReached(value.Character) then
                crewReachedEnd = true

                local msg = nil

                -- award points for mission completion
                if crewMissionsComplete then
                    local xp = Traitormod.AwardPoints(value, Traitormod.Config.PointsGainedFromCrewMissionsCompleted, true)
                    msg = Traitormod.Language.CrewWins .. " \n\n" .. string.format(Traitormod.Language.ExperienceAwarded, xp)
                end
                
                local lifeMsg, icon = Traitormod.AdjustLives(value, (Traitormod.Config.LivesGainedFromCrewMissionsCompleted or 1))
                if msg and lifeMsg then
                    msg = msg .. "\n" .. lifeMsg
                elseif lifeMsg then
                    msg = lifeMsg
                end
                Traitormod.SendMessage(value, msg, icon)
            end
        end
    end

    -- if traitor was disabled or no traitor was chosen (maybe)
    if Traitormod.SelectedGamemode == nil or Traitormod.SelectedGamemode.Name == "nogamemode" then
        endMessage = Traitormod.Language.RoundSummary .. "\n\n" .. Traitormod.Language.NoTraitors
    else
        local gameModeMessage = Traitormod.SelectedGamemode.GetRoundSummary()
        Traitormod.Debug(string.format("Round %d ended | traitorsEnabled = %d | crewMissionsComplete = %s | endReached = %s", Traitormod.RoundNumber, traitorsEnabled, tostring(crewMissionsComplete), tostring(crewReachedEnd)))

        local eventMessage = ""
    
        for key, value in pairs(Traitormod.SelectedRandomEvents) do
            eventMessage = eventMessage .. "\"" .. value.Name .. "\" "
        end
    
        if #Traitormod.SelectedRandomEvents == 0 then
            eventMessage = "None"
        end
    
        local roundResult = ""
        if Traitormod.SelectedGamemode.Completed then
            roundResult = Traitormod.Language.TraitorsWin .. "\n\n"
        elseif crewMissionsComplete and crewReachedEnd then
            roundResult = Traitormod.Language.CrewWins .. "\n\n"
        end
    
        endMessage = 
        Traitormod.Language.RoundSummary .. "\n\n" ..
        roundResult .. 
        string.format(Traitormod.Language.Gamemode, Traitormod.SelectedGamemode.Name) .. "\n" ..
        string.format(Traitormod.Language.RandomEvents, eventMessage) .. "\n\n" .. 
        gameModeMessage .. "\n"

    end

    -- show summary only if traitor mode was enabled initially
    if Game.ServerSettings.TraitorsEnabled ~= 0 then
        Traitormod.SendMessageEveryone(endMessage)
    end
    
    Traitormod.Log(endMessage)
    Traitormod.LastRoundSummary = endMessage
    
    -- end all events
    for key, event in pairs(Traitormod.SelectedRandomEvents) do
        event.End()
    end

    Traitormod.SelectedGamemode = dofile(Traitormod.Path .. "/Lua/gamemodes/nogamemode.lua")
    Traitormod.SelectedRandomEvents = {}

    Traitormod.SaveData()
end)

Hook.Add("characterCreated", "Traitormod.CharacterCreated", function (character)
    -- if character is valid player
    if character == nil or 
    character.IsBot == true or
    character.IsHuman == false or
    character.ClientDisconnected == true or
    character.TeamID == 0 then
        return
    end
    
    -- delay handling, otherwise client won't be found
    Timer.Wait(function ()
        if Traitormod.SelectedGamemode and Traitormod.SelectedGamemode.CurrentRoundNumber ~= Traitormod.RoundNumber then return end
        local client = Traitormod.FindClientCharacter(character)
        --Traitormod.Debug("Character spawned: " .. character.Name .. " client: " .. tostring(client))

        if client ~= nil then
            -- set experience of respawned character to stored value - note initial spawn may not call this hook (on local server)
            Traitormod.LoadExperience(client)
        end
    end, 100)
end)

Hook.Add("characterDeath", "Traitormod.DeathByTraitor", function (character, affliction)
    if Traitormod.SelectedGamemode == nil then
        return
    end

    local client = Traitormod.FindClientCharacter(character)

    -- if character is valid player
    if client == nil or
    character == nil or 
    character.IsHuman == false or
    character.ClientDisconnected == true or
    character.TeamID == 0 then
        return
    end

    local deathMsg, deathIcon
    if Traitormod.SelectedGamemode.OnCharacterDied then
        deathMsg, deathIcon = Traitormod.SelectedGamemode.OnCharacterDied(client, affliction)
    end
    
    -- loose one live. if gamemode provided no icon, use icon from life adjustment
    local lifeMsg, lifeIcon = Traitormod.AdjustLives(client, -1)
    if not deathIcon then
        deathIcon = lifeIcon
    end
    
    if deathMsg and lifeMsg then
        deathMsg = deathMsg .. "\n\n" .. lifeMsg 
    elseif lifeMsg then
       deathMsg = lifeMsg
    end

    Traitormod.SendMessage(client, deathMsg, deathIcon)
end)

-- register tick
Hook.Add("think", "Traitormod.Think", function ()
    if not Game.RoundStarted or Traitormod.SelectedGamemode == nil then
        return
    end

    Traitormod.SelectedGamemode.Think()

    for key, event in pairs(Traitormod.SelectedRandomEvents) do
        event.Think()
    end

    -- every 60s, if a character has 100+ PointsToBeGiven, store added points and send feedback
    if Timer.GetTime() > pointsGiveTimer then
        for key, value in pairs(Traitormod.PointsToBeGiven) do
            if value > 100 then
                local xp = Traitormod.AwardPoints(key, value)
                Traitormod.GiveExperience(key.Character, xp)

                local text = Traitormod.Language.ExperienceAwarded .. "\n" .. string.format(Traitormod.Language.ExperienceAwarded, math.floor(xp))
                Game.SendDirectChatMessage("", text, nil, Traitormod.Config.ChatMessageType, key)
                
                Traitormod.PointsToBeGiven[key] = 0
            end
        end

        -- if configured, give temporary experience to all characters
        if Traitormod.Config.FreeExperience and Traitormod.Config.FreeExperience > 0 then
            for key, value in pairs(Client.ClientList) do
                Traitormod.GiveExperience(value.Character, Traitormod.Config.FreeExperience)
            end
        end

        pointsGiveTimer = Timer.GetTime() + Traitormod.Config.ExperienceTimer
    end
end)

-- Traitormod.Commands hook
Hook.Add("chatMessage", "Traitormod.ChatMessage", function (message, client)
    local split = Traitormod.ParseCommand(message)

    if #split == 0 then return end
    
    local command = table.remove(split, 1)

    if Traitormod.Commands[command] then
        return Traitormod.Commands[command].Callback(client, split)
    end
end)


dofile(Traitormod.Path .. "/Lua/commands.lua")
