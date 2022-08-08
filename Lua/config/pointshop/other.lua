local category = {}

category.Name = "Other"
category.IsTraitorOnly = false

category.Products = {
    {
        Name = "Moloch Shell Fragment",
        Price = 340,
        Limit = 1,
        Items = {"shellshield"}
    },

    {
        Name = "Disposable Diving Suit",
        Price = 400,
        Limit = 1,
        Items = {"respawndivingsuit"}
    },

    {
        Name = "Diving Mask",
        Price = 280,
        Limit = 1,
        Items = {"divingmask"}
    },

    {
        Name = "Bike Horn",
        Price = 350,
        Limit = 10,
        Items = {"bikehorn"}
    },
}

return category