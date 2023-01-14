local n = 1
Hook.Add("think", "Traitormod.MiscGhostRoles", function (character)
    if not Traitormod.Config.GhostRoleConfig.Enabled then return end

    for key, character in pairs(Character.CharacterList) do
        if not Traitormod.GhostRoles.IsGhostRole(character) then
            if Traitormod.Config.GhostRoleConfig.MiscGhostRoles[character.SpeciesName.Value] then
                Traitormod.GhostRoles.Ask(character.Name .. " " .. n, function (client)
                    client.SetClientCharacter(character)
                end, character)
            end
        end
    end
end)