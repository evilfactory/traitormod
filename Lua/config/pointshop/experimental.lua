local category = {}

category.Name = "Experimental"
category.IsTraitorOnly = false

category.Products = {
    {
        Name = "Door",
        Price = 2800,
        Limit = 1,
        Items = {
            {Identifier = "door", IsInstallation = true}
        }
    },

    {
        Name = "Oxygen Generator",
        Price = 3200,
        Limit = 1,
        Items = {
            {Identifier = "shuttleoxygenerator", IsInstallation = true}
        }
    },

    {
        Name = "Fabricator",
        Price = 5000,
        Limit = 1,
        Items = {
            {Identifier = "fabricator", IsInstallation = true}
        }
    },

    {
        Name = "Deconstructor",
        Price = 3900,
        Limit = 1,
        Items = {
            {Identifier = "deconstructor", IsInstallation = true}
        }
    },

    {
        Name = "Medical Fabricator",
        Price = 4600,
        Limit = 1,
        Items = {
            {Identifier = "medicalfabricator", IsInstallation = true}
        }
    },

    {
        Name = "Research Station",
        Price = 1700,
        Limit = 1,
        Items = {
            {Identifier = "op_researchterminal", IsInstallation = true}
        }
    },

    {
        Name = "Junction Box",
        Price = 1200,
        Limit = 1,
        Items = {
            {Identifier = "junctionbox", IsInstallation = true}
        }
    },

    {
        Name = "Battery",
        Price = 2000,
        Limit = 1,
        Items = {
            {Identifier = "battery", IsInstallation = true}
        }
    },

    {
        Name = "Super Capacitor",
        Price = 2000,
        Limit = 1,
        Items = {
            {Identifier = "supercapacitor", IsInstallation = true}
        }
    },
}

return category