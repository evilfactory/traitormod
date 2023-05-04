if CLIENT then return end

Hook.Add("roundStart", "crewmenuRoundStart", function ()
    for key, value in pairs(Client.ClientList) do
        if value.Character ~= nil then
            value.Character.TeamID = CharacterTeamType.FriendlyNPC
        end
    end
end)

Hook.Add("roundEnd", "crewmenuRoundEnd", function ()
    for key, value in pairs(Client.ClientList) do
        if value.Character ~= nil and value.Character.IsHuman and value.Character.TeamID ~= CharacterTeamType.Team2 then
            value.Character.TeamID = CharacterTeamType.Team1
        end
    end
end)

Hook.Add("chatMessage", "crewmenu_chatcommands", function(msg, client)

    if msg == "!alive" then
        if client.Character == nil or client.Character.IsDead == true or bit32.band(client.Permissions, 0x40) == 0x40 then

            local msg = ""
            for key, value in pairs(Character.CharacterList) do

                if value.IsHuman and not value.IsBot then
                    print(value.IsDead)
                    if value.IsDead then
                        msg = msg .. "[DEAD] " .. value.name .. "\n"
                    else
                        msg = msg .. "[ALIVE] " .. value.name .. "\n"
                    end
                end
            end

            Game.SendDirectChatMessage("", msg, nil, 7, client)

            return true
        end

    end
end)
