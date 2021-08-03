local util = {}

util.clientChar = function(char)
    local clients = Player.GetAllClients()

    for key, client in pairs(clients) do
        if (client.Character == char) then return client end
    end

    return nil
end

util.GetDeadClients = function()
    local valid = {}

    for key, value in pairs(Player.GetAllClients()) do
        if value.InGame then
            if value.Character == nil then table.insert(valid, value) end

            if value.Character ~= nil and value.Character.IsDead == true then
                table.insert(valid, value)
            end

        end
    end

    return valid
end

util.GetValidPlayers = function()
    local chars = Player.GetAllCharacters()
    local valid = {}

    for key, value in pairs(chars) do
        if (value.IsHuman == true and value.IsDead == false) and
            value.ClientDisconnected == false then
            table.insert(valid, value)
        end
    end

    return valid

end

function util.stringstarts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

util.characterIsTraitor = function(char, traitors)

    for key, value in pairs(traitors) do
        if char == key then return true end
    end

    return false
end

util.GetValidPlayersNoBotsAndNoTraitors = function(traitors)
    local chars = Player.GetAllCharacters()
    local valid = {}

    for key, value in pairs(chars) do
        if (value.IsHuman == true and value.IsDead == false) and
            value.ClientDisconnected == false then
            if value.IsBot == false and traitors[value] == nil then table.insert(valid, value) end
        end
    end

    return valid

end

util.GetValidPlayersNoBots = function()
    local chars = Player.GetAllCharacters()
    local valid = {}

    for key, value in pairs(chars) do
        if (value.IsHuman == true and value.IsDead == false) and
            value.ClientDisconnected == false then
            if value.IsBot == false then table.insert(valid, value) end
        end
    end

    return valid

end

util.TableCount = function (tbl)
    local count = 0

    for key, value in pairs(tbl) do
        count = count + 1    
    end

    return count
end

util.GetValidPlayersNoTraitors = function(traitors)
    local chars = Player.GetAllCharacters()
    local valid = {}

    for key, value in pairs(chars) do
        if (value.IsHuman == true and value.IsDead == false) and
            value.ClientDisconnected == false then
            if traitors[value] == nil then
                table.insert(valid, value)
            end
        end
    end

    return valid

end


return util