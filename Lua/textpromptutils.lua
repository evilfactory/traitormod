local c = {}

local currentPromptID = 0
local promptIDToCallback = {}

local function SendEventMessage(msg, options, id, eventSprite, client)
    local message = Networking.Start()
    message.Write(Byte(18)) -- net header
    message.Write(Byte(0)) -- conversation

    message.Write(UShort(id)) -- ushort identifier 0
    message.Write(eventSprite) -- event sprite
    message.Write(UShort(2))
    message.Write(false) -- continue conversation

    message.Write(Byte(2))
    message.Write(msg)
    message.Write(false)
    message.Write(Byte(#options))
    for key, value in pairs(options) do
        message.Write(value)
    end
    message.Write(Byte(#options))
    for i = 0, #options - 1, 1 do
        message.Write(Byte(i))
    end

    Networking.Send(message, client.Connection, DeliveryMethod.Reliable)
end


Hook.Add("netMessageReceived", "promptResponse", function (msg, header, client)
    if header == ClientPacketHeader.EVENTMANAGER_RESPONSE then 
        local id = msg.ReadUInt16()
        local option = msg.ReadByte()

        if promptIDToCallback[id] ~= nil then
            promptIDToCallback[id](option + 1, client)
        end
    end
end)

c.Prompt = function (message, options, client, callback, eventSprite)
    currentPromptID = currentPromptID + 1

    promptIDToCallback[currentPromptID] = callback
    SendEventMessage(message, options, currentPromptID, eventSprite, client)
end

return c