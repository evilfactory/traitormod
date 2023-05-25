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
        <!--Can't fail, but can't use OnUse for projectiles-->
        <StatusEffect type="OnUse" target="This">
            <LuaHook name="Cultist.Injected" />
        </StatusEffect>
        <StatusEffect type="OnSuccess" target="This" Condition="-100.0" setvalue="true"/>
        <StatusEffect type="OnSuccess" target="UseTarget" duration="60.0">
          <!-- HuskInfectionState must be less than 0.01 so you can't speed up the infection -->
          <Affliction identifier="huskinfection" amount="1" />
        </StatusEffect>
        <StatusEffect type="OnSuccess" target="UseTarget">
          <Conditional entitytype="eq Character"/>
          <Sound file="Content/Items/Medical/Syringe.ogg" range="500" />
        </StatusEffect>
        <StatusEffect type="OnImpact" target="UseTarget" multiplyafflictionsbymaxvitality="true" AllowWhenBroken="true">
          <Affliction identifier="stun" amount="0.1" />
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

    Hook.Add("Cultist.Injected", "Cultist.Injected", function (effect, deltaTime, item, targets, worldPosition)
        if item.HasTag("active") then
            if item.ParentInventory ~= nil and LuaUserData.IsTargetType(item.ParentInventory.Owner, "Barotrauma.Item") then
                local injector = item.ParentInventory.Owner
                if injector.ParentInventory ~= nil and LuaUserData.IsTargetType(injector.ParentInventory.Owner, "Barotrauma.Character") then
                    local character = injector.ParentInventory.Owner
                    if character.Inventory.GetItemInLimbSlot(InvSlotType.Headset) == injector then
                        local affliction = AfflictionPrefab.Prefabs["huskinfection"].Instantiate(95)
                        character.CharacterHealth.ApplyAffliction(character.AnimController.MainLimb, affliction)    
                    end
                end
            end
        end
    end)


    Hook.Add("meleeWeapon.handleImpact",  "Cultist.Stinger", function (melee, target)
        if melee.Item.Prefab.Identifier ~= "huskstinger" then return end
        if not LuaUserData.IsTargetType(target.UserData, "Barotrauma.Limb") then return end
        local character = target.UserData.character

        do
            local affliction = AfflictionPrefab.Prefabs["huskinfection"].Instantiate(2)
            character.CharacterHealth.ApplyAffliction(character.AnimController.MainLimb, affliction)
        end

        do -- speed up affliction, since its capped at 50% by default
            local affliction = character.CharacterHealth.GetAffliction("huskinfection", true)
            if affliction then
                affliction._strength = affliction._strength + 2
            end
        end
    end)
end

category.Products = {
    {
        Price = 100,
        Limit = 8,
        IsLimitGlobal = false,
        Items = {"huskeggs"},
    },

    {
        Identifier = "huskattractorbeacon",
        Price = 700,
        Limit = 1,
        IsLimitGlobal = false,
        Action = function (client)
            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("sonarbeacon"), client.Character.Inventory, nil, nil, function (item)
                item.Description = "‖color:160, 32, 240, 255‖A modified sonar beacon, behind it says \"Leave it active for 30 seconds for a surprise\"‖color:end‖"
                item.set_InventoryIconColor(Color(160, 32, 240))
                item.SpriteColor = Color(160, 32, 240)
                local color = item.SerializableProperties[Identifier("SpriteColor")]
                Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(color, item))
                local invColor = item.SerializableProperties[Identifier("InventoryIconColor")]
                Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(invColor, item))

                Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("batterycell"), item.OwnInventory, nil, nil, function (batteryCell)
                    batteryCell.NonPlayerTeamInteractable = true
                    local prop = batteryCell.SerializableProperties[Identifier("NonPlayerTeamInteractable")]
                    Networking.CreateEntityEvent(batteryCell, Item.ChangePropertyEventData(prop, batteryCell))
                end)

                local interface = item.GetComponentString("CustomInterface")
                interface.customInterfaceElementList[2].Signal = "Husk Beacon"
                item.CreateServerEvent(interface, interface)

                Traitormod.AddHuskBeacon(item, 30)
            end)
        end
    },

    {
        Price = 150,
        Limit = 4,
        IsLimitGlobal = false,
        Items = {"huskstinger"},
    },

    {
        Identifier = "huskautoinjector",
        Price = 600,
        Limit = 2,
        IsLimitGlobal = false,
        Action = function (client)
            local prefabInjector = ItemPrefab.GetItemPrefab("autoinjectorheadset")
            local prefabUEX = ItemPrefab.GetItemPrefab("huskeggs")
            Entity.Spawner.AddItemToSpawnQueue(prefabInjector, client.Character.Inventory, nil, nil, function (item)
                Entity.Spawner.AddItemToSpawnQueue(prefabUEX, item.OwnInventory, nil, nil, function (item2)
                    item2.Description = "Highly active husk eggs."
                    item2.set_InventoryIconColor(Color(0, 0, 255))
                    item2.SpriteColor = Color(0, 0, 255, 255)
                    item2.AddTag("active")

                    local color = item2.SerializableProperties[Identifier("SpriteColor")]
                    Networking.CreateEntityEvent(item2, Item.ChangePropertyEventData(color, item2))
                    local invColor = item2.SerializableProperties[Identifier("InventoryIconColor")]
                    Networking.CreateEntityEvent(item2, Item.ChangePropertyEventData(invColor, item2))

                    item2.NonPlayerTeamInteractable = true
                    local prop = item2.SerializableProperties[Identifier("NonPlayerTeamInteractable")]
                    Networking.CreateEntityEvent(item2, Item.ChangePropertyEventData(prop, item2))
                end)
            end)
        end
    },

    {
        Identifier = "huskedbloodpack",
        Price = 350,
        Limit = 4,
        IsLimitGlobal = false,
        Action = function (client)
            local prefabInjector = ItemPrefab.GetItemPrefab("antibloodloss2")
            Entity.Spawner.AddItemToSpawnQueue(prefabInjector, client.Character.Inventory, nil, nil, function (item)
                local holdable = item.GetComponentString("Holdable")

                local husk = AfflictionPrefab.Prefabs["huskinfection"]

                local effect = holdable.statusEffectLists[22][1]
                effect.set_Afflictions({husk.Instantiate(0.5)})

                effect = holdable.statusEffectLists[9][1]
                effect.set_Afflictions({husk.Instantiate(0.5)})

            end)
        end
    },

    {
        Identifier = "firemanscarrytalent",
        Price = 350,
        Limit = 1,
        IsLimitGlobal = false,
        Action = function (client, product, items)
            client.Character.GiveTalent("firemanscarry")
        end
    },

    {
        Identifier = "spawnhusk",
        Price = 150,
        Limit = 5,
        Action = function (client, product, items)
            Entity.Spawner.AddCharacterToSpawnQueue("husk", client.Character.WorldPosition, function (character)
            end)
        end
    },

    {
        Identifier = "invisibilitygear",
        Price = 800,
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

            local robes = ItemPrefab.GetItemPrefab("zealotrobes")
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
        Price = 500,
        Limit = 1,
        IsLimitGlobal = false,
        Items = {"advancedsyringegun"},
    },

    {
        Price = 30,
        Limit = 4,
        IsLimitGlobal = false,
        Items = {"skillbookeuropanmedicine"},
    },

    {
        Price = 370,
        Limit = 3,
        IsLimitGlobal = false,
        Items = {"chemgrenade", "chemgrenade", "chemgrenade", "chemgrenade"},
    },

    {
        Price = 120,
        Limit = 3,
        IsLimitGlobal = false,
        Items = {"europabrew", "europabrew", "europabrew", "europabrew"},
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
        Identifier = "huskoxygensupply",
        Price = 1400,
        Limit = 1,
        IsLimitGlobal = true,

        CanBuy = function (client, product)
            return not Traitormod.RoundEvents.IsEventActive("OxygenGeneratorHusk")
        end,

        Action = function ()
            Traitormod.RoundEvents.TriggerEvent("OxygenGeneratorHusk")
        end
    },
}

return category