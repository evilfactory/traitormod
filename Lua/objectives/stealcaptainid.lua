local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "StealCaptainID"
objective.RoleFilter = {["captain"] = true}
objective.AmountPoints = 1300

function objective:Start(target)
    -- if no valid captain found, abort
    if not target then
        return false
    end

    self.Text = Traitormod.Language.ObjectiveStealCaptainID

    return true
end

function objective:IsCompleted()
    for item in self.Character.Inventory.AllItems do
        if item.Prefab.Identifier == "idcard" and item.GetComponentString("IdCard").OwnerJobId == "captain" then
            return true
        end
    end

    return false
end

return objective