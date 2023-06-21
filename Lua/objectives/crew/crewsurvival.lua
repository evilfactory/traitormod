local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "CrewSurvival"
objective.AmountPoints = 650
objective.EndRoundObjective = true
objective.Count = 0

function objective:Start(target)
    self.Text = Traitormod.Language.ObjectiveCrewSurvival

    return true
end

function objective:IsCompleted()
    for key, value in pairs(Character.CharacterList) do
        if value.HasJob("janitor") or value.HasJob("staff") and not value.IsDead and value.TeamID == CharacterTeamType.Team1 then
            objective.Count = objective.Count + 1

            if objective.Count > 2 then
                return true
            end
        end
    end

    return false
end

return objective
