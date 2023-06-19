local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "Husk"
objective.AmountPoints = 800

function objective:Start(target)
    self.Target = target

    if self.Target == nil then
        return false
    end

    self.TargetName = Traitormod.GetJobString(self.Target) .. " " .. self.Target.Name

    self.Text = string.format(Traitormod.Language.ObjectiveHusk, self.TargetName)

    return true
end

function objective:IsCompleted()
    if self.Target == nil then
        return false
    end

    local aff = self.Target.CharacterHealth.GetAffliction("huskinfection", true)

    if aff ~= nil and aff.Strength > 80 then
        return true
    end

    return false
end

function objective:IsFailed()
    if self.Target == nil then
        return false
    end

    if self.Target.IsDead then
        return true
    end

    return false
end

function objective:TargetPreference(character)
    if character.IsCaptain then
        return false
    end

    return true
end

return objective
