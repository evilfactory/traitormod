local category = {}

category.Name = "Medical"
category.IsTraitorOnly = false

-- this is just so i don't need to type out all the 34 different unresearched genetic materials
local geneticMaterials = {}
for prefab in ItemPrefab.Prefabs do
    if string.find(prefab.Identifier.Value, "_unresearched") then
        table.insert(geneticMaterials, prefab.Identifier.Value)
    end
end

category.Products = {
    {
        Name = "Bandage",
        Price = 450,
        Limit = 4,
        Items = {"bandage"}
    },

    {
        Name = "Opium",
        Price = 1300,
        Limit = 3,
        Items = {"opium"}
    },

    {
        Name = "Saline",
        Price = 700,
        Limit = 2,
        Items = {"saline"}
    },

    {
        Name = "Ethanol",
        Price = 160,
        Limit = 4,
        Items = {"ethanol"}
    },

    {
        Name = "Adrenaline Gland",
        Price = 370,
        Limit = 5,
        Items = {"adrenalinegland"}
    },

    {
        Name = "Aquatic Poppy",
        Price = 300,
        Limit = 5,
        Items = {"aquaticpoppy"}
    },

    {
        Name = "Elastic Plant",
        Price = 100,
        Limit = 5,
        Items = {"elastinplant"}
    },

    {
        Name = "Fiber Plant",
        Price = 230,
        Limit = 5,
        Items = {"fiberplant"}
    },

    {
        Name = "Sea Yeast Shroom",
        Price = 175,
        Limit = 5,
        Items = {"yeastshroom"}
    },

    {
        Name = "Slime Bacteria",
        Price = 190,
        Limit = 5,
        Items = {"slimebacteria"}
    },

    {
        Name = "Swim Bladder",
        Price = 250,
        Limit = 5,
        Items = {"swimbladder"}
    },

    {
        Name = "Advanced Gene Splicer",
        Price = 1800,
        Limit = 2,
        Items = {"advancedgenesplicer"}
    },

    {
        Name = "Unresearched Genetic Material",
        Price = 250,
        Limit = 10,
        ItemRandom = true,
        Items = geneticMaterials
    },
}

return category