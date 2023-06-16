local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "Escape"
objective.AmountPoints = 1500
objective.Amount = 5

function objective:Start(target)
    self.Text = "Escape."

    return true
end

function objective:IsCompleted()
    if Vector2.Distance(self.Character.WorldPosition, Submarine.MainSub.WorldPosition) > 10000 then
        return true
    end

    return false
end

return objective
