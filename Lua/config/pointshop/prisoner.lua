local category = {}

category.Identifier = "prisoner"
category.Decoration = "group"
category.FadeToBlack = true

category.CanAccess = function(client)
    return client.Character and not client.Character.IsDead and client.Character.HasJob("convict")
end

local randomItems = {}
for prefab in ItemPrefab.Prefabs do
    if prefab.CanBeSold or prefab.CanBeBought then
        table.insert(randomItems, prefab)
    end
end

category.Products = {
    {
        Name = "Beanie",
        Price = 1,
        Limit = 1,
        IsLimitGlobal = false,
        Items = {"touque"},
    },

    {
        Price = 100,
        Limit = 2,
        Items = {"cigaretteDJL"}
    },

    {
        Identifier = "randomitem",
        Price = 375,
        Limit = 5,
        IsLimitGlobal = true,
        Action = function (client, product, items)
            local item = randomItems[math.random(1, #randomItems)]
            Entity.Spawner.AddItemToSpawnQueue(item, client.Character.WorldPosition, nil, nil, function () end)
        end
    },

    {
        Name = "Lockpick",
        Price = 300,
        Limit = 1,
        IsLimitGlobal = false,
        Items = {"ah_lockpick"},
    },

    {
        Name = "Crowbar",
        Price = 600,
        Limit = 1,
        IsLimitGlobal = true,
        Items = {"crowbar"},
    },

    {
        Name = "Wrench",
        Price = 50,
        Limit = 2,
        IsLimitGlobal = true,
        Items = {"wrench"},
    },

    {
        Identifier = "separatistgear",
        Price = 2500,
        Limit = 1,
        IsLimitGlobal = true,
        Items = {"pirateclothes", "piratebodyarmor", "piratebandana"},
    },

    {
        Name = "Shiv",
        Price = 400,
        Limit = 2,
        IsLimitGlobal = true,
        Items = {"divingknife"},
    },

    {
        Name = "Premium Shiv",
        Price = 1100,
        Limit = 1,
        IsLimitGlobal = true,
        Items = {"frogsstabbingknife"},
    },

    {
        Name = "Ol' Choppy",
        Price = 2000,
        Limit = 1,
        IsLimitGlobal = true,
        Items = {"frogspyschoknife"},
    },

    {
        Name = "Meth",
        Price = 100,
        Limit = 1,
        IsLimitGlobal = false,
        Items = {"meth", "meth"},
    },

    {
        Name = "Steroids",
        Price = 100,
        Limit = 1,
        IsLimitGlobal = false,
        Items = {"steroids", "steroids"},
    },

    {
        Identifier = "clowngear",
        Price = 2700,
        Limit = 1,
        IsLimitGlobal = true,
        Items = {"clownmask", "clowncostume", "toyhammer", "bikehorn"},
    },

    {
        Identifier = "enrollclown",
        Price = 500,
        Limit = 1,
        IsLimitGlobal = false,
        Action = function (client, product, items)
            client.Character.GiveTalent("enrollintoclowncollege")
        end
    },

    {
        Name = "Molotov",
        Price = 5500,
        Limit = 2,
        IsLimitGlobal = true,
        Items = {"molotovcoctail"},
    },

    {
        Name = "Stun Grenade",
        Price = 715,
        Limit = 2,
        IsLimitGlobal = true,
        Items = {"stungrenade"},
    },

    {
        Name = "Boom Stick",
        Price = 9100,
        Limit = 1,
        IsLimitGlobal = true,
        Items = {"shotgununique", 
        "shotgunshell", "shotgunshell", "shotgunshell","shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell"},
    },
}

return category
