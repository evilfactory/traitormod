if CLIENT then return end

Hook.Add("roundStart", "crewmenuRoundStart", function ()
    for key, value in pairs(Client.ClientList) do
        Networking.CreateEntityEvent(value.Character, Character.RemoveFromCrewEventData.__new(value.Character.TeamID, {}))
    end
end)