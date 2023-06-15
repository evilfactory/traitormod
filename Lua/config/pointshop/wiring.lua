local category = {}

category.Identifier = "wiring"

category.Products = {
    {
        Price = 400,
        Limit = 4,
        Items = {
            {Identifier = "door", IsInstallation = true}
        }
    },

    {
        Price = 400,
        Limit = 4,
        Items = {
            {Identifier = "hatch", IsInstallation = true}
        }
    },

    {
        Price = 800,
        Limit = 2,
        Items = {
            {Identifier = "dischargecoil", IsInstallation = true}
        }
    },

    {
        Price = 100,
        Limit = 6,
        Items = {
            {Identifier = "suppliescabinet", IsInstallation = true}
        }
    },

    {
        Price = 200,
        Limit = 6,
        Items = {
            {Identifier = "shuttleoxygenerator", IsInstallation = true}
        }
    },

    {
        Price = 230,
        Limit = 4,
        Items = {
            {Identifier = "fabricator", IsInstallation = true}
        }
    },

    {
        Price = 235,
        Limit = 4,
        Items = {
            {Identifier = "deconstructor", IsInstallation = true}
        }
    },

    {
        Price = 300,
        Limit = 4,
        Items = {
            {Identifier = "medicalfabricator", IsInstallation = true}
        }
    },

    {
        Price = 290,
        Limit = 4,
        Items = {
            {Identifier = "op_researchterminal", IsInstallation = true}
        }
    },

    {
        Price = 180,
        Limit = 8,
        Items = {
            {Identifier = "junctionbox", IsInstallation = true}
        }
    },

    {
        Price = 300,
        Limit = 6,
        Items = {
            {Identifier = "battery", IsInstallation = true}
        }
    },

    {
        Price = 300,
        Limit = 4,
        Items = {
            {Identifier = "supercapacitor", IsInstallation = true}
        }
    },

    {
        Price = 400,
        Limit = 3,
        Items = {
            {Identifier = "shuttleengine", IsInstallation = true}
        },
        CanBuy = function (client, product)
            if client.Character and client.Character.Submarine then
                return true
            end
            return false
        end
    },

    {
        Price = 300,
        Limit = 3,
        Items = {
            {Identifier = "smallpump", IsInstallation = true}
        }
    },

    {
        Price = 1500,
        Limit = 1,
        Items = {
            {Identifier = "reactor1", IsInstallation = true}
        }
    },

    {
        Price = 370,
        Limit = 2,
        Items = {
            {Identifier = "navterminal", IsInstallation = true}
        }
    },

    {
        Price = 110,
        Limit = 5,
        Items = {
            {Identifier = "camera", IsInstallation = true}
        }
    },

    {
        Price = 180,
        Limit = 5,
        Items = {
            {Identifier = "periscope", IsInstallation = true}
        }
    },

    {
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
        Price = 25,
        Limit = 5,
        Items = {
            {Identifier = "opdeco_officechair", IsInstallation = true}
        },
    },

    {
        Price = 50,
        Limit = 5,
        Items = {
            {Identifier = "opdeco_bunkbeds", IsInstallation = true}
        },
    },

    {
        Price = 40,
        Limit = 8,
        Items = {
            {Identifier = "wire"}
        },
    },
}

return category