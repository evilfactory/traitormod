local event = {}

event.Name = "tboutbreak"
event.MinRoundTime = 2
event.MinIntensity = 0
event.MaxIntensity = 0.1
event.ChancePerMinute = 0.05
event.OnlyOncePerRound = true

event.ColorsToRevert = {}

event.Start = function ()
    local infectedCount = math.random(1, 3)
    local infectedCharacters = {}
    local infectedCharacterNames = {}

    for i = 1, infectedCount do
        local randomCharacter = Character.CharacterList[math.random(#Character.CharacterList)]
        while infectedCharacters[randomCharacter] or randomCharacter.IsDead or randomCharacter.TeamID ~= 1 do
            randomCharacter = Character.CharacterList[math.random(#Character.CharacterList)]
        end
        infectedCharacters[randomCharacter] = true
        table.insert(infectedCharacterNames, randomCharacter.Name)
        
        local prefab = AfflictionPrefab.Prefabs["tb_Tuberculosis"]
        local resistance = randomCharacter.CharacterHealth.GetResistance(prefab)
        if resistance < 1 then
            local strength = 5 * randomCharacter.CharacterHealth.MaxVitality / 100 / (1 - resistance)
            local affliction = prefab.Instantiate(strength)
            randomCharacter.CharacterHealth.ApplyAffliction(randomCharacter.AnimController.GetLimb(LimbType.Torso), affliction, false)
            print(string.format("Character %s has been infected with Tuberculosis.", randomCharacter.Name))
        else
            print(string.format("Character %s is resistant to Tuberculosis and was not infected.", randomCharacter.Name))
        end
    end

    Timer.Wait(function ()
        local text = "Attention crew!\n\nOur sensors have detected the presence of Tuberculosis pathogens in the air. It appears that one or more individuals on the station have been infected. Please take immediate precautions:\n\n1. Wear protective masks.\n2. Avoid close contact with others.\n3. Report any symptoms to the medical team immediately.\n\nStay safe and follow all health protocols."
        Traitormod.RoundEvents.SendEventMessage(text, "EyeButton")
        print(string.format("Tuberculosis outbreak event started. Number of characters infected: %d. Infected characters: %s", infectedCount, table.concat(infectedCharacterNames, ", ")))
    end, 60000)

end

return event
