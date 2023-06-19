local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "Kidnap"
objective.AmountPoints = 2500

function objective:Start(target)
    self.Target = target

    if self.Target == nil then
        return false
    end

    self.TargetName = Traitormod.GetJobString(target) .. " " .. target.Name

    self.Text = string.format(Traitormod.Language.ObjectiveKidnap, self.TargetName,
    self.Seconds)

    self.SecondsLeft = self.Seconds

    return true
end

function objective:IsCompleted()
    if self.SecondsLeft <= 0 then
        self.Text = string.format(Traitormod.Language.ObjectiveKidnap, self.TargetName,
        self.Seconds)

        return true
    end

    local char = self.Target

    if char == nil or char.IsDead then return false end

    local item = char.Inventory.GetItemInLimbSlot(InvSlotType.RightHand)

    if item ~= nil and item.Prefab.Identifier == "handcuffs" then
        if self.lastTimer == nil then
            self.lastTimer = Timer.GetTime()
        end

        self.SecondsLeft = math.max(0, self.SecondsLeft - (Timer.GetTime() - self.lastTimer))

        self.Text = string.format(Traitormod.Language.ObjectiveKidnap, self.TargetName, math.floor(self.SecondsLeft))

        self.lastTimer = Timer.GetTime()

    else
        self.lastTimer = Timer.GetTime()
    end

    return false
end

return objective
