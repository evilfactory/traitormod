local category = {}

category.Name = "Maintenance"
category.IsTraitorOnly = false

category.Products = {
    {
        Name = "Screwdriver",
        Price = 250,
        Limit = 1,
        Items = {"screwdriver"}
    },

    {
        Name = "Wrench",
        Price = 250,
        Limit = 1,
        Items = {"wrench"}
    },

    {
        Name = "Welding Tool",
        Price = 460,
        Limit = 1,
        Items = {"weldingtool", "weldingfueltank"}
    },

    {
        Name = "Fixfoam Grenade",
        Price = 900,
        Limit = 2,
        Items = {"fixfoamgrenade"}
    },

    {
        Name = "Low Quality Fuel Rod",
        Price = 560,
        Limit = 10,

        Items = {{Identifier = "fuelrod", Condition = 9}},
    },
}

return category