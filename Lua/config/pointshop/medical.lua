local category = {}

category.Name = "Medical"
category.IsTraitorOnly = false

category.Products = {
    {
        Name = "Bandage",
        Price = 100,
        Limit = 4,
        Items = {"bandage"}
    },

    {
        Name = "Morphine",
        Price = 100,
        Limit = 4,
        Items = {"morphine"}
    },
}

return category