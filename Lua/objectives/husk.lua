local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "Husk"
objective.AmountPoints = 800

function objective:Start(target)
    self.Target = target

    if self.Target == nil then
        return false
    end

    self.TargetName = Traitormod.GetJobString(self.Target) .. " " .. self.Target.Name

    self.Text = string.format("Turn %s into a full husk.", self.TargetName)

    return true
end

function objective:IsCompleted()
    if self.Target == nil then
        return
    end

    local aff = self.Target.CharacterHealth.GetAffliction("huskinfection", true)

    if aff ~= nil and aff.Strength > 95 then
        return true
    end

    return false
end

return objective
