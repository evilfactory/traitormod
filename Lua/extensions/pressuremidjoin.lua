local extension = {}

extension.Identifier = "pressuremidjoin"

extension.Init = function ()
    Hook.Add("character.created", "Traitormod.GivePressureResistance", function(character)
        local pressurePrefab = AfflictionPrefab.Prefabs["pressurestabilized"].Instantiate(30)
        local limb = character.AnimController.MainLimb
        character.CharacterHealth.ApplyAffliction(limb, pressurePrefab)
        if character.TeamID == CharacterTeamType.Team1 then
            Networking.CreateEntityEvent(character, Character.RemoveFromCrewEventData.__new(character.TeamID, {}))
        end
    end)
end

return extension