local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "Assassinate"
objective.AmountPoints = 600

function objective:Start(character, target)
    self.Target = target

    if self.Target == nil then return false end

    self.ObjectiveText = string.format(Traitormod.Language.ObjectiveAssassinate, self.Target.Name)

    return true
end

function objective:IsCompleted()
    return self.Target.IsDead
end

return objective
