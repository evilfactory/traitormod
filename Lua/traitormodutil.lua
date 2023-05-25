Traitormod.Config = dofile(Traitormod.Path .. "/Lua/config/baseconfig.lua")

if not File.Exists(Traitormod.Path .. "/Lua/config/config.lua") then
    File.Write(Traitormod.Path .. "/Lua/config/config.lua", File.Read(Traitormod.Path .. "/Lua/config/config.lua.example"))
end

-- user config
loadfile(Traitormod.Path .. "/Lua/config/config.lua")(Traitormod.Config)

Traitormod.Patching = loadfile(Traitormod.Path .. "/Lua/xmlpatching.lua")(Traitormod.Path)

Traitormod.Languages = {
    dofile(Traitormod.Path .. "/Lua/language/english.lua")
}

Traitormod.DefaultLanguage = Traitormod.Languages[1]
Traitormod.Language = Traitormod.DefaultLanguage

for key, value in pairs(Traitormod.Languages) do
    if Traitormod.Config.Language == value.Name then
        Traitormod.Language = value

        for key, value in pairs(Traitormod.DefaultLanguage) do
            if Traitormod.Language[key] == nil then -- in case the language being loaded doesnt have a specific localization for a key, use the default language
                Traitormod.Language[key] = value
            end
        end

        break
    end
end

local json = dofile(Traitormod.Path .. "/Lua/json.lua")

Traitormod.LoadRemoteData = function (client, loaded)
    local data = {
        Account = client.SteamID,
    }

    for key, value in pairs(Traitormod.Config.RemoteServerAuth) do
        data[key] = value
    end

    Networking.HttpPost(Traitormod.Config.RemotePoints, function (res) 
        local success, result = pcall(json.decode, res)
        if not success then
            Traitormod.Log("Failed to retrieve points from server: " .. res)
            return
        end

        if result.Points then
            local originalPoints = Traitormod.GetData(client, "Points") or 0
            Traitormod.Log("Retrieved points from server for " .. client.SteamID .. ": " .. originalPoints .. " -> " .. result.Points)
            Traitormod.SetData(client, "Points", result.Points)
        end

        if loaded then loaded() end
    end, json.encode(data))
end

Traitormod.PublishRemoteData = function (client)
    local data = {
        Account = client.SteamID,
        Points = Traitormod.GetData(client, "Points")
    }

    if data.Points == nil then return end

    Traitormod.Log("Published points from server for " .. client.SteamID .. ": " .. data.Points)

    for key, value in pairs(Traitormod.Config.RemoteServerAuth) do
        data[key] = value
    end

    Networking.HttpPost(Traitormod.Config.RemotePoints, function (res) end, json.encode(data))
end

Traitormod.NewClientData = function (client)
    Traitormod.ClientData[client.SteamID] = {}
    Traitormod.ClientData[client.SteamID]["Points"] = Traitormod.Config.StartPoints
end

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

Traitormod.SetMasterData = function (name, value)
    Traitormod.ClientData[name] = value
end

Traitormod.GetMasterData = function (name)
    return Traitormod.ClientData[name]
end

Traitormod.SetData = function (client, name, amount)
    if Traitormod.ClientData[client.SteamID] == nil then 
        Traitormod.NewClientData(client)
    end

    Traitormod.ClientData[client.SteamID][name] = amount
end

Traitormod.GetData = function (client, name)
    if Traitormod.ClientData[client.SteamID] == nil then 
        Traitormod.NewClientData(client)
    end

    return Traitormod.ClientData[client.SteamID][name]
end

Traitormod.AddData = function(client, name, amount)
    Traitormod.SetData(client, name, math.max((Traitormod.GetData(client, name) or 0) + amount, 0))
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

Traitormod.SendChatMessage = function (client, text, color)
    if not client or not text or text == "" then
        return
    end

    text = tostring(text)

    local chatMessage = ChatMessage.Create("", text, ChatMessageType.Default)
    if color then
        chatMessage.Color = color
    end

    Game.SendDirectChatMessage(chatMessage, client)
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

Traitormod.MissionIdentifier =  "easterbunny" -- can be any defined Traitor mission id in vanilla xml, mainly used for icon
Traitormod.SendTraitorMessageBox = function (client, text, icon)
    Game.SendTraitorMessage(client, text, icon or Traitormod.MissionIdentifier, TraitorMessageType.ServerMessageBox);
    Game.SendDirectChatMessage("", text, nil, Traitormod.Config.ChatMessageType, client)
end

-- set character traitor to enable sabotage, set mission objective text then sync with session
Traitormod.UpdateVanillaTraitor = function (client, enabled, objectiveSummary, missionIdentifier)
    if not client or not client.Character then
        Traitormod.Error("UpdateVanillaTraitor failed! Client or Character was null!")
        return
    end

    client.Character.IsTraitor = enabled
    client.Character.TraitorCurrentObjective = objectiveSummary
    Game.SendTraitorMessage(client, objectiveSummary, missionIdentifier or Traitormod.MissionIdentifier, TraitorMessageType.Objective)
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

    local role = Traitormod.RoleManager.GetRole(client.Character)

    if role and role.IsAntagonist then
        Traitormod.UpdateVanillaTraitor(client, true, role:Greet())
    end
end

Traitormod.SendObjectiveFailed = function(client, objectiveText)
    Traitormod.SendMessage(client, 
    string.format(Traitormod.Language.ObjectiveFailed, objectiveText), "MissionFailedIcon")

    local role = Traitormod.RoleManager.GetRole(client.Character)

    if role and role.IsAntagonist then
        Traitormod.UpdateVanillaTraitor(client, true, role:Greet())
    end
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

Traitormod.Error = function (message, ...)
    Game.Log("[TraitorMod-Error] " .. message, 9)
    
    if Traitormod.Config.DebugLogs then
        printerror(string.format(message, ...))
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
        if Traitormod.SelectedGamemode and Traitormod.SelectedGamemode.AwardedPoints then
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

Traitormod.SendTip = function ()
    local tip = Traitormod.Language.Tips[math.random(1, #Traitormod.Language.Tips)]

    for index, value in pairs(Client.ClientList) do
        Traitormod.SendChatMessage(value, Traitormod.Language.TipText .. tip, Color.Orange)
    end
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

Traitormod.InsertString = function(str1, str2, pos)
    return str1:sub(1,pos)..str2..str1:sub(pos+1)
end

Traitormod.HighlightClientNames = function (text, color)
    for key, value in pairs(Client.ClientList) do
        local name = value.Name

        local i, j = string.find(text, name)

        if i ~= nil then
            text = Traitormod.InsertString(text, string.format("‖color:%s,%s,%s‖", color.R, color.G, color.B), i - 1)
        end

        local i, j = string.find(text, name)

        if i ~= nil then
            text = Traitormod.InsertString(text, "‖end‖", j)
        end
    end

    return text
end

Traitormod.GetJobString = function(character)
    local prefix = "Crew member"
    if character.Info and character.Info.Job then
        prefix = tostring(TextManager.Get("jobname." .. tostring(character.Info.Job.Prefab.Identifier)))
    end
    return prefix
end

-- returns true if character has reached the end of the level
Traitormod.EndReached = function(character, distance)
    if LevelData and LevelData.LevelType and LevelData.LevelType.Outpost then
        return true
    end

    if Level.Loaded.EndOutpost == nil then
        return Submarine.MainSub.AtEndExit
    end

    local characterInsideOutpost = not character.IsDead and character.Submarine == Level.Loaded.EndOutpost
    -- character is inside or docked to outpost 
    return characterInsideOutpost or Vector2.Distance(character.WorldPosition, Level.Loaded.EndPosition) < distance
end

Traitormod.SendWelcome = function(client)
    if Traitormod.Config.SendWelcomeMessage or Traitormod.Config.SendWelcomeMessage == nil then
        Game.SendDirectChatMessage("", "| Traitor Mod v" .. Traitormod.VERSION .. " |\n" .. Traitormod.GetDataInfo(client), nil, ChatMessageType.Server, client)
    end
end