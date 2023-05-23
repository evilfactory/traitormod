local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "AssassinateDrunk"
objective.AmountPoints = 900
function objective:Start(target)
    self.Target = target

    if self.Target == nil then return false end

    self.Text = string.format(Traitormod.Language.ObjectiveAssassinateDrunk, self.Target.Name)

    return true
end

function objective:IsCompleted()
    local aff = self.Character.CharacterHealth.GetAffliction("drunk", true)

    if aff ~= nil and aff.Strength >= 10 and self.Target.IsDead then
        return true
    end

    return false
end

function objective:IsFailed()
    local aff = self.Character.CharacterHealth.GetAffliction("drunk", true)

    if self.Target.IsDead then
        if aff == nil or aff.Strength < 10 then
            return true
        end
    end

    return false
end


return objective
