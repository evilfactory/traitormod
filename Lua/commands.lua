----- USER COMMANDS -----
Traitormod.AddCommand("!help", function (client, args)
    Traitormod.SendMessage(client, Traitormod.Language.Help)

    return true
end)

Traitormod.AddCommand("!version", function (client, args)
    Traitormod.SendMessage(client, "Running Evil Factory's Traitor Mod v" .. Traitormod.VERSION)

    return true
end)

Traitormod.AddCommand("!traitor", function (client, args)
    if Game.ServerSettings.TraitorsEnabled == 0 then
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

Traitormod.AddCommand("!points", function (client, args)
    Traitormod.SendMessage(client, Traitormod.GetDataInfo(client, true))

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

Traitormod.AddCommand("!allpoints", function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end
    
    local messageToSend = ""

    for index, value in pairs(Client.ClientList) do
        messageToSend = messageToSend .. value.Name .. ": " .. math.floor(Traitormod.GetData(value, "Points") or 0) .. " Points - " .. math.floor(Traitormod.GetData(value, "Weight") or 0) .. " Weight"
    end

    Traitormod.SendMessage(client, messageToSend)

    return true
end)

Traitormod.AddCommand("!addpoint", function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end
    
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

    local found = nil

    for key, value in pairs(Client.ClientList) do
        if value.Name == name then
            found = value
        end
    end

    if found == nil then
        Traitormod.SendMessage(client, "Couldn't find a client with name " .. name)
        return true
    end

    Traitormod.AddData(found, "Points", amount)
    Traitormod.SendMessage(client, string.format("Gave %s points to %s.", amount, found.Name))

    return true
end)