local category = {}

category.Name = "Traitor"
category.Decoration = "clown"
category.FadeToBlack = true

category.CanAccess = function(client)
    return client.Character and not client.Character.IsDead and client.Character.IsTraitor
end

Hook.Patch("Barotrauma.Items.Components.Projectile", "HandleProjectileCollision", function (instance, ptable)
    local target = ptable["target"]

    if not instance.Launcher then return end
    if not instance.Launcher.HasTag("teleporter") then return end
    if instance.User == nil then return end
    if target == nil then return end
    if target.Body == nil then return end

    if tostring(target.Body.UserData) == "Barotrauma.Limb" then
        local character = target.Body.UserData.character

        local oldPosition = instance.User.WorldPosition
        instance.User.TeleportTo(character.WorldPosition)
        character.TeleportTo(oldPosition)
    else
        instance.User.TeleportTo(instance.Item.WorldPosition)
    end
end)

category.Products = {
    {
        Name = "Explosive Auto-Injector",
        Price = 2500,
        Limit = 1,
        IsLimitGlobal = false,
        Action = function (client)
            local prefabInjector = ItemPrefab.GetItemPrefab("autoinjectorheadset")
            local prefabUEX = ItemPrefab.GetItemPrefab("uex")
            Entity.Spawner.AddItemToSpawnQueue(prefabInjector, client.Character.Inventory, nil, nil, function (item)
                Entity.Spawner.AddItemToSpawnQueue(prefabUEX, client.Character.Inventory, nil, nil, function (item2)
                    item2.Tags = "medical"
                    item2.Description = "A modified UEX that can be put inside an Auto-Injector headset."
                    item2.set_InventoryIconColor(Color(0, 0, 255))
                    item2.SpriteColor = Color(0, 0, 255, 255)

                    local color = item2.SerializableProperties[Identifier("SpriteColor")]
                    Networking.CreateEntityEvent(item2, Item.ChangePropertyEventData(color, item2))            
                    local invColor = item2.SerializableProperties[Identifier("InventoryIconColor")]
                    Networking.CreateEntityEvent(item2, Item.ChangePropertyEventData(invColor, item2))
                end)
            end)
        end
    },

    {
        Name = "Invisible Suit (protip: hide your id card and keep your health full)",
        Price = 800,
        Limit = 1,
        IsLimitGlobal = false,
        Action = function (client)
            local suit = ItemPrefab.GetItemPrefab("divingsuit")
            Entity.Spawner.AddItemToSpawnQueue(suit, client.Character.Inventory, nil, nil, function (item)
                local light = item.GetComponentString("LightComponent")

                item.set_InventoryIconColor(Color(255, 255, 255, 50))
                item.SpriteColor = Color(0, 0, 0, 0)
                item.Tags = "smallitem"
                light.LightColor = Color(0, 0, 0, 0)

                local color = item.SerializableProperties[Identifier("SpriteColor")]
                Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(color, item))            
                local invColor = item.SerializableProperties[Identifier("InventoryIconColor")]
                Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(invColor, item))
                local lightColor = light.SerializableProperties[Identifier("LightColor")]
                Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(lightColor, light))

                Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("oxygentank"), item.OwnInventory)
            end)
        end
    },

    {
        Name = "Teleporter Revolver",
        Price = 1200,
        Limit = 1,
        IsLimitGlobal = false,
        Action = function (client)
            local revolver = ItemPrefab.GetItemPrefab("revolver")
            Entity.Spawner.AddItemToSpawnQueue(revolver, client.Character.Inventory, nil, nil, function (item)
                item.Tags = "teleporter"
                item.Description = "‖color:gui.red‖A special revolver with teleportation features...‖color:end‖"

                item.set_InventoryIconColor(Color(0, 0, 255, 255))
                item.SpriteColor = Color(0, 0, 255, 255)

                local color = item.SerializableProperties[Identifier("SpriteColor")]
                Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(color, item))            
                local invColor = item.SerializableProperties[Identifier("InventoryIconColor")]
                Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(invColor, item))

                for i = 1, 6, 1 do
                    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("revolverround"), item.OwnInventory)
                end
            end)
        end
    },

    {
        Name = "Boom Stick",
        Price = 3200,
        Limit = 1,
        IsLimitGlobal = false,
        Items = {"shotgununique", 
        "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell","shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell"},
    },

    {
        Name = "Shotgun Shell (x8)",
        Price = 320,
        Limit = 5,
        IsLimitGlobal = false,
        Items = {"shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell", "shotgunshell"},
    },

    {
        Name = "Deadeye Carbine",
        Price = 2900,
        Limit = 1,
        IsLimitGlobal = false,
        Items = {"smgunique", "smgmagazine", "smgmagazine"},
    },

    {
        Name = "SMG Magazine",
        Price = 250,
        Limit = 5,
        IsLimitGlobal = false,
        Items = {"smgmagazine"},
    },

    {
        Name = "Prototype Steam Cannon",
        Price = 1300,
        Limit = 1,
        IsLimitGlobal = false,
        Items = {"flamerunique", "incendiumfueltank"},
    },

    {
        Name = "Detonator",
        Price = 950,
        Limit = 3,
        IsLimitGlobal = false,
        Items = {"detonator"},
    },

    {
        Name = "UEX",
        Price = 700,
        Limit = 5,
        IsLimitGlobal = false,
        Items = {"uex"},
    },

    {
        Name = "Stun Grenade",
        Price = 600,
        Limit = 3,
        IsLimitGlobal = false,
        Items = {"stungrenade"},
    },

    {
        Name = "Mutated Pomegrenade",
        Price = 530,
        Limit = 3,
        IsLimitGlobal = false,
        Items = {"badcreepingorange"},
    },

    {
        Name = "Turn Off Lights For 3 Minutes",
        Price = 350,
        Limit = 1,
        IsLimitGlobal = true,

        CanBuy = function (client, product)
            return not Traitormod.RoundEvents.IsEventActive("LightsOff")
        end,

        Action = function ()
            Traitormod.RoundEvents.TriggerEvent("LightsOff")
        end
    },

    {
        Name = "Turn Off Communications For 5 Minutes",
        Price = 400,
        Limit = 1,
        IsLimitGlobal = true,

        CanBuy = function (client, product)
            return not Traitormod.RoundEvents.IsEventActive("CommunicationsOffline")
        end,

        Action = function ()
            Traitormod.RoundEvents.TriggerEvent("CommunicationsOffline")
        end
    },
}

return category