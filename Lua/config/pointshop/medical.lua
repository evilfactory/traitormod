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
        Price = 200,
        Limit = 4,
        Items = {"bandage", "bandage"}
    },

    {
        Price = 200,
        Limit = 3,
        Items = {"opium", "opium"}
    },

    {
        Price = 560,
        Limit = 4,
        Items = {"bloodpackominus"}
    },

    {
        Price = 310,
        Limit = 8,
        Items = {"bloodpackoplus"}
    },

    {
        Price = 450,
        Limit = 1,
        Items = {"osteosynthesisimplants"}
    },

    {
        Price = 650,
        Limit = 1,
        Items = {"spinalimplant"}
    },

    {
        Price = 1000,
        Limit = 1,
        Items = {"stasisbag"}
    },

    {
        Price = 310,
        Limit = 8,
        Items = {"ointment"}
    },

    {
        Price = 400,
        Limit = 3,
        Items = {"deusizine"}
    },

    {
        Price = 110,
        Limit = 4,
        Items = {"ethanol"}
    },

    {
        Price = 100,
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
        Price = 300,
        Limit = 3,
        Items = {"meth"}
    },

    {
        Price = 200,
        Limit = 1,
        Items = {"paralyxis"}
    },

    {
        Price = 130,
        Limit = 2,
        Items = {"adrenalinegland"}
    },

    {
        Price = 110,
        Limit = 3,
        Items = {"aquaticpoppy"}
    },

    {
        Price = 110,
        Limit = 3,
        Items = {"elastinplant"}
    },

    {
        Price = 110,
        Limit = 3,
        Items = {"fiberplant"}
    },

    {
        Price = 110,
        Limit = 3,
        Items = {"yeastshroom"}
    },

    {
        Price = 250,
        Limit = 3,
        Items = {"slimebacteria"}
    },

    {
        Price = 250,
        Limit = 2,
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