local category = {}

category.Name = "Traitor"
category.IsTraitorOnly = true

category.Products = {
    {
        Name = "Boom Stick",
        Price = 3200,
        Limit = 1,
        IsLimitGlobal = false,
        Items = {"shotgununique", 
        "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell"},
    },

    {
        Name = "Deadeye Carbine",
        Price = 3200,
        Limit = 1,
        IsLimitGlobal = false,
        Items = {"smgunique", "smgmagazine", "smgmagazine"},
    },

    {
        Name = "Europan Handshake",
        Price = 2700,
        Limit = 1,
        IsLimitGlobal = false,
        Items = {"divingknifeunique"},
    },

    {
        Name = "Prototype Steam Cannon",
        Price = 1300,
        Limit = 1,
        IsLimitGlobal = false,
        Items = {"flamerunique", "incendiumfueltank"},
    },

    {
        Name = "Detonator",
        Price = 1350,
        Limit = 3,
        IsLimitGlobal = false,
        Items = {"detonator"},
    },

    {
        Name = "UEX Materials",
        Price = 1500,
        Limit = 5,
        IsLimitGlobal = false,
        Items = {"sodium", "phosphorus"},
    },

    --[[
    {
        Name = "Make You Explode Lol",
        Price = 10,
        Limit = 5,
        Items = {"compoundn"},
        Action = function (client, product, items)
            Timer.Wait(function ()
                items[1].Condition = 0
            end, 1000)
        end
    },
    ]]--
}

return category