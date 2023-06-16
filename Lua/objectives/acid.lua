local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "OnAcid"
objective.AmountPoints = 500

function objective:Start(target)
    self.Target = target

    if self.Target == nil then
        return false
    end

    self.TargetName = Traitormod.GetJobString(self.Target) .. " " .. self.Target.Name

    self.Text = string.format("Inject %s with deliriumine.", self.TargetName)

    return true
end

function objective:IsCompleted()
    if self.Target == nil then
        return false
    end

    local aff = self.Target.CharacterHealth.GetAffliction("deliriuminepoisoning", true)

    if aff ~= nil and aff.Strength > 50 then
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

return objective
