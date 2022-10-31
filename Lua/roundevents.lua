local re = {}

LuaUserData.RegisterType("Barotrauma.EventManager") -- temporary

re.OnGoingEvents = {}

re.ThisRoundEvents = {}
re.EventConfigs = Traitormod.Config.RandomEventConfig

re.IsEventActive = function (eventName)
    if re.OnGoingEvents[eventName] then
        return true
    end
    return false
end

re.TriggerEvent = function (eventName)
    if not Game.RoundStarted then
        Traitormod.Error("Tried to trigger event " .. eventName .. ", but round is not started.")
        return
    end

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
    event.End = function (isRoundEnd)
        re.OnGoingEvents[eventName] = nil
        originalEnd(isRoundEnd)
    end

    Traitormod.Stats.AddStat("EventTriggered", event.Name, 1)

    re.OnGoingEvents[eventName] = event
    Timer.Wait(event.Start, 0)

    if re.ThisRoundEvents[eventName] == nil then
        re.ThisRoundEvents[eventName] = 0
    end
    re.ThisRoundEvents[eventName] = re.ThisRoundEvents[eventName] + 1

    Traitormod.Log("Event " .. eventName .. " triggered.")
end

re.CheckRandomEvent = function (event)
    if event.MinRoundTime ~= nil and Traitormod.RoundTime / 60 < event.MinRoundTime then
        return
    end

    if event.MaxRoundTime ~= nil and Traitormod.RoundTime / 60 > event.MaxRoundTime then
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

    Traitormod.Log("Selected random event to trigger \"" .. event.Name .. "\" with intensity " .. intensity .. " and round time " .. Traitormod.RoundTime / 60 .. " minutes.")

    re.TriggerEvent(event.Name)
end

re.SendEventMessage = function (text, icon)
    for key, value in pairs(Client.ClientList) do
        local messageChat = ChatMessage.Create("", text, ChatMessageType.Default, nil, nil)
        messageChat.Color = Color(200, 30, 241, 255)
        Game.SendDirectChatMessage(messageChat, value)

        local messageBox = ChatMessage.Create("", text, ChatMessageType.ServerMessageBoxInGame, nil, nil)
        messageBox.IconStyle = icon
        Game.SendDirectChatMessage(messageBox, value)
    end 
end

local lastRandomEventCheck = 0
Hook.Add("think", "TraitorMod.RoundEvents.Think", function ()
    if not re.EventConfigs.Enabled then return end
    if not Game.RoundStarted then return end

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
        value.End(true)
        re.OnGoingEvents[key] = nil
    end

    re.ThisRoundEvents = {}
end)

for _, value in pairs(re.EventConfigs.Events) do
    if value.Init then value.Init() end
end

return re