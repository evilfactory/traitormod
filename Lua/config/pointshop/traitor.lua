local category = {}

category.Name = "Traitor"
category.Decoration = "clown"
category.FadeToBlack = true

category.CanAccess = function(client)
    return client.Character and not client.Character.IsDead and client.Character.IsTraitor
end

category.Products = {
    {
        Name = "Boom Stick",
        Price = 3200,
        Limit = 1,
        IsLimitGlobal = false,
        Items = {"shotgununique", 
        "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell","shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell"},
    },

    {
        Name = "Shotgun Shell (x8)",
        Price = 320,
        Limit = 5,
        IsLimitGlobal = false,
        Items = {"shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell"},
    },

    {
        Name = "Deadeye Carbine",
        Price = 2900,
        Limit = 1,
        IsLimitGlobal = false,
        Items = {"smgunique", "smgmagazine", "smgmagazine"},
    },

    {
        Name = "SMG Magazine",
        Price = 250,
        Limit = 5,
        IsLimitGlobal = false,
        Items = {"smgmagazine"},
    },

    {
        Name = "Prototype Steam Cannon",
        Price = 1300,
        Limit = 1,
        IsLimitGlobal = false,
        Items = {"flamerunique", "incendiumfueltank"},
    },

    {
        Name = "Detonator",
        Price = 950,
        Limit = 3,
        IsLimitGlobal = false,
        Items = {"detonator"},
    },

    {
        Name = "UEX",
        Price = 700,
        Limit = 5,
        IsLimitGlobal = false,
        Items = {"uex"},
    },

    {
        Name = "Stun Grenade",
        Price = 600,
        Limit = 3,
        IsLimitGlobal = false,
        Items = {"stungrenade"},
    },

    {
        Name = "Mutated Pomegrenade",
        Price = 530,
        Limit = 3,
        IsLimitGlobal = false,
        Items = {"badcreepingorange"},
    },

    {
        Name = "Turn Off Lights For 3 Minutes",
        Price = 350,
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
        Name = "Turn Off Communications For 5 Minutes",
        Price = 400,
        Limit = 1,
        IsLimitGlobal = true,

        CanBuy = function (client, product)
            return not Traitormod.RoundEvents.IsEventActive("CommunicationsOffline")
        end,

        Action = function ()
            Traitormod.RoundEvents.TriggerEvent("CommunicationsOffline")
        end
    },
}

return category