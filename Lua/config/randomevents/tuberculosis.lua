local event = {}

event.Name = "tboutbreak"
event.MinRoundTime = 2
event.MinIntensity = 0
event.MaxIntensity = 0.1
event.ChancePerMinute = 0.025
event.OnlyOncePerRound = true

event.ColorsToRevert = {}

event.Start = function ()
    local infectedCount = math.random(1, 3)
    local infectedCharacters = {}
    local infectedCharacterNames = {}

    -- Create a list of eligible characters
    local eligibleCharacters = {}
    for _, character in ipairs(Character.CharacterList) do
        if not character.IsDead and character.TeamID == 1 then
            table.insert(eligibleCharacters, character)
        end
    end

    -- Adjust infectedCount if necessary
    if #eligibleCharacters < infectedCount then
        infectedCount = #eligibleCharacters
    end

    -- Select random characters to infect
    for i = 1, infectedCount do
        local randomIndex = math.random(#eligibleCharacters)
        local randomCharacter = table.remove(eligibleCharacters, randomIndex)
        infectedCharacters[randomCharacter] = true
        table.insert(infectedCharacterNames, randomCharacter.Name)
        
        local prefab = AfflictionPrefab.Prefabs["tb_Tuberculosis"]
        local resistance = randomCharacter.CharacterHealth.GetResistance(prefab)
        if resistance < 1 then
            local strength = 5 * randomCharacter.CharacterHealth.MaxVitality / 100 / (1 - resistance)
            local affliction = prefab.Instantiate(strength)
            randomCharacter.CharacterHealth.ApplyAffliction(randomCharacter.AnimController.GetLimb(LimbType.Torso), affliction, false)
        end
    end

    Timer.Wait(function ()
        local text = "Attention crew!\n\nOur sensors have detected the presence of Tuberculosis pathogens in the air. It appears that one or more individuals on the station have been infected. Please take immediate precautions:\n\n1. Wear protective masks.\n2. Avoid close contact with others.\n3. Report any symptoms to the medical team immediately.\n\nStay safe and follow all health protocols."
        Traitormod.RoundEvents.SendEventMessage(text, "EyeButton")
    end, 60000)
end


return event
