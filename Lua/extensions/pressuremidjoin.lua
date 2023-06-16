local extension = {}

extension.Identifier = "pressuremidjoin"

extension.Init = function ()
    Hook.Add("character.created", "Traitormod.GivePressureResistance", function(character)
        local pressurePrefab = AfflictionPrefab.Prefabs["pressurestabilized"].Instantiate(30)
        local limb = character.AnimController.MainLimb
        character.CharacterHealth.ApplyAffliction(limb, pressurePrefab)
        Networking.CreateEntityEvent(character, Character.RemoveFromCrewEventData.__new(character.TeamID, {}))

        Timer.Wait(function ()
            Traitormod.RoleManager.AssignRole(character, Traitormod.RoleManager.Roles.Crew:new())
        end, 500)
    end)
end

return extension