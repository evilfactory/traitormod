local category = {}

category.Name = "Maintenance"
category.IsTraitorOnly = false

category.Products = {
    {
        Name = "Screwdriver",
        Price = 250,
        Limit = 1,
        Items = {"screwdrver"}
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
        Items = {"weldingtool", "weldingfuel"}
    },

    {
        Name = "Fixfoam Grenade",
        Price = 900,
        Limit = 2,
        Items = {"fixfoamgrenade"}
    },

    {
        Name = "Low Quality Fuel Rod",
        Price = 700,
        Limit = 1,

        Items = {"fuelrod"},
        ItemsCondition = {5},
    },
}

return category