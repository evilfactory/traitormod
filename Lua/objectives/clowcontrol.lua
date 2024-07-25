local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "ClownControl"
objective.AmountPoints = 1600
objective.RoleFilter = {
    ["he-chef"] = true,
    ["staff"] = true,
    ["janitor"] = true,
    ["prisondoctor"] = true,
    ["guard"] = true,
    ["warden"] = true,
    ["headguard"] = true,
}

function objective:Start()

    self.Text = string.format(Traitormod.Language.ObjectiveClownControl)

    return true
end

function objective:IsCompleted()
    local count = 0

    for i, character in pairs(Character.CharacterList) do
        -- Check if character is alive
        if not character.IsDead then
            local headItem = character.Inventory.GetItemInLimbSlot(InvSlotType.Head)
            local innerClothesItem = character.Inventory.GetItemInLimbSlot(InvSlotType.InnerClothes)
            
            -- Ensure items are not nil and check if they match the clown costume and mask
            if headItem and innerClothesItem and headItem.Prefab.Identifier == "clownmask" and innerClothesItem.Prefab.Identifier == "clowncostume" then
                count = count + 1
            end
        end
        
        -- Return true if at least 4 characters meet the condition
        if count >= 4 then
            return true
        end
    end
    
    return false
end

return objective