if CLIENT then return end

Hook.Add("roundStart", "crewmenuRoundStart", function ()
    for key, value in pairs(Character.CharacterList) do
        Networking.CreateEntityEvent(value, Character.RemoveFromCrewEventData.__new(value.TeamID, {}))
    end
end)