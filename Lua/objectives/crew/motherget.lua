local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "GetHonkMother"
objective.AmountPoints = 800

function objective:Start(target)
    -- if no valid captain found, abort
    if not target then
        return false
    end

    self.Text = "Obtain Mother's Providence and Countenance."

    return true
end

function objective:IsCompleted()
    if self.Character.Inventory.FindItemByIdentifier("clownmaskunique") and self.Character.Inventory.FindItemByIdentifier("clownsuitunique") then
        return true
    end

    return false
end

return objective