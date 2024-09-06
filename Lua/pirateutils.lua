function Traitormod.GeneratePirate(position, client, loadoutType)
    local loadout = Traitormod.Loadouts[loadoutType]
    if not loadout then
        error("Invalid loadout type: " .. tostring(loadoutType))
    end
    local info = CharacterInfo(Identifier("human"))
    info.Name = "Pirate " .. info.Name
    info.Job = Job(JobPrefab.Get(loadout.job))
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
            wifi.TeamID = CharacterTeamType.Team2
        end
    end

    -- Drop unwanted items
    for _, itemId in ipairs(loadout.itemsToDrop) do
        local item = character.Inventory.FindItemByIdentifier(itemId, true)
        if item then
            item.Drop()
            Entity.Spawner.AddEntityToRemoveQueue(item)
        end
    end

    -- Add items to the pirate's inventory
    for _, itemData in ipairs(loadout.itemsToAdd) do
        for i = 1, itemData.count or 1 do
            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab(itemData.id), character.Inventory, nil, nil, function(item)
                if itemData.subItems then
                    for _, subItemData in ipairs(itemData.subItems) do
                        for j = 1, subItemData.count or 1 do
                            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab(subItemData.id), item.OwnInventory, nil, nil, function(subItem)
                                subItem.Condition = subItemData.condition or subItem.Condition
                            end)
                        end
                    end
                end
            end)
        end
    end
    Traitormod.RoleManager.AssignRole(character, Traitormod.RoleManager.Roles.Pirate:new())
    client.SetClientCharacter(character)
    return character
end

-- Define loadout configurations
Traitormod.Loadouts = {
    pirate = {
        job = "warden",
        itemsToDrop = {
            "captainspipe", "handcuffs", "coalitioncommendation", "revolver",
            "handheldterminal", "handheldstatusmonitor", "toolbelt"
        },
        itemsToAdd = {
            { id = "shotgun", count = 1, subItems = { { id = "shotgunshell", count = 6 } } },
            { id = "smg", count = 1, subItems = { { id = "smgmagazinedepletedfuel", count = 1 } } },
            { id = "plasmacutter", count = 1, subItems = { { id = "oxygenitetank", count = 1 } } },
            { id = "underwaterscooter", count = 1, subItems = { { id = "batterycell", count = 1 } } },
            { id = "shotgunshell", count = 12 },
            { id = "toolbelt", count = 1, subItems = {
                    { id = "antibleeding1", count = 6 },
                    { id = "antibloodloss2", count = 4 },
                    { id = "fuelrod", count = 1 },
                    { id = "smgmagazine", count = 2 },
                    { id = "combatstimulantsyringe", count = 1 },
                    { id = "tourniquet", count = 1 },
            }},
            { id = "handheldsonar", count = 1, subItems = { { id = "batterycell", count = 1 } } },
            { id = "pirateclothes", count = 1 },
            { id = "scp_renegadedivingsuit", count = 1, subItems = { { id = "oxygenitetank", count = 1 } } },
            { id = "crowbar", count = 1 } -- Add crowbar as a normal item
    },
    exosuitPirate = {
        job = "warden",
        itemsToDrop = {
            "captainspipe", "handcuffs", "coalitioncommendation", "revolver",
            "handheldterminal", "handheldstatusmonitor", "toolbelt"
        },
        itemsToAdd = {
            { id = "assault_rifle", count = 1, subItems = { { id = "assault_rifle_magazine", count = 1 } } },
            { id = "assault_rifle_magazine", count = 3 },
            { id = "exosuit", count = 1, subItems = { { id = "oxygenitetank", count = 1 } } },
            { id = "combatstimulantsyringe", count = 1 },
            { id = "tourniquet", count = 1 },
            { id = "antibiotics", count = 4 },
            { id = "toolbelt", count = 1, subItems = {
                { id = "antibleeding1", count = 6 },
                { id = "antibloodloss2", count = 4 },
                { id = "fuelrod", count = 1 },
                { id = "underwaterscooter", count = 1, subItems = { { id = "batterycell", count = 1 } } },
                { id = "plasmacutter", count = 1, subItems = { { id = "oxygenitetank", count = 1 } } }
            }},
            { id = "handheldsonar", count = 1, subItems = { { id = "batterycell", count = 1 } } }
        }
        }
    },
    albinoPirate = {
        job = "warden",
        itemsToDrop = {
            "captainspipe", "handcuffs", "coalitioncommendation", "revolver",
            "handheldterminal", "handheldstatusmonitor", "toolbelt"
        },
        itemsToAdd = {
            { id = "thggreatsword", count = 1 },
            { id = "frogssnubnosehandcannon", count = 1, subItems = {{ id = "thghandcannon+P+round", count = 6 }}},
            { id = "combatstimulantsyringe", count = 1 },
            { id = "thghandcannon+P+round", count = 6 },
            { id = "tourniquet", count = 1 },
            { id = "antibiotics", count = 4 },
            { id = "toolbelt", count = 1, subItems = {
                { id = "antibleeding1", count = 6 },
                { id = "antibloodloss2", count = 4 },
                { id = "fuelrod", count = 1 },
                { id = "underwaterscooter", count = 1, subItems = { { id = "batterycell", count = 1 } } },
                { id = "plasmacutter", count = 1, subItems = { { id = "oxygenitetank", count = 1 } } }
            }},
            { id = "handheldsonar", count = 1, subItems = { { id = "batterycell", count = 1 } } }
        }
    }
}