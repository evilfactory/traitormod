local assassination = Traitormod.SelectedGamemode

Traitormod.AddCommand("!traitoralive", function (client, args)
    for character, traitor in pairs(assassination.Traitors) do
        if not character.IsDead then
            return Traitormod.Language.TraitorsAlive
        end
    end

    return Traitormod.Language.AllTraitorsDead
end)
