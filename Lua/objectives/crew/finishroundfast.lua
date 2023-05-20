local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "FinishRoundFast"
objective.AmountPoints = 450
objective.EndRoundObjective = true

function objective:Start(target)
    self.Text = Traitormod.Language.ObjectiveFinishRoundFast

    return true
end

function objective:IsCompleted()
    if Traitormod.RoundTime < 60 * 20 then
        return false
    end

    if Traitormod.EndReached(self.Character, 5000) then
        return true
    end

    return false
end

return objective
