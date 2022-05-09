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
    local traitor = assassination.Traitors[objective.Character]
    return traitor.Kills > 0 and traitor.Deaths == 0
end

return objective