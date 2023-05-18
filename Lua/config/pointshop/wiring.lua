local category = {}

category.Name = "Wiring"

category.Products = {
    {
        Name = "Door",
        Price = 400,
        Limit = 4,
        Items = {
            {Identifier = "door", IsInstallation = true}
        }
    },

    {
        Name = "Hatch",
        Price = 400,
        Limit = 4,
        Items = {
            {Identifier = "hatch", IsInstallation = true}
        }
    },

    {
        Name = "Supplies Cabinet",
        Price = 100,
        Limit = 6,
        Items = {
            {Identifier = "suppliescabinet", IsInstallation = true}
        }
    },

    {
        Name = "Oxygen Generator",
        Price = 200,
        Limit = 6,
        Items = {
            {Identifier = "shuttleoxygenerator", IsInstallation = true}
        }
    },

    {
        Name = "Fabricator",
        Price = 230,
        Limit = 4,
        Items = {
            {Identifier = "fabricator", IsInstallation = true}
        }
    },

    {
        Name = "Deconstructor",
        Price = 235,
        Limit = 4,
        Items = {
            {Identifier = "deconstructor", IsInstallation = true}
        }
    },

    {
        Name = "Medical Fabricator",
        Price = 300,
        Limit = 4,
        Items = {
            {Identifier = "medicalfabricator", IsInstallation = true}
        }
    },

    {
        Name = "Research Station",
        Price = 290,
        Limit = 4,
        Items = {
            {Identifier = "op_researchterminal", IsInstallation = true}
        }
    },

    {
        Name = "Junction Box",
        Price = 180,
        Limit = 8,
        Items = {
            {Identifier = "junctionbox", IsInstallation = true}
        }
    },

    {
        Name = "Battery",
        Price = 300,
        Limit = 6,
        Items = {
            {Identifier = "battery", IsInstallation = true}
        }
    },

    {
        Name = "Super Capacitor",
        Price = 300,
        Limit = 4,
        Items = {
            {Identifier = "supercapacitor", IsInstallation = true}
        }
    },

    {
        Name = "Shuttle Engine",
        Price = 400,
        Limit = 3,
        Items = {
            {Identifier = "shuttleengine", IsInstallation = true}
        }
    },

    {
        Name = "Small Pump",
        Price = 300,
        Limit = 3,
        Items = {
            {Identifier = "smallpump", IsInstallation = true}
        }
    },

    {
        Name = "Nuclear Reactor",
        Price = 1500,
        Limit = 1,
        Items = {
            {Identifier = "reactor1", IsInstallation = true}
        }
    },

    {
        Name = "Navigation Terminal",
        Price = 370,
        Limit = 2,
        Items = {
            {Identifier = "navterminal", IsInstallation = true}
        }
    },

    {
        Name = "Camera",
        Price = 110,
        Limit = 5,
        Items = {
            {Identifier = "camera", IsInstallation = true}
        }
    },

    {
        Name = "Periscope",
        Price = 180,
        Limit = 5,
        Items = {
            {Identifier = "periscope", IsInstallation = true}
        }
    },

    {
        Name = "Lamp",
        Price = 50,
        Limit = 5,
        Items = {
            {Identifier = "lamp", IsInstallation = true}
        },
        Action = function (client, product, items)
            for key, value in pairs(items) do
                value.GetComponentString("LightComponent").IsOn = true
            end
        end
    },

    {
        Name = "Chair",
        Price = 25,
        Limit = 5,
        Items = {
            {Identifier = "opdeco_officechair", IsInstallation = true}
        },
    },

    {
        Name = "Bunk Beds",
        Price = 50,
        Limit = 5,
        Items = {
            {Identifier = "opdeco_bunkbeds", IsInstallation = true}
        },
    },

    {
        Name = "Wire",
        Price = 40,
        Limit = 8,
        Items = {
            {Identifier = "wire"}
        },
    },
}

return category