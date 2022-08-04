local category = {}

category.Name = "Death Spawn"
category.IsTraitorOnly = false
category.IsDeadOnly = true

local function SpawnCreature(species, client)
    local waypoints = Submarine.MainSub.GetWaypoints(true)
    local goodWaypoints = {}

    for key, value in pairs(waypoints) do
        if value.CurrentHull == nil then
            table.insert(goodWaypoints, value)
        end
    end

    local spawnPosition

    if #goodWaypoints == 0 then
        -- no waypoints? https://c.tenor.com/RgExaLgYIScAAAAC/megamind-megamind-meme.gif
        spawnPosition = Submarine.MainSub.WorldPosition -- spawn it in the middle of the sub

        Traitormod.Log("Couldnt find any good waypoints, spawning in the middle of the sub.")
    else
        spawnPosition = goodWaypoints[math.random(#goodWaypoints)].WorldPosition
    end

    Entity.Spawner.AddCharacterToSpawnQueue(species, spawnPosition, function (character)
        client.SetClientCharacter(character)
    end)
end

category.Products = {
    {
        Name = "Spawn as Crawler",
        Price = 400,
        Limit = 6,
        IsLimitGlobal = true,

        Action = function (client, product, items)
            SpawnCreature("crawler", client)
        end
    },

    {
        Name = "Spawn as Mudraptor",
        Price = 900,
        Limit = 4,
        IsLimitGlobal = true,

        Action = function (client, product, items)
            SpawnCreature("mudraptor", client)
        end
    },

    {
        Name = "Spawn as Husk",
        Price = 3500,
        Limit = 2,
        IsLimitGlobal = true,

        Action = function (client, product, items)
            SpawnCreature("husk", client)
        end
    },
}

return category