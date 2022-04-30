local assassination = Traitormod.SelectedGamemode
local objective = {}

objective.Name = "Survive"
objective.EndRoundObjective = true

objective.Start = function (character)
    objective.Character = character

    objective.ObjectiveText = Traitormod.Language.ObjectiveSurvive
    

    return true
end

objective.IsCompleted = function ()
    return assassination.Traitors[objective.Character].Deaths == 0
end

return objective