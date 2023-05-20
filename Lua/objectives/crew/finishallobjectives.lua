local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "FinishAllObjectives"
objective.Text = Traitormod.Language.ObjectiveFinishAllObjectives
objective.EndRoundObjective = false
objective.AmountPoints = 0
objective.AmountLives = 1

function objective:Start()
    return true
end

function objective:IsCompleted()
    local role = Traitormod.RoleManager.GetRole(self.Character)

    if role == nil then return false end

    local objectivesAwarded = 0
    local objectivesMax = 0
    for key, value in pairs(role.Objectives) do
        if value.Awarded then objectivesAwarded = objectivesAwarded + 1 end

        objectivesMax = objectivesMax + 1
    end

    return objectivesAwarded >= objectivesMax - 1
end

return objective