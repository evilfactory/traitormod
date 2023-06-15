local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "TurnHusk"
objective.AmountPoints = 500
objective.AmountLives = 1
objective.AlwaysActive = true
objective.DontLooseLives = true

function objective:Start()
    self.Text = Traitormod.Language.ObjectiveTurnHusk

    self.OldCharacter = self.Character

    return true
end

function objective:IsCompleted()
    if self.OldCharacter == nil then
        return
    end

    local aff = self.OldCharacter.CharacterHealth.GetAffliction("huskinfection", true)

    if aff ~= nil and aff.Strength > 95 then
        return true
    end

    return false
end

return objective
