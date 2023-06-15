local category = {}

category.Name = "Convict Uplink"
category.Decoration = "group"
category.FadeToBlack = true

category.CanAccess = function(client)
    return client.Character and not client.Character.IsDead and client.Character.HasJob("convict")
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
        Name = "Separatist Gear",
        Price = 2750,
        Limit = 1,
        IsLimitGlobal = true,
        Items = {"pirateclotheshard", "piratebodyarmor", "piratebandana"},
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
        Name = "Clown Gear",
        Price = 1200,
        Limit = 2,
        IsLimitGlobal = true,
        Items = {"clownmask", "clowncostume"},
    },

    {
        Name = "Enroll into Clown College",
        Price = 500,
        Limit = 2,
        IsLimitGlobal = true,
        Action = function (client, product, items)
            client.Character.GiveTalent("enrollintoclowncollege")
        end
    },

    {
        Name = "Molotov",
        Price = 4500,
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