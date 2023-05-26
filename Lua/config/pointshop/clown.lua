local category = {}

category.Name = "Clown"
category.Decoration = "cultist"
category.FadeToBlack = true

category.CanAccess = function(client)
    return client.Character and not client.Character.IsDead and Traitormod.RoleManager.HasRole(client.Character, "HonkmotherClown")
end

category.Init = function ()
    local spawnInstallation = function (submarine, position, prefab)
        if submarine == nil then
            Entity.Spawner.AddItemToSpawnQueue(prefab, position, nil, nil)
        else
            Entity.Spawner.AddItemToSpawnQueue(prefab, position - submarine.Position, submarine, nil, nil)
        end
    end

    Hook.Add("statusEffect.apply.fixfoamgrenade", "Traitormod.FixFoamGrenadeJail", function (effect, deltaTime, item, targets, worldPosition)
        if not item.HasTag("jailgrenade") then return end

        if effect.type == ActionType.OnSecondaryUse then
            local character
            for key, value in pairs(Character.CharacterList) do
                if Vector2.Distance(item.WorldPosition, value.WorldPosition) < 500 and value.IsHuman and not value.IsDead then
                    if character == nil or Vector2.Distance(item.WorldPosition, value.WorldPosition) < Vector2.Distance(item.WorldPosition, character.WorldPosition) then
                        character = value
                    end
                end
            end

            if character == nil then return end

            local submarine = character.Submarine
            spawnInstallation(submarine, character.WorldPosition - Vector2(0, 90), ItemPrefab.Prefabs["hatch"])
            spawnInstallation(submarine, character.WorldPosition + Vector2(0, 90), ItemPrefab.Prefabs["hatch"])
            spawnInstallation(submarine, character.WorldPosition - Vector2(50, 0), ItemPrefab.Prefabs["door"])
            spawnInstallation(submarine, character.WorldPosition + Vector2(50, 0), ItemPrefab.Prefabs["door"])

        end
    end)
end

category.Products = {
    {
        Price = 250,
        Limit = 4,
        IsLimitGlobal = false,
        Items = {"badcreepingorange"},
    },

    {
        Price = 10,
        Limit = 50,
        Items = {"bananapeel"}
    },

    {
        Price = 200,
        Limit = 3,
        Items = {"deliriumine"}
    },

    {
        Identifier = "jailgrenade",
        Price = 450,
        Limit = 3,
        IsLimitGlobal = false,
        Action = function (client)
            local grenade = ItemPrefab.GetItemPrefab("fixfoamgrenade")
            Entity.Spawner.AddItemToSpawnQueue(grenade, client.Character.Inventory, nil, nil, function (item)
                item.AddTag("jailgrenade")
                item.Description = Traitormod.Language.Pointshop.jailgrenade_desc

                item.set_InventoryIconColor(Color(255, 0, 0, 255))
                item.SpriteColor = Color(255, 0, 0, 255)

                local color = item.SerializableProperties[Identifier("SpriteColor")]
                Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(color, item))            
                local invColor = item.SerializableProperties[Identifier("InventoryIconColor")]
                Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(invColor, item))
            end)
        end
    },

    {
        Identifier = "clowngearcrate",
        Price = 400,
        Limit = 2,
        IsLimitGlobal = false,
        Action = function (client)
            local clownCrate = ItemPrefab.GetItemPrefab("clowncrate")
            Entity.Spawner.AddItemToSpawnQueue(clownCrate, client.Character.Inventory, nil, nil, function (item)
                local items = {"clowncostume", "clowncostume", "clownsuitunique", "clownsuitunique", "clowndivingmask", "clowndivingmask", "clownmask", "clownmask", "clownmaskunique", "clownmaskunique", "toyhammer", "bikehorn"}

                for key, value in pairs(items) do
                    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.Prefabs[value], item.OwnInventory)
                end
            end)
        end
    },

    {
        Identifier = "clownexosuit",
        Price = 1300,
        Limit = 1,
        IsLimitGlobal = false,
        Action = function (client)
            local clownExosuit = ItemPrefab.GetItemPrefab("clownexosuit")
            Entity.Spawner.AddItemToSpawnQueue(clownExosuit, client.Character.Inventory, nil, nil, function (item)
                local items = {"fuelrod", "oxygenitetank"}

                for key, value in pairs(items) do
                    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.Prefabs[value], item.OwnInventory)
                end
            end)
        end
    },

    {
        Price = 300,
        Limit = 10,
        Items = {"cymbals"}
    },

    {
        Price = 190,
        Limit = 5,
        Items = {"pressurestabilizer"}
    },

    {
        Price = 130,
        Limit = 5,
        Items = {"rum"}
    },

    {
        Price = 100,
        Limit = 10,
        Items = {"smallmudraptoregg", "saline", "saline"}
    },

    {
        Identifier = "clowntalenttree",
        Price = 400,
        Limit = 1,
        IsLimitGlobal = false,
        Action = function (client, product, items)
            client.Character.GiveTalent("enrollintoclowncollege")
            client.Character.GiveTalent("waterprankster")
            client.Character.GiveTalent("chonkyhonks")
            client.Character.GiveTalent("psychoclown")
            client.Character.GiveTalent("truepotential")
        end
    },

    {
        Identifier = "invisibilitygear",
        Price = 500,
        Limit = 1,
        IsLimitGlobal = false,
        Action = function (client)
            local suit = ItemPrefab.GetItemPrefab("divingsuit")
            Entity.Spawner.AddItemToSpawnQueue(suit, client.Character.Inventory, nil, nil, function (item)
                local light = item.GetComponentString("LightComponent")

                item.set_InventoryIconColor(Color(100, 100, 100, 50))
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

            local robes = ItemPrefab.GetItemPrefab("cultistrobes")
            Entity.Spawner.AddItemToSpawnQueue(robes, client.Character.Inventory, nil, nil, function (item)

                item.set_InventoryIconColor(Color(100, 100, 100, 50))
                item.SpriteColor = Color(0, 0, 0, 0)
                item.Tags = "smallitem"

                local color = item.SerializableProperties[Identifier("SpriteColor")]
                Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(color, item))            
                local invColor = item.SerializableProperties[Identifier("InventoryIconColor")]
                Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(invColor, item))
            end)

            local cap = ItemPrefab.GetItemPrefab("ironhelmet")
            Entity.Spawner.AddItemToSpawnQueue(cap, client.Character.Inventory, nil, nil, function (item)

                item.set_InventoryIconColor(Color(100, 100, 100, 50))
                item.SpriteColor = Color(0, 0, 0, 0)
                item.Tags = "smallitem"

                local color = item.SerializableProperties[Identifier("SpriteColor")]
                Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(color, item))            
                local invColor = item.SerializableProperties[Identifier("InventoryIconColor")]
                Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(invColor, item))
            end)
        end
    },

    {
        Price = 250,
        Limit = 4,
        IsLimitGlobal = false,
        Items = {"chloralhydrate", "chloralhydrate", "chloralhydrate", "chloralhydrate"},
    },

    {
        Price = 950,
        Limit = 3,
        IsLimitGlobal = false,
        Items = {"detonator"},
    },

    {
        Identifier = "clownmagic",
        Price = 650,
        Limit = 2,
        IsLimitGlobal = true,

        CanBuy = function (client, product)
            return not Traitormod.RoundEvents.IsEventActive("ClownMagic")
        end,

        Action = function ()
            Traitormod.RoundEvents.TriggerEvent("ClownMagic")
        end
    },

    {
        Identifier = "randomizelights",
        Price = 350,
        Limit = 2,
        IsLimitGlobal = true,

        CanBuy = function (client, product)
            return not Traitormod.RoundEvents.IsEventActive("RandomLights")
        end,

        Action = function ()
            Traitormod.RoundEvents.TriggerEvent("RandomLights")
        end
    },
}

return category