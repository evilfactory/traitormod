local category = {}

category.Name = "Maintenance"
category.IsTraitorOnly = false

category.Products = {
    {
        Name = "Screwdriver",
        Price = 100,
        Limit = 1,
        Items = {"screwdriver"}
    },

    {
        Name = "Wrench",
        Price = 100,
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
        Name = "Fixfoam Grenade",
        Price = 200,
        Limit = 4,
        Items = {"fixfoamgrenade"}
    },

    {
        Name = "Low Quality Fuel Rod",
        Price = 260,
        Limit = 10,

        Items = {{Identifier = "fuelrod", Condition = 9}},
    },
}

return category