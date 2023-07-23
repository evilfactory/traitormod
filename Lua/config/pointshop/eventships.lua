local category = {}

category.Identifier = "eventships"
category.CanAccess = function(client)
    if client.HasPermission(ClientPermissions.ManageRound) then
        return true
    else
        return false
    end
end

category.Init = function ()
    if Traitormod.SubmarineBuilder then
        category.StreamChalkId = Traitormod.SubmarineBuilder.AddSubmarine(Traitormod.Path .. "/Submarines/Stream Chalk.sub", "[P]Stream Chalk")
        category.Separatist = Traitormod.SubmarineBuilder.AddSubmarine(Traitormod.Path .. "/Submarines/Separtist_Fighter.sub", "Separatist Fighter Ship")
        category.Unknown = Traitormod.SubmarineBuilder.AddSubmarine(Traitormod.Path .. "/Submarines/Unknown.sub", "Unknown")
        category.Coalition_Dropship = Traitormod.SubmarineBuilder.AddSubmarine(Traitormod.Path .. "/Submarines/Coalition_Dropship.sub", "Coalition Dropship")
        category.CoalitionRescueShuttle = Traitormod.SubmarineBuilder.AddSubmarine(Traitormod.Path .. "/Submarines/Coalition Hemulen.sub", "Coalition Rescue Shuttle")
        category.PrisonerTransport = Traitormod.SubmarineBuilder.AddSubmarine(Traitormod.Path .. "/Submarines/Prisoner Transport Barsuk.sub", "Prisoner Transport Barsuk")
        category.Unknown_Signal = Traitormod.SubmarineBuilder.AddSubmarine(Traitormod.Path .. "/Submarines/Unknown_Signal.sub", "Mysterious Signal")
    end
end

local function CanBuy(id, client)
    local submarine = Traitormod.SubmarineBuilder.FindSubmarine(id)
    local position = client.Character.WorldPosition + Vector2(0, -submarine.Borders.Height)

    local levelWalls = Level.Loaded.GetTooCloseCells(position, submarine.Borders.Width)
    if #levelWalls > 0 then
        return false, Traitormod.Language.ShipTooCloseToWall
    end

    for key, value in pairs(Submarine.Loaded) do
        if submarine ~= value then
            local maxDistance = (value.Borders.Width + submarine.Borders.Width) / 2
            if Vector2.Distance(value.WorldPosition, position) < maxDistance then
                return false, Traitormod.Language.ShipTooCloseToShip
            end
        end
    end

    return true
end

local function SpawnSubmarine(id, client)
    local submarine = Traitormod.SubmarineBuilder.FindSubmarine(id)
    local position = client.Character.WorldPosition + Vector2(0, -submarine.Borders.Height)

    submarine.SetPosition(position)
    submarine.GodMode = false

    for _, item in pairs(submarine.GetItems(false)) do
        item.Condition = item.MaxCondition
    end

    Traitormod.SubmarineBuilder.ResetSubmarineSteering(submarine)
    return submarine
end

category.Products = {
    {
        Identifier = "streamchalk",
        Price = 0,
        Limit = 1,
        IsLimitGlobal = true,

        Action = function (client, product, items)
            SpawnSubmarine(category.StreamChalkId, client)
        end,

        CanBuy = function (client, product)
            return CanBuy(category.StreamChalkId, client)
        end
    },

    {
        Identifier = "Dropship",
        Price = 0,
        Limit = 1,
        IsLimitGlobal = true,

        Action = function (client, product, items)
            SpawnSubmarine(category.Coalition_Dropship, client)
        end,

        CanBuy = function (client, product)
            return CanBuy(category.Coalition_Dropship, client)
        end
    },

    {
        Identifier = "separatist",
        Price = 0,
        Limit = 1,
        IsLimitGlobal = true,

        Action = function (client, product, items)
            SpawnSubmarine(category.Separatist, client)
        end,

        CanBuy = function (client, product)
            return CanBuy(category.Separatist, client)
        end
    },

    {
        Identifier = "barsuktwo",
        Price = 0,
        Limit = 1,
        IsLimitGlobal = true,

        Action = function (client, product, items)
            local submarine = SpawnSubmarine(category.PrisonerTransport, client)
            AutoItemPlacer.RegenerateLoot(submarine, nil)
        end,

        CanBuy = function (client, product)
            return CanBuy(category.PrisonerTransport, client)
        end
    },

    {
        Identifier = "rescueshuttle",
        Price = 0,
        Limit = 1,
        IsLimitGlobal = true,

        Action = function (client, product, items)
            local submarine = SpawnSubmarine(category.CoalitionRescueShuttle, client)
            AutoItemPlacer.RegenerateLoot(submarine, nil)
        end,

        CanBuy = function (client, product)
            return CanBuy(category.CoalitionRescueShuttle, client)
        end
    },

    {
        Identifier = "unknownwreck",
        Price = 0,
        Limit = 1,
        IsLimitGlobal = true,

        Action = function (client, product, items)
            local submarine = SpawnSubmarine(category.Unknown, client)
            AutoItemPlacer.RegenerateLoot(submarine, nil)
        end,

        CanBuy = function (client, product)
            return CanBuy(category.Unknown, client)
        end
    },

    {
        Identifier = "unknownsignal",
        Price = 0,
        Limit = 1,
        IsLimitGlobal = true,

        Action = function (client, product, items)
            local submarine = SpawnSubmarine(category.Unknown_Signal, client)
            AutoItemPlacer.RegenerateLoot(submarine, nil)
        end,

        CanBuy = function (client, product)
            return CanBuy(category.Unknown_Signal, client)
        end
    },
}

return category
