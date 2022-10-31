Traitormod.Config = dofile(Traitormod.Path .. "/Lua/config/config.lua")

Traitormod.Languages = {
    dofile(Traitormod.Path .. "/Lua/language/english.lua")
}

Traitormod.Language = Traitormod.Languages[1]

for key, value in pairs(Traitormod.Languages) do
    if Traitormod.Config.Language == value.Name then
        Traitormod.Language = value
    end
end

local json = dofile(Traitormod.Path .. "/Lua/json.lua")
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

Traitormod.FindClient = function (name)
    for key, value in pairs(Client.ClientList) do
        if value.Name == name or tostring(value.SteamID) == name then
            return value
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
    else
        Game.SendMessage(text, ChatMessageType.Server)
    end
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

Traitormod.MissionIdentifier =  'easterbunny' -- can be any defined Traitor mission id in vanilla xml, mainly used for icon
Traitormod.SendTraitorMessageBox = function (client, text)
    Game.SendTraitorMessage(client, text, Traitormod.MissionIdentifier, TraitorMessageType.ServerMessageBox);
    Game.SendDirectChatMessage("", text, nil, Traitormod.Config.ChatMessageType, client)
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
    Game.SendTraitorMessage(client, msg, Traitormod.MissionIdentifier, TraitorMessageType.Objective)
end

-- send feedback to the character for completing a traitor objective and update vanilla traitor state
Traitormod.SendObjectiveCompleted = function(client, objectiveText, points, livesText)
    if livesText then
        livesText = "\n" .. livesText
    else
        livesText = ""
    end

    Traitormod.SendMessage(client, 
    string.format(Traitormod.Language.ObjectiveCompleted, objectiveText) .. " \n\n" .. 
    string.format(Traitormod.Language.PointsAwarded, points) .. livesText
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
    if type(commandName) == "table" then
        for command in commandName do
            Traitormod.AddCommand(command, callback)
        end
    else
        local cmd = {}
    
        Traitormod.Commands[string.lower(commandName)] = cmd
        cmd.Callback = callback;
    end
end

Traitormod.RemoveCommand = function (commandName)
    Traitormod.Commands[commandName] = nil
end

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
    
    if Traitormod.Config.DebugLogs then
        printerror(message)
    end
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

Traitormod.AllTraitorsHandcuffed = function (traitors)
    if traitors == nil then return 0 end
    
    local num = 0
    for character, traitor in pairs(traitors) do
        local item = character.Inventory.GetItemInLimbSlot(InvSlotType.RightHand)

        if item ~= nil and item.Prefab.Identifier == "handcuffs" then
            num = num + 1
        end
    end

    return num
end

Traitormod.LoadExperience = function (client)
    if client == nil then
        Traitormod.Error("Loading experience failed! Client was nil")
        return
    elseif not client.Character or not client.Character.Info then 
        Traitormod.Error("Loading experience failed! Client.Character or .Info was null! " .. Traitormod.ClientLogName(client))
        return 
    end
    local amount = Traitormod.Config.AmountExperienceWithPoints(Traitormod.GetData(client, "Points") or 0)
    local max = Traitormod.Config.MaxExperienceFromPoints or 2000000000     -- must be int32

    if amount > max then
        amount = max
    end

    Traitormod.Debug("Loading experience from stored points: " .. Traitormod.ClientLogName(client) .. " -> " .. amount)
    client.Character.Info.SetExperience(amount)
end

Traitormod.GiveExperience = function (character, amount, isMissionXP)
    if character == nil or character.Info == nil or character.Info.GiveExperience == nil or character.IsHuman == false or amount == nil or amount == 0 then
        return false
    end
    Traitormod.Debug("Giving experience to character: " .. character.Name .. " -> " .. amount)
    character.Info.GiveExperience(amount, isMissionXP)
    return true
end

Traitormod.AwardPoints = function (client, amount, isMissionXP)
    if not Traitormod.Config.TestMode then
        Traitormod.AddData(client, "Points", amount)
        Traitormod.Stats.AddClientStat("PointsGained", client, amount)
        Traitormod.Log(string.format("Client %s was awarded %d points.", Traitormod.ClientLogName(client), math.floor(amount)))
        if Traitormod.SelectedGamemode.AwardedPoints then
            local oldValue = Traitormod.SelectedGamemode.AwardedPoints[client.SteamID] or 0
            Traitormod.SelectedGamemode.AwardedPoints[client.SteamID] = oldValue + amount
        end
    end
    return amount
end

Traitormod.AdjustLives = function (client, amount)
    if not amount or amount == 0 then
        return
    end

    local oldLives = Traitormod.GetData(client, "Lives") or Traitormod.Config.MaxLives
    local newLives =  oldLives + amount

    if (newLives or 0) > Traitormod.Config.MaxLives then
        -- if gained more lives than maxLives, reset to maxLives
        newLives = Traitormod.Config.MaxLives
    end

    local icon = "InfoFrameTabButton.Mission"
    if newLives == oldLives then
        -- no change in lives, no need for feedback
        return nil, icon
    end

    local amountString = Traitormod.Language.ALife
    if amount > 1 then amountString = amount .. Traitormod.Language.Lives end

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
        Traitormod.Log("Player ".. client.Name .." lost all lives. Reducing points...")
        if not Traitormod.Config.TestMode then  
            local oldAmount = Traitormod.GetData(client, "Points") or 0
            local newAmount = Traitormod.Config.PointsLostAfterNoLives(oldAmount)
            Traitormod.SetData(client, "Points", newAmount)
            Traitormod.Stats.AddClientStat("PointsLost", client, oldAmount - newAmount)

            Traitormod.LoadExperience(client)
        end
        newLives = Traitormod.Config.MaxLives
        lifeAdjustMessage = string.format(Traitormod.Language.NoLives, newLives)
    end
    
    Traitormod.Log("Adjusting lives of player " .. Traitormod.ClientLogName(client) .. " by " .. amount .. ". New value: " .. newLives)
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

Traitormod.ClientLogName = function(client, name)
    if name == nil then name = client.Name end

    name = string.gsub(name, "%‖", "")

    local log = "‖metadata:" .. client.SteamID .. "‖" .. name .. "‖end‖"
    return log
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

Traitormod.SendWelcome = function(client)
    if Traitormod.Config.SendWelcomeMessage or Traitormod.Config.SendWelcomeMessage == nil then
        Game.SendDirectChatMessage("", "| Traitor Mod v" .. Traitormod.VERSION .. " |\n" .. Traitormod.GetDataInfo(client), nil, ChatMessageType.Server, client)
    end
end