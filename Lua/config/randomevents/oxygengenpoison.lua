local event = {}

event.Enabled = true
event.Name = "OxygenGeneratorPoison"
event.MinRoundTime = 15
event.MinIntensity = 0
event.MaxIntensity = 0.05
event.ChancePerMinute = 0.001
event.OnlyOncePerRound = true

event.Start = function ()
    local text = Traitormod.Language.OxygenPoison
    Traitormod.RoundEvents.SendEventMessage(text, "GameModeIcon.pvp", Color.Red)

    local poison = AfflictionPrefab.Prefabs["sufforinpoisoning"]
    local function GivePoison(character)
        if character.Submarine ~= Submarine.MainSub then return end
        if character.IsDead then return end
        if character.IsProtectedFromPressure then return end
        local headGear = character.Inventory.GetItemInLimbSlot(InvSlotType.Head)
        if headGear ~= nil and headGear.Prefab.Identifier == "divingmask" then return end
        if headGear ~= nil and headGear.Prefab.Identifier == "clowndivingmask" then return end

        character.CharacterHealth.ApplyAffliction(character.AnimController.MainLimb, poison.Instantiate(20))
    end


    Timer.Wait(function ()
        for key, value in pairs(Character.CharacterList) do
            GivePoison(value)
        end
    end, 20000)

    Timer.Wait(event.End, 30000)
end


event.End = function (isEndRound)
    if not isEndRound then
        local text = Traitormod.Language.OxygenSafe

        Traitormod.RoundEvents.SendEventMessage(text, "GameModeIcon.multiplayercampaign")
    end
end

return event