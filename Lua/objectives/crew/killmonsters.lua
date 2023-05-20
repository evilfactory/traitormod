local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "KillMonsters"
objective.AmountPoints = 400
objective.Monster = {
    Identifiers = {"Crawler"},
    Text = "Crawlers",
    Amount = 20,
}

function objective:Start(target)
    self.Progress = 0
    self.Text = string.format(Traitormod.Language.ObjectiveKillMonsters, self.Progress, self.Monster.Amount, self.Monster.Text)

    return true
end

function objective:CharacterDeath(character)
    local anyMatched = false
    for key, value in pairs(self.Monster.Identifiers) do
        if character.SpeciesName.Value == value then
            anyMatched = true
        end
    end

    if anyMatched then
        if character.CauseOfDeath and character.CauseOfDeath.Killer == self.Character then
            self.Progress = self.Progress + 1
            self.Text = string.format(Traitormod.Language.ObjectiveKillMonsters, self.Progress, self.Monster.Amount, self.Monster.Text)
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
