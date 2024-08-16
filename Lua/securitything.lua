local timers = {}
local livePrisoners = 0
local totalPrisoners = 0

function Traitormod.TimerFunction(interval, callback)
    local timer = {
        interval = interval,
        callback = callback,
        elapsed = 0
    }
    table.insert(timers, timer)
end

Hook.Add("think", "TimerFunction.Think", function ()
    for _, timer in ipairs(timers) do
        timer.elapsed = timer.elapsed + (1 / 60)
        if timer.elapsed >= timer.interval then
            timer.callback()
            timer.elapsed = 0
        end
    end
end)

Traitormod.TimerFunction(300, function()
    livePrisoners = 0 -- Reset the count
    totalPrisoners = 0
    for _, prisoner in pairs(Client.ClientList) do
        if prisoner.Character.HasJob("convict") then
            totalPrisoners = totalPrisoners + 1
            if CheckPrisonerObjective(prisoner.Character) then
                livePrisoners = livePrisoners + 1
            end
        end
    end

    for _, client in pairs(Client.ClientList) do
        if client.Character.HasJob("guard") or client.Character.HasJob("headguard") or client.Character.HasJob("warden") then
            Traitormod.AwardPoints(client, livePrisoners * 100, livePrisoners .. " out of " .. totalPrisoners .. " prisoners were live.") -- Award points based on the count of live prisoners
        end
    end
end)

function CheckPrisonerObjective(character)
    local role = Traitormod.RoleManager.GetRole(character)
    if role == nil then return false end

    local completedEscape = role:CompletedObjectives("Escape") > 0
    local isDead = character.IsDead

    return completedEscape or not isDead
end