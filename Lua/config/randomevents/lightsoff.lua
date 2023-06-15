local event = {}

event.Name = "LightsOff"
event.MinRoundTime = 15
event.MinIntensity = 0
event.MaxIntensity = 0.1
event.ChancePerMinute = 0.0005
event.OnlyOncePerRound = true

event.Time = 3

event.ColorsToRevert = {}

event.Start = function ()
    for k, v in pairs(Submarine.MainSub.GetItems(true)) do
        local c = v.GetComponentString('LightComponent')
        if c and not v.Prefab.CanBeBought then
            Timer.Wait(function ()
                event.ColorsToRevert[v] = c.LightColor
                c.LightColor = Color(0, 0, 0, 128)
                local prop = c.SerializableProperties[Identifier("LightColor")]
                Networking.CreateEntityEvent(v, Item.ChangePropertyEventData(prop, c))    
            end, math.random(1000, 5000))
        end
    end

    Timer.Wait(function ()
        local text = Traitormod.Language.LightsOff
        Traitormod.RoundEvents.SendEventMessage(text, "EyeButton")     
    end, 6000)

    Timer.Wait(event.End, event.Time * 60000)
end


event.End = function ()
    for k, v in pairs(event.ColorsToRevert) do
        Timer.Wait(function ()
            local c = k.GetComponentString('LightComponent')
            c.LightColor = v
            local prop = c.SerializableProperties[Identifier("LightColor")]
            Networking.CreateEntityEvent(k, Item.ChangePropertyEventData(prop, c))
        end, math.random(1000, 5000))

        event.ColorsToRevert[k] = nil
    end
end

return event