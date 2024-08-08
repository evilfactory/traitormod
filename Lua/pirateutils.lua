local PirateUtils = {}

function PirateUtils.GeneratePirate(position)
    local info = CharacterInfo(Identifier("human"))
    info.Name = "Pirate " .. info.Name
    info.Job = Job(JobPrefab.Get("warden"))

    local character = Character.Create(info, position, info.Name, 0, false, true)
    character.CanSpeak = true
    character.TeamID = CharacterTeamType.Team2
    character.GiveJobItems(nil)

    local idCard = character.Inventory.GetItemInLimbSlot(InvSlotType.Card)
    if idCard then
        idCard.NonPlayerTeamInteractable = true
        local prop = idCard.SerializableProperties[Identifier("NonPlayerTeamInteractable")]
        Networking.CreateEntityEvent(idCard, Item.ChangePropertyEventData(prop, idCard))
    end

    local headset = character.Inventory.GetItemInLimbSlot(InvSlotType.Headset)
    if headset then
        local wifi = headset.GetComponentString("WifiComponent")
        if wifi then
            wifi.TeamID = CharacterTeamType.Team1
        end
    end

    -- Drop unwanted items
    local itemsToDrop = {
        "captainspipe", "handcuffs", "coalitioncommendation", "revolver",
        "handheldterminal", "handheldstatusmonitor"
    }
    for _, itemId in ipairs(itemsToDrop) do
        local item = character.Inventory.FindItemByIdentifier(itemId, true)
        if item then
            item.Drop()
            Entity.Spawner.AddEntityToRemoveQueue(item)
        end
    end

    -- Add items to the pirate's inventory
    local itemsToAdd = {
        { id = "shotgun", count = 1, subItems = { { id = "shotgunshell", count = 6 } } },
        { id = "smg", count = 1, subItems = { { id = "smgmagazinedepletedfuel", count = 1 } } },
        { id = "smgmagazine", count = 2 },
        { id = "oxygenitetank", count = 1 },
        { id = "combatstimulantsyringe", count = 1 },
        { id = "tourniquet", count = 1 },
        { id = "shotgunshell", count = 12 },
        { id = "antibiotics", count = 4 },
        { id = "scp_armykit", count = 1, subItems = {
            { id = "antibleeding1", count = 6 },
            { id = "antibloodloss2", count = 4 },
            { id = "fuelrod", count = 1 },
            { id = "underwaterscooter", count = 1, subItems = { { id = "batterycell", count = 1 } } },
            { id = "plasmacutter", count = 1, subItems = { { id = "oxygenitetank", count = 1 } } }
        }},
        { id = "handheldsonar", count = 1, subItems = { { id = "batterycell", count = 1 } } },
        { id = "pirateclothes", count = 1 },
        { id = "scp_renegadedivingsuit", count = 1, subItems = { { id = "oxygenitetank", count = 1 } } }
    }

    for _, itemData in ipairs(itemsToAdd) do
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab(itemData.id), character.Inventory, nil, nil, function(item)
            if itemData.subItems then
                for _, subItemData in ipairs(itemData.subItems) do
                    for i = 1, subItemData.count do
                        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab(subItemData.id), item.OwnInventory)
                    end
                end
            end
        end)
    end

    -- Remove old clothes and add new ones
    local oldClothes = character.Inventory.GetItemInLimbSlot(InvSlotType.InnerClothes)
    if oldClothes then
        oldClothes.Drop()
        Entity.Spawner.AddEntityToRemoveQueue(oldClothes)
    end

    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("pirateclothes"), character.Inventory, nil, nil, function(item)
        character.Inventory.TryPutItem(item, character.Inventory.FindLimbSlot(InvSlotType.InnerClothes), true, false, character)
    end)

    return character
end

return PirateUtils