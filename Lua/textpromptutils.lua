local c = {}

local promptIDToCallback = {}

local function SendEventMessage(msg, options, id, eventSprite, fadeToBlack, client)
    local message = Networking.Start()
    message.WriteByte(Byte(17)) -- net header
    message.WriteByte(Byte(0)) -- conversation

    message.WriteUInt16(UShort(id)) -- ushort identifier 0
    message.WriteString(eventSprite) -- event sprite
    message.WriteByte(Byte(0)) -- dialog Type
    message.WriteBoolean(false) -- continue conversation

    message.WriteUInt16(UShort(0)) -- speak Id
    message.WriteString(msg)
    message.WriteBoolean(fadeToBlack or false) -- fade to black
    message.WriteByte(Byte(#options))
    for key, value in pairs(options) do
        message.WriteString(value)
    end
    message.WriteByte(Byte(#options))
    for i = 0, #options - 1, 1 do
        message.WriteByte(Byte(i))
    end

    Networking.Send(message, client.Connection, DeliveryMethod.Reliable)
end


Hook.Add("netMessageReceived", "Traitormod.promptResponse", function (msg, header, client)
    if header == ClientPacketHeader.EVENTMANAGER_RESPONSE then 
        local id = msg.ReadUInt16()
        local option = msg.ReadByte()

        if promptIDToCallback[id] ~= nil then
            promptIDToCallback[id](option + 1, client)
            promptIDToCallback[id] = nil
        end

        msg.BitPosition = msg.BitPosition - (8 * 3) -- rewind 3 bytes from the message, so it can be read again
    end
end)

c.Prompt = function (message, options, client, callback, eventSprite, fadeToBlack)
    local currentPromptID = math.floor(math.random(0,65535))

    promptIDToCallback[currentPromptID] = callback
    SendEventMessage(message, options, currentPromptID, eventSprite, fadeToBlack, client)
end

return c