local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "MakeDrugs"
objective.AmountPoints = 550

function objective:Start(target)
    self.Text = "Make (0/10) medical items."
    self.Progress = 0
    self.SpecialText = math.random(1, 500)

    Hook.Add("item.created", "MedicObjective"..self.SpecialText, function (item)
        Timer.Wait(function ()
            local parent = item.ParentInventory
            
            if parent == nil then return end
            if LuaUserData.IsTargetType(parent.Owner, "Barotrauma.Character") then return end
            if parent.Owner.Prefab.Identifier ~= "medicalfabricator" then return end

            if item.HasTag("medical") then
                self.Progress = self.Progress + 1
                self.Text = "Make ("..self.Progress.."/10) medical items."
             end
        end, 750)
    end)

    return true
end

function objective:IsCompleted()
    if self.Progress > 9 then
        Hook.Remove("item.created", "MedicObjective"..self.SpecialText)
        self.Progress = 10
        self.Text = "Make (10/10) medical items."
        return true
    end

    return false
end

return objective
