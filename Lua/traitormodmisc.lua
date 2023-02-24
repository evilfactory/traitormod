local timer = Timer.GetTime()

local peopleInOutpost = 0

local n = 1
Hook.Add("think", "Traitormod.MiscThink", function ()
    if timer > Timer.GetTime() then return end
    if not Game.RoundStarted then return end

    timer = Timer.GetTime() + 5

    if Traitormod.Config.GhostRoleConfig.Enabled then
        for key, character in pairs(Character.CharacterList) do
            if not Traitormod.GhostRoles.IsGhostRole(character) then
                if Traitormod.Config.GhostRoleConfig.MiscGhostRoles[character.SpeciesName.Value] then
                    Traitormod.GhostRoles.Ask(character.Name .. " " .. n, function (client)
                        client.SetClientCharacter(character)
                    end, character)
                    n = n + 1
                end
            end
        end
    end

    if not Traitormod.RoundEvents.EventExists("OutpostPirateAttack") then return end
    if Traitormod.RoundEvents.IsEventActive("OutpostPirateAttack") then return end
    if Traitormod.SelectedGamemode == nil or Traitormod.SelectedGamemode.Name ~= "Secret" then return end

    local targets = {}
    local outpost = Level.Loaded.EndOutpost.WorldPosition

    for key, character in pairs(Character.CharacterList) do
        if character.IsRemotePlayer and character.IsHuman and not character.IsDead and Vector2.Distance(character.WorldPosition, outpost) < 5000 then
            table.insert(targets, character)
        end
    end

    if #targets > 0 then
        peopleInOutpost = peopleInOutpost + 1
    end

    if peopleInOutpost > 30 then
        Traitormod.RoundEvents.TriggerEvent("OutpostPirateAttack")
    end
end)

Hook.Add("roundEnd", "Traitormod.MiscEnd", function ()
    peopleInOutpost = 0
end)

if Traitormod.Config.NerfSwords then
    local replacement = [[
    <overwrite>
        <Attack targetimpulse="2" severlimbsprobability="0.55" itemdamage="10" structuredamage="1" structuresoundtype="StructureSlash">
            <Affliction identifier="lacerations" strength="5" />
            <Affliction identifier="bleeding" strength="25" />
            <Affliction identifier="stun" strength="0.01" />
        </Attack>
    </overwrite>
    ]]

    local husk = ItemPrefab.GetItemPrefab("ceremonialsword")
    local element = husk.ConfigElement.Element.Element("MeleeWeapon")
    Traitormod.Patching.RemoveAll(element, "Attack")
    Traitormod.Patching.Add(element, replacement)
end