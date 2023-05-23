local category = {}

category.Name = "Maintenance"

category.Products = {
    {
        Name = "Screwdriver",
        Price = 90,
        Limit = 1,
        Items = {"screwdriver"}
    },

    {
        Name = "Wrench",
        Price = 90,
        Limit = 1,
        Items = {"wrench"}
    },

    {
        Name = "Welding Tool",
        Price = 160,
        Limit = 4,
        Items = {"weldingtool", "weldingfueltank"}
    },

    {
        Name = "Handheld Status Monitor",
        Price = 250,
        Limit = 2,
        Items = {"handheldstatusmonitor"}
    },

    {
        Name = "Fixfoam Grenade",
        Price = 190,
        Limit = 4,
        Items = {"fixfoamgrenade", "fixfoamgrenade"}
    },

    {
        Name = "Repair Pack",
        Price = 140,
        Limit = 4,
        Items = {"repairpack", "repairpack", "repairpack", "repairpack"}
    },

    {
        Name = "Low Quality Fuel Rod",
        Price = 260,
        Limit = 10,

        Items = {{Identifier = "fuelrod", Condition = 9}},
    },
}

return category