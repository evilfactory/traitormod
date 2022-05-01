local VERSION = "2.1-SNAPSHOT"

print("Traitor Mod v" .. VERSION .. " by Evil Factory")
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

Traitormod.SendMessageEveryone = function (text)
    Game.SendMessage(text, 7)
    Game.SendMessage(text, 1)
end

Traitormod.SendMessage = function (client, text, icon)
    -- ChatMessageType 1-5 in chat, 6 is log, 7/10 is popup, 9 no effect, 11 is messagebox
    if icon then
        Game.SendDirectChatMessage("", text, nil, 11, client, icon)
    else
        Game.SendDirectChatMessage("", text, nil, 7, client)
    end

    Game.SendDirectChatMessage("", text, nil, 1, client)
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

local iconIdentifier =  "enginetrap" -- can be any defined Traitor mission id in vanilla xml, mainly used for icon
Traitormod.SendTraitorMessageBox = function (character, text)
    local client = Traitormod.FindClientCharacter(character)
    Game.SendTraitorMessage(client, text, iconIdentifier, TraitorMessageType.ServerMessageBox);
    Game.SendDirectChatMessage("", text, nil, 1, client)
end

-- set character traitor to enable sabotage, set mission objective text then sync with session
 Traitormod.UpdateVanillaTraitor = function (character, enabled, objectiveSummary)
    character.IsTraitor = enabled
    local client = Traitormod.FindClientCharacter(character)
    local msg = nil
    if enabled and Traitormod.SelectedGamemode then
        msg = objectiveSummary or Traitormod.SelectedGamemode.GetTraitorObjectiveSummary(character)
    end
    character.TraitorCurrentObjective = msg
    Game.SendTraitorMessage(client, msg, iconIdentifier, TraitorMessageType.Objective)
 end

 Traitormod.SendObjectiveCompleted = function(client, objective, xp)
    Traitormod.SendMessage(client, 
    string.format(Traitormod.Language.ObjectiveCompleted, objective.ObjectiveText) .. " \n\n" .. 
    string.format(Traitormod.Language.ExperienceAwarded, xp), "MissionCompletedIcon") --InfoFrameTabButton.Mission

    Traitormod.UpdateVanillaTraitor(client.Character, true)
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
    if ptable.gainedFromAbility then return end
    if instance.Character == nil then return end
    if instance.Character.IsDead then return end

    local client = Traitormod.FindClientCharacter(instance.Character)

    if client == nil then return end

    local points = Traitormod.Config.PointsGainedFromSkill[ptable.skillIdentifier]

    if points == nil then return end

    points = points * ptable.increase

    Traitormod.PointsToBeGiven[client] = (Traitormod.PointsToBeGiven[client] or 0) + points
end)

Traitormod.LoadData()

Traitormod.Log = function (message)
    print("[TraitorMod] " .. message)
end

Traitormod.Debug = function (message)
    if Traitormod.Config.DebugLogs then
        print("[TraitorMod-Debug] " .. message)
    end
end

Traitormod.Error = function (message)
    print("[TraitorMod-Error] " .. message)
end

Traitormod.AllCrewMissionsCompleted = function ()
    for key, value in pairs(Game.GameSession.missions) do
        if not value.Completed then
            return false
        end
    end
    return true
end

Traitormod.GiveExperience = function (character, amount, isMissionXP)
    Traitormod.Debug("Giving experience to character: " .. character.Name .. " -> " .. amount)
    character.Info.GiveExperience(amount, isMissionXP)
end

Traitormod.AwardPoints = function (client, amount, update, isMissionXP)
    Traitormod.AddData(client, "Points", amount)
                
    local xp = Traitormod.Config.AmountExperienceWithPoints(amount)

    Traitormod.GiveExperience(client.Character, xp)
    if update == nil or update then
        Traitormod.UpdateVanillaTraitor(client.Character, true)
    end

    return xp
end

local weightedRandom = dofile(Traitormod.Path .. "/Lua/weightedrandom.lua")

local traitorsEnabled = -1
Hook.Add("roundStart", "Traitormod.RoundStart", function ()
    Traitormod.Log("Starting traitor round - Traitor Mod v" .. VERSION)

    -- give XP to players based on stored points
    for key, value in pairs(Client.ClientList) do
        if value.Character ~= nil and value.Character.Info ~= nil then
            local amount = Traitormod.Config.AmountExperienceWithPoints(Traitormod.GetData(value, "Points") or 0)
            Traitormod.GiveExperience(value.Character, amount)
        end
    end

    traitorsEnabled = Game.ServerSettings.TraitorsEnabled
    if traitorsEnabled == 0 then
        Traitormod.Log("Traitors are disabled.")
        return
    elseif traitorsEnabled == 1 then
        local rng = math.random()
        if rng < 0.5 then
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
    local endReached = false
    local crewMissionsComplete = Traitormod.AllCrewMissionsCompleted()
    -- handle stored player lives and weight
    for key, value in pairs(Client.ClientList) do
        -- add weight according to points and config conversion
        Traitormod.AddData(value, "Weight", Traitormod.Config.AmountWeightWithPoints(Traitormod.GetData(value, "Points") or 0))

        if value.Character ~= nil then
            -- if char is dead, remove one live, if lives reaches 0 reduce poitns according to config
            if value.Character.IsDead then
                Traitormod.AddData(value, "Lives", -1)

                if (Traitormod.GetData(value, "Lives") or 0) <= 0 then
                    Traitormod.SetData(value, "Points", Traitormod.Config.PointsLostAfterNoLives(Traitormod.GetData(value, "Points") or 0))
                    Traitormod.SetData(value, "Lives", Traitormod.Config.MaxLives)
                end
            -- else if character in reach of end position, gain a live
            else if Vector2.Distance(value.Character.WorldPosition, Level.Loaded.EndPosition) < Traitormod.Config.DistanceToEndOutpostRequired then
                endReached = true
                
                -- FIXME: if no traitor, award points for mission completion
                if valueIsNoTraitor and crewMissionsComplete then
                    local xp = Traitormod.AwardPoints(client, Traitormod.Config.PointsGainedFromCrewMissionsCompleted, false, true)
                    Traitormod.SendMessage(client, 
                    Traitormod.Language.CrewWins .. " \n\n" .. 
                    string.format(Traitormod.Language.ExperienceAwarded, xp), "MissionCompletedIcon") --InfoFrameTabButton.Mission
                end

                if (Traitormod.GetData(value, "Lives") or 0) < Traitormod.Config.MaxLives then
                        Traitormod.AddData(value, "Lives", 1)
                    end
                end
            end
        end
    end

    if traitorsEnabled == 0 or Traitormod.SelectedGamemode == nil then
        return
    end

    Traitormod.RoundNumber = Traitormod.RoundNumber + 1

    -- send LastRoundSummary
    local endMessage = Traitormod.SelectedGamemode.End()

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
    elseif crewMissionsComplete and endReached then
        roundResult = Traitormod.Language.CrewWins .. "\n\n"
    end

    endMessage = 
    Traitormod.Language.RoundSummary .. "\n" ..
    roundResult .. 
    string.format(Traitormod.Language.Gamemode, Traitormod.SelectedGamemode.Name) .. "\n" ..
    string.format(Traitormod.Language.RandomEvents, eventMessage) .. "\n\n" .. 
    endMessage

    Game.Log(endMessage, ServerLogMessageType.ServerMessage)
    Traitormod.SendMessageEveryone(endMessage)
    Traitormod.LastRoundSummary = endMessage
    
    -- end all events
    for key, event in pairs(Traitormod.SelectedRandomEvents) do
        event.End()
    end

    Traitormod.SelectedRandomEvents = {}

    Traitormod.SaveData()
end)

local pointsGiveTimer = 0

-- register tick
Hook.Add("think", "Traitormod.Think", function ()
    if Game.RoundStarted and Traitormod.SelectedGamemode then
        Traitormod.SelectedGamemode.Think()
    
        for key, event in pairs(Traitormod.SelectedRandomEvents) do
            event.Think()
        end
    end

    -- every 500s, if a character has 200+ PointsToBeGiven, store added points and send feedback
    if Timer.GetTime() > pointsGiveTimer then
        for key, value in pairs(Traitormod.PointsToBeGiven) do
            if value > 200 then
                local xp = Traitormod.AwardPoints(key, value, false)
                Traitormod.SendMessage(key, string.format(Traitormod.Language.ExperienceAwarded, math.floor(xp)), "InfoFrameTabButton.Mission")

                Traitormod.PointsToBeGiven[key] = 0
            end
        end

        pointsGiveTimer = Timer.GetTime() + 500
    end
end)

-- Traitormod.Commands hook
Hook.Add("chatMessage", "Traitormod.ChatMessage", function (message, client)
    local split = Traitormod.ParseCommand(message)
    
    local command = table.remove(split, 1)

    if Traitormod.Commands[command] then
        return Traitormod.Commands[command].Callback(client, split)
    end
end)


dofile(Traitormod.Path .. "/Lua/commands.lua")