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
        Identifier = "randomitem",
        Price = 100,
        Limit = 5,
        Action = function (client, product, items)
            local item = randomItems[math.random(1, #randomItems)]
            Entity.Spawner.AddItemToSpawnQueue(item, client.Character.WorldPosition, nil, nil, function () end)
        end
    },

    {
        Price = 290,
        Limit = 5,
        Items = {"skillbooksubmarinewarfare"}
    },

    {
        Price = 290,
        Limit = 5,
        Items = {"skillbookeuropanmedicine"}
    },

    {
        Price = 290,
        Limit = 5,
        Items = {"skillbookhandyseaman"}
    },

    {
        Price = 290,
        Limit = 5,
        Items = {"skillbooksailorsguide"}
    },

    {
        Identifier = "clownsuit",
        Price = 650,
        Limit = 2,
        Items = {"clowncostume", "clownmask"}
    },

    {
        Price = 10,
        Limit = 50,
        Items = {"banana"}
    },

    {
        Price = 145,
        Limit = 3,
        Items = {"coilgunammobox"}
    },

    {
        Price = 340,
        Limit = 1,
        Items = {"shellshield"}
    },

    {
        Price = 400,
        Limit = 1,
        Items = {"respawndivingsuit"}
    },

    {
        Price = 280,
        Limit = 1,
        Items = {"divingmask"}
    },

    {
        Price = 350,
        Limit = 10,
        Items = {"bikehorn"}
    },

    {
        Price = 50,
        Limit = 2,
        Items = {"guitar"}
    },

    {
        Price = 50,
        Limit = 2,
        Items = {"harmonica"}
    },

    {
        Price = 50,
        Limit = 2,
        Items = {"accordion"}
    },

    {
        Price = 30,
        Limit = 5,
        Items = {"petnametag"}
    },

    {
        Price = 10,
        Limit = 16,
        Items = {"poop"},
    },

    {
        Identifier = "randomegg",
        Price = 50,
        Limit = 5,
        Items = {"smallmudraptoregg", "tigerthresheregg", "crawleregg", "peanutegg", "psilotoadegg", "orangeboyegg", "balloonegg"},
        ItemRandom = true
    },

    {
        Identifier = "assistantbot",
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