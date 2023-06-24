local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "HealCharacters"
objective.AmountPoints = 350
objective.Amount = 150

function objective:Start(target)
    self.Progress = 0

    self.Text = string.format(Traitormod.Language.ObjectiveHealCharacters, math.floor(self.Progress), self.Amount, self.MinCondition)

    return true
end

function objective:CharacterHealed(character, healer, amount)
    if healer ~= self.Character then return end
    
    self.Progress = self.Progress + amount
    self.Text = string.format(Traitormod.Language.ObjectiveHealCharacters, math.floor(self.Progress), self.Amount, self.MinCondition)
end

function objective:IsCompleted()
    if self.Progress >= self.Amount then
        return true
    end

    return false
end

return objective
