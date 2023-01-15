local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "PoisonCaptain"
objective.RoleFilter = { ["captain"] = true }
objective.AmountPoints = 1600

function objective:Start(target)
    self.Target = target

    if self.Target == nil then
        return false
    end

    if not self.Character.IsMedic then
        Traitormod.Debug("PoisonCaptain is only available for medics.")
        return false
    end

    self.TargetName = Traitormod.GetJobString(self.Target)

    self.Poison = "Sufforin"

    self.Text = string.format(Traitormod.Language.ObjectivePoisonCaptain, self.TargetName,
        self.Poison)

    return true
end

function objective:IsCompleted()
    if self.Target == nil then
        return
    end

    local aff = self.Target.CharacterHealth.GetAffliction("sufforinpoisoning", true)

    if aff ~= nil and aff.Strength > 10 then
        return true
    end

    return false
end

return objective
