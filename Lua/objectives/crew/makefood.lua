local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "Make4FoodItems"
objective.AmountPoints = 600
objective.Progress = 0

function objective:Start(target)
    self.Text = "Make ("..objective.Progress.."/4) food items."

    Hook.Add("item.created", "ChefCookingOilObjective", function (item)
        if item.HasTag("fooditem") then
            objective.Progress = objective.Progress + 1
            self.Text = "Cook ("..objective.Progress.."/2) meth on a stove"
        end
    end)

    return true
end

function objective:IsCompleted()
    if objective.Progress > 3 then
        Hook.Remove("item.created", "ChefCookingOilObjective")
        return true
    end

    return false
end

return objective