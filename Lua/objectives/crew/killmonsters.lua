local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "KillMonsters"
objective.AmountPoints = 400
objective.Monster = {
    Identifier = "Crawler",
    Text = "Crawlers",
    Amount = 20,
}

function objective:Start(target)
    self.Text = string.format("Kill %s %s.", self.Monster.Amount, self.Monster.Text)

    self.Progress = 0

    return true
end

function objective:CharacterDeath(character)
    if character.SpeciesName.Value == self.Monster.Identifier then
        if character.CauseOfDeath and character.CauseOfDeath.Killer == self.Character then
            self.Progress = self.Progress + 1
            self.Text = string.format("Kill (%s/%s) %s.", self.Progress, self.Monster.Amount, self.Monster.Text)
        end
    end
end

function objective:IsCompleted()
    if self.Progress >= self.Monster.Amount then
        return true
    end

    return false
end

return objective
