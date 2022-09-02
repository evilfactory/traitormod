local objective = {}

objective.Name = "Kidnap"

objective.Start = function (character, target)
    objective.Target = target

    if objective.Target == nil then
        return false
    end

    objective.TargetName = Traitormod.GetJobString(target) .. " " .. target.Name

    objective.ObjectiveText = string.format(Traitormod.Language.ObjectiveKidnap, objective.TargetName, objective.Config.Seconds)

    objective.SecondsLeft = objective.Config.Seconds

    return true
end

objective.IsCompleted = function ()
    if objective.SecondsLeft <= 0 then
        objective.ObjectiveText = string.format(Traitormod.Language.ObjectiveKidnap, objective.TargetName, objective.Config.Seconds)

        return true
    end

    local char = objective.Target

    if char == nil or char.IsDead then return false end

    local item = char.Inventory.GetItemInLimbSlot(InvSlotType.RightHand)

    if item ~= nil and item.Prefab.Identifier == "handcuffs" then
        if objective.lastTimer == nil then
            objective.lastTimer = Timer.GetTime()
        end
        
        objective.SecondsLeft = math.max(0, objective.SecondsLeft - (Timer.GetTime() - objective.lastTimer))

        objective.ObjectiveText = string.format(Traitormod.Language.ObjectiveKidnap, objective.TargetName, math.floor(objective.SecondsLeft))

        objective.lastTimer = Timer.GetTime()

    else
        objective.lastTimer = Timer.GetTime()
    end

    return false
end

return objective