local objective = {}

objective.Name = "Survive"
objective.EndRoundObjective = true

objective.Start = function (character)
    objective.Character = character

    objective.ObjectiveText = Traitormod.Language.ObjectiveSurvive
    

    return true
end

objective.IsCompleted = function ()
    return not objective.Character.IsDead
end

objective.GetListText = function (endround)
    if objective.CheckCompleted() and endround then
        return Traitormod.Language.Completed .. Traitormod.Language.ObjectiveSurvive
    else
        return Traitormod.Language.ObjectiveSurvive .. " (" .. string.format(Traitormod.Language.Points, objective.Config.AmountPoints) .. ")"
    end
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