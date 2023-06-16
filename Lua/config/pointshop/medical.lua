local category = {}

category.Identifier = "medical"

-- this is just so i don't need to type out all the 34 different unresearched genetic materials
local geneticMaterials = {}
for prefab in ItemPrefab.Prefabs do
    if string.find(prefab.Identifier.Value, "_unresearched") then
        table.insert(geneticMaterials, prefab.Identifier.Value)
    end
end

category.CanAccess = function(client)
    return client.Character and not client.Character.IsDead and client.Character.HasJob("prisondoctor")
end

category.Products = {
    {
        Price = 130,
        Limit = 4,
        Items = {"bandage", "bandage"}
    },

    {
        Price = 130,
        Limit = 3,
        Items = {"opium", "opium"}
    },

    {
        Price = 550,
        Limit = 4,
        Items = {"bloodpackominus"}
    },

    {
        Price = 300,
        Limit = 8,
        Items = {"bloodpackoplus"}
    },

    {
        Price = 80,
        Limit = 4,
        Items = {"ethanol"}
    },

    {
        Price = 70,
        Limit = 4,
        Items = {"chlorine"}
    },

    {
        Price = 60,
        Limit = 4,
        Items = {"sulphuricacid"}
    },

    {
        Price = 105,
        Limit = 4,
        Items = {"alienblood"}
    },

    {
        Price = 80,
        Limit = 8,
        Items = {"meth"}
    },

    {
        Price = 200,
        Limit = 1,
        Items = {"paralyxis"}
    },

    {
        Price = 60,
        Limit = 5,
        Items = {"adrenalinegland"}
    },

    {
        Price = 70,
        Limit = 5,
        Items = {"aquaticpoppy"}
    },

    {
        Price = 50,
        Limit = 5,
        Items = {"elastinplant"}
    },

    {
        Price = 60,
        Limit = 5,
        Items = {"fiberplant"}
    },

    {
        Price = 65,
        Limit = 5,
        Items = {"yeastshroom"}
    },

    {
        Price = 80,
        Limit = 5,
        Items = {"slimebacteria"}
    },

    {
        Price = 250,
        Limit = 5,
        Items = {"swimbladder"}
    },

    {
        Price = 2300,
        Limit = 1,
        Items = {"advancedgenesplicer"}
    },

    {
        Price = 250,
        Limit = 10,
        ItemRandom = true,
        Items = geneticMaterials
    },
}

return category