local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "Repair"
objective.AmountPoints = 400
objective.Amount = 5
objective.ItemIdentifier = "junctionbox"
objective.ItemText = "Junction Boxes"
objective.MinCondition = 20

function objective:Start(target)
    self.Progress = 0

    self.Text = string.format("Repair (%s/%s) %s that had their condition below %s", self.Progress, self.Amount, self.ItemText, self.MinCondition)

    return true
end

function objective:StopRepairing(item, character)
    if item.Prefab.Identifier == self.ItemIdentifier and character == self.Character then
        self.Progress = self.Progress + 1
        self.Text = string.format("Repair (%s/%s) %s that had their condition below %s%%", self.Progress, self.Amount, self.ItemText, self.MinCondition)
    end
end

function objective:IsCompleted()
    if self.Progress >= self.Amount then
        return true
    end

    return false
end

return objective
