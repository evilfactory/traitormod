local extension = {}

extension.Identifier = "BrokenHandcuffs"

extension.Init = function ()
    local timer = Timer.GetTime()
    Hook.Add("think", "BrokenHandcuffs.Think", function ()
        if timer > Timer.GetTime() then return end
        timer = Timer.GetTime() + 1

        for key, value in pairs(Character.CharacterList) do
            if value.IsHuman and value.IsKeyDown(InputType.Crouch) then
                local item = value.Inventory.GetItemInLimbSlot(InvSlotType.RightHand)

                if item and not item.Removed and item.Prefab.Identifier == "handcuffs" then
                    item.Condition = item.Condition - 0.85

                    if item.Condition <= 0 then
                        Entity.Spawner.AddEntityToRemoveQueue(item)
                    end
                end
            end
        end
    end)
end

return extension