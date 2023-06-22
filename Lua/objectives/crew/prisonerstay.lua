local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "KeepPrisonersInside"
objective.AmountPoints = 400
objective.EndRoundObjective = true
objective.MinCount = 6

if objective.MinCount > 3 then
    objective.MinCount = objective.MinCount - 3
end

function objective:Start(target)
    self.Text = string.format(Traitormod.Language.ObjectivePrisoner, objective.MinCount)
    return true
end

function objective:IsCompleted()
    local count = Traitormod.CountAliveConvictsInsideMainSub()

    if count >= objective.MinCount then
        return true
    end

    return false
end

return objective
