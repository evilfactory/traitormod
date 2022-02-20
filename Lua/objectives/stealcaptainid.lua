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

    return true
end

objective.CheckCompleted = function ()
    for item in objective.Character.Inventory.AllItems do
        if item.Prefab.Identifier == "idcard" and string.find(item.Tags, "jobid:captain") then
            return true
        end
    end
end

objective.GetListText = function ()
    if objective.CheckCompleted() then
        return Traitormod.Language.Completed .. Traitormod.Language.ObjectiveStealCaptainID
    else
        return Traitormod.Language.ObjectiveStealCaptainID .. " (" .. string.format(Traitormod.Language.Points, objective.Config.AmountPoints) .. ")"
    end
end

objective.GetCompletedText = function ()
    return string.format(Traitormod.Language.ObjectiveCompleted, Traitormod.Language.ObjectiveStealCaptainID)
end

objective.Award = function (character)
    local client = Traitormod.FindClientCharacter(character)

    if client == nil then 
        print("Traitormod Error: Couldn't award " + character.Name)
    else
        Traitormod.AddData(client, "Points", objective.Config.AmountPoints)
    end

    objective.Awarded = true
end

return objective