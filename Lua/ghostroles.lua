local gr = {}

gr.Roles = {}

gr.Ask = function (name, callback)
    name = string.lower(name)
    gr.Roles[name] = {Callback = callback, Taken = false}

    local text = "[Ghost Role] New ghost role available: %s (type in chat ‖color:gui.orange‖!ghostrole %s‖color:end‖ to accept)"

    text = string.format(text, name, name)

    for key, client in pairs(Client.ClientList) do
        if client.Character == nil or client.Character.IsDead then
            local chatMessage = ChatMessage.Create("Ghost Roles", text, ChatMessageType.Default, nil, nil)
            chatMessage.Color = Color(255, 100, 10, 255)
            Game.SendDirectChatMessage(chatMessage, client)
        end
    end
end

Traitormod.AddCommand("!ghostrole", function(client, args)
    if client.Character ~= nil and not client.Character.IsDead then
        Traitormod.SendMessage(client, "Only spectators can use ghost roles.")
        return true
    end

    if not client.InGame then
        Traitormod.SendMessage(client, "You must be in game to use ghost roles.")
        return true
    end

    local name = table.concat(args, " ")
    name = string.lower(name)

    if gr.Roles[name] == nil then
        local roles = ""
        for key, value in pairs(gr.Roles) do
            if value.Taken then
                roles = roles .. key .. "(Already Taken)\n"
            else
                roles = roles .. key .. "\n"
            end
        end

        if roles == "" then roles = "None" end

        Traitormod.SendMessage(client, "Ghost role not found, did you type the name correctly? Available roles: \n" .. roles)
        return true
    end

    if gr.Roles[name].Taken then
        Traitormod.SendMessage(client, "Someone already took this ghost role.")
        return true
    end

    gr.Roles[name].Callback(client)
    gr.Roles[name].Taken = true
end)


Hook.Add("roundEnd", "TraitorMod.GhostRoles.RoundEnd", function ()
    gr.Roles = {}
end)

return gr