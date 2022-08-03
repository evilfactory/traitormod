local category = {}

category.Name = "Death Spawn"
category.IsTraitorOnly = false
category.IsDeadOnly = true

category.Products = {
    {
        Name = "Spawn as Husk",
        Price = 600,
        Limit = 4,
        IsLimitGlobal = true,

        Action = function (client, product, items)
            local waypoint = Submarine.MainSub.GetWaypoints(true)
            local spawnpoint = waypoint[math.random(#waypoint)]

            Entity.Spawner.AddCharacterToSpawnQueue("husk", spawnpoint.WorldPosition, function (character)
                client.SetClientCharacter(character)
            end)
        end
    },
}

return category