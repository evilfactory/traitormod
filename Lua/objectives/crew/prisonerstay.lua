local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "KeepPrisonersInside"
objective.AmountPoints = 400
objective.EndRoundObjective = true

function objective:Start(target)
    self.Text = Traitormod.Language.ObjectivePrisoner

    return true
end

function objective:IsCompleted()
    local count = Traitormod.CountAliveConvictsInsideMainSub()

    if count > 3 then
        return true
    end

    return false
end

return objective
