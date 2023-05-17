local category = {}

category.Name = "Death Spawn"
category.Decoration = "huskinvite"

category.CanAccess = function(client)
    return client.Character == nil or client.Character.IsDead or not client.Character.IsHuman
end

local function SpawnCreature(species, client, insideHuman)
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
    end)
end

category.Products = {
    {
        Name = "Spawn as Crawler",
        Price = 400,
        Limit = 4,
        IsLimitGlobal = true,
        PricePerLimit = 100,
        Timeout = 60,

        Action = function (client, product, items)
            SpawnCreature("crawler", client)
        end
    },
--[[
    {
        Name = "Spawn as Zombie Sprinter",
        Price = 750,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 750,
        Timeout = 60,

        Action = function (client, product, items)
            SpawnCreature("Humanzombiesprinter", client)
        end
    },
temporarily removed
    {
        Name = "Spawn as Zombie Staggerer",
        Price = 510,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 350,
        Timeout = 60,

        Action = function (client, product, items)
            SpawnCreature("Humanzombiestaggerernatural", client)
        end
    },
--]]
    
    {
        Name = "Spawn as Spineling",
        Price = 600,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 100,
        Timeout = 60,

        Action = function (client, product, items)
            SpawnCreature("spineling", client)
        end
    },

    {
        Name = "Spawn as Mudraptor",
        Price = 850,
        Limit = 3,
        IsLimitGlobal = true,
        PricePerLimit = 150,
        Timeout = 60,

        Action = function (client, product, items)
            SpawnCreature("mudraptor", client)
        end
    },

    {
        Name = "Spawn as Bombshark",
        Price = 1000,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 250,
        Timeout = 60,

        Action = function (client, product, items)
            SpawnCreature("bombshark", client)
        end
    },

    {
        Name = "Spawn as Nightraptor",
        Price = 935,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 350,
        Timeout = 60,

        Action = function (client, product, items)
            SpawnCreature("nightraptor", client)
        end
    },

    {
        Name = "Spawn as Mantis",
        Price = 980,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 200,
        Timeout = 60,

        Action = function (client, product, items)
            SpawnCreature("mantis", client)
        end
    },

    {
        Name = "Spawn as Husk",
        Price = 1150,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 400,
        Timeout = 60,

        Action = function (client, product, items)
            SpawnCreature("husk", client)
        end
    },

    {
        Name = "Spawn as Bone Thresher",
        Price = 1300,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 500,
        Enabled = true,
        Timeout = 60,

        Action = function (client, product, items)
            SpawnCreature("Bonethresher", client)
        end
    },

    {
        Name = "Spawn as Tiger Thresher",
        Price = 850,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 350,
        Enabled = true,
        Timeout = 60,

        Action = function (client, product, items)
            SpawnCreature("Tigerthresher", client)
        end
    },

    {
        Name = "Spawn as Legacy Moloch (Horrible)",
        Price = 2500,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 350,
        Enabled = true,
        Timeout = 60,

        Action = function (client, product, items)
            SpawnCreature("legacymoloch", client)
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

        Action = function (client, product, items)
            SpawnCreature("hammerhead", client)
        end
    },

    {
        Name = "Spawn as Fractal Squid",
        Price = 2500,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 900,
        Timeout = 60,

        Action = function (client, product, items)
            SpawnCreature("fractalsquid", client)
        end
    },

    {
        Name = "Spawn as Fractal Guardian",
        Price = 3900,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 1000,
        Timeout = 60,

        Action = function (client, product, items)
            SpawnCreature("fractalguardian", client)
        end
    },

    {
        Name = "Spawn as Giant Spineling",
        Price = 9500,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 1750,
        Enabled = true,
        Timeout = 60,

        Action = function (client, product, items)
            SpawnCreature("Spineling_giant", client)
        end
    },

    {
        Name = "Spawn as Veteran Mudraptor",
        Price = 7500,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 650,
        Enabled = true,
        Timeout = 60,

        Action = function (client, product, items)
            SpawnCreature("Mudraptor_veteran", client)
        end
    },

    {
        Name = "Spawn as Latcher",
        Price = 35000,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 50000,
        Timeout = 60,

        Action = function (client, product, items)
            SpawnCreature("latcher", client)
        end
    },

    {
        Name = "Spawn as Charybdis",
        Price = 50000,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 50000,
        Timeout = 60,

        Action = function (client, product, items)
            SpawnCreature("charybdis", client)
        end
    },

    {
        Name = "Spawn as Endworm",
        Price = 90000,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 20000,
        Timeout = 80,

        Action = function (client, product, items)
            SpawnCreature("endworm", client)
        end
    },

    {
        Name = "Spawn as Cyborg Worm",
        Price = 250000,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 60000000,
        Timeout = 80,

        Action = function (client, product, items)
            SpawnCreature("cyborgworm", client)
        end
    },
}

return category
