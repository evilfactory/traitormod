local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "Make4FoodItems"
objective.AmountPoints = 600

function objective:Start(target)
    self.Text = "Make (0/4) food items."
    self.Progress = 0

    Hook.Add("item.created", "ChefCookingOilObjective", function (item)
        Timer.Wait(function ()
            local parent = item.ParentInventory
            if parent == nil then return end
            if LuaUserData.IsTargetType(parent.Owner, "Barotrauma.Character") then return end
                
            if item.HasTag("fooditem") then
                self.Progress = self.Progress + 1
                self.Text = "Make ("..self.Progress.."/4) food items."
            end
        end, 750)
    end)

    return true
end

function objective:IsCompleted()
    if self.Progress > 3 then
        Hook.Remove("item.created", "ChefCookingOilObjective")
        self.Text = "Make (4/4) food items."
        return true
    end

    return false
end

return objective