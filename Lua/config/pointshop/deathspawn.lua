local category = {}

category.Name = "Death Spawn"
category.Decoration = "huskinvite"

category.CanAccess = function(client)
    return client.Character == nil or client.Character.IsDead or not client.Character.IsHuman
end

local function SpawnCreature(species, client, product, insideHuman)
    local waypoints = Submarine.MainSub.GetWaypoints(true)

    if LuaUserData.IsTargetType(Game.GameSession.GameMode, "Barotrauma.PvPMode") then
        waypoints = Submarine.MainSubs[math.random(2)].GetWaypoints(true)
    end

    local spawnPositions = {}

    if insideHuman then
        for key, value in pairs(Character.CharacterList) do
            if value.IsHuman and not value.IsDead and value.TeamID == CharacterTeamType.Team1 then
                table.insert(spawnPositions, value.WorldPosition)
            end
        end
    else
        for key, value in pairs(waypoints) do
            if value.CurrentHull == nil then
                local walls = Level.Loaded.GetTooCloseCells(value.WorldPosition, 250)
                if #walls == 0 then
                    table.insert(spawnPositions, value.WorldPosition)
                end
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
        Traitormod.Pointshop.TrackRefund(client, product)
    end)
end

category.Products = {
    {
        Name = "Spawn as Crawler",
        Price = 400,
        Limit = 5,
        IsLimitGlobal = true,
        PricePerLimit = 100,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 300,
            StartTime = 15,
            EndTime = 60,
        },

        Action = function (client, product, items)
            SpawnCreature("crawler", client, product)
        end
    },

    {
        Name = "Spawn as Legacy Crawler",
        Price = 400,
        Limit = 4,
        IsLimitGlobal = true,
        PricePerLimit = 100,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 300,
            StartTime = 15,
            EndTime = 60,
        },

        Action = function (client, product, items)
            SpawnCreature("legacycrawler", client, product)
        end
    },

    {
        Name = "Spawn as Legacy Husk",
        Price = 450,
        Limit = 5,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 300,
            StartTime = 15,
            EndTime = 60,
        },

        Action = function (client, product, items)
            SpawnCreature("legacyhusk", client, product)
        end
    },

    {
        Name = "Spawn as Crawler Baby",
        Price = 250,
        Limit = 4,
        IsLimitGlobal = true,
        PricePerLimit = 10,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 100,
            StartTime = 15,
            EndTime = 60,
        },

        Action = function (client, product, items)
            SpawnCreature("crawler_hatchling", client, product)
        end
    },

    {
        Name = "Spawn as Mudraptor Baby",
        Price = 400,
        Limit = 5,
        IsLimitGlobal = true,
        PricePerLimit = 150,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 150,
            StartTime = 15,
            EndTime = 60,
        },

        Action = function (client, product, items)
            SpawnCreature("mudraptor_hatchling", client, product)
        end
    },

    {
        Name = "Spawn as Thresher Baby",
        Price = 700,
        Limit = 5,
        IsLimitGlobal = true,
        PricePerLimit = 250,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 200,
            StartTime = 15,
            EndTime = 60,
        },

        Action = function (client, product, items)
            SpawnCreature("tigerthresher_hatchling", client, product)
        end
    },

    {
        Name = "Spawn as Spineling",
        Price = 1000,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 250,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 300,
            StartTime = 15,
            EndTime = 60,
        },

        Action = function (client, product, items)
            SpawnCreature("spineling", client, product)
        end
    },

    {
        Name = "Spawn as Mudraptor",
        Price = 1000,
        Limit = 3,
        IsLimitGlobal = true,
        PricePerLimit = 100,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 300,
            StartTime = 15,
            EndTime = 60,
        },

        Action = function (client, product, items)
            SpawnCreature("mudraptor", client, product)
        end
    },

    {
        Name = "Spawn as Mantis",
        Price = 1100,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 200,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 300,
            StartTime = 15,
            EndTime = 60,
        },

        Action = function (client, product, items)
            SpawnCreature("mantis", client, product)
        end
    },

    {
        Name = "Spawn as Husk",
        Price = 1600,
        Limit = 4,
        IsLimitGlobal = true,
        PricePerLimit = 400,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 800,
            StartTime = 15,
            EndTime = 60,
        },

        Action = function (client, product, items)
            SpawnCreature("husk", client, product)
        end
    },

    {
        Name = "Spawn as Bone Thresher",
        Price = 1800,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 500,
        Enabled = true,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 800,
            StartTime = 15,
            EndTime = 60,
        },

        Action = function (client, product, items)
            SpawnCreature("Bonethresher", client, product)
        end
    },

    {
        Name = "Spawn as Tiger Thresher",
        Price = 2500,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 500,
        Enabled = true,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 1000,
            StartTime = 15,
            EndTime = 60,
        },

        Action = function (client, product, items)
            SpawnCreature("Tigerthresher", client, product)
        end
    },

    {
        Name = "Spawn as Legacy Moloch (Horrible)",
        Price = 2500,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 500,
        Enabled = true,
        Timeout = 60,

        Action = function (client, product, items)
            SpawnCreature("legacymoloch", client, product)
        end
    },

    {
        Name = "Spawn as Legacy Carrier (Horrible)",
        Price = 500,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 500,
        Enabled = true,
        Timeout = 60,

        Action = function (client, product, items)
            SpawnCreature("Carrier", client, product)
        end
    },

    {
        Name = "Spawn as Hammerhead",
        Price = 2500,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 1000,
        Enabled = true,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 1000,
            StartTime = 15,
            EndTime = 60,
        },

        Action = function (client, product, items)
            SpawnCreature("hammerhead", client, product)
        end
    },

    {
        Name = "Spawn as Fractal Guardian",
        Price = 4900,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 1000,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 1500,
            StartTime = 15,
            EndTime = 60,
        },

        Action = function (client, product, items)
            SpawnCreature("fractalguardian", client, product)
        end
    },

    {
        Name = "Spawn as Giant Spineling",
        Price = 20000,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 1000,
        Enabled = true,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 19000,
            StartTime = 60,
            EndTime = 70,
        },

        Action = function (client, product, items)
            SpawnCreature("Spineling_giant", client, product)
        end
    },

    {
        Name = "Spawn as Veteran Mudraptor",
        Price = 8000,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 1000,
        Enabled = true,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 4000,
            StartTime = 20,
            EndTime = 60,
        },

        Action = function (client, product, items)
            SpawnCreature("Mudraptor_veteran", client, product)
        end
    },

    {
        Name = "Spawn as Latcher",
        Price = 50000,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 50000,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 49000,
            StartTime = 60,
            EndTime = 70,
        },

        Action = function (client, product, items)
            SpawnCreature("latcher", client, product)
        end
    },

    {
        Name = "Spawn as Charybdis",
        Price = 80000,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 50000,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 79000,
            StartTime = 60,
            EndTime = 70,
        },

        Action = function (client, product, items)
            SpawnCreature("charybdis", client, product)
        end
    },

    {
        Name = "Spawn as Peanut",
        Price = 50,
        Limit = 2,
        IsLimitGlobal = false,

        Action = function (client, product, items)
            SpawnCreature("peanut", client, product, true)
        end
    },

    {
        Name = "Spawn as Orange Boy",
        Price = 50,
        Limit = 2,
        IsLimitGlobal = false,

        Action = function (client, product, items)
            SpawnCreature("orangeboy", client, product, true)
        end
    },

    {
        Name = "Spawn as Cthulhu",
        Price = 50,
        Limit = 2,
        IsLimitGlobal = false,

        Action = function (client, product, items)
            SpawnCreature("balloon", client, product, true)
        end
    },

    {
        Name = "Spawn as Psilotoad",
        Price = 50,
        Limit = 2,
        IsLimitGlobal = false,

        Action = function (client, product, items)
            SpawnCreature("psilotoad", client, product, true)
        end
    },
}

return category