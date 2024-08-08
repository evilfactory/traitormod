local category = {}
loadfile(Traitormod.Path .. "/Lua/pirateutils.lua")(Traitormod.Config)

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
