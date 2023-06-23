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
        Price = 75,
        Limit = 4,
        Items = {"bandage", "bandage"}
    },

    {
        Price = 100,
        Limit = 3,
        Items = {"opium", "opium"}
    },

    {
        Price = 200,
        Limit = 4,
        Items = {"bloodpackominus"}
    },

    {
        Price = 120,
        Limit = 8,
        Items = {"bloodpackoplus"}
    },

    {
        Price = 210,
        Limit = 2,
        Items = {"osteosynthesisimplants"}
    },

    {
        Price = 350,
        Limit = 2,
        Items = {"spinalimplant"}
    },

    {
        Price = 650,
        Limit = 1,
        Items = {"stasisbag"}
    },

    {
        Price = 100,
        Limit = 8,
        Items = {"ointment"}
    },

    {
        Price = 200,
        Limit = 3,
        Items = {"deusizine"}
    },

    {
        Price = 50,
        Limit = 4,
        Items = {"ethanol"}
    },

    {
        Price = 65,
        Limit = 4,
        Items = {"chlorine"}
    },

    {
        Price = 100,
        Limit = 4,
        Items = {"sulphuricacid"}
    },

    {
        Price = 95,
        Limit = 4,
        Items = {"alienblood"}
    },

    {
        Price = 150,
        Limit = 3,
        Items = {"meth"}
    },

    {
        Price = 250,
        Limit = 1,
        Items = {"paralyxis"}
    },

    {
        Price = 120,
        Limit = 2,
        Items = {"adrenalinegland"}
    },

    {
        Price = 165,
        Limit = 3,
        Items = {"aquaticpoppy"}
    },

    {
        Price = 75,
        Limit = 3,
        Items = {"elastinplant"}
    },

    {
        Price = 75,
        Limit = 3,
        Items = {"fiberplant"}
    },

    {
        Price = 75,
        Limit = 3,
        Items = {"yeastshroom"}
    },

    {
        Price = 100,
        Limit = 3,
        Items = {"slimebacteria"}
    },

    {
        Price = 75,
        Limit = 2,
        Items = {"swimbladder"}
    },

    {
        Price = 2000,
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
