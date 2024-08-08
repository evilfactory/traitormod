local category = {}
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

category.Identifier = "eventmanager"
category.Decoration = "ManAndHisRaptor"

category.CanAccess = function(client)
    if client.HasPermission(ClientPermissions.ManageRound) then
        return true
    else
        return false
    end
end

local function SpawnCreature(species, client, product, paidPrice, insideHuman)
    local spawnPositions = {}
    local subPosition = Submarine.MainSub.WorldPosition

    -- Generate random positions around the submarine within a radius of 1000-2000 units
    for i = 1, 10 do
        local angle = math.random() * 2 * math.pi
        local distance = math.random(1000, 2000)
        local offsetX = math.cos(angle) * distance
        local offsetY = math.sin(angle) * distance
        local spawnPosition = Vector2(subPosition.X + offsetX, subPosition.Y + offsetY)
        table.insert(spawnPositions, spawnPosition)
    end

    local spawnPosition
    if #spawnPositions == 0 then
        -- no waypoints? https://c.tenor.com/RgExaLgYIScAAAAC/megamind-megamind-meme.gif
        spawnPosition = Submarine.MainSub.WorldPosition -- spawn it in the middle of the sub
        Traitormod.Log("Couldnt find any good waypoints, spawning in the middle of the sub.")
    else
        spawnPosition = spawnPositions[math.random(#spawnPositions)]
    end

    Entity.Spawner.AddCharacterToSpawnQueue(species, spawnPosition, function (character)
        client.SetClientCharacter(character)
        Traitormod.Pointshop.TrackRefund(client, product, paidPrice)
    end)
end

local function SpawnPirate(client, product, paidPrice)
    local submarine = Submarine.MainSub
    local subPosition = submarine.WorldPosition
    local spawnPositions = {}

    -- Generate random positions around the submarine within a radius of 1000-2000 units
    for i = 1, 10 do
        local angle = math.random() * 2 * math.pi
        local distance = math.random(1000, 2000)
        local offsetX = math.cos(angle) * distance
        local offsetY = math.sin(angle) * distance
        local spawnPosition = Vector2(subPosition.X + offsetX, subPosition.Y + offsetY)
        table.insert(spawnPositions, spawnPosition)
    end

    local spawnPosition
    if #spawnPositions == 0 then
        -- no waypoints? https://c.tenor.com/RgExaLgYIScAAAAC/megamind-megamind-meme.gif
        spawnPosition = subPosition -- spawn it in the middle of the sub
        Traitormod.Log("Couldn't find any good waypoints, spawning in the middle of the sub.")
    else
        spawnPosition = spawnPositions[math.random(#spawnPositions)]
    end

    local character = PirateUtils.GeneratePirate(spawnPosition)
    client.SetClientCharacter(character)
    Traitormod.Pointshop.TrackRefund(client, product, paidPrice)
end

category.Products = {
    {
        Identifier = "spawnaspirate",
        Price = 1000,
        Limit = 1,
        IsLimitGlobal = true,
        Action = function (client, product, paidPrice)
            SpawnPirate(client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnascrawler",
        Price = 0,
        Limit = 5,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Timeout = 0,

        Action = function (client, product, items, paidPrice)
            SpawnCreature("crawler", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnascrawlerhusk",
        Price = 0,
        Limit = 3,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Timeout = 0,

        Action = function (client, product, items, paidPrice)
            SpawnCreature("Crawlerhusk", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnasspineling",
        Price = 0,
        Limit = 3,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Timeout = 0,

        Action = function (client, product, items, paidPrice)
            SpawnCreature("spineling", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnasmudraptor",
        Price = 0,
        Limit = 3,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Timeout = 0,

        Action = function (client, product, items, paidPrice)
            SpawnCreature("mudraptor", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnasmantis",
        Price = 0,
        Limit = 4,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Timeout = 0,

        Action = function (client, product, items, paidPrice)
            SpawnCreature("mantis", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnashusk",
        Price = 0,
        Limit = 4,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Timeout = 0,

        Action = function (client, product, items, paidPrice)
            SpawnCreature("husk", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnashuskedhuman",
        Price = 0,
        Limit = 3,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Timeout = 60,

        Action = function (client, product, items, paidPrice)
            SpawnCreature("Humanhusk", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnasbonethresher",
        Price = 0,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Enabled = true,
        Timeout = 0,

        Action = function (client, product, items, paidPrice)
            SpawnCreature("Bonethresher", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnastigerthresher",
        Price = 0,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Enabled = true,
        Timeout = 0,

        Action = function (client, product, items, paidPrice)
            SpawnCreature("Tigerthresher", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnaslegacycarrier",
        Price = 0,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Enabled = true,
        Timeout = 60,

        Action = function (client, product, items, paidPrice)
            SpawnCreature("Carrier", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnashammerhead",
        Price = 0,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Enabled = true,
        Timeout = 0,

        Action = function (client, product, items, paidPrice)
            SpawnCreature("hammerhead", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnashammerheadmar",
        Price = 0,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Enabled = true,
        Timeout = 0,

        Action = function (client, product, items, paidPrice)
            SpawnCreature("hammerheadmatriarch", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnasfractalguardian",
        Price = 0,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Timeout = 0,

        Action = function (client, product, items, paidPrice)
            SpawnCreature("fractalguardian", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnasfractalguardian2",
        Price = 0,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Timeout = 0,

        Action = function (client, product, items, paidPrice)
            SpawnCreature("fractalguardian2", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnasfractalguardian3",
        Price = 0,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Timeout = 0,

        Action = function (client, product, items, paidPrice)
            SpawnCreature("fractalguardian3", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnasgiantspineling",
        Price = 0,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Enabled = true,
        Timeout = 0,

        Action = function (client, product, items, paidPrice)
            SpawnCreature("Spineling_giant", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnasveteranmudraptor",
        Price = 0,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Enabled = true,
        Timeout = 60,

        Action = function (client, product, items, paidPrice)
            SpawnCreature("Mudraptor_veteran", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnaslatcher",
        Price = 0,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Timeout = 0,

        Action = function (client, product, items, paidPrice)
            SpawnCreature("latcher", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnascharybdis",
        Price = 0,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Timeout = 0,

        Action = function (client, product, items, paidPrice)
            SpawnCreature("charybdis", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnasendworm",
        Price = 0,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Timeout = 60,

        Action = function (client, product, items, paidPrice)
            SpawnCreature("endworm", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnascyborgworm",
        Price = 0,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Timeout = 80,

        Action = function (client, product, items, paidPrice)
            SpawnCreature("cyborgworm", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnaspeanut",
        Price = 0,
        Limit = 2,
        IsLimitGlobal = false,

        Action = function (client, product, items, paidPrice)
            SpawnCreature("peanut", client, product, paidPrice, true)
        end
    },

    {
        Identifier = "spawnasorangeboy",
        Price = 0,
        Limit = 2,
        IsLimitGlobal = false,

        Action = function (client, product, items, paidPrice)
            SpawnCreature("orangeboy", client, product, paidPrice, true)
        end
    },

    {
        Identifier = "spawnascthulhu",
        Price = 0,
        Limit = 2,
        IsLimitGlobal = false,

        Action = function (client, product, items, paidPrice)
            SpawnCreature("balloon", client, product, paidPrice, true)
        end
    },

    {
        Identifier = "spawnaspsilotoad",
        Price = 0,
        Limit = 2,
        IsLimitGlobal = false,

        Action = function (client, product, items, paidPrice)
            SpawnCreature("psilotoad", client, product, paidPrice, true)
        end
    },
}

return category
