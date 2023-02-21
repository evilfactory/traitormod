local category = {}

category.Name = "Security"
category.Decoration = "security"

category.CanAccess = function(client)
    return client.Character and not client.Character.IsDead and 
    (client.Character.HasJob("securityofficer") or client.Character.HasJob("captain"))
end

category.Products = {
    {
        Name = "Firemans Carry Talent",
        Price = 350,
        Limit = 1,
        IsLimitGlobal = false,
        Action = function (client, product, items)
            client.Character.GiveTalent("firemanscarry")
        end
    },

    {
        Name = "Coilgun Ammo",
        Price = 200,
        Limit = 5,
        IsLimitGlobal = false,
        Items = {"coilgunammobox"},
    },

    {
        Name = "Handcuffs",
        Price = 100,
        Limit = 5,
        IsLimitGlobal = false,
        Items = {"handcuffs"},
    },

    {
        Name = "Stun Baton",
        Price = 200,
        Limit = 2,
        IsLimitGlobal = false,
        Items = {"stunbaton", "batterycell"},
    },

    {
        Name = "Stun Gun",
        Price = 500,
        Limit = 1,
        IsLimitGlobal = false,
        Items = {"stungun", "stungundart", "stungundart", "stungundart", "stungundart"},
    },

    {
        Name = "Stun Gun Ammo (x4)",
        Price = 100,
        Limit = 1,
        IsLimitGlobal = false,
        Items = {"stungundart", "stungundart", "stungundart", "stungundart"},
    },

    {
        Name = "Revolver Ammo (x6)",
        Price = 250,
        Limit = 1,
        IsLimitGlobal = false,
        Items = {"revolverround", "revolverround","revolverround", "revolverround", "revolverround", "revolverround"},
    },

    {
        Name = "SMG Magazine (x2)",
        Price = 350,
        Limit = 5,
        IsLimitGlobal = false,
        Items = {"smgmagazine", "smgmagazine"},
    },

    {
        Name = "Shotgun Shells (x8)",
        Price = 300,
        Limit = 5,
        IsLimitGlobal = false,
        Items = {"shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell"},
    },

    {
        Name = "Stun Grenade",
        Price = 400,
        Limit = 3,
        IsLimitGlobal = false,
        Items = {"stungrenade"},
    },

    {
        Name = "Flamer",
        Price = 800,
        Limit = 1,
        IsLimitGlobal = false,
        Items = {"flamer", "incendiumfueltank"},
    },

}

return category