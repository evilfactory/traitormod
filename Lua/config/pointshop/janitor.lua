local category = {}

category.Identifier = "janitor"

category.CanAccess = function(client)
    return client.Character and not client.Character.IsDead and client.Character.HasJob("janitor")
end

category.Products = {
    {
        Price = 50,
        Limit = 10,
        Items = {"bodybag"}
    },

    {
        Price = 150,
        Limit = 2,
        Items = {"opium", "opium"}
    },

    {
        Price = 75,
        Limit = 5,
        Items = {"ethanol"}
    },

    {
        Price = 250,
        Limit = 3,
        Items = {"respawndivingsuit"}
    },

    {
        Price = 1750,
        Limit = 1,
        Items = {"frogsparalyzantsprayer"}
    },

    {
        Price = 500,
        Limit = 1,
        Items = {"clownmask"}
    },

    {
        Price = 500,
        Limit = 1,
        Items = {"clowncostume"}
    },

    {
        Price = 150,
        Limit = 3,
        Items = {"clowncrate"}
    },

    {
        Price = 85,
        Limit = 1,
        Items = {"scp_memehorn"}
    },

    {
        Price = 200,
        Limit = 2,
        Items = {"he-beerclownjuice"}
    },
}

return category
