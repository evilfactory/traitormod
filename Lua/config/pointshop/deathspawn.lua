local category = {}

category.Identifier = "deathspawn"
category.Decoration = "huskinvite"

category.CanAccess = function(client)
    return client.Character == nil or client.Character.IsDead or not client.Character.IsHuman
end

local function SpawnCreature(species, client, product, paidPrice, insideHuman)
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
        Traitormod.Pointshop.TrackRefund(client, product, paidPrice)
    end)
end

category.Products = {
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
        Identifier = "spawnaslegacycrawler",
        Price = 400,
        Limit = 4,
        IsLimitGlobal = true,
        PricePerLimit = 100,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 300,
            StartTime = 15,
            EndTime = 30,
        },

        Action = function (client, product, items, paidPrice)
            SpawnCreature("legacycrawler", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnaslegacyhusk",
        Price = 450,
        Limit = 5,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 300,
            StartTime = 15,
            EndTime = 30,
        },

        Action = function (client, product, items, paidPrice)
            SpawnCreature("legacyhusk", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnascrawlerbaby",
        Price = 250,
        Limit = 4,
        IsLimitGlobal = true,
        PricePerLimit = 10,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 100,
            StartTime = 15,
            EndTime = 30,
        },

        Action = function (client, product, items, paidPrice)
            SpawnCreature("crawler_hatchling", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnasmudraptorbaby",
        Price = 400,
        Limit = 5,
        IsLimitGlobal = true,
        PricePerLimit = 150,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 200,
            StartTime = 15,
            EndTime = 30,
        },

        Action = function (client, product, items, paidPrice)
            SpawnCreature("mudraptor_hatchling", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnasthresherbaby",
        Price = 700,
        Limit = 5,
        IsLimitGlobal = true,
        PricePerLimit = 250,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 400,
            StartTime = 15,
            EndTime = 30,
        },

        Action = function (client, product, items, paidPrice)
            SpawnCreature("tigerthresher_hatchling", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnasspineling",
        Price = 1000,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 250,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 700,
            StartTime = 15,
            EndTime = 30,
        },

        Action = function (client, product, items, paidPrice)
            SpawnCreature("spineling", client, product, paidPrice)
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
        Price = 3000,
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
        Identifier = "spawnasbonethresher",
        Price = 1800,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 500,
        Enabled = true,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 1000,
            StartTime = 15,
            EndTime = 35,
        },

        Action = function (client, product, items, paidPrice)
            SpawnCreature("Bonethresher", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnastigerthresher",
        Price = 2500,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 500,
        Enabled = true,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 1500,
            StartTime = 15,
            EndTime = 35,
        },

        Action = function (client, product, items, paidPrice)
            SpawnCreature("Tigerthresher", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnaslegacymoloch",
        Price = 2500,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 500,
        Enabled = true,
        Timeout = 60,

        Action = function (client, product, items, paidPrice)
            SpawnCreature("legacymoloch", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnaslegacycarrier",
        Price = 500,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 500,
        Enabled = true,
        Timeout = 60,

        Action = function (client, product, items, paidPrice)
            SpawnCreature("Carrier", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnashammerhead",
        Price = 2500,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 600,
        Enabled = true,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 1500,
            StartTime = 15,
            EndTime = 35,
        },

        Action = function (client, product, items, paidPrice)
            SpawnCreature("hammerhead", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnasfractalguardian",
        Price = 4900,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 1000,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 2500,
            StartTime = 15,
            EndTime = 40,
        },

        Action = function (client, product, items, paidPrice)
            SpawnCreature("fractalguardian", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnasgiantspineling",
        Price = 20000,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 1000,
        Enabled = true,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 19000,
            StartTime = 50,
            EndTime = 60,
        },

        Action = function (client, product, items, paidPrice)
            SpawnCreature("Spineling_giant", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnasveteranmudraptor",
        Price = 5000,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 1000,
        Enabled = true,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 3500,
            StartTime = 20,
            EndTime = 60,
        },

        Action = function (client, product, items, paidPrice)
            SpawnCreature("Mudraptor_veteran", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnaslatcher",
        Price = 50000,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 49000,
            StartTime = 50,
            EndTime = 60,
        },

        Action = function (client, product, items, paidPrice)
            SpawnCreature("latcher", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnascharybdis",
        Price = 80000,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 79000,
            StartTime = 50,
            EndTime = 60,
        },

        Action = function (client, product, items, paidPrice)
            SpawnCreature("charybdis", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnasendworm",
        Price = 100000,
        Limit = 1,
        IsLimitGlobal = true,
        PricePerLimit = 0,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 80000,
            StartTime = 50,
            EndTime = 60,
        },

        Action = function (client, product, items, paidPrice)
            SpawnCreature("endworm", client, product, paidPrice)
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