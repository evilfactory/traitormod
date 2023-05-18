local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "Assassinate"
objective.AmountPoints = 500
function objective:Start(target)
    self.Target = target

    if self.Target == nil then return false end

    self.Text = string.format(Traitormod.Language.ObjectiveAssassinate, self.Target.Name)

    return true
end

function objective:IsCompleted()
    return self.Target.IsDead
end

return objective
