local event = {}

event.Enabled = true
event.Name = "AmmoDelivery"
event.MinRoundTime = 5
event.MinIntensity = 0.6
event.MaxIntensity = 1
event.ChancePerMinute = 0.03
event.OnlyOncePerRound = false

local items = {"coilgunammoboxexplosive", "coilgunammoboxexplosive", "coilgunammoboxexplosive", "railgunshell", "railgunshell", "railgunshell", "railgunshell", "railgunshell"}

event.Start = function ()
    local position = nil

    for key, value in pairs(Submarine.MainSub.GetWaypoints(true)) do
        if value.AssignedJob and value.AssignedJob.Identifier == "securityofficer" then
            position = value.WorldPosition
            break
        end
    end

    if position == nil then
        position = Submarine.MainSub.WorldPosition
    end

    for key, value in pairs(items) do
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab(value), position)
    end

    local text = "A delivery of explosive coilgun ammo and railgun shells has been made to the armoury area of the submarine."
    Traitormod.RoundEvents.SendEventMessage(text, "GameModeIcon.sandbox")

    event.End()
end


event.End = function ()

end

return event