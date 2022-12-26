local n = 1
Hook.Add("character.created", "Traitormod.MudraptorPet", function (character)
    if character.SpeciesName == "Mudraptor_pet" then
        Traitormod.GhostRoles.Ask("Mudraptor Pet " .. n, function (client)
            client.SetClientCharacter(character)
        end, character)
    end
end)