local role = Traitormod.RoleManager.Roles.Role:new()

role.Name = "Antagonist"
role.IsAntagonist = true

Traitormod.AddCommand("!tc", function(client, args)
    local feedback = Traitormod.Language.CommandNotActive

    local clientRole = Traitormod.RoleManager.GetRole(client.Character)

    if clientRole == nil or client.Character.IsDead then
        feedback = Traitormod.Language.NoTraitor
    elseif not clientRole.TraitorBroadcast then
        feedback = Traitormod.Language.CommandNotActive
    elseif #args > 0 then
        local msg = ""
        for word in args do
            msg = msg .. " " .. word
        end

        for character, role in pairs(Traitormod.RoleManager.RoundRoles) do
            if role.TraitorBroadcast then
                local targetClient = Traitormod.FindClientCharacter(character)

                if targetClient then
                    Game.SendDirectChatMessage("",
                        string.format(Traitormod.Language.TraitorBroadcast, Traitormod.ClientLogName(client), msg), nil,
                        ChatMessageType.Error, targetClient)
                end
            end
        end

        return not clientRole.TraitorBroadcastHearable
    else
        feedback = "Usage: !tc [Message]"
    end

    Game.SendDirectChatMessage("", feedback, nil, Traitormod.Config.ChatMessageType, client)

    return true
end)

Traitormod.AddCommand("!tannounce", function(client, args)
    local feedback = Traitormod.Language.CommandNotActive

    local clientRole = Traitormod.RoleManager.GetRole(client.Character)

    if clientRole == nil or client.Character.IsDead then
        feedback = Traitormod.Language.NoTraitor
    elseif not clientRole.TraitorBroadcast then
        feedback = Traitormod.Language.CommandNotActive
    elseif #args > 0 then
        local msg = ""
        for word in args do
            msg = msg .. " " .. word
        end

        for character, role in pairs(Traitormod.RoleManager.RoundRoles) do
            if role.TraitorBroadcast then
                local targetClient = Traitormod.FindClientCharacter(character)

                if targetClient then
                    Game.SendDirectChatMessage("",
                        string.format(Traitormod.Language.TraitorBroadcast, client, msg), nil,
                        ChatMessageType.ServerMessageBoxInGame, targetClient)
                end
            end
        end

        return not clientRole.TraitorBroadcastHearable
    else
        feedback = "Usage: !tannounce [Message]"
    end

    Game.SendDirectChatMessage("", feedback, nil, Traitormod.Config.ChatMessageType, client)

    return true
end)

Traitormod.AddCommand("!tdm", function(client, args)
    local feedback = ""

    local clientRole = Traitormod.RoleManager.GetRole(client.Character)

    if clientRole == nil or client.Character.IsDead then
        feedback = Traitormod.Language.NoTraitor
    elseif not clientRole.TraitorDm then
        feedback = Traitormod.Language.CommandNotActive
    else
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
    end

    Game.SendDirectChatMessage("", feedback, nil, Traitormod.Config.ChatMessageType, client)
    return true
end)

function role:FilterTarget(objective, character)
    local targetRole = Traitormod.RoleManager.GetRole(character)
    if targetRole and targetRole.IsAntagonist then
        return false
    end

    return Traitormod.RoleManager.Roles.Role.FilterTarget(self, objective, character)
end


return role
