local re = {}

LuaUserData.RegisterType("Barotrauma.EventManager") -- temporary

re.RoundTime = 0
re.OnGoingEvents = {}

re.ThisRoundEvents = {}
re.EventConfigs = Traitormod.Config.RandomEventConfig

re.TriggerEvent = function (eventName)
    if re.OnGoingEvents[eventName] then
        Traitormod.Error("Event " .. eventName .. " is already running.")
        return
    end

    local event = nil
    for _, value in pairs(re.EventConfigs.Events) do
        if value.Enabled and value.Name == eventName then
            event = value
        end
    end

    if event == nil then
        Traitormod.Error("Tried to trigger event " .. eventName .. " but it doesnt exist or is disabled.")
        return
    end

    local originalEnd = event.End
    event.End = function ()
        re.OnGoingEvents[eventName] = nil
        originalEnd()
    end

    event.Start()
    re.OnGoingEvents[eventName] = event

    if re.ThisRoundEvents[eventName] == nil then
        re.ThisRoundEvents[eventName] = 0
    end
    re.ThisRoundEvents[eventName] = re.ThisRoundEvents[eventName] + 1

    Traitormod.Log("Event " .. eventName .. " triggered.")
end

re.CheckRandomEvent = function (event)
    if event.MinRoundTime ~= nil and re.RoundTime < event.MinRoundTime * 60 then
        return
    end

    if event.MaxRoundTime ~= nil and re.RoundTime > event.MaxRoundTime * 60 then
        return
    end

    local intensity = Game.GameSession.EventManager.CurrentIntensity

    if event.MinIntensity ~= nil and intensity < event.MinIntensity then
        return
    end

    if event.MaxIntensity ~= nil and intensity > event.MaxIntensity then
        return
    end

    if math.random() > event.ChancePerMinute then
        return
    end

    re.TriggerEvent(event.Name)
end

local lastRandomEventCheck = 0
Hook.Add("think", "TraitorMod.RoundEvents.Think", function ()
    if not Game.RoundStarted then return end

    re.RoundTime = re.RoundTime + 1/60

    if Timer.GetTime() > lastRandomEventCheck then
        for _, event in pairs(re.EventConfigs.Events) do
            if re.OnGoingEvents[event.Name] == nil and event.Enabled then
                if not event.OnlyOncePerRound or re.ThisRoundEvents[event.Name] == nil then
                    re.CheckRandomEvent(event)
                end
            end
        end
        lastRandomEventCheck = Timer.GetTime() + 60
    end
end)

Hook.Add("roundEnd", "TraitorMod.RoundEvents.RoundEnd", function ()
    for key, value in pairs(re.OnGoingEvents) do
        value.End()
        re.OnGoingEvents[key] = nil
    end

    re.ThisRoundEvents = {}

    RoundTime = 0
end)

return re