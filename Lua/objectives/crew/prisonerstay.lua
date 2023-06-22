local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "KeepPrisonersInside"
objective.AmountPoints = 400
objective.EndRoundObjective = true
objective.MinCount = 2

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
