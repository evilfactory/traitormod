local event = {}

event.Name = "ClownMagic"
event.MinRoundTime = 15
event.MinIntensity = 0
event.MaxIntensity = 0.1
event.ChancePerMinute = 0
event.OnlyOncePerRound = true

event.ColorsToRevert = {}

event.Start = function ()
    local characters = {}
    local positions = {}

    for key, value in pairs(Character.CharacterList) do
        if value.Submarine == Submarine.MainSub then
            table.insert(characters, value)
            table.insert(positions, value.WorldPosition)
        end
    end

    if #characters == 0 then return end

    for key, value in pairs(characters) do
        value.TeleportTo(positions[math.random(#positions)])
    end

    local text = Traitormod.Language.ClownMagic
    Traitormod.RoundEvents.SendEventMessage(text)

    event.End()
end


event.End = function ()

end

return event