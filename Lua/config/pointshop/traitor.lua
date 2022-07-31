local category = {}

category.Name = "Traitor"
category.IsTraitorOnly = true

category.Products = {
    {
        Name = "Frag Grenade",
        Price = 500,
        Limit = 1,
        IsLimitGlobal = true,
        Items = {"fraggrenade"},
    }
}

return category