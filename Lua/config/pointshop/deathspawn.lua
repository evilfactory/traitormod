local category = {}

category.Name = "Death Spawn"
category.Decoration = "huskinvite"

category.CanAccess = function(client)
    return client.Character == nil or client.Character.IsDead or not client.Character.IsHuman
end

local function SpawnCreature(species, client, insideHuman)
    local waypoints = Submarine.MainSub.GetWaypoints(true)
    local spawnPositions = {}

    if insideHuman then
        for key, value in pairs(Character.CharacterList) do
            if value.IsHuman and not value.IsDead then
                table.insert(spawnPositions, value.WorldPosition)
            end
        end
    else
        for key, value in pairs(waypoints) do
            if value.CurrentHull == nil then
                table.insert(spawnPositions, value.WorldPosition)
            end
        end
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
    end)
end

category.Products = {
    {
        Name = "Spawn as Crawler",
        Price = 450,
        Limit = 4,
        IsLimitGlobal = true,
        PricePerLimit = 100,

        Action = function (client, product, items)
            SpawnCreature("crawler", client)
        end
    },

    {
        Name = "Spawn as Legacy Crawler",
        Price = 400,
        Limit = 4,
        IsLimitGlobal = true,
        PricePerLimit = 100,

        Action = function (client, product, items)
            SpawnCreature("legacycrawler", client)
        end
    },

    {
        Name = "Spawn as Crawler Baby",
        Price = 250,
        Limit = 5,
        IsLimitGlobal = true,
        PricePerLimit = 50,

        Action = function (client, product, items)
            SpawnCreature("crawler_hatchling", client)
        end
    },

    {
        Name = "Spawn as Mudraptor Baby",
        Price = 400,
        Limit = 5,
        IsLimitGlobal = true,
        PricePerLimit = 150,

        Action = function (client, product, items)
            SpawnCreature("mudraptor_hatchling", client)
        end
    },

    {
        Name = "Spawn as Thresher Baby",
        Price = 800,
        Limit = 5,
        IsLimitGlobal = true,
        PricePerLimit = 250,

        Action = function (client, product, items)
            SpawnCreature("tigerthresher_hatchling", client)
        end
    },

    {
        Name = "Spawn as Mudraptor",
        Price = 1800,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 300,

        Action = function (client, product, items)
            SpawnCreature("mudraptor", client)
        end
    },

    {
        Name = "Spawn as Husk",
        Price = 2500,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 400,

        Action = function (client, product, items)
            SpawnCreature("husk", client)
        end
    },

    {
        Name = "Spawn as Fractal Guardian",
        Price = 2900,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 300,

        Action = function (client, product, items)
            SpawnCreature("fractalguardian", client)
        end
    },

    {
        Name = "Spawn as Hammerhead",
        Price = 7500,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 1000,
        Enabled = true,

        Action = function (client, product, items)
            SpawnCreature("hammerhead", client)
        end
    },

    {
        Name = "Spawn as Veteran Mudraptor",
        Price = 10000,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 1000,
        Enabled = true,

        Action = function (client, product, items)
            SpawnCreature("Mudraptor_veteran", client)
        end
    },

    {
        Name = "Spawn as Charybdis",
        Price = 150000,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 50000,

        Action = function (client, product, items)
            SpawnCreature("charybdis", client)
        end
    },

    {
        Name = "Spawn as Peanut",
        Price = 50,
        Limit = 2,
        IsLimitGlobal = false,

        Action = function (client, product, items)
            SpawnCreature("peanut", client, true)
        end
    },

    {
        Name = "Spawn as Orange Boy",
        Price = 50,
        Limit = 2,
        IsLimitGlobal = false,

        Action = function (client, product, items)
            SpawnCreature("orangeboy", client, true)
        end
    },

    {
        Name = "Spawn as Cthulhu",
        Price = 50,
        Limit = 2,
        IsLimitGlobal = false,

        Action = function (client, product, items)
            SpawnCreature("balloon", client, true)
        end
    },

    {
        Name = "Spawn as Psilotoad",
        Price = 50,
        Limit = 2,
        IsLimitGlobal = false,

        Action = function (client, product, items)
            SpawnCreature("psilotoad", client, true)
        end
    },
}

return category