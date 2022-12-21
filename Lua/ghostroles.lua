local gr = {}


local ghostRolesAnnounceTimer = 0

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

    ghostRolesAnnounceTimer = Timer.GetTime() + 80
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

        Traitormod.SendMessage(client, "Ghost role not found, did you type the name correctly? Available roles: \n\n" .. roles)
        return true
    end

    if gr.Roles[name].Taken then
        Traitormod.SendMessage(client, "Someone already took this ghost role.")
        return true
    end

    Traitormod.Log(Traitormod.ClientLogName(client) .. " took the ghost role of " .. name .. ".")

    gr.Roles[name].Callback(client)
    gr.Roles[name].Taken = true
end)


Hook.Add("think", "Traitormod.GhostRoles.Think", function (...)
    if Timer.GetTime() < ghostRolesAnnounceTimer then return end
    ghostRolesAnnounceTimer = Timer.GetTime() + 200

    local roles = ""
    for key, value in pairs(gr.Roles) do
        if not value.Taken then
            roles = roles .. "\"‖color:gui.orange‖" .. key .. "\"‖color:end‖ "
        end
    end

    if roles == "" then return end

    for key, client in pairs(Client.ClientList) do
        if client.Character == nil or client.Character.IsDead then
            local chatMessage = ChatMessage.Create("Ghost Roles", "Ghost roles available: " .. roles .. "\n\nUse !ghostrole name to pick a role.", ChatMessageType.Default, nil, nil)
            chatMessage.Color = Color(255, 100, 10, 255)
            Game.SendDirectChatMessage(chatMessage, client)
        end
    end
end)

Hook.Add("roundEnd", "TraitorMod.GhostRoles.RoundEnd", function ()
    gr.Roles = {}
end)

return gr