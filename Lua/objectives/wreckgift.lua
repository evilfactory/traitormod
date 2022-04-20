local objective = {}

objective.Name = "WreckGift"

objective.Start = function (character)
    objective.Character = character

    objective.ObjectiveText = Traitormod.Language.ObjectiveSurvive
    

    return true
end

objective.IsCompleted = function ()
    return not objective.Character.IsDead
end

return objective