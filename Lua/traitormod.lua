print("Traitor Mod by Evil Factory.")
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
    Game.SendMessage(text, ChatMessageType.MessageBox)
    Game.SendMessage(text, ChatMessageType.Private)
end

Traitormod.SendMessage = function (client, text, popup, icon)
    if popup == true then
        Game.SendDirectChatMessage("", text, nil, ChatMessageBox.ServerMessageBoxInGame, client, icon)
    else
        Game.SendDirectChatMessage("", text, nil, ChatMessageType.MessageBox, client)
    end

    Game.SendDirectChatMessage("", text, nil, ChatMessageType.Private, client)
end

Traitormod.SendMessageCharacter = function (character, text, popup, icon)
    local client = Traitormod.FindClientCharacter(character)

    if client == nil then
        print("Traitormod.SendMessageCharacter() Client is null, ", character.name, " ", text)
        return
    end

    Traitormod.SendMessage(client, text, popup, icon)
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


local weightedRandom = dofile(Traitormod.Path .. "/Lua/weightedrandom.lua")

Hook.Add("roundStart", "Traitormod.RoundStart", function ()
    for key, value in pairs(Client.ClientList) do
        if value.Character ~= nil and value.Character.Info ~= nil then
            local amount = Traitormod.Config.AmountExperienceWithPoints(Traitormod.GetData(value, "Points") or 0)
            value.Character.Info.GiveExperience(amount)
        end
    end

    if #Traitormod.EnabledGamemodes == 0 then return end
    local result = weightedRandom.Choose(Traitormod.EnabledGamemodes, "Config", "WeightChance")
    Traitormod.SelectedGamemode = Traitormod.EnabledGamemodes[result]
    Traitormod.SelectedGamemode.Start()

    if Random.Range(0, 100) < Traitormod.Config.RandomEventConfig.AnyRandomEventChance then
        local result = weightedRandom.Choose(Traitormod.EnabledRandomEvents, "Config", "WeightChance")

        if result ~= nil then
            table.insert(Traitormod.SelectedRandomEvents, Traitormod.EnabledRandomEvents[result])
            Traitormod.EnabledRandomEvents[result].Start()
        end
    end
end)

Hook.Add("roundEnd", "Traitormod.RoundEnd", function ()
    Traitormod.RoundNumber = Traitormod.RoundNumber + 1
    
    if Traitormod.SelectedGamemode == nil then return end

    for key, value in pairs(Client.ClientList) do
        Traitormod.AddData(value, "Weight", Traitormod.Config.AmountWeightWithPoints(Traitormod.GetData(value, "Points") or 0))

        if value.Character ~= nil then
            if value.Character.IsDead then
                Traitormod.AddData(value, "Lives", -1)

                if (Traitormod.GetData(value, "Lives") or 0) <= 0 then
                    Traitormod.SetData(value, "Points", Traitormod.Config.PointsLostAfterNoLives(Traitormod.GetData(value, "Points") or 0))
                    Traitormod.SetData(value, "Lives", Traitormod.Config.MaxLives)
                end
            else if Vector2.Distance(value.Character.WorldPosition, Level.Loaded.EndPosition) < Traitormod.Config.DistanceToEndOutpostRequired then
                    if (Traitormod.GetData(value, "Lives") or 0) < Traitormod.Config.MaxLives then
                        Traitormod.AddData(value, "Lives", 1)
                    end
                end
            end
        end
    end

    local endMessage = Traitormod.SelectedGamemode.End()

    local eventMessage = ""

    for key, value in pairs(Traitormod.SelectedRandomEvents) do
        eventMessage = eventMessage .. "\"" .. value.Name .. "\" "
    end

    if #Traitormod.SelectedRandomEvents == 0 then
        eventMessage = "None"
    end

    endMessage = 
    string.format(Traitormod.Language.Gamemode, Traitormod.SelectedGamemode.Name) .. "\n" ..
    string.format(Traitormod.Language.RandomEvents, eventMessage) ..
    "\n\n" .. endMessage

    Game.Log(endMessage, ServerLogMessageType.ServerMessage)
    Traitormod.SendMessageEveryone(endMessage)
    Traitormod.LastRoundSummary = endMessage
    
    for key, event in pairs(Traitormod.SelectedRandomEvents) do
        event.End()
    end

    Traitormod.SelectedRandomEvents = {}

    Traitormod.SaveData()
end)

local pointsGiveTimer = 0

Hook.Add("think", "Traitormod.Think", function ()
    if Game.RoundStarted and Traitormod.SelectedGamemode then
        Traitormod.SelectedGamemode.Think()
    
        for key, event in pairs(Traitormod.SelectedRandomEvents) do
            event.Think()
        end
    end

    if Timer.GetTime() > pointsGiveTimer then
        for key, value in pairs(Traitormod.PointsToBeGiven) do
            if value > 200 then
                Traitormod.AddData(key, "Points", value)

                Traitormod.SendMessage(key, string.format(Traitormod.Language.PointsAwarded, math.floor(value)), true, "InfoFrameTabButton.Mission")

                Traitormod.PointsToBeGiven[key] = 0
            end
        end

        pointsGiveTimer = Timer.GetTime() + 500
    end
end)

Hook.Add("chatMessage", "Traitormod.ChatMessage", function (message, client)
    local split = Traitormod.ParseCommand(message)

    if #split == 0 then return end
    
    local command = table.remove(split, 1)

    if Traitormod.Commands[command] then
        return Traitormod.Commands[command].Callback(client, split)
    end
end)


dofile(Traitormod.Path .. "/Lua/commands.lua")
