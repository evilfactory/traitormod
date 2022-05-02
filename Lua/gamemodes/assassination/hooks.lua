local assassination = Traitormod.SelectedGamemode
local lang = Traitormod.Language

assassination.OnCharacterDied = function (client, affliction)
    if assassination.Traitors == nil then
        return
    end

    local character = client.Character
    local attacker = character.CauseOfDeath.Killer
    local victimTraitor = assassination.Traitors[character]
    local attackerName = "Unknown"
    local victimType = "Crew member"
    local message = nil
    local icon = nil

    if victimTraitor then
        victimType = "Traitor"
        victimTraitor.Deaths = (victimTraitor.Deaths or 0) + 1

        -- if traitor dies while assassination is not complete and traitor not supposed to come back as traitor, set traitor failed - loose traitor state
        if not assassination.Completed and assassination.Config.TraitorRespawnAs ~= "traitor" then
            if Game.ServerSettings.AllowRespawn then
                message = lang.TraitorDeath
                icon = "InfoFrameTabButton.Traitor"
                Traitormod.UpdateVanillaTraitor(client, false)
            end
            victimTraitor.Failed = true
        end
    elseif attacker ~= nil then
        attackerName = attacker.Name

        -- inform traitor victims
        if assassination.Traitors[attacker] ~= nil then
            victimType = "Assassination target"
            assassination.Traitors[attacker].Kills = (assassination.Traitors[attacker].Kills or 0) + 1
            
            message = lang.KilledByTraitor
            icon = "InfoFrameTabButton.Traitor"
        end
    end

    Traitormod.Log(string.format("%s %s died. Cause: %s Killer: %s", victimType, character.Name, character.CauseOfDeath.Type, attackerName))

    return message, icon
end