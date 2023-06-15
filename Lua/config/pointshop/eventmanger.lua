local category = {}

category.Name = "Event Manger Spawn"
category.Decoration = "ManAndHisRaptor"

category.CanAccess = function(client)
    return client.HasPermission(ClientPermissions.ConsoleCommands)
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
        Price = 0,
        Limit = 5,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Timeout = 15,

        Action = function (client, product, items)
            SpawnCreature("crawler", client)
        end
    },

    {
        Name = "Spawn as Spineling",
        Price = 0,
        Limit = 5,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Timeout = 15,

        Action = function (client, product, items)
            SpawnCreature("spineling", client)
        end
    },

    {
        Name = "Spawn as Mudraptor",
        Price = 0,
        Limit = 3,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Timeout = 15,

        Action = function (client, product, items)
            SpawnCreature("mudraptor", client)
        end
    },

    {
        Name = "Spawn as Bombshark",
        Price = 0,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Timeout = 15,

        Action = function (client, product, items)
            SpawnCreature("bombshark", client)
        end
    },

    {
        Name = "Spawn as Nightraptor",
        Price = 0,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Timeout = 15,

        Action = function (client, product, items)
            SpawnCreature("nightraptor", client)
        end
    },

    {
        Name = "Spawn as Mantis",
        Price = 0,
        Limit = 5,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Timeout = 15,

        Action = function (client, product, items)
            SpawnCreature("mantis", client)
        end
    },

    {
        Name = "Spawn as Husk",
        Price = 0,
        Limit = 5,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Timeout = 15,

        Action = function (client, product, items)
            SpawnCreature("husk", client)
        end
    },

    {
        Name = "Spawn as Bone Thresher",
        Price = 0,
        Limit = 3,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Enabled = true,
        Timeout = 15,

        Action = function (client, product, items)
            SpawnCreature("Bonethresher", client)
        end
    },

    {
        Name = "Spawn as Tiger Thresher",
        Price = 0,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Enabled = true,
        Timeout = 15,

        Action = function (client, product, items)
            SpawnCreature("Tigerthresher", client)
        end
    },

    {
        Name = "Spawn as Hammerhead",
        Price = 0,
        Limit = 3,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Enabled = true,
        Timeout = 15,

        Action = function (client, product, items)
            SpawnCreature("hammerhead", client)
        end
    },

    {
        Name = "Spawn as Golden Hammerhead",
        Price = 0,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Enabled = true,
        Timeout = 15,

        Action = function (client, product, items)
            SpawnCreature("Hammerheadgold", client)
        end
    },

    {
        Name = "Spawn as Hammerhead Matriarch",
        Price = 0,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Enabled = true,
        Timeout = 15,

        Action = function (client, product, items)
            SpawnCreature("hammerheadmatriarch", client)
        end
    },

    {
        Name = "Spawn as Fractal Squid",
        Price = 0,
        Limit = 5,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Timeout = 15,

        Action = function (client, product, items)
            SpawnCreature("fractalsquid", client)
        end
    },

    {
        Name = "Spawn as Fractal Guardian",
        Price = 0,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Timeout = 85,

        Action = function (client, product, items)
            SpawnCreature("fractalguardian", client)
        end
    },

    {
        Name = "Spawn as Fractal Guardian (Steam Cannon)",
        Price = 0,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Timeout = 30,

        Action = function (client, product, items)
            SpawnCreature("fractalguardian2", client)
        end
    },

    {
        Name = "Spawn as Fractal Guardian (Plasma Cutter)",
        Price = 0,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Timeout = 120,

        Action = function (client, product, items)
            SpawnCreature("fractalguardian3", client)
        end
    },

    {
        Name = "Spawn as Giant Spineling",
        Price = 0,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Enabled = true,
        Timeout = 15,

        Action = function (client, product, items)
            SpawnCreature("Spineling_giant", client)
        end
    },

    {
        Name = "Spawn as Veteran Mudraptor",
        Price = 0,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Enabled = true,
        Timeout = 15,

        Action = function (client, product, items)
            SpawnCreature("Mudraptor_veteran", client)
        end
    },

    {
        Name = "Spawn as Latcher",
        Price = 0,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Timeout = 45,

        Action = function (client, product, items)
            SpawnCreature("latcher", client)
        end
    },

    {
        Name = "Spawn as Charybdis",
        Price = 0,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Timeout = 60,

        Action = function (client, product, items)
            SpawnCreature("charybdis", client)
        end
    },

    {
        Name = "Spawn as Endworm",
        Price = 0,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Timeout = 80,

        Action = function (client, product, items)
            SpawnCreature("endworm", client)
        end
    },

    {
        Name = "Spawn as Cyborg Worm",
        Price = 0,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Timeout = 80,

        Action = function (client, product, items)
            SpawnCreature("cyborgworm", client)
        end
    },
}

return category
