local objective = {}

objective.Name = "PoisonCaptain"
objective.RoleFilter = {["captain"] = true}

objective.Start = function (character, target)
    objective.Character = character
    objective.Target = target

    if objective.Target == nil then
        return false
    end

    if not objective.Character.IsMedic then
        Traitormod.Debug("PoisonCaptain is only available for medics.")
        return false
    end

    objective.TargetName = Traitormod.GetJobString(objective.Target)

    objective.Poison = "Sufforin"

    objective.ObjectiveText = string.format(Traitormod.Language.ObjectivePoisonCaptain, objective.TargetName, objective.Poison)

    return true
end

objective.IsCompleted = function ()
    if objective.Target == nil then
        return
    end

    local aff = objective.Target.CharacterHealth.GetAffliction("sufforinpoisoning", true)

    if aff ~= nil and aff.Strength > 10 then
        return true
    end

    return false
end

return objective