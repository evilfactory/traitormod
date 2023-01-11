local category = {}

category.Name = "Cultist"
category.Decoration = "cultist"
category.FadeToBlack = true

category.CanAccess = function(client)
    return client.Character and not client.Character.IsDead and Traitormod.RoleManager.HasRole(client.Character, "Cultist")
end

LuaUserData.MakeMethodAccessible(Descriptors["Barotrauma.StatusEffect"], "set_Afflictions")
LuaUserData.MakeFieldAccessible(Descriptors["Barotrauma.Affliction"], "_strength")

category.Init = function ()
    local replacement = [[
        <overwrite>
        <StatusEffect type="OnUse" target="This" Condition="-100.0" disabledeltatime="true" />
        <StatusEffect type="OnUse" target="Character">
          <!-- HuskInfectionState must be less than 0.01 so you can't speed up the infection -->
          <Affliction identifier="huskinfection" amount="5" />
        </StatusEffect>
        <!-- Remove the item when fully used -->
        <StatusEffect type="OnBroken" target="This">
          <Remove />
        </StatusEffect>
        </overwrite>
    ]]
    
    local husk = ItemPrefab.GetItemPrefab("huskeggs")
    local element = husk.ConfigElement.Element.Element("MeleeWeapon")
    Traitormod.Patching.RemoveAll(element, "StatusEffect")
    Traitormod.Patching.Add(element, replacement)
    
    Hook.Add("think", "Traitormod.Pointshop.Cultist.SpeedyHusk", function ()
        for key, value in pairs(Character.CharacterList) do
            if value.IsHuman then
                local aff = value.CharacterHealth.GetAffliction("huskinfection", true)
                if aff ~= nil and aff.Strength > 60 then
                    aff._strength = aff._strength + 0.01
                elseif aff ~= nil and aff.Strength > 30 then
                    aff._strength = aff._strength + 0.007
                end
            end
        end
    end)
end

category.Products = {
    {
        Name = "Calyx Extract",
        Price = 0,
        Limit = 8,
        IsLimitGlobal = false,
        Items = {"huskeggs"},
    },

    {
        Name = "Husk Stinger",
        Price = 100,
        Limit = 4,
        IsLimitGlobal = false,
        Items = {"huskstinger"},
    },

    {
        Name = "Husk Auto-Injector",
        Price = 500,
        Limit = 1,
        IsLimitGlobal = false,
        Action = function (client)
            local prefabInjector = ItemPrefab.GetItemPrefab("autoinjectorheadset")
            local prefabUEX = ItemPrefab.GetItemPrefab("huskeggs")
            Entity.Spawner.AddItemToSpawnQueue(prefabInjector, client.Character.Inventory, nil, nil, function (item)
                Entity.Spawner.AddItemToSpawnQueue(prefabUEX, client.Character.Inventory, nil, nil, function (item2)
                    item2.Description = "Highly active husk eggs."
                    item2.set_InventoryIconColor(Color(0, 0, 255))
                    item2.SpriteColor = Color(0, 0, 255, 255)

                    local color = item2.SerializableProperties[Identifier("SpriteColor")]
                    Networking.CreateEntityEvent(item2, Item.ChangePropertyEventData(color, item2))            
                    local invColor = item2.SerializableProperties[Identifier("InventoryIconColor")]
                    Networking.CreateEntityEvent(item2, Item.ChangePropertyEventData(invColor, item2))

                    local melee = item2.GetComponentString("MeleeWeapon")
                    local effect = melee.statusEffectLists[2][2]
                    effect.Afflictions[1]._strength = 9999
                    local melee = item2.GetComponentString("Projectile")
                    effect = melee.statusEffectLists[14][2]
                    effect.Afflictions[1]._strength = 9999

                end)
            end)
        end
    },

    {
        Name = "Husked Blood Pack",
        Price = 100,
        Limit = 4,
        IsLimitGlobal = false,
        Action = function (client)
            local prefabInjector = ItemPrefab.GetItemPrefab("antibloodloss2")
            Entity.Spawner.AddItemToSpawnQueue(prefabInjector, client.Character.Inventory, nil, nil, function (item)
                local holdable = item.GetComponentString("Holdable")

                local husk = AfflictionPrefab.Prefabs["huskinfection"]

                local effect = holdable.statusEffectLists[22][1]
                effect.set_Afflictions({husk.Instantiate(1)})

                effect = holdable.statusEffectLists[9][1]
                effect.set_Afflictions({husk.Instantiate(1)})

            end)
        end
    },

    {
        Name = "Acid Grenade (4x)",
        Price = 290,
        Limit = 3,
        IsLimitGlobal = false,
        Items = {"chemgrenade", "chemgrenade", "chemgrenade", "chemgrenade"},
    },

    {
        Name = "Europabrew (4x)",
        Price = 120,
        Limit = 3,
        IsLimitGlobal = false,
        Items = {"europabrew", "europabrew", "europabrew", "europabrew"},
    },

    {
        Name = "Chloral Hydrate (4x)",
        Price = 150,
        Limit = 3,
        IsLimitGlobal = false,
        Items = {"chloralhydrate", "chloralhydrate", "chloralhydrate", "chloralhydrate"},
    },

    {
        Name = "Detonator",
        Price = 950,
        Limit = 3,
        IsLimitGlobal = false,
        Items = {"detonator"},
    },
}

return category