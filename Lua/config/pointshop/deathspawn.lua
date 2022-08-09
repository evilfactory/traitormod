local category = {}

category.Name = "Death Spawn"
category.IsTraitorOnly = false
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
        Price = 700,
        Limit = 4,
        IsLimitGlobal = true,
        PricePerLimit = 1000,

        Action = function (client, product, items)
            SpawnCreature("crawler", client)
        end
    },

    {
        Name = "Spawn as Mudraptor",
        Price = 2500,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 1500,

        Action = function (client, product, items)
            SpawnCreature("mudraptor", client)
        end
    },

    {
        Name = "Spawn as Husk",
        Price = 3000,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 2000,

        Action = function (client, product, items)
            SpawnCreature("husk", client)
        end
    },

    {
        Name = "Spawn as Fractal Guardian",
        Price = 2800,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 1600,

        Action = function (client, product, items)
            SpawnCreature("fractalguardian", client)
        end
    },

    {
        Name = "Spawn as Charybdis",
        Price = 250000,
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