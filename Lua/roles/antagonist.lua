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
                local headerTwo = "N/A"

                if role.Name == "Traitor" then
                    headerTwo = Traitormod.Language.TraitorBroadcast
                elseif role.Name == "Pirate" then
                    headerTwo = Traitormod.Language.PirateBroadcast
                elseif role.Name == "Cultist" then
                    headerTwo = Traitormod.Language.CultistBroadcast
                elseif role.Name == "HuskServant" then
                    headerTwo = Traitormod.Language.ServantBroadcast
                end

                if targetClient then
                    Game.SendDirectChatMessage("",
                        string.format(headerTwo, Traitormod.ClientLogName(client), msg), nil,
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


return role
