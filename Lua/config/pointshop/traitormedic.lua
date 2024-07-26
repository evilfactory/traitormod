local category = {}

category.Identifier = "traitormedic"
category.Decoration = "Separatists"
category.FadeToBlack = true

category.CanAccess = function(client)
    return client.Character and not client.Character.IsDead and client.Character.HasJob("prisondoctor") and Traitormod.RoleManager.HasRole(client.Character, "Traitor")
end

local function GetRandomAlivePlayer()
    local client = Client.ClientList[math.random(1, #Client.ClientList)]
    local character = nil
    
    if client.Character then
        character = client.character
    else
        return GetRandomAlivePlayer()
    end

    if not character.IsDead and not character.IsUnconscious and not character.IsRagdolled and character.IsHuman and character.TeamID == CharacterTeamType.Team1 then
        return character
    else
        return GetRandomAlivePlayer()
    end
end

category.Products = {
    {
        Identifier = "separatistgear",
        Price = 1500,
        Limit = 3,
        IsLimitGlobal = true,
        Items = {"pirateclotheshard", "piratebodyarmor", "piratehelmet"},
    },

    {
        Price = 3100,
        Limit = 1,
        IsLimitGlobal = true,
        Items = {"hackingdevice"},
    },

    {
        Price = 1300,
        Limit = 1,
        IsLimitGlobal = true,
        Items = {"organscalpel_brain"},
    },

    {
        Identifier = "randomcoma",
        Price = 900,
        Limit = 1,
        IsLimitGlobal = true,
        Action = function (client)
            local character = GetRandomAlivePlayer()
            local coma = AfflictionPrefab.Prefabs["coma"].Instantiate(25)

            character.CharacterHealth.ApplyAffliction(character.AnimController.MainLimb, coma)
        end
    },

    {
        Identifier = "arthurmorgan",
        Price = 1000,
        Limit = 2,
        IsLimitGlobal = true,
        Action = function (client)
            local prefabInjector = ItemPrefab.GetItemPrefab("opium")
            Entity.Spawner.AddItemToSpawnQueue(prefabInjector, client.Character.Inventory, nil, nil, function (item)
                item.Tags = "tubersyringe"
                item.Description = "‖color:gui.red‖Sample of the bacterium called Mycobacterium tuberculosis. Causes Tuberculosis. Disguised as opium.‖color:end‖"
                local weapon = item.GetComponentString("MeleeWeapon")
                local tb = AfflictionPrefab.Prefabs["tb_Tuberculosis"]

                local effect = weapon.statusEffectLists[22][1]
                effect.set_Afflictions({tb.Instantiate(1)})

                effect = weapon.statusEffectLists[9][1]
                effect.set_Afflictions({tb.Instantiate(1)})

            end)
        end
    },

    {
        Price = 450,
        Limit = 1,
        IsLimitGlobal = false,
        Items = {"advancedsyringegun"},
    },

    {
        Price = 1250,
        Limit = 1,
        IsLimitGlobal = true,
        Items = {"surgerybomb"},
    },

    {
        Price = 2000,
        Limit = 1,
        IsLimitGlobal = true,
        Items = {"surgeryC4Block"},
    },

    {
        Price = 50,
        Limit = 1,
        IsLimitGlobal = false,
        Items = {"internalbombdetonator"},
    },

    {
        Price = 350,
        Limit = 1,
        IsLimitGlobal = false,
        Items = {"skillbookeuropanmedicine"},
    },

    {
        Price = 800,
        Limit = 1,
        IsLimitGlobal = true,
        Items = {"liquidoxygenite", "liquidoxygenite", "liquidoxygenite", "liquidoxygenite",
        "liquidoxygenite", "liquidoxygenite", "liquidoxygenite", "liquidoxygenite"},
    },

    {
        Price = 850,
        Limit = 2,
        IsLimitGlobal = false,
        Items = {"antidama2", "antidama2", "antidama2"},
    },

    {
        Price = 1100,
        Limit = 2,
        IsLimitGlobal = false,
        Items = {"sufforin"},
    },

    {
        Price = 750,
        Limit = 3,
        IsLimitGlobal = false,
        Items = {"radiotoxin"},
    },

    {
        Price = 900,
        Limit = 1,
        IsLimitGlobal = false,
        Items = {"endocrinebooster"},
    },

    {
        Price = 900,
        Limit = 1,
        IsLimitGlobal = true,
        Items = {"combatstimulantsyringe"},
    },

    {
        Price = 900,
        Limit = 4,
        IsLimitGlobal = true,
        Items = {"raptorbaneextract", "raptorbaneextract", "raptorbaneextract", "raptorbaneextract"},
    },

    {
        Price = 1850,
        Limit = 1,
        IsLimitGlobal = false,
        Items = {"pressurestabilizer"},
    },

    {
        Price = 200,
        Limit = 4,
        IsLimitGlobal = false,
        Items = {"chloralhydrate", "chloralhydrate"},
    },

    {
        Price = 1200,
        Limit = 5,
        IsLimitGlobal = true,
        Items = {"molotovcoctail"},
    },

    {
        Identifier = "choke",
        Price = 500,
        Limit = 1,
        IsLimitGlobal = false,
        Action = function (client)
            local revolver = ItemPrefab.GetItemPrefab("piratebandana")
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
        Identifier = "turnoffcommunications",
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
