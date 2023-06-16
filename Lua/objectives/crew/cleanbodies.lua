local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "CleanBodies"
objective.AmountPoints = 500

function objective:Start(target)
    self.Target = target

    if self.Target == nil then return false end

    self.Text = string.format(Traitormod.Language.ObjectiveCleanBody, self.Target.Name)

    return true
end

function objective:IsCompleted()
    return self.Target.IsDead and self.Target.Submarine == nil
end

function objective:TargetPreference(character)
    if not character.HasJob("convict") then
        return false
    end

    return true
end

function objective:IsFailed()
    if self.Target == nil then
        return true
    end

    return false
end

return objective
