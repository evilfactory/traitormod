local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "Repair"
objective.AmountPoints = 400
objective.Amount = 5
objective.ItemIdentifier = {"junctionbox"}
objective.ItemText = "Junction Boxes"

function objective:Start(target)
    self.Progress = 0

    self.Text = string.format(Traitormod.Language.ObjectiveRepair, self.Progress, self.Amount, self.ItemText)

    return true
end

function objective:StopRepairing(item, character)
    local anyItemMatched = false
    for key, value in pairs(self.ItemIdentifier) do
        if value == item.Prefab.Identifier then
            anyItemMatched = true
        end
    end
    if not anyItemMatched then return end

    if character == self.Character and item.ConditionPercentage > 80 then
        self.Progress = self.Progress + 1
        self.Text = string.format(Traitormod.Language.ObjectiveRepair, self.Progress, self.Amount, self.ItemText)
    end
end

function objective:IsCompleted()
    if self.Progress >= self.Amount then
        return true
    end

    return false
end

return objective
