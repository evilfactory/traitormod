local objective = {}

objective.Name = "StealCaptainID"

objective.Start = function (character)
    local captainFound = false

    for key, value in pairs(Client.ClientList) do
        if value.Character ~= nil and value.Character.Info ~= nil then
            if value.Character.Info.Job.Prefab.Identifier == "captain" then
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
        if item.Prefab.Identifier == "idcard" and string.find(item.Tags, "jobid:captain") then
            return true
        end
    end

    return false
end

return objective