local event = {}

event.Name = "RandomLights"
event.MinRoundTime = 15
event.MinIntensity = 0
event.MaxIntensity = 0.1
event.ChancePerMinute = 0.0005
event.OnlyOncePerRound = true

event.ColorsToRevert = {}

event.Start = function ()
    for k, v in pairs(Submarine.MainSub.GetItems(true)) do
        local c = v.GetComponentString('LightComponent')
        if c then
            Timer.Wait(function ()
                event.ColorsToRevert[v] = c.LightColor
                c.LightColor = Color(math.random(255), math.random(255), math.random(255), 255)
                local prop = c.SerializableProperties[Identifier("LightColor")]
                Networking.CreateEntityEvent(v, Item.ChangePropertyEventData(prop, c))    
            end, math.random(1000, 5000))
        end
    end

    Timer.Wait(function ()
        --local text = "All lights suddenly turn off, but power is still on? What's going on?"
        --Traitormod.RoundEvents.SendEventMessage(text, "EyeButton")     
    end, 6000)
end


event.End = function ()

end

return event