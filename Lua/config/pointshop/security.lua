local category = {}

category.Name = "Security"
--category.Decoration = "clown"

category.CanAccess = function(client)
    return client.Character and not client.Character.IsDead and client.Character.HasJob("securityofficer")
end

category.Products = {

    {
        Name = "Handcuffs",
        Price = 100,
        Limit = 2,
        IsLimitGlobal = false,
        Items = {"handcuffs"},
    },

    {
        Name = "Stun Baton",
        Price = 200,
        Limit = 1,
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
        Name = "Revolver",
        Price = 1000,
        Limit = 1,
        IsLimitGlobal = false,
        Items = {"revolver", 
        "revolverround", "revolverround", "revolverround", "revolverround", "revolverround", "revolverround", "revolverround", "revolverround","revolverround", "revolverround", "revolverround", "revolverround"},
    },

    {
        Name = "SMG",
        Price = 1500,
        Limit = 1,
        IsLimitGlobal = false,
        Items = {"smg", "smgmagazine", "smgmagazine"},
    },

    {
        Name = "SMG Magazine",
        Price = 150,
        Limit = 5,
        IsLimitGlobal = false,
        Items = {"smgmagazine"},
    },

    {
        Name = "Shotgun",
        Price = 2000,
        Limit = 1,
        IsLimitGlobal = false,
        Items = {"shotgun", 
        "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell","shotgunshell", "shotgunshell", "shotgunshell","shotgunshell"},
    },

    {
        Name = "Shotgun Shell (x8)",
        Price = 250,
        Limit = 5,
        IsLimitGlobal = false,
        Items = {"shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell"},
    },

    {
        Name = "Flamer Cannon",
        Price = 800,
        Limit = 1,
        IsLimitGlobal = false,
        Items = {"flamer", "incendiumfueltank"},
    },

    {
        Name = "Stun Grenade",
        Price = 400,
        Limit = 3,
        IsLimitGlobal = false,
        Items = {"stungrenade"},
    },

}

return category