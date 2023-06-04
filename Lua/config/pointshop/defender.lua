local category = {}

category.Identifier = "defender"
category.Gamemode = "AttackDefend"

category.CanAccess = function(client)
    return client.Character and not client.Character.IsDead and Traitormod.RoleManager.HasRole(client.Character, "Defender")
end

category.Products = {
    {
        Price = 90,
        Limit = 1,
        Items = {"screwdriver"}
    },

}

return category