local assassination = Traitormod.SelectedGamemode
local lang = Traitormod.Language

Hook.Add("characterDeath", "Traitormod.Assassination.DeathByTraitor", function (character, affliction)
    if character == nil or 
    character.CauseOfDeath == nil or 
    character.CauseOfDeath.Killer == nil or
    character.IsHuman == false or
    character.ClientDisconnected == true or
    character.TeamID == 0 or 
    assassination.Traitors == nil then
        return
    end

    if assassination.Traitors[character] then return end

    local attacker = character.CauseOfDeath.Killer

    if assassination.Traitors[attacker] ~= nil then
        Traitormod.SendMessageCharacter(character, lang.KilledByTraitor, true, "InfoFrameTabButton.Traitor")
    end
end)