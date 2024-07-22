local event = {}

event.Name = "tboutbreak"
event.MinRoundTime = 2
event.MinIntensity = 0
event.MaxIntensity = 1
event.ChancePerMinute = 0.05
event.OnlyOncePerRound = true

event.ColorsToRevert = {}

event.Start = function ()
    local infectedCount = math.random(1, 3)
    local infectedCharacters = {}

    for i = 1, infectedCount do
        local randomCharacter = Character.CharacterList[math.random(#Character.CharacterList)]
        while infectedCharacters[randomCharacter] do
            randomCharacter = Character.CharacterList[math.random(#Character.CharacterList)]
        end
        infectedCharacters[randomCharacter] = true

        local prefab = AfflictionPrefab.Prefabs["Tuberculosis"]
        local resistance = randomCharacter.CharacterHealth.GetResistance(prefab)
        if resistance < 1 then
            local strength = 5 * randomCharacter.CharacterHealth.MaxVitality / 100 / (1 - resistance)
            local affliction = prefab.Instantiate(strength)
            randomCharacter.CharacterHealth.ApplyAffliction(randomCharacter.AnimController.GetLimb(LimbType.Torso), affliction, false)
        end
    end

    Timer.Wait(function ()
        local text = Traitormod.Language.Tuber
        Traitormod.RoundEvents.SendEventMessage(text, "EyeButton")     
    end, 60000)
end

return event