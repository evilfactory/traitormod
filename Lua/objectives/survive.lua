local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "Survive"
objective.Text = Traitormod.Language.ObjectiveSurvive
objective.EndRoundObjective = true
objective.AlwaysActive = true
objective.AmountPoints = 500
objective.AmountLives = 1


function objective:Start()
    return true
end

function objective:IsCompleted()
    local role = Traitormod.RoleManager.GetRole(self.Character)

    if role == nil then return false end

    local anyObjective = false
    for key, value in pairs(role.Objectives) do
        if value.Awarded then anyObjective = true end
    end

    return anyObjective and not self.Character.IsDead
end

return objective