local category = {}

category.Name = "Medical"

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
        Price = 120,
        Limit = 4,
        Items = {"bandage"}
    },

    {
        Name = "Opium",
        Price = 130,
        Limit = 3,
        Items = {"opium"}
    },

    {
        Name = "Saline",
        Price = 125,
        Limit = 2,
        Items = {"saline"}
    },

    {
        Name = "Ethanol",
        Price = 80,
        Limit = 4,
        Items = {"ethanol"}
    },

    {
        Name = "Chlorine",
        Price = 70,
        Limit = 4,
        Items = {"chlorine"}
    },

    {
        Name = "Sulphuric Acid",
        Price = 60,
        Limit = 4,
        Items = {"sulphuricacid"}
    },

    {
        Name = "Alien Blood",
        Price = 105,
        Limit = 4,
        Items = {"alienblood"}
    },

    {
        Name = "Adrenaline Gland",
        Price = 60,
        Limit = 5,
        Items = {"adrenalinegland"}
    },

    {
        Name = "Aquatic Poppy",
        Price = 70,
        Limit = 5,
        Items = {"aquaticpoppy"}
    },

    {
        Name = "Elastic Plant",
        Price = 50,
        Limit = 5,
        Items = {"elastinplant"}
    },

    {
        Name = "Fiber Plant",
        Price = 60,
        Limit = 5,
        Items = {"fiberplant"}
    },

    {
        Name = "Sea Yeast Shroom",
        Price = 65,
        Limit = 5,
        Items = {"yeastshroom"}
    },

    {
        Name = "Slime Bacteria",
        Price = 80,
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
        Name = "Gardening Kit",
        Price = 100,
        Limit = 2,
        Items = {"raptorbaneseed", "creepingorangevineseed", "saltvineseed", "tobaccovineseed", "smallplanter", "fertilizer", "wateringcan"}
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