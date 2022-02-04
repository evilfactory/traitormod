local event = {}

event.Name = "SuperBallastFlora"

local ballastFloraTimer = 0
local ballastFloraEndTimer = 0

event.Start = function ()
    ballastFloraTimer = Timer.GetTime() + event.Config.BallastFloraInitialDelay
    ballastFloraEndTimer = Timer.GetTime() + event.Config.BallastFloraInitialDelay + event.Config.BallastFloraEndDelay
end

event.Think = function ()
    if Timer.GetTime() > ballastFloraEndTimer then
        return
    end

    if Timer.GetTime() > ballastFloraTimer then

        local pumps = {}
        for key, value in pairs(Submarine.MainSub.GetItems(true)) do
            local pump = value.GetComponentString("Pump")
            if pump ~= nil then
                table.insert(pumps, pump)
            end
        end

        if #pumps > 0 then
            local pump = pumps[Random.Range(1, #pumps + 1)]
            
            pump.InfectBallast("ballastflora", true)
        end

        ballastFloraTimer = Timer.GetTime() + event.Config.BallastFloraDelay
    end
end

event.End = function ()
    
end

return event