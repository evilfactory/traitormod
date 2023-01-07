local n = 1
Hook.Add("character.created", "Traitormod.MiscGhostRoles", function (character)
    if character.SpeciesName == "Mudraptor_pet" then
        Traitormod.GhostRoles.Ask("Mudraptor Pet " .. n, function (client)
            client.SetClientCharacter(character)
        end, character)
    end

    if character.SpeciesName == "Watcher" then
        Traitormod.GhostRoles.Ask("Watcher " .. n, function (client)
            client.SetClientCharacter(character)
        end, character)
    end
end)