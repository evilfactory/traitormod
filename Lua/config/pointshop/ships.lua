local category = {}

category.Name = "Ships"
category.CanAccess = function(client)
    return client.Character and not client.Character.IsDead and Traitormod.SubmarineBuilder ~= nil
end

category.Init = function ()
    if Traitormod.SubmarineBuilder then
        category.HemulenID = Traitormod.SubmarineBuilder.AddSubmarine("Content/Submarines/Hemulen.sub", "[P]Hemulen")
    end
end

local function CheckSpawnPosition(position, size)
    local levelWalls = Level.Loaded.GetTooCloseCells(position, size)
    if #levelWalls > 0 then
        return "Cannot spawn ship, position is too close to a level wall."
    end

    for key, value in pairs(Submarine.Loaded) do
        if Vector2.Distance(value.WorldPosition, position) < 3000 then
            return "Cannot spawn ship, position is too close to another submarine."
        end
    end
end

category.Products = {
    {
        Name = "Hemulen",
        Price = 2000,
        Limit = 1,
        IsLimitGlobal = true,

        Action = function (client, product, items)
            local position = client.Character.WorldPosition + Vector2(0, 300)
            local submarine = Traitormod.SubmarineBuilder.FindSubmarine(category.HemulenID)

            submarine.SetPosition(client.Character.WorldPosition + Vector2(0, 300))
            submarine.GodMode = false
        end,

        CanBuy = function (client, product)
            local position = client.Character.WorldPosition + Vector2(0, 300)
            local submarine = Traitormod.SubmarineBuilder.FindSubmarine(category.HemulenID)

            local result = CheckSpawnPosition(position, submarine.Borders.Width)

            if result then
                return false, result
            end

            return true
        end
    },
}

return category