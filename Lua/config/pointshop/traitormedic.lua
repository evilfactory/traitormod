local category = {}

category.Name = "Traitor Medic"
category.Decoration = "Separatists"
category.FadeToBlack = true

category.CanAccess = function(client)
    return client.Character and client.Character.JobIdentifier == "prisondoctor" and not client.Character.IsDead and Traitormod.RoleManager.HasRole(client.Character, "Traitor")
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
        Name = "Put random person into coma (Dangerous)",
        Price = 1500,
        Limit = 1,
        IsLimitGlobal = true,
        Action = function (client)
            local character = GetRandomAlivePlayer()
            local coma = AfflictionPrefab.Prefabs["coma"].Instantiate(25)

            character.CharacterHealth.ApplyAffliction(character.AnimController.MainLimb, coma)
        end
    },

    {
        Name = "Mycobacterium tuberculosis Sample",
        Price = 1500,
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
        Name = "Advanced Syringe Gun",
        Price = 450,
        Limit = 1,
        IsLimitGlobal = false,
        Items = {"advancedsyringegun"},
    },

    {
        Name = "Surgical Bomb (UEX)",
        Price = 1750,
        Limit = 1,
        IsLimitGlobal = true,
        Items = {"surgerybomb"},
    },

    {
        Name = "Surgical Bomb (C-4)",
        Price = 2900,
        Limit = 1,
        IsLimitGlobal = true,
        Items = {"surgeryC4Block"},
    },

    {
        Name = "Surgical Bomb Detonator",
        Price = 50,
        Limit = 1,
        IsLimitGlobal = false,
        Items = {"internalbombdetonator"},
    },

    {
        Name = "Europan Medicine",
        Price = 600,
        Limit = 1,
        IsLimitGlobal = false,
        Items = {"skillbookeuropanmedicine"},
    },

    {
        Name = "Liquid Oxygenite",
        Price = 1100,
        Limit = 1,
        IsLimitGlobal = true,
        Items = {"liquidoxygenite", "liquidoxygenite", "liquidoxygenite", "liquidoxygenite",
        "liquidoxygenite", "liquidoxygenite", "liquidoxygenite", "liquidoxygenite"},
    },

    {
        Name = "Fentanyl",
        Price = 2000,
        Limit = 2,
        IsLimitGlobal = false,
        Items = {"antidama2", "antidama2", "antidama2"},
    },

    {
        Name = "Sufforin",
        Price = 2750,
        Limit = 1,
        IsLimitGlobal = false,
        Items = {"sufforin"},
    },

    {
        Name = "Radiotoxin",
        Price = 900,
        Limit = 2,
        IsLimitGlobal = false,
        Items = {"radiotoxin"},
    },

    {
        Name = "Endocrine Booster",
        Price = 1500,
        Limit = 1,
        IsLimitGlobal = false,
        Items = {"endocrinebooster"},
    },

    {
        Name = "Combat Stimulant",
        Price = 1500,
        Limit = 1,
        IsLimitGlobal = true,
        Items = {"combatstimulantsyringe"},
    },

    {
        Name = "Raptor Bane Extract",
        Price = 900,
        Limit = 4,
        IsLimitGlobal = true,
        Items = {"raptorbaneextract", "raptorbaneextract", "raptorbaneextract", "raptorbaneextract"},
    },

    {
        Name = "Pressure Stabilizer",
        Price = 3750,
        Limit = 1,
        IsLimitGlobal = false,
        Items = {"pressurestabilizer"},
    },

    {
        Name = "Chloral Hydrate",
        Price = 400,
        Limit = 4,
        IsLimitGlobal = false,
        Items = {"chloralhydrate"},
    },
}

return category
