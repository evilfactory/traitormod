local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "SecurityTeamSurvival"
objective.AmountPoints = 400
objective.EndRoundObjective = true

function objective:Start(target)
    self.Text = Traitormod.Language.SecurityTeamSurvival

    return true
end

function objective:IsCompleted()
    for key, value in pairs(Character.CharacterList) do
        if value.IsSecurity and not value.IsDead and value.TeamID == CharacterTeamType.Team1 then
            return true
        end
    end

    return false
end

return objective
