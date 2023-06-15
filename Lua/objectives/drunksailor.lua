local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "DrunkSailor"
objective.AmountPoints = 500

function objective:Start(target)
    self.Target = target

    if self.Target == nil then
        return false
    end

    self.TargetName = Traitormod.GetJobString(self.Target)

    self.Text = string.format(Traitormod.Language.ObjectiveDrunkSailor, self.TargetName)

    return true
end

function objective:IsCompleted()
    if self.Target == nil then
        return
    end

    local aff = self.Target.CharacterHealth.GetAffliction("drunk", true)

    if aff ~= nil and aff.Strength > 80 then
        return true
    end

    return false
end

return objective
