local assassination = Traitormod.SelectedGamemode
local lang = Traitormod.Language

Hook.Add("characterDeath", "Traitormod.Assassination.DeathByTraitor", function (character, affliction)
    if character == nil or 
    character.CauseOfDeath == nil or 
    character.IsHuman == false or
    character.ClientDisconnected == true or
    character.TeamID == 0 or 
    assassination.Traitors == nil then
        return
    end

    local attacker = character.CauseOfDeath.Killer
    local victimTraitor = assassination.Traitors[character]
    local attackerName = "Unknown"
    local victimType = "Crew member"

    if victimTraitor then
        victimType = "Traitor"
        victimTraitor.Deaths = (victimTraitor.Deaths or 0) + 1

        -- if traitor dies while assassination is not complete and traitor not supposed to come back as traitor, set traitor failed - loose traitor state
        if not assassination.Completed and assassination.Config.TraitorRespawnAs ~= "traitor" then
            if Game.ServerSettings.AllowRespawn then
                Traitormod.SendMessageCharacter(character, lang.TraitorDeath, "InfoFrameTabButton.Traitor")

                Traitormod.UpdateVanillaTraitor(character, false)
            end
            victimTraitor.Failed = true
        end
    elseif attacker ~= nil then
        attackerName = attacker.Name

        -- inform traitor victims
        if assassination.Traitors[attacker] ~= nil then
            victimType = "Assassination target"
            assassination.Traitors[attacker].Kills = (assassination.Traitors[attacker].Kills or 0) + 1
            Traitormod.SendMessageCharacter(character, lang.KilledByTraitor, "InfoFrameTabButton.Traitor")
        end
    end

    Traitormod.Log(string.format("%s %s died. Cause: %s Killer: %s", victimType, character.Name, character.CauseOfDeath.Type, attackerName))
end)