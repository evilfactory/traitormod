local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "Assassinate"
objective.AmountPoints = 500
objective.RoleFilter = { 
    ["he-chef"] = true,
    ["staff"] = true,
    ["janitor"] = true,
    ["prisondoctor"] = true,
    ["guard"] = true,
    ["warden"] = true,
    ["headguard"] = true,
}

function objective:Start(target)
    self.Target = target

    if self.Target == nil then return false end

    self.Text = string.format(Traitormod.Language.ObjectiveAssassinate, self.Target.Name)

    return true
end

function objective:IsCompleted()
    return self.Target.IsDead
end

function objective:TargetPreference(character)
    if character.HasJob("warden") or character.HasJob("headguard") then
        return false
    end

    return true
end

return objective
