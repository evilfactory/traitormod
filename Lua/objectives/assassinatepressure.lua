local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "AssassinatePressure"
objective.AmountPoints = 700
function objective:Start(target)
    self.Target = target

    if self.Target == nil then return false end

    self.Text = string.format(Traitormod.Language.ObjectiveAssassinatePressure, self.Target.Name)

    return true
end

function objective:IsCompleted()
    if not self.Target.IsDead then return false end

    local causeOfDeath = self.Target.CauseOfDeath

    if causeOfDeath == nil then return false end

    if causeOfDeath.Type == CauseOfDeathType.Affliction then
        return causeOfDeath.Affliction.Identifier == "pressure"
    end

    if causeOfDeath.Type == CauseOfDeathType.Pressure then
        return true
    end
end

function objective:IsFailed()
    if not self.Target.IsDead then return false end

    local causeOfDeath = self.Target.CauseOfDeath

    if causeOfDeath == nil then return false end

    local conditionsMet = false
    if causeOfDeath.Type == CauseOfDeathType.Affliction and causeOfDeath.Affliction.Identifier == "pressure" then
        conditionsMet = true
    end

    if causeOfDeath.Type == CauseOfDeathType.Pressure then
        conditionsMet = true
    end

    return not conditionsMet
end

return objective
