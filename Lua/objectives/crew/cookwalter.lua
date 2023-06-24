local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "CookMeth"
objective.AmountPoints = 400

function objective:Start(target)
    self.Text = "Cook (0/2) meth on a stove"
    self.Progress = 0

    Hook.Add("item.created", "ChefCookingMethObjective", function (item)
        Timer.Wait(function ()
            local parent = item.ParentInventory
            if parent == nil then return end
            if LuaUserData.IsTargetType(parent.Owner, "Barotrauma.Character") then return end
            if parent.Owner.Prefab.Identifier == "medicalfabricator" then return end
                
            if item.Prefab.Identifier == "meth" then
                self.Progress = self.Progress + 1
                self.Text = "Cook ("..self.Progress.."/2) meth on a stove"
            end
        end, 750)
    end)

    return true
end

function objective:IsCompleted()
    if self.Progress > 1 then
        Hook.Remove("item.created", "ChefCookingMethObjective")
        self.Progress = 2
        self.Text = "Cook (2/2) meth on a stove"
        return true
    end

    return false
end

return objective
