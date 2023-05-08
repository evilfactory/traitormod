local category = {}

category.Name = "Convict Uplink"
category.Decoration = "Separatists"
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
        Name = "Separatist Gear",
        Price = 3250,
        Limit = 1,
        IsLimitGlobal = true,
        Items = {"pirateclotheshard", "piratebodyarmor", "piratebandana"},
    },

    {
        Name = "Suicide Vest",
        Price = 5000,
        Limit = 1,
        IsLimitGlobal = true,
        Items = {"suicidevestDJL", "uex"},
    },

    {
        Name = "Molotov",
        Price = 3500,
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
        Name = "Mutated Pomegrenade",
        Price = 1250,
        Limit = 2,
        IsLimitGlobal = true,
        Items = {"badcreepingorange"},
    },

    {
        Name = "Boom Stick",
        Price = 10000,
        Limit = 1,
        IsLimitGlobal = true,
        Items = {"shotgununique", 
        "shotgunshell", "shotgunshell", "shotgunshell","shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell"},
    },

    {
        Name = "Turn Off Lights For 3 Minutes",
        Price = 950,
        Limit = 1,
        IsLimitGlobal = true,

        CanBuy = function (client, product)
            return not Traitormod.RoundEvents.IsEventActive("LightsOff")
        end,

        Action = function ()
            Traitormod.RoundEvents.TriggerEvent("LightsOff")
        end
    },

    {
        Name = "Turn Off Communications For 2 Minutes",
        Price = 1000,
        Limit = 1,
        IsLimitGlobal = true,

        CanBuy = function (client, product)
            return not Traitormod.RoundEvents.IsEventActive("CommunicationsOffline")
        end,

        Action = function ()
            Traitormod.RoundEvents.TriggerEvent("CommunicationsOffline")
        end
    },

    {
        Name = "Sabotage Oxygen Generator [Warn Other Prisoners]",
        Price = 9500,
        Limit = 1,
        IsLimitGlobal = true,

        CanBuy = function (client, product)
            return not Traitormod.RoundEvents.IsEventActive("OxygenGeneratorPoison")
        end,

        Action = function ()
            Traitormod.RoundEvents.TriggerEvent("OxygenGeneratorPoison")
        end
    },
}

return category