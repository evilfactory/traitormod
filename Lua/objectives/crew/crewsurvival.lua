local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "CrewSurvival"
objective.AmountPoints = 650
objective.EndRoundObjective = true

function objective:Start(target)
    self.Text = Traitormod.Language.SecurityTeamSurvival

    return true
end

function objective:IsCompleted()
    for key, value in pairs(Character.CharacterList) do
        if value.HasJob("prisondoctr") or value.HasJob("janitor") or value.HasJob("staff") and not value.IsDead and value.TeamID == CharacterTeamType.Team1 then
            return true
        end
    end

    return false
end

return objective
