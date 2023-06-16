local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "MakeDrugs"
objective.AmountPoints = 550
objective.Progress = 0

function objective:Start(target)
    self.Text = "Make ("..objective.Progress.."/5) medical items."

    Hook.Add("item.created", "MedicObjective", function (item)
        Timer.Wait(function ()
            if item.HasTag("medical") and not item.HasTag("notarget") then
                objective.Progress = objective.Progress + 1
                self.Text = "Make ("..objective.Progress.."/5) medical items."
            end
        end, 6000)
    end)

    return true
end

function objective:IsCompleted()
    if objective.Progress > 4 then
        Hook.Remove("item.created", "MedicObjective")
        return true
    end

    return false
end

return objective