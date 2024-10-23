local category = {}

category.Identifier = "deathspawn"
category.Decoration = "huskinvite"

category.CanAccess = function(client)
    return client.Character == nil or client.Character.IsDead or not client.Character.IsHuman
end

Hook.Add("roundStart", "originalsubpos", function()
    Traitormod.originalSubPosition = Submarine.MainSub.WorldPosition
end)

local function SpawnCreature(species, client, product, paidPrice, insideHuman)
    local spawnAbove = false
    local radius = 500     -- Define the radius around the spawn point
    local mainSubPosition = Submarine.MainSub.WorldPosition

    if Traitormod.originalSubPosition ~= nil and mainSubPosition ~= nil then

        local verticalMovement = 0
        if mainSubPosition and Traitormod.originalSubPosition then
            verticalMovement = mainSubPosition.Y - Traitormod.originalSubPosition.Y
        else
            print("Error: mainSubPosition or Traitormod.originalSubPosition is nil")
        end
        local threshold = 2000
        spawnAbove = verticalMovement > threshold
    end

    local distance = nil  -- Define the distance below the submarine
    if spawnAbove then
        distance = 1500
    else
        distance = -1500
    end

    local spawnCenter = Vector2(mainSubPosition.X, mainSubPosition.Y - distance)

    
    local spawnPositions = {}

    for i = 1, 10 do  -- Generate 10 possible spawn positions
        local angle = math.random() * math.pi * 2
        local r = math.sqrt(math.random()) * radius
        local x = spawnCenter.X + r * math.cos(angle)
        local y = spawnCenter.Y + r * math.sin(angle)
        table.insert(spawnPositions, Vector2(x, y))
    end

    local spawnPosition = spawnPositions[math.random(#spawnPositions)]

    Entity.Spawner.AddCharacterToSpawnQueue(species, spawnPosition, function (character)
        client.SetClientCharacter(character)
        Traitormod.Pointshop.TrackRefund(client, product, paidPrice)
    end)
end

local function SpawnPirate(client, product, paidPrice)
    local submarine = Submarine.MainSub
    local subPosition = submarine.WorldPosition
    local spawnPositions = {}
    local waypoints = Submarine.MainSub.GetWaypoints(true)

    if LuaUserData.IsTargetType(Game.GameSession.GameMode, "Barotrauma.PvPMode") then
        waypoints = Submarine.MainSubs[math.random(2)].GetWaypoints(true)
    end

    for key, value in pairs(waypoints) do
        if value.CurrentHull == nil then
            local walls = Level.Loaded.GetTooCloseCells(value.WorldPosition, 250)
            if #walls == 0 then
                table.insert(spawnPositions, value.WorldPosition)
            end
        end
    end

    local spawnPosition
    if #spawnPositions == 0 then
        spawnPosition = subPosition
        Traitormod.Log("Couldn't find any good waypoints, spawning in the middle of the sub.")
    else
        spawnPosition = spawnPositions[math.random(#spawnPositions)]
    end

    Traitormod.GeneratePirate(spawnPosition, client, "pirate")
    Traitormod.Pointshop.TrackRefund(client, product, paidPrice)
end

category.Products = {
    {
        Identifier = "spawn as pirate",
        Price = 4000,
        Limit = 3,
        IsLimitGlobal = true,
        PricePerLimit = 100,
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
