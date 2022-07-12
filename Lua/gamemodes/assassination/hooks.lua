local assassination = Traitormod.SelectedGamemode
local lang = Traitormod.Language

assassination.OnCharacterDied = function (client, affliction)
    local character = client.Character

    if assassination.Traitors == nil then
        return
    end

    local victimTraitor = assassination.Traitors[character]
    local attackerName = "Unknown"
    local cause = "Unknown"
    local victimType = "Crew member"
    local message = nil
    local icon = nil

    if character.CauseOfDeath ~= nil then
        cause = character.CauseOfDeath.Type
    end

    -- if victim was a traitor
    if victimTraitor then
        victimType = "Traitor"
        victimTraitor.Deaths = (victimTraitor.Deaths or 0) + 1

        -- if traitor dies while assassination is not complete and traitor not supposed to come back as traitor, set traitor failed - loose traitor state
        if not victimTraitor.Failed and not assassination.Completed and assassination.Config.TraitorRespawnAs ~= "traitor" then
            if Game.ServerSettings.AllowRespawn then
                message = lang.TraitorDeath
                icon = "InfoFrameTabButton.Traitor"
                Traitormod.UpdateVanillaTraitor(client, false)
            end
            victimTraitor.Failed = true
        end
    end

    Traitormod.Log(string.format("%s %s died. Cause: %s Killer: %s", victimType, character.Name, cause, attackerName))

    return message, icon
end

--assassination.OnCharacterCreated = function(client, character)
--    if assassination.Config.AllowDeadTraitors then
-----     -- update "new" traitor character
--        local spawnedTraitor = assassination.Traitors[character] --< can not work with character as key
--        print(spawnedTraitor)
--        if spawnedTraitor ~= nil then
--            Traitormod.Debug("Traitor " .. character.Name .. " respawned.")
--            -- traitor was spawned that was dead on selection -> update new character
--            if client ~= nil then
--                Traitormod.UpdateVanillaTraitor(client, true)
--            else
--                character.IsTraitor = true
--            end
--        end
--    end
--end