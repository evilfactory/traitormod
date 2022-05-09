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
