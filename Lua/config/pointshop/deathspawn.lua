local category = {}

category.Identifier = "deathspawn"
category.Decoration = "huskinvite"

category.CanAccess = function(client)
    return client.Character == nil or client.Character.IsDead or not client.Character.IsHuman
end

local function SpawnCreature(species, client, product, paidPrice, insideHuman)
    local spawnPositions = {}

    local subPosition = Submarine.MainSub.WorldPosition

    -- Generate random positions around the submarine within a radius of 1000-2000 units
    for i = 1, 10 do
        local angle = math.random() * 2 * math.pi
        local distance = math.random(2500, 5000)
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
        local distance = math.random(2500, 5000)
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

    Traitormod.GeneratePirate(spawnPosition,client,"pirate") -- GeneratePirate is a function from pirateutils.lua
    Traitormod.Pointshop.TrackRefund(client, product, paidPrice)
end

category.Products = {
    {
        Identifier = "spawn as pirate",
        Price = 4000,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 500,
            StartTime = 20,
            EndTime = 40,
        },
        Action = function (client, product, paidPrice)
            SpawnPirate(client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnascrawler",
        Price = 400,
        Limit = 5,
        IsLimitGlobal = true,
        PricePerLimit = 100,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 300,
            StartTime = 15,
            EndTime = 30,
        },

        Action = function (client, product, items, paidPrice)
            SpawnCreature("crawler", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnascrawlerhusk",
        Price = 500,
        Limit = 3,
        IsLimitGlobal = true,
        PricePerLimit = 100,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 300,
            StartTime = 15,
            EndTime = 30,
        },

        Action = function (client, product, items, paidPrice)
            SpawnCreature("Crawlerhusk", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnasmudraptor",
        Price = 1000,
        Limit = 3,
        IsLimitGlobal = true,
        PricePerLimit = 100,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 700,
            StartTime = 15,
            EndTime = 35,
        },

        Action = function (client, product, items, paidPrice)
            SpawnCreature("mudraptor", client, product, paidPrice)
        end
    },
    
    {
        Identifier = "spawnasveteranmudraptor",
        Price = 2750,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 300,
            StartTime = 15,
            EndTime = 30,
        },

        Action = function (client, product, items, paidPrice)
            SpawnCreature("mudraptor_veteran", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnastigerthresher",
        Price = 2500,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 300,
            StartTime = 15,
            EndTime = 30,
        },

        Action = function (client, product, items, paidPrice)
            SpawnCreature("tigerthresher", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnasmantis",
        Price = 1100,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 200,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 800,
            StartTime = 15,
            EndTime = 30,
        },

        Action = function (client, product, items, paidPrice)
            SpawnCreature("mantis", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnashusk",
        Price = 1600,
        Limit = 4,
        IsLimitGlobal = true,
        PricePerLimit = 400,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 1000,
            StartTime = 15,
            EndTime = 35,
        },

        Action = function (client, product, items, paidPrice)
            SpawnCreature("husk", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnashuskedhuman",
        Price = 2200,
        Limit = 3,
        IsLimitGlobal = true,
        PricePerLimit = 400,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 2100,
            StartTime = 15,
            EndTime = 35,
        },

        Action = function (client, product, items, paidPrice)
            SpawnCreature("Humanhusk", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnaspeanut",
        Price = 50,
        Limit = 2,
        IsLimitGlobal = false,

        Action = function (client, product, items, paidPrice)
            SpawnCreature("peanut", client, product, paidPrice, true)
        end
    },

    {
        Identifier = "spawnasorangeboy",
        Price = 50,
        Limit = 2,
        IsLimitGlobal = false,

        Action = function (client, product, items, paidPrice)
            SpawnCreature("orangeboy", client, product, paidPrice, true)
        end
    },

    {
        Identifier = "spawnascthulhu",
        Price = 50,
        Limit = 2,
        IsLimitGlobal = false,

        Action = function (client, product, items, paidPrice)
            SpawnCreature("balloon", client, product, paidPrice, true)
        end
    },

    {
        Identifier = "spawnaspsilotoad",
        Price = 50,
        Limit = 2,
        IsLimitGlobal = false,

        Action = function (client, product, items, paidPrice)
            SpawnCreature("psilotoad", client, product, paidPrice, true)
        end
    },
}

return category
