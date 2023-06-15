local extension = {}

extension.Identifier = "pressuremidjoin"

extension.Init = function ()
    Hook.Add("character.created", "Traitormod.GivePressureResistance", function(character)
        local pressurePrefab = AfflictionPrefab.Prefabs["pressurestabilized"]
        local limb = character.AnimController.MainLimb
        character.CharacterHealth.ApplyAffliction(limb, pressurePrefab.Instantiate(25))
    end)
end

return extension