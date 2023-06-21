local category = {}

category.Identifier = "clown"
category.Decoration = "clown"
category.FadeToBlack = true

category.CanAccess = function(client)
    return client.Character and not client.Character.IsDead and Traitormod.RoleManager.HasRole(client.Character, "Clown")
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

    Hook.Add("traitormod.terminalWrite", "Traitormod.Pointshop.IdCardLocator", function (item, client, output)
        if not item.HasTag("idcardlocator") then return end
        if not client.Character then return end

        if output ~= "scan" then return end

        local terminal = item.GetComponentString("Terminal")
    
        for key, value in pairs(Util.GetItemsById("idcard")) do
            local distance = Vector2.Distance(client.Character.WorldPosition, value.WorldPosition)
            local idCard = value.GetComponentString("IdCard")
            local ownerJobName = idCard.OwnerJob and idCard.OwnerJob.Name or "Unknown"

            terminal.ShowMessage = string.format(Traitormod.Language.Pointshop.idcardlocator_result, tostring(ownerJobName), idCard.OwnerName, math.floor(distance))
        end

        terminal.SyncHistory()
    end)

    local replacement = [[
    <overwrite>
      <StatusEffect type="OnUse" target="UseTarget" delay="1" comparison="Or">
        <Conditional speciesname="latcher"/>
        <Conditional speciesname="endworm"/>
        <Conditional speciesname="charybdis"/>
        <TriggerEvent identifier="toyhammeronabyssmonster" />
      </StatusEffect>
      <StatusEffect type="OnUse" target="This" Condition="-50.0" setvalue="true"/>
      <Attack targetimpulse="2">
        <Affliction identifier="stun" strength="22" />
      </Attack>
      <StatusEffect type="OnUse" forceplaysounds="true">
        <Sound type="OnUse" file="Content/Items/Weapons/ToyHammerHit1.ogg" range="800" selectionmode="Random"/>
        <Sound type="OnUse" file="Content/Items/Weapons/ToyHammerHit2.ogg" range="800" />
        <Sound type="OnUse" file="Content/Items/Weapons/ToyHammerHit3.ogg" range="800" />
        <Sound type="OnUse" file="Content/Items/Weapons/ToyHammerHit4.ogg" range="800" />
        <Sound type="OnUse" file="Content/Items/Weapons/ToyHammerHit5.ogg" range="800" />
        <Sound type="OnUse" file="Content/Items/Weapons/ToyHammerHit6.ogg" range="800" />
      </StatusEffect>
      <StatusEffect type="OnBroken" target="This">
         <Remove />
      </StatusEffect>
    </overwrite>
    ]]

    local replacementClownSuit = [[
     <overwrite>
     <Wearable slots="Any,InnerClothes" msg="ItemMsgPickUpSelect">
        <sprite name="Legendary Clown's Costume Torso" texture="clown_rare.png" limb="Torso" hidelimb="false" inherittexturescale="true" inheritorigin="true" inheritsourcerect="true" />
        <sprite name="Legendary Clown's Costume Right Hand" texture="clown_rare.png" limb="RightHand" hidelimb="true" inherittexturescale="true" inheritorigin="true" inheritsourcerect="true" />
        <sprite name="Legendary Clown's Costume Left Hand" texture="clown_rare.png" limb="LeftHand" hidelimb="true" inherittexturescale="true" inheritorigin="true" inheritsourcerect="true" />
        <sprite name="Legendary Clown's Costume Right Lower Arm" texture="clown_rare.png" limb="RightArm" hidelimb="true" inherittexturescale="true" inheritorigin="true" inheritsourcerect="true" />
        <sprite name="Legendary Clown's Costume Left Lower Arm" texture="clown_rare.png" limb="LeftArm" hidelimb="true" inherittexturescale="true" inheritorigin="true" inheritsourcerect="true" />
        <sprite name="Legendary Clown's Costume Right Upper Arm" texture="clown_rare.png" limb="RightForearm" hidelimb="true" inherittexturescale="true" inheritorigin="true" inheritsourcerect="true" />
        <sprite name="Legendary Clown's Costume Left Upper Arm" texture="clown_rare.png" limb="LeftForearm" hidelimb="true" inherittexturescale="true" inheritorigin="true" inheritsourcerect="true" />
        <sprite name="Legendary Clown's Costume Waist" texture="clown_rare.png" limb="Waist" hidelimb="true" inherittexturescale="true" inheritorigin="true" inheritsourcerect="true" />
        <sprite name="Legendary Clown's Costume Right Thigh" texture="clown_rare.png" limb="RightThigh" hidelimb="true" inherittexturescale="true" inheritorigin="true" inheritsourcerect="true" />
        <sprite name="Legendary Clown's Costume Left Thigh" texture="clown_rare.png" limb="LeftThigh" hidelimb="true" inherittexturescale="true" inheritorigin="true" inheritsourcerect="true" />
        <sprite name="Legendary Clown's Costume Right Leg" texture="clown_rare.png" limb="RightLeg" hidelimb="true" inherittexturescale="true" inheritorigin="true" inheritsourcerect="true" />
        <sprite name="Legendary Clown's Costume Left Leg" texture="clown_rare.png" limb="LeftLeg" hidelimb="true" inherittexturescale="true" inheritorigin="true" inheritsourcerect="true" />
        <sprite name="Legendary Clown's Costume Left Shoe" texture="clown_rare.png" limb="LeftFoot" hidelimb="true" inherittexturescale="true" inheritorigin="true" inheritsourcerect="true" />
        <sprite name="Legendary Clown's Costume Right Shoe" texture="clown_rare.png" limb="RightFoot" hidelimb="true" inherittexturescale="true" inheritorigin="true" inheritsourcerect="true" />
        <!-- HöNK -->
        <damagemodifier armorsector="0.0,360.0" afflictionidentifiers="lacerations" damagemultiplier="0.8" damagesound="LimbClown" />
        <damagemodifier armorsector="0.0,360.0" afflictionidentifiers="gunshotwound, bitewounds" damagemultiplier="0.75" damagesound="LimbClown" />
      </Wearable>
      </overwrite>
    ]]

    local replacementClownMask = [[
        <overwrite>
        <Wearable slots="Any,Head" armorvalue="20.0" msg="ItemMsgPickUpSelect">
            <damagemodifier afflictionidentifiers="lacerations,gunshotwound" armorsector="0.0,360.0" damagemultiplier="0.45" damagesound="LimbArmor" deflectprojectiles="true" />
            <damagemodifier afflictionidentifiers="bitewounds, blunttrauma" armorsector="0.0,360.0" damagemultiplier="0.65" damagesound="LimbArmor" deflectprojectiles="true" />
            <damagemodifier afflictiontypes="bleeding" armorsector="0.0,360.0" damagemultiplier="0.35" damagesound="LimbArmor" deflectprojectiles="true" />
            <damagemodifier afflictionidentifiers="concussion" armorsector="0.0,360.0" damagemultiplier="0.0" damagesound="" deflectprojectiles="true" />
            <sprite name="Clown Mask Wearable" texture="Content/Items/Jobgear/headgears.png" limb="Head" inheritlimbdepth="true" inheritscale="true" ignorelimbscale="true" scale="0.65" sourcerect="414,417,89,71" origin="0.5,0.6" />
            <StatusEffect tags="clown" type="OnWearing" target="Character" HideFace="true" duration="0.1" stackable="false" />
        </Wearable>
        </overwrite>
       ]]

    local hammer = ItemPrefab.GetItemPrefab("toyhammer")
    local mothersuit = ItemPrefab.GetItemPrefab("clownsuitunique")
    local mothermask = ItemPrefab.GetItemPrefab("clownmaskunique")
    local element = hammer.ConfigElement.Element.Element("MeleeWeapon")
    local elementSuit = mothersuit.ConfigElement.Element.Element("Wearable")
    local elementMask = mothermask.ConfigElement.Element.Element("Wearable")
    Traitormod.Patching.RemoveAll(element, "StatusEffect")
    Traitormod.Patching.RemoveAll(elementSuit, "Wearable")
    Traitormod.Patching.RemoveAll(elementMask, "Wearable")
    Traitormod.Patching.Add(element, replacement)
    Traitormod.Patching.Add(elementSuit, replacementClownSuit)
    Traitormod.Patching.Add(elementMask, replacementClownMask)

    Hook.Add("item.use", "Clown.Boom", function (item, itemUser, targetLimb)
        if item.HasTag("medical") and item.HasTag("clownboom") then
            if item.ParentInventory ~= nil and LuaUserData.IsTargetType(item.ParentInventory.Owner, "Barotrauma.Item") then
                local injector = item.ParentInventory.Owner
                if injector.ParentInventory ~= nil and LuaUserData.IsTargetType(injector.ParentInventory.Owner, "Barotrauma.Character") then
                    local character = injector.ParentInventory.Owner
                    if character.Inventory.GetItemInLimbSlot(InvSlotType.Headset) == injector then
                        Game.Explode(character.WorldPosition, 450, 45, 85, 350, 25, 45, 1500)
                    end
                end
            end
        end
    end)
end

category.Products = {
    {
        Price = 100,
        Limit = 15,
        IsLimitGlobal = false,
        Items = {"clownmask"},
    },

    {
        Price = 25,
        Limit = 1,
        IsLimitGlobal = false,
        Items = {"bikehorn"},
    },

    {
        Identifier = "ClownEnsemble",
        Price = 250,
        Limit = 1,
        IsLimitGlobal = false,
        Items = {"clownmask", "clowncostume"},
    },

    {
        Identifier = "HonkmotherClothes",
        Price = 700,
        Limit = 1,
        IsLimitGlobal = true,
        Items = {"clownmaskunique", "clownsuitunique"},
    },

    {
        Price = 100,
        Limit = 2,
        IsLimitGlobal = false,
        Items = {"clowndivingmask"},
    },

    {
        Identifier = "hammerbuff",
        Price = 650,
        Limit = 2,
        IsLimitGlobal = false,
        Items = {"toyhammer"},
    },

    {
        Identifier = "idcardlocator",
        Price = 500,
        Limit = 1,
        IsLimitGlobal = false,
        Action = function (client)
            local logbook = ItemPrefab.GetItemPrefab("logbook")
            Entity.Spawner.AddItemToSpawnQueue(logbook, client.Character.Inventory, nil, nil, function (item)
                item.Description = Traitormod.Language.Pointshop.idcardlocator_desc
                item.set_InventoryIconColor(Color(255, 0, 0, 255))
                item.SpriteColor = Color(255, 0, 0, 255)
                item.Tags = "idcardlocator"

                local color = item.SerializableProperties[Identifier("SpriteColor")]
                Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(color, item))
                local invColor = item.SerializableProperties[Identifier("InventoryIconColor")]
                Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(invColor, item))

                local terminal = item.GetComponentString("Terminal")
                terminal.ShowMessage = "Type \"scan\" to scan for id cards."
                terminal.SyncHistory()
        
            end)
        end
    },

    {
        Price = 25,
        Limit = 50,
        Items = {"bananapeel"}
    },

    {
        Price = 500,
        Limit = 1,
        Items = {"deliriumine"}
    },

    {
        Identifier = "jailgrenade",
        Price = 250,
        Limit = 5,
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
        Identifier = "fakehandcuffs",
        Price = 200,
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
        Identifier = "enrollclown",
        Price = 500,
        Limit = 1,
        IsLimitGlobal = false,
        Action = function (client, product, items)
            client.Character.GiveTalent("enrollintoclowncollege")
        end
    },

    {
        Identifier = "PsychoClown",
        Price = 600,
        Limit = 1,
        IsLimitGlobal = false,
        Action = function (client, product, items)
            client.Character.GiveTalent("psychoclown")
        end
    },

    {
        Price = 600,
        Limit = 2,
        Items = {"cymbals"}
    },

    {
        Price = 2100,
        Limit = 1,
        Items = {"pressurestabilizer"}
    },

    {
        Price = 350,
        Limit = 5,
        Items = {"ethanol"}
    },

    {
        Price = 250,
        Limit = 10,
        Items = {"smallmudraptoregg", "antibloodloss1", "antibloodloss1"}
    },

    {
        Identifier = "autoclown",
        Price = 3950,
        Limit = 1,
        IsLimitGlobal = true,
        Action = function (client)
            local prefabInjector = ItemPrefab.GetItemPrefab("autoinjectorheadset")
            local prefabC4 = ItemPrefab.GetItemPrefab("c4block")
            Entity.Spawner.AddItemToSpawnQueue(prefabInjector, client.Character.Inventory, nil, nil, function (item)
                item.Description = "Praise the honkmother. Has a surprise inside."
                Entity.Spawner.AddItemToSpawnQueue(prefabC4, client.Character.Inventory, nil, nil, function (item2)
                    item.OwnInventory.TryPutItem(item2, 1, false, false, client.Character, true, false)
                    item2.Description = "Praise the honkmother."
                    item2.set_InventoryIconColor(Color(255, 5, 10))
                    item2.SpriteColor = Color(255, 5, 10, 255)
                    item2.AddTag("medical")
                    item2.AddTag("clownboom")

                    local color = item2.SerializableProperties[Identifier("SpriteColor")]
                    Networking.CreateEntityEvent(item2, Item.ChangePropertyEventData(color, item2))
                    local invColor = item2.SerializableProperties[Identifier("InventoryIconColor")]
                    Networking.CreateEntityEvent(item2, Item.ChangePropertyEventData(invColor, item2))
                end)
            end)
        end
    },

    {
        Identifier = "firemanscarrytalent",
        Price = 290,
        Limit = 1,
        IsLimitGlobal = false,
        Action = function (client, product, items)
            client.Character.GiveTalent("firemanscarry")
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
        Identifier = "insaneclown",
        Price = 1100,
        Limit = 3,
        IsLimitGlobal = true,
        PricePerLimit = 1500,
        Action = function (client, product, items)
            local characters = {}
            local positions = {}
        
            for key, value in pairs(Character.CharacterList) do
                if value.Submarine == Submarine.MainSub then
                    table.insert(characters, value)
                    table.insert(positions, value.WorldPosition)
                end
            end
        
            if #characters == 0 then positions = {client.Character.WorldPosition} end

            local info = CharacterInfo(Identifier("human"))
            local possibleNames = {
                "Jestmaster",
                "Joe Hawley",
                "Jester",
                "Funnyman",
                "Honkmother's Disciple",
                "Sansundertale",
                "Haloperidol",
                "Murderous Comedian",
                "Harlequin",
                "Mr. Buffoon",
                "The Prankster",
                "Practical Joke",
                "The Pierrot",
                "Pillars of Fun",
                "Balloon Man",
                "The Grandest of Jesters",
                "Grandmaster Clown",
                "Killer",
                "Hunter",
                "Buddy the Clown"
            }

            info.Name = possibleNames[math.random(1, #possibleNames)]
            info.Job = Job(JobPrefab.Get("securityofficer"))
        
            local character = Character.Create(info, positions[math.random(#positions)], info.Name, 0, false, true)
            local affliction = AfflictionPrefab.Prefabs["deliriuminepoisoning"].Instantiate(35)
            local afflictionInsane = AfflictionPrefab.Prefabs["psychosis"].Instantiate(10)
            local afflictionPressure = AfflictionPrefab.Prefabs["pressurestabilized"].Instantiate(290)
            local afflictionVigor = AfflictionPrefab.Prefabs["strengthen"].Instantiate(350)
            character.CanSpeak = false
            character.TeamID = CharacterTeamType.None
            character.GiveTalent("psychoclown", true)
            character.GiveTalent("enrollintoclowncollege", true)
            character.CharacterHealth.ApplyAffliction(character.AnimController.MainLimb, affliction)
            character.CharacterHealth.ApplyAffliction(character.AnimController.MainLimb, afflictionInsane)
            character.CharacterHealth.ApplyAffliction(character.AnimController.MainLimb, afflictionPressure)
            character.CharacterHealth.ApplyAffliction(character.AnimController.MainLimb, afflictionVigor)
            character.GiveJobItems(nil)

            local oldClothes = character.Inventory.GetItemInLimbSlot(InvSlotType.InnerClothes)
            if oldClothes then oldClothes.Drop() Entity.Spawner.AddEntityToRemoveQueue(oldClothes) end

            local oldHat = character.Inventory.GetItemInLimbSlot(InvSlotType.Head)
            if oldHat then oldHat.Drop() Entity.Spawner.AddEntityToRemoveQueue(oldHat) end
            
            for item in character.Inventory.AllItems do
                if item.Prefab.Identifier ~= "idcard" then
                    Entity.Spawner.AddEntityToRemoveQueue(item)
                end
            end
            
            local idCard = character.Inventory.GetItemInLimbSlot(InvSlotType.Card)
            if idCard then
                idCard.NonPlayerTeamInteractable = true
                idCard.AddTag("name:"..info.Name)
                idCard.AddTag("job:clown")
                idCard.Description = "A mysterious force is preventing you from taking this ID."
                local prop = idCard.SerializableProperties[Identifier("NonPlayerTeamInteractable")]
                Networking.CreateEntityEvent(idCard, Item.ChangePropertyEventData(prop, idCard))
            end

            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("clowncostume"), character.Inventory, nil, nil, function (item)
                character.Inventory.TryPutItem(item, character.Inventory.FindLimbSlot(InvSlotType.InnerClothes), true, false, character)
                item.NonPlayerTeamInteractable = true
                item.Description = "A mysterious force is preventing you from grabbing it.."
                local prop = item.SerializableProperties[Identifier("NonPlayerTeamInteractable")]
                Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(prop, item))
            end)

            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("clownmask"), character.Inventory, nil, nil, function (item)
                character.Inventory.TryPutItem(item, character.Inventory.FindLimbSlot(InvSlotType.Head), true, false, character)
                item.NonPlayerTeamInteractable = true
                item.Description = "A mysterious force is preventing you from grabbing it.."
                local prop = item.SerializableProperties[Identifier("NonPlayerTeamInteractable")]
                Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(prop, item))
            end)

            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("boardingaxe"), character.Inventory, nil, nil, function (item)
                item.NonPlayerTeamInteractable = true
                item.Description = "A mysterious force is preventing you from grabbing it.."
                local prop = item.SerializableProperties[Identifier("NonPlayerTeamInteractable")]
                Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(prop, item))
            end)

            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("bikehorn"), character.Inventory, nil, nil, function (item)
                item.NonPlayerTeamInteractable = true
                local prop = item.SerializableProperties[Identifier("NonPlayerTeamInteractable")]
                Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(prop, item))
            end)

            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("toyhammer"), character.Inventory, nil, nil, function (item)
                item.NonPlayerTeamInteractable = true
                local prop = item.SerializableProperties[Identifier("NonPlayerTeamInteractable")]
                Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(prop, item))
            end)

            Traitormod.GhostRoles.Ask("The Clown", function (client)
                Traitormod.LostLivesThisRound[client.SteamID] = false
                client.SetClientCharacter(character)
        
                Traitormod.SendMessageCharacter(character, "You are a clown! Eliminate them. Protect all fellow clowns.", "InfoFrameTabButton.Mission")
            end, character)

            local text = "Attention! There is a mute clown going rampant in our station. Eliminate it!"
            Traitormod.RoundEvents.SendEventMessage(text, "GameModeIcon.pvp", Color.OrangeRed)
        end
    },

    {
        Identifier = "randomizelights",
        Price = 300,
        Limit = 3,
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
