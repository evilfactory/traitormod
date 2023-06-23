local category = {}

category.Identifier = "cultist"
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
    --revival fluid
    Hook.Patch("Barotrauma.Items.Components.MeleeWeapon", "HandleImpact", function (instance, ptable)
        if not instance.Item.HasTag("revivalfluid") then return end

        local limb = ptable["targetFixture"].Body.UserData
        if limb == nil or not LuaUserData.IsTargetType(limb, "Barotrauma.Limb") then return end
        
        local character = limb.character
        if character == nil or not character.IsHuman or not character.IsDead then return end
        
        -- it will revive the character and give it the husk infection
        character.Revive()
        local infection = AfflictionPrefab.Prefabs["huskinfection"]
        character.CharacterHealth.ApplyAffliction(character.AnimController.MainLimb, infection.Instantiate(100))
        local affliction = character.CharacterHealth.GetAffliction("huskinfection", true)
        if affliction then
            affliction._strength = 100
        end

        Timer.Wait(function ()
            local client = Traitormod.FindClientCharacter(character)
            if client then
                client.SetClientCharacter(character)
            end
        end, 1500)
    end)
    --cultist stinger gives husk
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
        Price = 3500,
        Limit = 1,
        IsLimitGlobal = true,
        Items = {"hackingdevice"},
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

                local effect = holdable.statusEffectLists[ActionType.OnSuccess][1]
                effect.set_Afflictions({husk.Instantiate(0.5)})

                effect = holdable.statusEffectLists[ActionType.OnFailure][1]
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
        Identifier = "choke",
        Price = 500,
        Limit = 1,
        IsLimitGlobal = false,
        Action = function (client)
            local revolver = ItemPrefab.GetItemPrefab("divingmask")
            Entity.Spawner.AddItemToSpawnQueue(revolver, client.Character.Inventory, nil, nil, function (item)
                item.Tags = "chocker"
                item.Description = Traitormod.Language.Pointshop.choke_desc

                item.set_InventoryIconColor(Color(255, 0, 0, 50))
                item.SpriteColor = Color(255, 0, 0, 50)

                local color = item.SerializableProperties[Identifier("SpriteColor")]
                Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(color, item))            
                local invColor = item.SerializableProperties[Identifier("InventoryIconColor")]
                Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(invColor, item))

            end)
        end  
    },

    {
        Identifier = "fakehandcuffs",
        Price = 400,
        Limit = 2,
        IsLimitGlobal = false,
        Action = function (client)
            -- logic is implemented in pointshop/traitor.lua
            local handcuffs = ItemPrefab.GetItemPrefab("handcuffs")
            Entity.Spawner.AddItemToSpawnQueue(handcuffs, client.Character.Inventory, nil, nil, function (item)
                item.Tags = "fakehandcuffs"
                Traitormod.SendChatMessage(client, Traitormod.Language.FakeHandcuffsUsage , Color.Aqua)
            end)
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
        Identifier = "revivalfluid",
        Price = 1150,
        Limit = 2,
        IsLimitGlobal = false,
        Action = function (client, product, items)
            local prefabHuskeggs = ItemPrefab.GetItemPrefab("huskeggs")
            Entity.Spawner.AddItemToSpawnQueue(prefabHuskeggs, client.Character.Inventory, nil, nil, function (item)
                item.Tags = "revivalfluid"
                item.Description = Traitormod.Language.Pointshop.revivalfluid_desc
                
                item.set_InventoryIconColor(Color(255, 191, 0))
                item.SpriteColor = Color(255, 191, 0)
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
        Identifier = "turnofflights",
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
}

return category
