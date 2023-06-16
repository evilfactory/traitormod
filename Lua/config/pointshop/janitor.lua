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
        Price = 400,
        Limit = 2,
        Items = {"opium", "opium"}
    },

    {
        Price = 250,
        Limit = 5,
        Items = {"ethanol"}
    },

    {
        Price = 450,
        Limit = 3,
        Items = {"respawndivingsuit"}
    },

    {
        Price = 2850,
        Limit = 1,
        Items = {"frogsparalyzantsprayer"}
    },

    {
        Price = 750,
        Limit = 1,
        Items = {"clownmask"}
    },

    {
        Price = 750,
        Limit = 1,
        Items = {"clowncostume"}
    },

    {
        Price = 200,
        Limit = 3,
        Items = {"clowncrate"}
    },

    {
        Price = 500,
        Limit = 1,
        Items = {"scp_memehorn"}
    },

    {
        Price = 600,
        Limit = 2,
        Items = {"he-beerclownjuice"}
    },
}

return category