local category = {}

category.Identifier = "maintenance"

category.CanAccess = function(client)
    return client.Character and not client.Character.IsDead and client.Character.HasJob("staff")
end

category.Products = {
    {
        Price = 50,
        Limit = 1,
        Items = {"flashlight"}
    },

    {
        Price = 100,
        Limit = 2,
        Items = {"cigaretteDJL"}
    },

    {
        Price = 300,
        Limit = 3,
        Items = {"batterycell"}
    },

    {
        Price = 700,
        Limit = 1,
        Items = {"fulguriumbatterycell"}
    },

    {
        Price = 90,
        Limit = 1,
        Items = {"screwdriver"}
    },

    {
        Price = 90,
        Limit = 1,
        Items = {"wrench"}
    },

    {
        Price = 160,
        Limit = 4,
        Items = {"weldingtool", "weldingfueltank"}
    },

    {
        Price = 250,
        Limit = 2,
        Items = {"handheldstatusmonitor"}
    },

    {
        Price = 190,
        Limit = 4,
        Items = {"fixfoamgrenade", "fixfoamgrenade"}
    },

    {
        Price = 140,
        Limit = 4,
        Items = {"repairpack", "repairpack", "repairpack", "repairpack"}
    },

    {
        Identifier = "fuelrodlowquality",
        Price = 260,
        Limit = 10,

        Items = {{Identifier = "fuelrod", Condition = 9}},
    },

    {
        Price = 1000,
        Limit = 1,

        Items = {"fuelrod"},
    },

    {
        Price = 1000,
        Limit = 1,

        Items = {"fuelrod"},
    },

    {
        Price = 650,
        Limit = 1,

        Items = {"scp_hardeneddivingmask"},
    },

    {
        Price = 3900,
        Limit = 1,
        IsLimitGlobal = true,

        Items = {"scp_liquidatorsuit"},
    },

    {
        Price = 2500,
        Limit = 2,
        IsLimitGlobal = true,

        Items = {"scp_heavyhazmatuniform"},
    },
}

return category