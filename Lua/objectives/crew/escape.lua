local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "Escape"
objective.AmountPoints = 1500
objective.Amount = 5

function objective:Start(target)
    self.Text = "Escape."

    return true
end

function objective:IsCompleted()
    if self.Character.Submarine ~= Submarine.MainSub then
        return true
    end

    return false
end

return objective
