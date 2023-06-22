local category = {}

category.Identifier = "chef"

category.CanAccess = function(client)
    return client.Character and not client.Character.IsDead and client.Character.HasJob("he-chef")
end

category.Products = {
    {
        Price = 85,
        Limit = 3,
        Items = {"he-sugar", "he-sugar"}
    },

    {
        Price = 85,
        Limit = 3,
        Items = {"he-flour", "he-flour"}
    },

    {
        Price = 250,
        Limit = 2,
        Items = {"he-ketchup"}
    },

    {
        Price = 150,
        Limit = 3,
        Items = {"he-crawlermeatchunk"}
    },

    {
        Price = 350,
        Limit = 3,
        Items = {"he-threshermeatchunk"}
    },

    {
        Price = 250,
        Limit = 2,
        Items = {"he-milk"}
    },

    {
        Price = 125,
        Limit = 4,
        Items = {"creepingorange"}
    },

    {
        Price = 100,
        Limit = 4,
        Items = {"saltbulb"}
    },

    {
        Price = 150,
        Limit = 4,
        Items = {"bubbleberries"}
    },

    {
        Price = 100,
        Limit = 1,
        IsLimitGlobal = true,
        Items = {"he-jarcrate"}
    },

    {
        Price = 250,
        Limit = 1,
        IsLimitGlobal = true,
        Items = {"he-refillstation"}
    },

    {
        Price = 325,
        Limit = 1,
        IsLimitGlobal = true,
        Items = {"he-brewkettle"}
    },

    {
        Price = 150,
        Limit = 1,
        IsLimitGlobal = true,
        Items = {"he-cafeteriacart"}
    },

    {
        Price = 375,
        Limit = 1,
        IsLimitGlobal = true,
        Items = {"he-bottleprinter"}
    },

    {
        Price = 425,
        Limit = 1,
        IsLimitGlobal = true,
        Items = {"he-distiller"}
    },

    {
        Price = 250,
        Limit = 2,
        Items = {"he-kegempty"}
    },

    {
        Price = 200,
        Limit = 3,
        Items = {"he-energydrink1"}
    },

    {
        Price = 135,
        Limit = 5,
        Items = {"ethanol"}
    },

    {
        Price = 125,
        Limit = 5,
        Items = {"yeastshroom"}
    },

    {
        Price = 15,
        Limit = 15,
        Items = {"he-glassfragments"}
    },
}

return category
