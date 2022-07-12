local objective = {}

objective.Name = "StealCaptainID"
objective.RoleFilter = {["captain"] = true}

objective.Start = function (character, target)
    objective.Character = character

    -- if no valid captain found, abort
    if not target then
        return false
    end

    objective.ObjectiveText = Traitormod.Language.ObjectiveStealCaptainID

    return true
end

objective.IsCompleted = function ()
    for item in objective.Character.Inventory.AllItems do
        if item.Prefab.Identifier == "idcard" and item.GetComponentString("IdCard").OwnerJobId == "captain" then
            return true
        end
    end

    return false
end

return objective