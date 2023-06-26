local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "SuffocateCrew"
objective.AmountPoints = 900
function objective:Start(target)
    self.Target = target

    if self.Target == nil then return false end

    self.Text = string.format("Suffocate %s to death.", self.Target.Name)

    return true
end

function objective:IsCompleted()
    if self.Target == nil then
        return false
    end

    local aff = self.Target.CharacterHealth.GetAffliction("respiratoryarrest", true)

    if aff ~= nil and aff.Strength > 15 then
        return true
    end
end

function objective:IsFailed()
    if self.Target == nil then
        return false
    end

    if self.Target.IsDead then
        return true
    end

    return not conditionsMet
end

return objective
