local objective = {}

objective.Name = "StealCaptainID"

objective.Start = function (character)
    local captainFound = false

    for key, value in pairs(Character.CharacterList) do
        if value ~= nil and value.Info ~= nil then
            if value.Info.Job.Prefab.Identifier == "captain" then
                captainFound = true
            end
        end
    end

    if not captainFound then
        return false
    end

    objective.Character = character

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