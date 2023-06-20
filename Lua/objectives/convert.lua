local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "ClownConvert"
objective.AmountPoints = 850
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

    self.Text = string.format(Traitormod.Language.ObjectiveConvert, self.Target.Name)

    return true
end

function objective:IsCompleted()
    if self.Target.IsDead and self.Target.Inventory.GetItemInLimbSlot(InvSlotType.Head).Prefab.Identifier == "clownmask" then
        return true
    end
    
    return false
end

return objective
