local event = {}

event.Name = "SuperBallastFlora"
event.MinRoundTime = 5
event.MinIntensity = 0
event.MaxIntensity = 0.3
event.ChancePerMinute = 0.015
event.OnlyOncePerRound = true

event.PumpsToInfect = 8

event.Start = function ()
    local pumps = {}
    for key, value in pairs(Submarine.MainSub.GetItems(true)) do
        local pump = value.GetComponentString("Pump")
        if pump ~= nil then
            table.insert(pumps, pump)
        end
    end

    for i = 1, event.PumpsToInfect, 1 do
        if #pumps > 0 then
            local index = math.random(#pumps)
            local pump = pumps[index]
            table.remove(pumps, index)

            pump.InfectBallast("ballastflora", true)
            pump.Item.CreateServerEvent(pump, pump)
        end
    end

    local text = "High concentration of ballast flora spores has been detected in this area, it's advised to search pumps for ballast flora!"
    Traitormod.RoundEvents.SendEventMessage(text, "EndRoundButton")

    event.End()
end


event.End = function ()

end

return event