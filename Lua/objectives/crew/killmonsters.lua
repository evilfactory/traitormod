local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "KillMonsters"
objective.AmountPoints = 400
objective.Monsters = {
    ["Crawler"] = {
        Text = "Crawlers",
        Amount = 20,
    },

    ["Hammerhead"] = {
        Text = "Hammerheads",
        Amount = 2,
    },

    ["Mudraptor"] = {
        Text = "Mudraptors",
        Amount = 2,
    },
}

function objective:Start(target)
    local types = {}
    for key, value in pairs(self.Monsters) do
        table.insert(types, key)
    end
    self.Type = types[math.random(1, #types)]

    self.Text = string.format("Kill %s %s.", self.Monsters[self.Type].Amount, self.Monsters[self.Type].Text)

    self.Progress = 0

    return true
end

function objective:CharacterDeath(character)
    if character.SpeciesName.Value == self.Type then
        if character.CauseOfDeath and character.CauseOfDeath.Killer == self.Character then
            self.Progress = self.Progress + 1
            self.Text = string.format("Kill (%s/%s) %s.", self.Progress, self.Monsters[self.Type].Amount, self.Monsters[self.Type].Text)
        end
    end
end

function objective:IsCompleted()
    if self.Progress >= self.Monsters[self.Type].Amount then
        return true
    end

    return false
end

return objective
