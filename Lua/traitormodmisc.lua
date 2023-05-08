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

if Traitormod.Config.DeathLogBook then
    local messages = {}

    Hook.Add("roundEnd", "Traitormod.DeathLogBook", function ()
        messages = {}
    end)

    Hook.Add("character.death", "Traitormod.DeathLogBook", function (character)
        if messages[character] == nil then return end

        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("logbook"), character.Inventory, nil, nil, function(item)
            local terminal = item.GetComponentString("Terminal")

            local text = ""
            for key, value in pairs(messages[character]) do
                text = text .. value .. "\n"
            end

            terminal.TextColor = Color.MidnightBlue
            terminal.ShowMessage = text
            terminal.SyncHistory()
        end)
    end)

    Traitormod.AddCommand("!write", function (client, args)
        if client.Character == nil or client.Character.IsDead or client.Character.SpeechImpediment > 0 or not client.Character.IsHuman then
            Traitormod.SendChatMessage(client, "You are unable to write to your death logbook.", Color.Red)
            return true
        end

        if messages[client.Character] == nil then
            messages[client.Character] = {}
        end

        if #messages[client.Character] > 255 then return end

        local message = table.concat(args, " ")
        table.insert(messages[client.Character], message)

        Traitormod.SendChatMessage(client, "Wrote \"" .. message .. "\" to the death logbook.", Color.Green)

        return true
    end)
end

Hook.Add("roundEnd", "ConvictEscape", function ()
    for key, plr in pairs(Client.ClientList) do
        if plr.Character and not plr.Character.IsDead and plr.Character.IsHuman and plr.Character.JobIdentifier == "convict" and plr.Character.Submarine ~= Submarine.MainSub then
            Traitormod.AwardPoints(plr, 2100)
            Traitormod.SendMessage(plr, "Congrats on escaping, you have received 2100 points.", "InfoFrameTabButton.Mission")
        end
    end
end)