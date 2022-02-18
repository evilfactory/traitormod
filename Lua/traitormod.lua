print("Traitor Mod by Evilfactory and Qunk.")

Game.OverrideTraitors(true)

Traitormod = {}
Traitormod.Config = dofile("Mods/traitormod/Lua/config.lua")
Traitormod.Languages = {
    dofile("Mods/traitormod/Lua/language/english.lua")
}

Traitormod.Language = Traitormod.Languages[1]

for key, value in pairs(Traitormod.Languages) do
    if Traitormod.Config.Language == value.Name then
        Traitormod.Language = value
    end
end

Traitormod.Gamemodes = {
    dofile("Mods/traitormod/Lua/gamemodes/assassination.lua")
}

Traitormod.EnabledGamemodes = {}
Traitormod.SelectedGamemode = dofile("Mods/traitormod/Lua/gamemodes/nogamemode.lua")

Traitormod.Objectives = {
    "Mods/traitormod/Lua/objectives/assassinate.lua",
    "Mods/traitormod/Lua/objectives/stealcaptainid.lua",
    "Mods/traitormod/Lua/objectives/survive.lua",
}

Traitormod.RandomEvents = {
    dofile("Mods/traitormod/Lua/randomevents/communicationsoffline.lua"),
    dofile("Mods/traitormod/Lua/randomevents/superballastflora.lua"),
}

Traitormod.EnabledRandomEvents = {}
Traitormod.SelectedRandomEvents = {}

local json = dofile("Mods/traitormod/Lua/json.lua")

if not File.Exists("Mods/traitormod/Lua/data.json") then
    File.Write("Mods/traitormod/Lua/data.json", "{}")
end

Traitormod.RoundNumber = 0

Traitormod.LoadData = function ()
    if Traitormod.Config.PermanentPoints then
        Traitormod.ClientData = json.decode(File.Read("Mods/traitormod/Lua/data.json")) or {}
    else
        Traitormod.ClientData = {}
    end
end

Traitormod.SaveData = function ()
    if Traitormod.Config.PermanentPoints then
        File.Write("Mods/traitormod/Lua/data.json", json.encode(Traitormod.ClientData))
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

Traitormod.SendMessage = function (client, text, popup, icon)
    if popup == true then
        Game.SendDirectChatMessage("", text, nil, 11, client, icon)
    else
        Game.SendDirectChatMessage("", text, nil, 7, client)
    end

    Game.SendDirectChatMessage("", text, nil, 1, client)
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

Traitormod.LoadData()


local weightedRandom = dofile("Mods/traitormod/Lua/weightedrandom.lua")

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

Hook.Add("think", "Traitormod.Think", function ()
    if Game.RoundStarted and Traitormod.SelectedGamemode then
        Traitormod.SelectedGamemode.Think()
    
        for key, event in pairs(Traitormod.SelectedRandomEvents) do
            event.Think()
        end
    end
end)

Hook.Add("chatMessage", "Traitormod.ChatMessage", function (message, client)
    if message == "!help" then
        Traitormod.SendMessage(client, Traitormod.Language.Help)

        return true
    end

    if message == "!traitor" then
        if Game.RoundStarted and Traitormod.SelectedGamemode then
            Traitormod.SelectedGamemode.ShowInfo(client.Character)
        else
            Traitormod.SendMessage(client, Traitormod.Language.RoundNotStarted)
        end

        return true
    end

    if message == "!points" then
        local maxPoints = 0
        for index, value in pairs(Client.ClientList) do
            maxPoints = maxPoints + (Traitormod.GetData(value, "Weight") or 0)
        end

        local percentage = (Traitormod.GetData(client, "Weight") or 0) / maxPoints * 100

        if percentage ~= percentage then
            percentage = 100 -- percentage is NaN, set it to 100%
        end

        Traitormod.SendMessage(client, string.format(Traitormod.Language.PointsInfo, Traitormod.GetData(client, "Points") or 0, Traitormod.GetData(client, "Lives") or Traitormod.Config.MaxLives, math.floor(percentage)))

        return true
    end

    if message == "!alive" and 
    ((client.Character == nil or client.Character.IsDead) or 
    client.HasPermission(ClientPermissions.ConsoleCommands)) then

        if not Game.RoundStarted or Traitormod.SelectedGamemode == nil then
            Traitormod.SendMessage(client, Traitormod.Language.RoundNotStarted)

            return true
        end

        local msg = ""
        for index, value in pairs(Character.CharacterList) do
            if value.IsHuman and not value.IsBot then
                if value.IsDead then
                    msg = msg .. value.Name .. " ---- " .. Traitormod.Language.Dead .. "\n"
                else
                    msg = msg .. value.Name .. " ++++ " .. Traitormod.Language.Alive .. "\n"
                end
            end
        end

        Traitormod.SendMessage(client, msg)

        return true
    end

    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end

    if message == "!roundinfo" then
        if Game.RoundStarted and Traitormod.SelectedGamemode then
            Traitormod.SelectedGamemode.ShowRoundInfo(client)
        elseif Traitormod.LastRoundSummary ~= nil then
            Traitormod.SendMessage(client, Traitormod.LastRoundSummary)
        else
            Traitormod.SendMessage(client, Traitormod.Language.RoundNotStarted)
        end

        return true
    end

    if message == "!traitoralive" then
        if Game.RoundStarted and Traitormod.SelectedGamemode then
            Traitormod.SendMessage(client, Traitormod.SelectedGamemode.TraitorAlive())
        else
            Traitormod.SendMessage(client, Traitormod.Language.RoundNotStarted)
        end

        return true
    end
    
end)
