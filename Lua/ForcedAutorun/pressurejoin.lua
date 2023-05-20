if CLIENT then return end

   Hook.Add("character.created", "Traitormod.GivePressureResistance", function(character)
       if not character.IsHuman or character.IsBot then return end

       local pressurePrefab = AfflictionPrefab.Prefabs["pressurestabilized"]
       local limb = character.AnimController.MainLimb
       character.CharacterHealth.ApplyAffliction(limb, pressurePrefab.Instantiate(35))
   end)
