local role = Traitormod.RoleManager.Roles.Role:new()

role.Name = "Antagonist"
role.IsAntagonist = true

Traitormod.AddCommand("!tc", function(client, args)
    local feedback = Traitormod.Language.CommandNotActive

    local clientRole = Traitormod.RoleManager.GetRole(client.Character)

    if clientRole == nil then
        feedback = Traitormod.Language.NoTraitor
    elseif not clientRole.TraitorBroadcast then
        feedback = Traitormod.Language.CommandNotActive
    elseif not client.InGame or not client.Character or not clientRole.IsAntagonist then
        feedback = Traitormod.Language.NoTraitor
    elseif #args > 0 then
        local msg = ""
        for word in args do
            msg = msg .. " " .. word
        end

        for _, character in pairs(Traitormod.RoleManager.FindAntagonists()) do
            local targetClient = Traitormod.FindClientCharacter(character)

            if targetClient then
                Game.SendDirectChatMessage("",
                    string.format(Traitormod.Language.TraitorBroadcast, Traitormod.ClientLogName(client), msg), nil,
                    ChatMessageType.Error, targetClient)
            end
        end

        return not role.TraitorBroadcastHearable
    else
        feedback = "Usage: !tc [Message]"
    end

    Game.SendDirectChatMessage("", feedback, nil, Traitormod.Config.ChatMessageType, client)

    return true
end)

Traitormod.AddCommand("!tdm", function(client, args)
    local feedback = ""

    local clientRole = Traitormod.RoleManager.GetRole(client.Character)

    if clientRole == nil then
        feedback = Traitormod.Language.NoTraitor
    elseif not clientRole.TraitorDm then
        feedback = Traitormod.Language.CommandNotActive
    elseif clientRole and clientRole.IsAntagonist then
        if #args > 1 then
            local found = Traitormod.FindClient(table.remove(args, 1))
            local msg = ""
            for word in args do
                msg = msg .. " " .. word
            end
            if found then
                Traitormod.SendMessage(found, Traitormod.Language.TraitorDirectMessage .. msg)
                feedback = string.format("[To %s]: %s", Traitormod.ClientLogName(found), msg)
                return true
            else
                feedback = "Name not found."
            end
        else
            feedback = "Usage: !tdm [Name] [Message]"
        end
    else
        feedback = Traitormod.Language.NoTraitor
        Traitormod.SendMessage(client, Traitormod.Language.NoTraitor)
        return true
    end

    Game.SendDirectChatMessage("", feedback, nil, Traitormod.Config.ChatMessageType, client)
    return true
end)


return role
