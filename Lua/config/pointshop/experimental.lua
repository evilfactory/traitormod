local category = {}

category.Name = "Experimental"
category.IsTraitorOnly = false

category.Products = {
    {
        Name = "Door",
        Price = 2800,
        Limit = 1,
        IsInstalation = true,
        Items = {
            {Identifier = "door", IsInstalation = true}
        }
    },

    {
        Name = "Oxygen Generator",
        Price = 3200,
        Limit = 1,
        Items = {
            {Identifier = "shuttleoxygenerator", IsInstalation = true}
        }
    },

    {
        Name = "Fabricator",
        Price = 5000,
        Limit = 1,
        Items = {
            {Identifier = "fabricator", IsInstalation = true}
        }
    },

    {
        Name = "Deconstructor",
        Price = 3900,
        Limit = 1,
        Items = {
            {Identifier = "deconstructor", IsInstalation = true}
        }
    },

    {
        Name = "Medical Fabricator",
        Price = 4600,
        Limit = 1,
        Items = {
            {Identifier = "medicalfabricator", IsInstalation = true}
        }
    },

    {
        Name = "Research Station",
        Price = 1700,
        Limit = 1,
        Items = {
            {Identifier = "op_researchterminal", IsInstalation = true}
        }
    },

    {
        Name = "Junction Box",
        Price = 1200,
        Limit = 1,
        Items = {
            {Identifier = "junctionbox", IsInstalation = true}
        }
    },

    {
        Name = "Battery",
        Price = 2000,
        Limit = 1,
        Items = {
            {Identifier = "battery", IsInstalation = true}
        }
    },

    {
        Name = "Super Capacitor",
        Price = 2000,
        Limit = 1,
        Items = {
            {Identifier = "supercapacitor", IsInstalation = true}
        }
    },
}

return category