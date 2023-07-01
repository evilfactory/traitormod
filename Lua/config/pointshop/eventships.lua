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
        category.BarsukId = Traitormod.SubmarineBuilder.AddSubmarine("Content/Submarines/Barsuk.sub", "[P]Barsuk")
        category.SeaShark = Traitormod.SubmarineBuilder.AddSubmarine(Traitormod.Path .. "/Submarines/Sea shark Mark II.sub", "[P]Sea shark Mark II")
        category.Uri = Traitormod.SubmarineBuilder.AddSubmarine(Traitormod.Path .. "/Submarines/Uri.sub", "[P]Uri - Alien Ship")
        category.CoalitionRescueShuttle = Traitormod.SubmarineBuilder.AddSubmarine(Traitormod.Path .. "/Submarines/Coalition Hemulen.sub", "Rescue Shuttle")
        category.PrisonerTransport = Traitormod.SubmarineBuilder.AddSubmarine(Traitormod.Path .. "/Submarines/Prisoner Transport Barsuk.sub", "Prisoner Transport Barsuk")
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
        Identifier = "uri",
        Price = 0,
        Limit = 1,
        IsLimitGlobal = true,

        Action = function (client, product, items)
            SpawnSubmarine(category.Uri, client)
        end,

        CanBuy = function (client, product)
            return CanBuy(category.Uri, client)
        end
    },

    {
        Identifier = "seashark",
        Price = 0,
        Limit = 1,
        IsLimitGlobal = true,

        Action = function (client, product, items)
            SpawnSubmarine(category.SeaShark, client)
        end,

        CanBuy = function (client, product)
            return CanBuy(category.SeaShark, client)
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
        Identifier = "barsuk",
        Price = 0,
        Limit = 1,
        IsLimitGlobal = true,

        Action = function (client, product, items)
            local submarine = SpawnSubmarine(category.BarsukId, client)
            AutoItemPlacer.RegenerateLoot(submarine, nil)
        end,

        CanBuy = function (client, product)
            return CanBuy(category.BarsukId, client)
        end
    },
}

return category