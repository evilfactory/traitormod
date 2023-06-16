local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "CookMeth"
objective.AmountPoints = 400
objective.Progress = 0

function objective:Start(target)
    self.Text = "Cook ("..objective.Progress.."/2) meth on a stove"

    Hook.Add("item.created", "ChefCookingMethObjective", function (item)
        if item.Prefab.Identifier == "meth" then
            objective.Progress = objective.Progress + 1
            self.Text = "Cook ("..objective.Progress.."/2) meth on a stove"
        end
    end)

    return true
end

function objective:IsCompleted()
    if objective.Progress > 1 then
        Hook.Remove("item.created", "ChefCookingMethObjective")
        return true
    end

    return false
end

return objective