local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "Survive"
objective.EndRoundObjective = true
objective.AlwaysActive = true
objective.AmountPoints = 500
objective.AmountLives = 1


function objective:Start(character)
    self.Character = character

    self.ObjectiveText = Traitormod.Language.ObjectiveSurvive

    return true
end

function objective:IsCompleted()
    return not self.Character.IsDead

    --local traitor = assassination.Traitors[objective.Character]
    --return traitor.Kills > 0 and traitor.Deaths == 0
end

return objective