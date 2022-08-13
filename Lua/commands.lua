----- USER COMMANDS -----
Traitormod.AddCommand("!help", function (client, args)
    Traitormod.SendMessage(client, Traitormod.Language.Help)

    return true
end)

Traitormod.AddCommand("!helpadmin", function (client, args)
    Traitormod.SendMessage(client, Traitormod.Language.HelpAdmin)

    return true
end)

Traitormod.AddCommand("!helptraitor", function (client, args)
    Traitormod.SendMessage(client, Traitormod.Language.HelpTraitor)

    return true
end)

Traitormod.AddCommand("!version", function (client, args)
    Traitormod.SendMessage(client, "Running Evil Factory's Traitor Mod v" .. Traitormod.VERSION)

    return true
end)

Traitormod.AddCommand("!traitor", function (client, args)
    if Traitormod.Config.OptionalTraitors and Traitormod.GetData(client, "NonTraitor") == true then
        Traitormod.SendMessage(client, Traitormod.Language.TraitorOff)
    elseif Game.ServerSettings.TraitorsEnabled == 0 then
        Traitormod.SendMessage(client, Traitormod.Language.NoTraitors)
    elseif Game.RoundStarted and Traitormod.SelectedGamemode and Traitormod.SelectedGamemode.GetTraitorObjectiveSummary then
        local summary = Traitormod.SelectedGamemode.GetTraitorObjectiveSummary(client.Character)
        Traitormod.SendMessage(client, summary)
    elseif Game.RoundStarted then
        Traitormod.SendMessage(client, Traitormod.Language.NoTraitor)
    else
        Traitormod.SendMessage(client, Traitormod.Language.RoundNotStarted)
    end

    return true
end)

Traitormod.AddCommand("!toggletraitor", function (client, args)
    local text = Traitormod.Language.CommandNotActive

    if Traitormod.Config.OptionalTraitors then
        local toggle = false
        if #args > 0 then
            toggle = string.lower(args[1]) == "on"
        else
            toggle = Traitormod.GetData(client, "NonTraitor") == true
        end
    
        if toggle then
            text = Traitormod.Language.TraitorOn
        else
            text = Traitormod.Language.TraitorOff
        end
        Traitormod.SetData(client, "NonTraitor", not toggle)
        Traitormod.SaveData() -- move this to player disconnect someday...
        
        Traitormod.Log(client.Name .. " can become traitor: " .. tostring(toggle))
    end

    Traitormod.SendMessage(client, text)

    return true
end)

Traitormod.AddCommand({"!point", "!points"}, function (client, args)
    Traitormod.SendMessage(client, Traitormod.GetDataInfo(client, true))

    return true
end)

Traitormod.AddCommand("!info", function (client, args)
    Traitormod.SendWelcome(client)
    
    return true
end)

Traitormod.AddCommand({"!suicide", "!kill", "!death"}, function (client, args)
    if client.Character == nil or client.Character.IsDead then
        Traitormod.SendMessage(client, "You are already dead!")
        return true
    end

    client.Character.Kill(CauseOfDeathType.Unknown)
end)

----- TRAITOR COMMANDS -----
Traitormod.AddCommand("!tc", function (client, args)
    local feedback = Traitormod.Language.CommandNotActive
    
    if not Traitormod.Config.TraitorBroadcast then
        feedback = Traitormod.Language.CommandNotActive
    elseif not client.InGame or not client.Character or not client.Character.IsTraitor then
        feedback = Traitormod.Language.NoTraitor
    elseif Traitormod.SelectedGamemode and Traitormod.SelectedGamemode.Traitors then
        if #args > 0 then
            local msg = ""
            for word in args do
                msg = msg .. " " .. word
            end

            for character, traitor in pairs(Traitormod.SelectedGamemode.Traitors) do
                local traitorClient = Traitormod.FindClientCharacter(character)
                if traitorClient then
                    Game.SendDirectChatMessage("", string.format(Traitormod.Language.TraitorBroadcast, client.Name, msg), nil, ChatMessageType.Error, traitorClient)
                end
            end
        
            return (not Traitormod.Config.TraitorBroadcastHearable)
        else
            feedback = "Usage: !tc [Message]"
        end
    end

    Game.SendDirectChatMessage("", feedback, nil, Traitormod.Config.ChatMessageType, client)

    return true
end)

Traitormod.AddCommand("!tdm", function (client, args)
    local feedback = ""
    if not Traitormod.Config.TraitorDm then
        feedback = Traitormod.Language.CommandNotActive
    elseif client.Character.IsTraitor then
        print(#args)
        if #args > 1 then
            local found = Traitormod.FindClient(table.remove(args, 1))
            local msg = ""
            for word in args do
                msg = msg .. " " .. word
            end
            if found then
                Traitormod.SendMessage(found, Traitormod.Language.TraitorDirectMessage .. msg)
                feedback = string.format("[To %s]: %s", found.Name, msg)
                return true
            else
                feedback = "Name not found."
            end
        else
            feedback = "Usage: !tdm [Name] [Message]"
        end
    else
        feedback = Traitormod.Language.NoTraitor
        Traitormod.SendMessage(client, Traitormod.Language.NoTraitor)
        return true
    end

    Game.SendDirectChatMessage("", feedback, nil, Traitormod.Config.ChatMessageType, client)
    return true
end)

----- ADMIN COMMANDS -----
Traitormod.AddCommand("!alive", function (client, args)
    if not (client.Character == nil or client.Character.IsDead) and not client.HasPermission(ClientPermissions.ConsoleCommands) then return end

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
end)

Traitormod.AddCommand("!roundinfo", function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end

    if Game.RoundStarted and Traitormod.SelectedGamemode and Traitormod.SelectedGamemode.GetRoundSummary then
        Traitormod.SendMessage(client, Traitormod.SelectedGamemode.GetRoundSummary())
    elseif Traitormod.LastRoundSummary ~= nil then
        Traitormod.SendMessage(client, Traitormod.LastRoundSummary)
    else
        Traitormod.SendMessage(client, Traitormod.Language.RoundNotStarted)
    end

    return true
end)

Traitormod.AddCommand({"!allpoint", "!allpoints"}, function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end
    
    local messageToSend = ""

    for index, value in pairs(Client.ClientList) do
        messageToSend = messageToSend .. "\n" .. value.Name .. ": " .. math.floor(Traitormod.GetData(value, "Points") or 0) .. " Points - " .. math.floor(Traitormod.GetData(value, "Weight") or 0) .. " Weight"
    end

    Traitormod.SendMessage(client, messageToSend)

    return true
end)

Traitormod.AddCommand({"!addpoint", "!addpoints"}, function (client, args)
    if not client.HasPermission(ClientPermissions.All) then
        Traitormod.SendMessage(client, "You do not have permissions to add points.")
        return
    end
    
    if #args < 2 then
        Traitormod.SendMessage(client, "Incorrect amount of arguments. usage: !addpoint \"Client Name\" 500")

        return true
    end

    local name = table.remove(args, 1)
    local amount = tonumber(table.remove(args, 1))

    if amount == nil or amount ~= amount then
        Traitormod.SendMessage(client, "Invalid number value.")
        return true
    end

    local found = Traitormod.FindClient(name)

    if found == nil then
        Traitormod.SendMessage(client, "Couldn't find a client with name / steamID " .. name)
        return true
    end

    Traitormod.AddData(found, "Points", amount)

    local msg = string.format("Gave %s points to %s.", amount, found.Name)
    Traitormod.SendMessage(client, msg)
    Traitormod.Log(client.Name .. " " .. msg)

    return true
end)

Traitormod.AddCommand({"!removepoint", "!removepoints"}, function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end

    if #args < 2 then
        Traitormod.SendMessage(client, "Incorrect amount of arguments. usage: !removepoint \"Client Name\" 500")

        return true
    end

    local name = table.remove(args, 1)
    local amount = tonumber(table.remove(args, 1))

    if amount == nil or amount ~= amount then
        Traitormod.SendMessage(client, "Invalid number value.")
        return true
    end

    local found = Traitormod.FindClient(name)

    if found == nil then
        Traitormod.SendMessage(client, "Couldn't find a client with name / steamID " .. name)
        return true
    end

    Traitormod.AddData(found, "Points", -amount)
    Traitormod.SendMessage(client, string.format("Removed %s points from %s.", amount, found.Name))

    return true
end)

Traitormod.AddCommand({"!addlife", "!addlive", "!addlifes", "!addlives"}, function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end

    if #args < 1 then
        Traitormod.SendMessage(client, "Incorrect amount of arguments. usage: !addlife \"Client Name\" 1")

        return true
    end

    local name = table.remove(args, 1)

    local amount = 1
    if #args > 1 then
        amount = tonumber(table.remove(args, 1))
    end

    if amount == nil or amount ~= amount then
        Traitormod.SendMessage(client, "Invalid number value.")
        return true
    end

    local gainLifeClients = {}
    if string.lower(name) == "all" then
        gainLifeClients = Client.ClientList
    else
        local found = Traitormod.FindClient(name)

        if found == nil then
            Traitormod.SendMessage(client, "Couldn't find a client with name / steamID " .. name)
            return true
        end
        table.insert(gainLifeClients, found)
    end

    for lifeClient in gainLifeClients do
        local lifeMsg, lifeIcon = Traitormod.AdjustLives(lifeClient, amount)

        Game.SendDirectChatMessage("", lifeClient.Name .. " got lives +"..amount, nil, Traitormod.Config.ChatMessageType, client)

        if lifeMsg then
            Traitormod.SendMessage(lifeClient, lifeMsg, lifeIcon)
        end
    end

    return true
end)

Traitormod.AddCommand("!revive", function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end

    local reviveClient = client
    local name = client.Name

    if #args > 0 then
        -- if client name is given, revive related character
        name = table.remove(args, 1)
        -- find character by client name
        for player in Client.ClientList do
            if player.Name == name or player.SteamID == name then
                reviveClient = player
            end
        end
    end

    if reviveClient.Character and reviveClient.Character.IsDead then
        reviveClient.Character.Revive()
        reviveClient.SetClientCharacter(reviveClient.Character);
        local lifeMsg, lifeIcon = Traitormod.AdjustLives(reviveClient, 1)

        if lifeMsg then
            Traitormod.SendMessage(reviveClient, lifeMsg, lifeIcon)
        end

        Game.SendDirectChatMessage("", "Character of " .. name .. " revived and given back 1 life.", nil, ChatMessageType.Error, client)

    elseif reviveClient.Character then
        Game.SendDirectChatMessage("", "Character of " .. name .. " is not dead.", nil, ChatMessageType.Error, client)
    else
        Game.SendDirectChatMessage("", "Character of " .. name .. " not found.", nil, ChatMessageType.Error, client)
    end

    return true
end)