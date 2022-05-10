local assassination = Traitormod.SelectedGamemode

Traitormod.AddCommand("!traitoralive", function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end

    for character, traitor in pairs(assassination.Traitors) do
        if not character.IsDead then
            Traitormod.SendMessage(client, Traitormod.Language.TraitorsAlive)
            return true
        end
    end

    Traitormod.SendMessage(client, Traitormod.Language.AllTraitorsDead)
    return true
end)

Traitormod.AddCommand("!traitors", function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end
    
    local traitorsText = Traitormod.Language.TraitorsRound .. " "
    for character, traitor in pairs(assassination.Traitors) do
        traitorsText = traitorsText .. "\"" .. character.Name .. "\" "
    end

    Traitormod.SendMessage(client, traitorsText)
    return true
end)