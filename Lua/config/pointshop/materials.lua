local category = {}

category.Identifier = "materials"

category.CanAccess = function(client)
    if not client.Character or client.Character.IsDead then return false end
    if not client.Character.HasJob("convict") then
        return true
    elseif client.Character.Submarine ~= Submarine.MainSub then
        return true
    end

    return false
end

category.Products = {
    {
        Price = 120,
        Limit = 4,
        Items = {"aluminium"}
    },

    {
        Price = 60,
        Limit = 4,
        Items = {"steel"}
    },

    {
        Price = 35,
        Limit = 4,
        Items = {"iron"}
    },

    {
        Price = 160,
        Limit = 4,
        Items = {"plastic"}
    },

    {
        Price = 170,
        Limit = 4,
        Items = {"rubber"}
    },

    {
        Price = 90,
        Limit = 4,
        Items = {"copper"}
    },

    {
        Price = 110,
        Limit = 4,
        Items = {"tin"}
    },

    {
        Price = 50,
        Limit = 4,
        Items = {"carbon"}
    },

    {
        Price = 80,
        Limit = 4,
        Items = {"lead"}
    },

    {
        Price = 100,
        Limit = 4,
        Items = {"titanium"}
    },

    {
        Price = 90,
        Limit = 4,
        Items = {"silicon"}
    },

    {
        Price = 95,
        Limit = 6,
        Items = {"scrap"}
    },

    {
        Price = 180,
        Limit = 4,
        Items = {"fulgurium"}
    },

    {
        Price = 200,
        Limit = 2,
        Items = {"physicorium"}
    },

    {
        Price = 200,
        Limit = 4,
        Items = {"sulphuriteshard"}
    },

    {
        Price = 300,
        Limit = 1,
        Items = {"incendium"}
    },

    {
        Price = 200,
        Limit = 4,
        Items = {"fulgurium"}
    },
}

return category