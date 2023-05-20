local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "GrowMudraptors"
objective.AmountPoints = 900
objective.Times = 3

objective.Static = function ()
    Hook.Add("character.created", "Traitormod.GrowMudraptor", function (character)
        Timer.NextFrame(function ()
            if character.SpeciesName == "Mudraptor_hatchling" and character.Submarine ~= nil then
                Traitormod.RoleManager.CallObjectiveFunction("GrowMudraptor")
            end
        end)
    end)
end

function objective:Start()
    self.Progress = 0

    self.Text = string.format(Traitormod.Language.ObjectiveGrowMudraptors, self.Progress, self.Times)

    return true
end

function objective:GrowMudraptor()
    self.Progress = self.Progress + 1
    self.Text = string.format(Traitormod.Language.ObjectiveGrowMudraptors, self.Progress, self.Times)
end

function objective:IsCompleted()
    return self.Progress >= self.Times
end

return objective
