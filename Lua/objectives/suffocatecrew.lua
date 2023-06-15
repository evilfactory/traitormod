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
    if not self.Target.IsDead then return false end

    local causeOfDeath = self.Target.CauseOfDeath

    if causeOfDeath == nil then return false end

    if causeOfDeath.Type == CauseOfDeathType.Affliction then
        return causeOfDeath.Affliction.Identifier == "oxygenlow"
    end

    if causeOfDeath.Type == CauseOfDeathType.Suffocation or causeOfDeath.Type == CauseOfDeathType.Drowning then
        return true
    end
end

function objective:IsFailed()
    if not self.Target.IsDead then return false end

    local causeOfDeath = self.Target.CauseOfDeath

    if causeOfDeath == nil then return false end

    local conditionsMet = false
    if causeOfDeath.Type == CauseOfDeathType.Affliction and causeOfDeath.Affliction.Identifier == "oxygenlow" then
        conditionsMet = true
    end

    if causeOfDeath.Type == CauseOfDeathType.Suffocation or causeOfDeath.Type == CauseOfDeathType.Drowning then
        conditionsMet = true
    end

    return not conditionsMet
end

return objective
