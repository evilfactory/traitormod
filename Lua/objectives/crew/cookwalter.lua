local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "CookMeth"
objective.AmountPoints = 400
objective.Progress = 0

function objective:Start(target)
    self.Text = "Cook ("..objective.Progress.."/2) meth"

    Hook.Add("item.created", "ChefCookingMethObjective", function (item)
        if item.HasTag("chem") and Item.OwnInventory.Owner.Prefab.Identifier == "he-stove" then
            objective.Progress = objective.Progress + 1
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