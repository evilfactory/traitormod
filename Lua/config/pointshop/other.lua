local category = {}

category.Name = "Other"

local randomItems = {}
for prefab in ItemPrefab.Prefabs do
    if prefab.CanBeSold or prefab.CanBeBought then
        table.insert(randomItems, prefab)
    end
end

category.Products = {
    {
        Name = "Random Item",
        Price = 100,
        Limit = 5,
        Action = function (client, product, items)
            local item = randomItems[math.random(1, #randomItems)]
            Entity.Spawner.AddItemToSpawnQueue(item, client.Character.WorldPosition, nil, nil, function () end)
        end
    },

    {
        Name = "Clown Suit",
        Price = 650,
        Limit = 2,
        Items = {"clowncostume", "clownmask"}
    },

    {
        Name = "Banana",
        Price = 10,
        Limit = 50,
        Items = {"banana"}
    },

    {
        Name = "Coilgun Ammo",
        Price = 145,
        Limit = 3,
        Items = {"coilgunammobox"}
    },

    {
        Name = "Moloch Shell Fragment",
        Price = 340,
        Limit = 1,
        Items = {"shellshield"}
    },

    {
        Name = "Disposable Diving Suit",
        Price = 400,
        Limit = 1,
        Items = {"respawndivingsuit"}
    },

    {
        Name = "Diving Mask",
        Price = 280,
        Limit = 1,
        Items = {"divingmask"}
    },

    {
        Name = "Bike Horn",
        Price = 350,
        Limit = 10,
        Items = {"bikehorn"}
    },

    {
        Name = "Guitar",
        Price = 50,
        Limit = 2,
        Items = {"guitar"}
    },

    {
        Name = "Harmonica",
        Price = 50,
        Limit = 2,
        Items = {"harmonica"}
    },

    {
        Name = "Accordion",
        Price = 50,
        Limit = 2,
        Items = {"accordion"}
    },

    {
        Name = "Pet Name Tag",
        Price = 30,
        Limit = 5,
        Items = {"petnametag"}
    },

    {
        Name = "Poop",
        Price = 10,
        Limit = 16,
        Items = {"poop"},
    },

    {
        Name = "Random Egg",
        Price = 50,
        Limit = 5,
        Items = {"smallmudraptoregg", "tigerthresheregg", "crawleregg", "peanutegg", "psilotoadegg", "orangeboyegg", "balloonegg"},
        ItemRandom = true
    },

    {
        Name = "Assistant Bot",
        Price = 400,
        Limit = 5,
        Action = function (client, product, items)
            local info = CharacterInfo(Identifier("human"))
            info.Job = Job(JobPrefab.Get("assistant"))
            local character = Character.Create(info, client.Character.WorldPosition, info.Name, 0, false, true)
            character.TeamID = CharacterTeamType.Team1
            character.GiveJobItems(nil)
        end
    },
}

return category