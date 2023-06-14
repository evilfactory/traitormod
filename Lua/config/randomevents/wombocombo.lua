local event = {}

event.Name = "WomboCombo"
event.ChancePerMinute = 0
event.OnlyOncePerRound = true

event.Time = 1

event.FlickerAmount = 3 -- one cycle of On and Off

event.Lights = {} -- (key=item, value=originalLightComponentColor)

event.Start = function ()

    -- Applying afflications
    local function GiveWombo(character)
        if character.Submarine ~= Submarine.MainSub then return end
        if character.IsDead then return end

        local poison = AfflictionPrefab.Prefabs["deliriuminepoisoning"]
        character.CharacterHealth.ApplyAffliction(character.AnimController.MainLimb, poison.Instantiate(100))
        local psychosis = AfflictionPrefab.Prefabs["psychosis"]
        character.CharacterHealth.ApplyAffliction(character.AnimController.MainLimb, psychosis.Instantiate(100))
        local hallucination = AfflictionPrefab.Prefabs["hallucinating"]
        character.CharacterHealth.ApplyAffliction(character.AnimController.MainLimb, hallucination.Instantiate(100))
    end
    for key, value in pairs(Character.CharacterList) do
        GiveWombo(value)
    end


    -- Disabling comms
    if not Traitormod.RoundEvents.IsEventActive("CommunicationsOffline") then
        Traitormod.RoundEvents.TriggerEvent("CommunicationsOffline")
    end


    -- Finding all LightComponents and their original color
    for k, v in pairs(Submarine.MainSub.GetItems(true)) do
        local c = v.GetComponentString('LightComponent')
        if c and not v.Prefab.CanBeBought then
            event.Lights[v] = c.LightColor
        end
    end

    -- turn lights off and on depending on the current flickering state
    local function setlightscolor(color)
        for item, originalColor in pairs(event.Lights) do
            Timer.Wait(function ()
                local c = item.GetComponentString('LightComponent')
                -- if color is nil it will revert it back to the original color
                c.LightColor = color or originalColor 
                local prop = c.SerializableProperties[Identifier("LightColor")]
                Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(prop, c))
            end, math.random(0, 1000)) -- delay shouldnt be greater then Time/(FlickerAmount*2)
        end
    end

    -- flicker the lights
    for i = 0, event.FlickerAmount-1, 1 do
        Timer.Wait(
        function()
            setlightscolor(Color(0, 0, 0, 128))
    
            Timer.Wait(function()
                setlightscolor(nil)
            end, event.Time/event.FlickerAmount * 60000 / 2)
        end, i * event.Time/event.FlickerAmount * 60000)
    end

    -- end this event
    Timer.Wait(event.End, event.Time * 60000)
end


event.End = function ()
    for item, _ in pairs(event.Lights) do
        event.Lights[item] = nil
    end
end

return event