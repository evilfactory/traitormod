if CLIENT then return end

Hook.Add("character.created", "crewMenuRemoverOnCharacterCreation", function (character)
    if character and character.IsHuman and not character.IsBot then
        Networking.CreateEntityEvent(character, Character.RemoveFromCrewEventData.__new(value.Character.TeamID, {}))
    end
end)
