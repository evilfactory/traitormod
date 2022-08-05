local category = {}

category.Name = "Experimental"
category.IsTraitorOnly = false

category.Products = {
    {
        Name = "Door",
        Price = 6000,
        Limit = 2,
        Items = {
            {Identifier = "door", IsInstallation = true}
        }
    },

    {
        Name = "Supplies Cabinet",
        Price = 450,
        Limit = 3,
        Items = {
            {Identifier = "suppliescabinet", IsInstallation = true}
        }
    },

    {
        Name = "Oxygen Generator",
        Price = 1400,
        Limit = 2,
        Items = {
            {Identifier = "shuttleoxygenerator", IsInstallation = true}
        }
    },

    {
        Name = "Fabricator",
        Price = 1900,
        Limit = 1,
        Items = {
            {Identifier = "fabricator", IsInstallation = true}
        }
    },

    {
        Name = "Deconstructor",
        Price = 1600,
        Limit = 1,
        Items = {
            {Identifier = "deconstructor", IsInstallation = true}
        }
    },

    {
        Name = "Medical Fabricator",
        Price = 1950,
        Limit = 1,
        Items = {
            {Identifier = "medicalfabricator", IsInstallation = true}
        }
    },

    {
        Name = "Research Station",
        Price = 1400,
        Limit = 1,
        Items = {
            {Identifier = "op_researchterminal", IsInstallation = true}
        }
    },

    {
        Name = "Junction Box",
        Price = 900,
        Limit = 4,
        Items = {
            {Identifier = "junctionbox", IsInstallation = true}
        }
    },

    {
        Name = "Battery",
        Price = 1300,
        Limit = 3,
        Items = {
            {Identifier = "battery", IsInstallation = true}
        }
    },

    {
        Name = "Super Capacitor",
        Price = 1400,
        Limit = 2,
        Items = {
            {Identifier = "supercapacitor", IsInstallation = true}
        }
    },
}

return category