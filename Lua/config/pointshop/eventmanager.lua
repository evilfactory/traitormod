local category = {}

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
