local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "ReactorCultist"
objective.AmountPoints = 500
objective.EndRoundObjective = true

function objective:Start(target)
    self.Text = ""

    return true
end

function objective:IsCompleted()
    return false
end

return objective
