local objective = {}

objective.Name = "Assassinate"

objective.Start = function (character, toKill)
    objective.ToKill = toKill

    return true
end

objective.CheckCompleted = function ()
    return objective.ToKill.IsDead
end

objective.GetListText = function (endround)
    if objective.CheckCompleted() then
        return string.format(Traitormod.Language.Completed .. Traitormod.Language.ObjectiveAssassinate, objective.ToKill.Name)
    else
        return string.format(Traitormod.Language.ObjectiveAssassinate, objective.ToKill.Name) .. " (" .. string.format(Traitormod.Language.Points, objective.Config.AmountPoints) .. ")"
    end
end

objective.GetCompletedText = function ()
    return string.format(Traitormod.Language.ObjectiveAssassinateCompleted, objective.ToKill.Name) .. string.format(Traitormod.Language.PointsAwarded, objective.Config.AmountPoints)
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