local category = {}

category.Identifier = "attacker"
category.Gamemode = "AttackDefend"

category.CanAccess = function(client)
    return client.Character and not client.Character.IsDead and Traitormod.RoleManager.HasRole(client.Character, "Attacker")
end

category.Products = {
    {
        Price = 90,
        Limit = 1,
        Items = {"screwdriver"}
    },

}

return category