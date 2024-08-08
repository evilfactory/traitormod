local event = {}
event.Name = "CleanupCrew"
event.MinRoundTime = 5
event.MinIntensity = 0
event.MaxIntensity = 0.1
event.ChancePerMinute = 0.01
event.OnlyOncePerRound = true

event.Start = function()
    local deadCharacters = {}
    for _, character in pairs(Character.CharacterList) do
        if character.IsDead and character.IsHuman then
            table.insert(deadCharacters, character)
        end
    end

    for _, client in pairs(Client.ClientList) do
        if client.Character == nil then
            table.insert(deadCharacters, client)
        end
    end

    if #deadCharacters == 0 then
        event.End()
        return
    end

    for _, deadCharacter in ipairs(deadCharacters) do
        local position = deadCharacter.WorldPosition or Vector2(0, 0)
        Traitormod.GeneratePirate(position)
    end

    Traitormod.RoundEvents.SendEventMessage("The Cleanup Crew has arrived!", "CrewWalletIconLarge")
end

event.End = function()
end

return event