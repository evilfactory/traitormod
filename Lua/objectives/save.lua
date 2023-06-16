local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "SavePrisoner"
objective.RoleFilter = { ["convict"] = true }
objective.AmountPoints = 2100

function objective:Start(target)
    self.Target = target

    if self.Target == nil then
        return false
    end

    self.TargetName = Traitormod.GetJobString(self.Target)

    self.Text = "Save convict "..self.Target.Name.." from this filthy prison."

    return true
end

function objective:IsCompleted()
    if self.Target == nil then
        return false 
    end

    if Vector2.Distance(self.Target.WorldPosition, Submarine.MainSub.WorldPosition) > 9000 then
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
