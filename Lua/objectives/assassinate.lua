local objective = {}

objective.Name = "Assassinate"

objective.Start = function (character, toKill)
    objective.ToKill = toKill

    objective.ObjectiveText = string.format(Traitormod.Language.ObjectiveAssassinate, objective.ToKill.Name)
    
    return true
end

objective.IsCompleted = function ()
    return objective.ToKill.IsDead
end

return objective