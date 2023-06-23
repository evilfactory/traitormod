local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "MakeDrugs"
objective.AmountPoints = 550

function objective:Start(target)
    self.Progress = 0
    self.Text = "Make ("..self.Progress.."/5) chemicals or opioids."

    Hook.Add("item.created", "MedicObjective", function (item)
        local parent = item.ParentInventory
            
        if parent == nil then return end
        if LuaUserData.IsTargetType(parent.Owner, "Barotrauma.Character") then return end
        if parent.Owner.Prefab.Identifier ~= "medicalfabricator" then return end
            
        if (item.Identifier == "antidama1"
             or item.Identifier == "antidama2"
             or item.Identifier == "combatstimulantsyringe"
             or item.Identifier == "opium"
             or item.Identifier == "steroids"
             or item.Identifier == "deusizine"
             or item.Identifier == "meth"
             or item.Identifier == "pomegrenadeextract"
             or item.Identifier == "tonicliquid"
             or item.Identifier == "pressurestabilizer")
         then
            self.Progress = self.Progress + 1
            self.Text = "Make ("..self.Progress.."/5) chemicals or opioids."
         end
    end)

    return true
end

function objective:IsCompleted()
    if self.Progress > 4 then
        Hook.Remove("item.created", "MedicObjective")
        self.Progress = 5
        self.Text = "Make (5/5) chemicals or opioids."
        return true
    end

    return false
end

return objective
