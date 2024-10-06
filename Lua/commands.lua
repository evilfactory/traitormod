----- USER COMMANDS -----
Traitormod.AddCommand("!help", function (client, args)
    Traitormod.SendMessage(client, Traitormod.Language.Help)

    return true
end)

Traitormod.AddCommand("!helpadmin", function (client, args)
    Traitormod.SendMessage(client, Traitormod.Language.HelpAdmin)

    return true
end)

Traitormod.AddCommand("!name", function (client, args)
    local name = Traitormod.GetData(client, "RPName")

    if name then
        Traitormod.SendMessage(client, "Your RP name is "..name..". You will have this name til your character dies.")
    else
        Traitormod.SendMessage(client, "You do not have a RP name.")
    end

    return true
end)

Traitormod.AddCommand("!helptraitor", function (client, args)
    Traitormod.SendMessage(client, Traitormod.Language.HelpTraitor)

    return true
end)

Traitormod.AddCommand("!announce", function(client, args)
    local feedback = nil

    if client.Character == nil or client.Character.IsDead then
        feedback = "You're dead."
        Game.SendDirectChatMessage("", feedback, nil, Traitormod.Config.ChatMessageType, client)
    return true end

    if client.Character.IsUnconscious
        or client.Character.IsRagdolled
        or HF.HasAffliction(client.Character,"sym_unconsciousness",0.1)
        or HF.HasAffliction(client.Character,"givein",0.1)
        or HF.HasAffliction(client.Character,"anesthesia",15)
        or HF.HasAffliction(client.Character,"paralysis",99)
    then
        feedback = "You're unconcious."
        Game.SendDirectChatMessage("", feedback, nil, Traitormod.Config.ChatMessageType, client)
        return true
    end

    for item in client.Character.Inventory.AllItems do
        if #args > 0 and item.Prefab.Identifier == "idcard" and item.GetComponentString("IdCard").OwnerJobId == "warden" and client.Character.TeamID ~= CharacterTeamType.Team2 then
            local msg = ""
            for word in args do
                msg = msg .. " " .. word
            end

            for key, value in pairs(Client.ClientList) do
               Traitormod.SendClientMessage("Warden's Announcement:"..msg, nil, Color.LightBlue, value)
            end
            return true
        elseif client.Character and client.Character.TeamID == CharacterTeamType.Team2 and #args > 0 then
            local msg = ""
            for word in args do
                msg = msg .. " " .. word
            end
                
            Traitormod.RoundEvents.SendEventMessage("Separatist Transmission: "..msg, "GameModeIcon.sandbox", Color.Khaki)
            return true
        else
            feedback = "You don't have the warden's ID."
            Game.SendDirectChatMessage("", feedback, nil, Traitormod.Config.ChatMessageType, client)
            return true
        end
    end
end)

Traitormod.AddCommand("!version", function (client, args)
    Traitormod.SendMessage(client, "Running Evil Factory's Traitor Mod v" .. Traitormod.VERSION)

    return true
end)

Traitormod.AddCommand({"!role", "!traitor"}, function (client, args)
    if client.Character == nil or client.Character.IsDead then
        Traitormod.SendMessage(client, "You need to be alive to use this command.")
        return true
    end

    local role = Traitormod.RoleManager.GetRole(client.Character)
    if role == nil then
        Traitormod.SendMessage(client, "You have no special role.")
    else
        Traitormod.SendMessage(client, role:Greet())
    end

    return true
end)

Traitormod.AddCommand({"!roles", "!traitors"}, function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end

    local roles = {}

    for character, role in pairs(Traitormod.RoleManager.RoundRoles) do
        if not roles[role.Name] then
            roles[role.Name] = {}
        end

        table.insert(roles[role.Name], character.Name)
    end

    local message = ""

    for roleName, r in pairs(roles) do
        message = message .. roleName .. ": "
        for _, name in pairs(r) do
            message = message .. "\"" .. name .. "\" "
        end
        message = message .. "\n\n"
    end

    if message == "" then message = "None." end

    Traitormod.SendMessage(client, message)

    return true
end)

Traitormod.AddCommand("!traitoralive", function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end

    for _, character in pairs(Traitormod.RoleManager.FindAntagonists()) do
        if not character.IsDead then
            Traitormod.SendMessage(client, Traitormod.Language.TraitorsAlive)
            return true
        end
    end

    Traitormod.SendMessage(client, Traitormod.Language.AllTraitorsDead)
    return true
end)

Traitormod.AddCommand("!toggletraitor", function (client, args)
    local text = Traitormod.Language.CommandNotActive

    if Traitormod.Config.OptionalTraitors then
        local toggle = false
        if #args > 0 then
            toggle = string.lower(args[1]) == "on"
        else
            toggle = Traitormod.GetData(client, "NonTraitor") == true
        end
    
        if toggle then
            text = Traitormod.Language.TraitorOn
        else
            text = Traitormod.Language.TraitorOff
        end
        Traitormod.SetData(client, "NonTraitor", not toggle)
        Traitormod.SaveData() -- move this to player disconnect someday...
        
        Traitormod.Log(Traitormod.ClientLogName(client) .. " can become traitor: " .. tostring(toggle))
    end

    Traitormod.SendMessage(client, text)

    return true
end)

Traitormod.AddCommand({"!point", "!points"}, function (client, args)
    Traitormod.SendMessage(client, Traitormod.GetDataInfo(client, true))

    return true
end)

Traitormod.AddCommand("!info", function (client, args)
    Traitormod.SendWelcome(client)
    
    return true
end)

Traitormod.AddCommand({"!suicide", "!kill", "!death"}, function (client, args)
    if client.Character == nil or client.Character.IsDead then
        Traitormod.SendMessage(client, "You are already dead!")
        return true
    end

    if Traitormod.GhostRoles.ReturnGhostRole(client.Character) then
        client.SetClientCharacter(nil)
    else
        client.Character.Kill(CauseOfDeathType.Unknown)
    end
    return true
end)

----- ADMIN COMMANDS -----
Traitormod.AddCommand("!alive", function (client, args)
    if client.Character == nil or client.Character.IsDead or client.HasPermission(ClientPermissions.ConsoleCommands) then

        if not Game.RoundStarted or Traitormod.SelectedGamemode == nil then
            Traitormod.SendMessage(client, Traitormod.Language.RoundNotStarted)
            return true
        end

        local msg = ""
        for index, value in pairs(Character.CharacterList) do
            if value.IsHuman and not value.IsBot then
                local targetClient = Traitormod.FindClientCharacter(value)
                local job = tostring(value.Info.Job.Prefab.Name)
                local clientName = ""

                if job == "Prison Doctor" then
                    job = "Doctor"
                elseif job == "Maintenance Worker" then
                    job = "M. Worker"
                end

                if targetClient then
                    clientName = targetClient.Name
                else
                    clientName = "Unknown"
                end

                if value.IsDead then
                    msg = msg .. clientName .. " ---- " .. Traitormod.Language.Dead .. " as " .. job .. " " .. value.Name .. "\n"
                else
                    msg = msg .. clientName .. " ++++ " .. Traitormod.Language.Alive .. " as " .. job .. " " .. value.Name .. "\n"
                end
            end
        end

        Traitormod.SendMessage(client, msg)
    end

    return true
end)

Traitormod.AddCommand("!spawn", function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end

    local spawnClient = client

    if #args > 0 then
        -- if client name is given, revive related character
        local name = table.remove(args, 1)
        -- find character by client name
        for player in Client.ClientList do
            if player.Name == name or player.SteamID == name then
                spawnClient = player
            end
        end
    end

    if spawnClient.Character == nil or spawnClient.Character.IsDead then
        Traitormod.MidRoundSpawn.TryCreateClientCharacter(Submarine.MainSub, spawnClient)
        Game.SendDirectChatMessage("", "Character of ".. Traitormod.ClientLogName(spawnClient) .. " successfully spawned.", nil, ChatMessageType.Server, client)
    else
        Game.SendDirectChatMessage("", "Character of " .. Traitormod.ClientLogName(spawnClient) .. " is alive.", nil, ChatMessageType.Error, client)
    end

    return true
end)

Traitormod.AddCommand("!roundinfo", function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end

    if Game.RoundStarted and Traitormod.SelectedGamemode and Traitormod.SelectedGamemode.RoundSummary then
        local summary = Traitormod.SelectedGamemode:RoundSummary()
        Traitormod.SendMessage(client, summary)
    elseif Game.RoundStarted and not Traitormod.SelectedGamemode then
        Traitormod.SendMessage(client, "Gamemode: None")
    elseif Traitormod.LastRoundSummary ~= nil then
        Traitormod.SendMessage(client, Traitormod.LastRoundSummary)
    else
        Traitormod.SendMessage(client, Traitormod.Language.RoundNotStarted)
    end

    return true
end)

Traitormod.AddCommand({"!allpoint", "!allpoints"}, function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end
    
    local messageToSend = ""

    for index, value in pairs(Client.ClientList) do
        messageToSend = messageToSend .. "\n" .. value.Name .. ": " .. math.floor(Traitormod.GetData(value, "Points") or 0) .. " Points - " .. math.floor(Traitormod.GetData(value, "Weight") or 0) .. " Weight"
    end

    Traitormod.SendMessage(client, messageToSend)

    return true
end)

Traitormod.AddCommand({"!intercom"}, function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end

    if #args < 1 then
        Traitormod.SendMessage(client, "Incorrect amount of arguments. usage: !announce [msg] - If you need to announce something with more than one word, surround it in quotations.")
        return true
    end

    local text = table.remove(args, 1)

    Traitormod.RoundEvents.SendEventMessage(text, nil, Color.LightGreen)

    return true
end)

Traitormod.AddCommand({"!traitorcom"}, function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end

    if #args < 1 then
        Traitormod.SendMessage(client, "Incorrect amount of arguments. usage: !traitorcom [msg] - If you need to announce something with more than one word, surround it in quotations.")
    
        return true
    end

    local text = table.remove(args, 1)

    for key, player in pairs(Client.ClientList) do
        if player and player.Character and player.HasPermission(ClientPermissions.ConsoleCommands) or Traitormod.RoleManager.HasRole(player.Character, "Traitor") then
            Traitormod.SendTraitorMessageBox(player, text)
        end
    end

    return true
end)

Traitormod.AddCommand({"!cultistcom"}, function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end

    if #args < 1 then
        Traitormod.SendMessage(client, "Incorrect amount of arguments. usage: !traitorcom [msg] - If you need to announce something with more than one word, surround it in quotations.")
    
        return true
    end

    local text = table.remove(args, 1)

    for key, player in pairs(Client.ClientList) do
        if player and player.Character and player.HasPermission(ClientPermissions.ConsoleCommands) or Traitormod.RoleManager.HasRole(player.Character, "Cultist") then
            Traitormod.SendTraitorMessageBox(player, text, "oneofus")
        end
    end

    return true
end)

Traitormod.AddCommand({"!funny"}, function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end

    spawnPosition = Submarine.MainSub.WorldPosition

    local funnyClient = client

    if #args > 0 then
        -- if client name is given, revive related character
        local name = Traitormod.GetClientByName(table.remove(args, 1))
        -- find character by client name
                funnyClient = name
    end

    Entity.Spawner.AddCharacterToSpawnQueue("mudraptor", spawnPosition, function (character)
        funnyClient.SetClientCharacter(character)
        character.TeamID = CharacterTeamType.Team1
    end)

    return true
end)

--[[Traitormod.AddCommand({"!donate", "!givepoint", "!givepoints"}, function (client, args)
    
    if #args < 2 then
        Traitormod.SendMessage(client, "Incorrect amount of arguments. usage: !donate \"Client Name\" 500")

        return true
    end

    local name = table.remove(args, 1)
    local amount = tonumber(table.remove(args, 1))

    if amount == nil or amount ~= amount then
        Traitormod.SendMessage(client, "Invalid number value.")
        return true
    end

    if Traitormod.GetData(client,"Points") < amount then
        Traitormod.SendMessage(client, "Not enough points")
    end

    local found = Traitormod.GetClientByName(client,name)

    if found == nil then
        Traitormod.SendMessage(client, "Couldn't find a client with name / steamID " .. name)
        return true
    end

    Traitormod.AddData(found, "Points", amount)
    Traitormod.AddData(client, "Points", Traitormod.GetData(client,"Points") - amount)

    Traitormod.SendMessage(client, string.format(Traitormod.Language.PointsAwarded, amount), "InfoFrameTabButton.Mission")

    local msg = string.format(client.name.." added %s points to %s.", amount, Traitormod.ClientLogName(found))
    Traitormod.SendMessageEveryone(msg)
    msg = Traitormod.ClientLogName(client) .. ": " .. msg
    Traitormod.Log(msg)

    return true
end)]]

Traitormod.AddCommand({"!addpoint", "!addpoints"}, function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then
        Traitormod.SendMessage(client, "You do not have permissions to add points.")
        return
    end
    
    if #args < 2 then
        Traitormod.SendMessage(client, "Incorrect amount of arguments. usage: !addpoint \"Client Name\" 500")

        return true
    end

    local name = table.remove(args, 1)
    local amount = tonumber(table.remove(args, 1))

    if amount == nil or amount ~= amount then
        Traitormod.SendMessage(client, "Invalid number value.")
        return true
    end

    if name == "all" then
        for index, value in pairs(Client.ClientList) do
            Traitormod.AddData(value, "Points", amount)
        end

        Traitormod.SendMessage(client, string.format(Traitormod.Language.PointsAwarded, amount), "InfoFrameTabButton.Mission")

        local msg = string.format("Admin added %s points to everyone.", amount)
        Traitormod.SendMessageEveryone(msg)
        msg = Traitormod.ClientLogName(client) .. ": " .. msg
        Traitormod.Log(msg)

        return true
    end

    local found = Traitormod.GetClientByName(client,name)

    if found == nil then
        Traitormod.SendMessage(client, "Couldn't find a client with name / steamID " .. name)
        return true
    end

    Traitormod.AddData(found, "Points", amount)

    Traitormod.SendMessage(client, string.format(Traitormod.Language.PointsAwarded, amount), "InfoFrameTabButton.Mission")

    local msg = string.format("Admin added %s points to %s.", amount, Traitormod.ClientLogName(found))
    Traitormod.SendMessageEveryone(msg)
    msg = Traitormod.ClientLogName(client) .. ": " .. msg
    Traitormod.Log(msg)

    return true
end)

Traitormod.AddCommand({"!addlife", "!addlive", "!addlifes", "!addlives"}, function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end

    if #args < 1 then
        Traitormod.SendMessage(client, "Incorrect amount of arguments. usage: !addlife \"Client Name\" 1")

        return true
    end

    local name = table.remove(args, 1)

    local amount = 1
    if #args > 0 then
        amount = tonumber(table.remove(args, 1))
    end

    if amount == nil or amount ~= amount then
        Traitormod.SendMessage(client, "Invalid number value.")
        return true
    end

    local gainLifeClients = {}
    if string.lower(name) == "all" then
        gainLifeClients = Client.ClientList
    else
        local found = Traitormod.FindClient(name)

        if found == nil then
            Traitormod.SendMessage(client, "Couldn't find a client with name / steamID " .. name)
            return true
        end
        table.insert(gainLifeClients, found)
    end

    for lifeClient in gainLifeClients do
        local lifeMsg, lifeIcon = Traitormod.AdjustLives(lifeClient, amount)
        local msg = string.format("Admin added %s lives to %s.", amount, Traitormod.ClientLogName(lifeClient))

        if lifeMsg then
            Traitormod.SendMessage(lifeClient, lifeMsg, lifeIcon)
            Traitormod.SendMessageEveryone(msg)
        else
            Game.SendDirectChatMessage("", Traitormod.ClientLogName(lifeClient) .. " already has maximum lives.", nil, Traitormod.Config.Error, client)
        end
    end

    return true
end)

local voidPos = {}

Traitormod.AddCommand("!void", function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end

    local target = Traitormod.FindClient(args[1])

    if not target then
        Traitormod.SendMessage(client, "Couldn't find a client with specified name / steamID")
        return true
    end

    if target.Character == nil or target.Character.IsDead then
        Traitormod.SendMessage(client, "Client's character is dead or non-existent.")
        return true
    end

    voidPos[target.Character] = target.Character.WorldPosition
    target.Character.TeleportTo(Vector2(0, Level.Loaded.Size.Y + 100000))
    target.Character.GodMode = true

    Traitormod.SendMessage(client, "Sent the character to the void.")

    return true
end)

Traitormod.AddCommand("!unvoid", function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end

    local target = Traitormod.FindClient(args[1])

    if not target then
        Traitormod.SendMessage(client, "Couldn't find a client with specified name / steamID")
        return true
    end

    if target.Character == nil or target.Character.IsDead then
        Traitormod.SendMessage(client, "Client's character is dead or non-existent.")
        return true
    end

    target.Character.TeleportTo(voidPos[target.Character])
    target.Character.GodMode = false
    voidPos[target.Character] = nil
    
    Traitormod.SendMessage(client, "Remove character from the void.")

    return true
end)

Traitormod.AddCommand("!revive", function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end

    local reviveClient = client

    if #args > 0 then
        -- if client name is given, revive related character
        local name = table.remove(args, 1)
        -- find character by client name
        for player in Client.ClientList do
            if player.Name == name or player.SteamID == name then
                reviveClient = player
            end
        end
    end

    if reviveClient.Character and reviveClient.Character.IsDead then
        reviveClient.Character.Revive()
        Timer.Wait(function ()
            reviveClient.SetClientCharacter(reviveClient.Character)
        end, 1500)
        local liveMsg, liveIcon = Traitormod.AdjustLives(reviveClient, 1)

        if liveMsg then
            Traitormod.SendMessage(reviveClient, liveMsg, liveIcon)
        end

        Game.SendDirectChatMessage("", "Character of " .. Traitormod.ClientLogName(reviveClient) .. " revived and given back 1 life.", nil, ChatMessageType.Error, client)
        Traitormod.SendMessageEveryone(string.format("Admin revived %s", Traitormod.ClientLogName(reviveClient)))

    elseif reviveClient.Character then
        Game.SendDirectChatMessage("", "Character of " .. Traitormod.ClientLogName(reviveClient) .. " is not dead.", nil, ChatMessageType.Error, client)
    else
        Game.SendDirectChatMessage("", "Character of " .. Traitormod.ClientLogName(reviveClient) .. " not found.", nil, ChatMessageType.Error, client)
    end

    return true
end)

Traitormod.AddCommand("!ongoingevents", function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end

    local text = "On Going Events: "
    for key, value in pairs(Traitormod.RoundEvents.OnGoingEvents) do
        text = text .. "\"" .. value.Name .. "\" "
    end

    Traitormod.SendMessage(client, text)

    return true
end)

Traitormod.AddCommand("!giveghostrole", function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end
    
    if #args < 2 then
        Traitormod.SendMessage(client, "Usage: !giveghostrole <ghost role name> <character>")
        return true
    end

    local target

    for key, value in pairs(Character.CharacterList) do
        if value.Name == args[2] and not value.IsDead then
            target = value
            break
        end
    end

    if not target then
        Traitormod.SendMessage(client, "Couldn't find a character with specified name")
        return true
    end

    Traitormod.GhostRoles.Ask(args[1], function (ghostClient)
        Traitormod.LostLivesThisRound[ghostClient.SteamID] = false

        ghostClient.SetClientCharacter(target)
    end, target)

    return true
end)

Traitormod.AddCommand("!roundtime", function (client, args)
    Traitormod.SendMessage(client, "This round has been going for " .. math.floor(Traitormod.RoundTime / 60) .. " minutes.")

    return true
end)

Traitormod.AddCommand("!assignrolecharacter", function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end
    
    if #args < 2 then
        Traitormod.SendMessage(client, "Usage: !assignrole <character> <role>")
        return true
    end

    local target

    for key, value in pairs(Character.CharacterList) do
        if value.Name == args[1] then
            target = value
            break
        end
    end

    if not target then
        Traitormod.SendMessage(client, "Couldn't find a character with specified name")
        return true
    end

    if target == nil or target.IsDead then
        Traitormod.SendMessage(client, "Client's character is dead or non-existent.")
        return true
    end

    local role = Traitormod.RoleManager.Roles[args[2]]

    if role == nil then
        Traitormod.SendMessage(client, "Couldn't find role to assign.")
        return true
    end

    if Traitormod.RoleManager.GetRole(target) ~= nil then
        Traitormod.RoleManager.RemoveRole(target)
    end
    Traitormod.RoleManager.AssignRole(target, role:new())

    Traitormod.SendMessage(client, "Assigned " .. target.Name .. " the role " .. role.Name .. ".")

    return true
end)

Traitormod.AddCommand("!assignrole", function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end
    
    if #args < 2 then
        Traitormod.SendMessage(client, "Usage: !assignrole <client> <role>")
        return true
    end

    local target = Traitormod.FindClient(args[1])

    if not target then
        Traitormod.SendMessage(client, "Couldn't find a client with specified name / steamID")
        return true
    end

    if target.Character == nil or target.Character.IsDead then
        Traitormod.SendMessage(client, "Client's character is dead or non-existent.")
        return true
    end

    local role = Traitormod.RoleManager.Roles[args[2]]

    if role == nil then
        Traitormod.SendMessage(client, "Couldn't find role to assign.")
        return true
    end

    local targetCharacter = target.Character

    if Traitormod.RoleManager.GetRole(targetCharacter) ~= nil then
        Traitormod.RoleManager.RemoveRole(targetCharacter)
    end
    Traitormod.RoleManager.AssignRole(targetCharacter, role:new())

    Traitormod.SendMessage(client, "Assigned " .. target.Name .. " the role " .. role.Name .. ".")

    return true
end)

Traitormod.AddCommand("!triggerevent", function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end

    if #args < 1 then
        Traitormod.SendMessage(client, "Usage: !triggerevent <event name>")
        return true
    end

    local event = nil
    for _, value in pairs(Traitormod.RoundEvents.EventConfigs.Events) do
        if value.Name == args[1] then
            event = value
        end
    end

    if event == nil then
        Traitormod.SendMessage(client, "Event " .. args[1] .. " doesnt exist.")
        return true
    end

    Traitormod.RoundEvents.TriggerEvent(event.Name)
    Traitormod.SendMessage(client, "Triggered event " .. event.Name)

    return true
end)

Traitormod.AddCommand("!clientname", function(client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end

    if #args < 1 then
        Traitormod.SendMessage(client, "Usage: !clientname <playername>")
        return true
    end

    

    local playername = args[1]
    for i,character in pairs(Character.CharacterList) do
        if character.Name == playername then
            for i,client2 in pairs(client.ClientList) do
                if client2.Character.Name == character.Name then
                    Traitormod.SendMessage(character.Name," is ",client.Name)

                else
                    Traitormod.SendMessage("character has no client? tf did you do?")
                end
            end
        else
            Traitormod.SendMessage("incorrect client name")
        end
    end

    return true
end)

Traitormod.AddCommand({"!locatesub", "!locatesubmarine"}, function (client, args)
    if client.Character == nil or not client.InGame then
        Traitormod.SendMessage(client, "You must be alive to use this command.")
        return true
    end

    if client.Character.IsHuman and client.Character.TeamID == CharacterTeamType.Team1 then
        Traitormod.SendMessage(client, "Only monsters are able to use this command.")
        return true
    end

    local center = client.Character.WorldPosition
    local target = Submarine.MainSub.WorldPosition

    local distance = Vector2.Distance(center, target) * Physics.DisplayToRealWorldRatio

    local diff = center - target

    local angle = math.deg(math.atan2(diff.X, diff.Y)) + 180

    local function degreeToOClock(v)
        local oClock = math.floor(v / 30)
        if oClock == 0 then oClock = 12 end
        return oClock .. " o'clock"
    end

    Game.SendDirectChatMessage("", "Submarine is " .. math.floor(distance) .. "m away from you, at " .. degreeToOClock(angle) .. ".", nil, ChatMessageType.Error, client)

    return true
end)


local preventSpam = {}
Traitormod.AddCommand({"!droppoints", "!droppoint", "!dropoint", "!dropoints"}, function (client, args)
    if preventSpam[client] ~= nil and Timer.GetTime() < preventSpam[client] then
        Traitormod.SendMessage(client, "Please wait a bit before using this command again.")
        return true
    end

    if client.Character == nil or client.Character.IsDead or client.Character.Inventory == nil then
        Traitormod.SendMessage(client, "You must be alive to use this command.")
        return true
    end

    if #args < 1 then
        Traitormod.SendMessage(client, "Usage: !droppoints amount")
        return true
    end

    local amount = tonumber(args[1])

    if amount == nil or amount ~= amount or amount < 100 or amount > 100000 then
        Traitormod.SendMessage(client, "Please specify a valid number between 100 and 100000.")
        return true
    end

    local availablePoints = Traitormod.GetData(client, "Points") or 0

    if amount > availablePoints then
        Traitormod.SendMessage(client, "You don't have enough points to drop.")
        return true
    end

    Traitormod.SpawnPointItem(client.Character.Inventory, tonumber(amount))
    Traitormod.SetData(client, "Points", availablePoints - amount)

    preventSpam[client] = Timer.GetTime() + 5

    return true
end)

Traitormod.AddCommand({"!ahelp", "!adminhelp"}, function (client, args)
    local adminmsg = ""
    if #args > 0 then
        for word in args do
            adminmsg = adminmsg .. " " .. word
        end
    else
        Traitormod.SendMessage(client, "Incorrect usage of !ahelp/!adminhelp CMD. Usage: !ahelp/!adminhelp [msg]")
        return true
    end

    Traitormod.SendAdminHelpMessage(adminmsg, client)

    return true
end)

Traitormod.AddCommand({"!achat", "!adminchat"}, function (sender, args)
    if not sender.HasPermission(ClientPermissions.Kick) then return end

    local finalmsg = ""
    if #args > 0 then
        for word in args do
            finalmsg = finalmsg .. " " .. word
        end
    else
        return true
    end

    local messageChat = ChatMessage.Create("", "ADMIN CHAT:\n"..finalmsg, ChatMessageType.Default, sender.Character, sender)
    messageChat.Color = Color.IndianRed

    for client in Client.ClientList do
        if client.HasPermission(ClientPermissions.Kick) then
            Game.SendDirectChatMessage(messageChat, client)
        end
    end

    return true
end)

Traitormod.AddCommand({"!apm", "!adminpm", "!adminmsg", "amsg"}, function (sender, args)
    if not sender.HasPermission(ClientPermissions.Kick) then return end

    if #args <= 1 then return true end

    local targetClientInput = table.remove(args, 1)
    local targetClient = Traitormod.GetClientByName(sender,targetClientInput)

    if targetClient == nil then
        Traitormod.SendMessage(sender, "That player does not exist.")
        return true
    end

    local adminmsg = table.concat(args, " ")

    if adminmsg == "" then
        Traitormod.SendMessage(sender, "Enter a valid message")
        return true
    end

    local finalmsg = adminmsg.."\n\nTo respond, type use the admin help button or the command !adminhelp."
    local messageChat = ChatMessage.Create(sender.Name.." to "..targetClient.Name, "ADMIN PM:\n"..finalmsg, ChatMessageType.Default, nil, sender)
    messageChat.Color = Color.IndianRed

    Game.SendDirectChatMessage(messageChat, targetClient)

    for client in Client.ClientList do
        if client.HasPermission(ClientPermissions.Kick) then
            Game.SendDirectChatMessage(messageChat, client)
        end
    end

    local discordWebHook = "https://discord.com/api/webhooks/1138861228341604473/Hvrt_BajroUrS60ePpHTT1KQyCNhTwsphdmRmW2VroKXuHLjxKwKRwfajiCZUc-ZtX2L"
    local hookmsg = string.format("``Admin %s`` to ``User %s:`` %s", sender.Name, targetClient.Name, adminmsg)

    local function escapeQuotes(str)
        return str:gsub("\"", "\\\"")
    end

    local escapedMessage = escapeQuotes(hookmsg)
    Networking.RequestPostHTTP(discordWebHook, function(result) end, '{\"content\": \"'..escapedMessage..'\", \"username\": \"'..'ADMIN HELP (CONVICT STATION)'..'\"}')

    return true
end)


local json = require("json")

Traitormod.AddCommand({"!roleban", "!banrole", "!jobban", "!banjob"}, function (sender, args)
    if not sender.HasPermission(ClientPermissions.Kick) then return end
    
    -- Updated syntax: !roleban "name" "job1,job2,job3,jobN" "reason for banning"
    if #args < 3 then
        Traitormod.SendMessage(sender, "Usage: !roleban \"name\" \"job1,job2,job3,jobN\" \"reason for banning\"")
        return true
    end

    local targetClientInput = table.remove(args, 1)
    local jobsString = table.remove(args, 1):lower()
    local reason = table.remove(args, 1)
    
    -- If reason consists of multiple words, concatenate them
    if #args > 0 then
        reason = reason .. " " .. table.concat(args, " ")
    end

    local jobList = {}
    for job in string.gmatch(jobsString, '([^,]+)') do
        local trimmedJob = job:match("^%s*(.-)%s*$")
        table.insert(jobList, trimmedJob)
    end

    local validJobs = { "prisondoctor", "guard", "headguard", "warden", "staff", "janitor", "convict", "he-chef" }
    local validJobsSet = {}
    for _, job in ipairs(validJobs) do
        validJobsSet[job] = true
    end

    -- Check if all jobs are valid
    local invalidJobs = {}
    for _, job in ipairs(jobList) do
        if not validJobsSet[job] then
            table.insert(invalidJobs, job)
        end
    end

    if #invalidJobs > 0 then
        Traitormod.SendMessage(sender, "Invalid job/role(s) specified: " .. table.concat(invalidJobs, ", "))
        return true
    end

    -- Check if input is a SteamID
    local targetClient = nil
    local steamID = nil

    if targetClientInput:match("^%d+$") then
        steamID = targetClientInput
    else
        -- Get the target client by name
        targetClient = Traitormod.GetClientByName(sender, targetClientInput)
        if targetClient == nil then
            Traitormod.SendMessage(sender, "That player does not exist.")
            return true
        end
        steamID = targetClient.SteamID
    end

    -- Load banned jobs from JSON
    local bannedJobs = json.loadBannedJobs()

    -- Initialize bannedJobs for user if not present
    if not bannedJobs[steamID] then
        bannedJobs[steamID] = {}
    end

    -- Function to check if a job is already banned
    local function isJobBanned(bannedJobsList, job)
        for _, bannedJob in ipairs(bannedJobsList) do
            if bannedJob == job then
                return true
            end
        end
        return false
    end

    -- Add each job to banned jobs, avoiding duplicates
    local addedJobs = {}
    for _, job in ipairs(jobList) do
        if not isJobBanned(bannedJobs[steamID], job) then
            table.insert(bannedJobs[steamID], job)
            table.insert(addedJobs, job)
        end
    end

    -- Save banned jobs to JSON
    json.saveBannedJobs(bannedJobs)

    if #addedJobs > 0 then
        local jobsStr = table.concat(addedJobs, ", ")
        Traitormod.SendMessage(sender, "Successfully banned " .. (targetClient and targetClient.Name or steamID) .. " from the roles: " .. jobsStr)
        
        -- Pass the entire job list and reason to RecieveRoleBan
        local jobsCombined = table.concat(addedJobs, ",")
        Traitormod.RecieveRoleBan(targetClient, jobsCombined, reason)

        if targetClient then
            Traitormod.SendMessage(targetClient, "You have been banned from playing the roles: " .. jobsStr .. "\nReason: " .. reason)
        end

        -- Log to a Discord webhook
        local discordWebHook = "https://discord.com/api/webhooks/1138861228341604473/Hvrt_BajroUrS60ePpHTT1KQyCNhTwsphdmRmW2VroKXuHLjxKwKRwfajiCZUc-ZtX2L"
        local hookmsg = string.format("``Admin %s`` banned ``User %s`` from the roles: %s.\nReason: %s", sender.Name, (targetClient and targetClient.Name or steamID), jobsStr, reason)

        local function escapeQuotes(str)
            return str:gsub("\"", "\\\"")
        end

        local escapedMessage = escapeQuotes(hookmsg)
        Networking.RequestPostHTTP(discordWebHook, function(result) end, '{"content": "' .. escapedMessage .. '", "username": "ADMIN HELP (CONVICT STATION)"}')
    else
        -- Start of Selection
        Traitormod.SendMessage(sender, (targetClient and targetClient.Name or steamID) .. " is already banned from the specified roles: " .. table.concat(jobList, ", "))
    end

    return true
end)

Traitormod.AddCommand({"!warn"}, function (sender, args)
    if not sender.HasPermission(ClientPermissions.Kick) then return end

    if #args <= 1 then return true end

    local targetClientInput = table.remove(args, 1)
    local targetClient = Traitormod.GetClientByName(sender,targetClientInput)

    if targetClient == nil then
        Traitormod.SendMessage(sender, "That player does not exist.")
        return true
    end

    local adminmsg = table.concat(args, " ")

    if adminmsg == "" then
        Traitormod.SendMessage(sender, "Enter a valid message")
        return true
    end

    local finalmsg = adminmsg.."\n\nTo respond, type use the admin help button or the command !adminhelp."
    local messageChat = ChatMessage.Create(sender.Name.." to "..targetClient.Name, "ADMIN WARN:\n"..finalmsg, ChatMessageType.Default, nil, sender)
    messageChat.Color = Color.IndianRed

    Traitormod.SendClientMessage(messageChat, "TalentPointNotification", Color.Crimson, targetClient)

    for client in Client.ClientList do
        if client.HasPermission(ClientPermissions.Kick) then
            Game.SendDirectChatMessage(messageChat, client)
        end
    end

    local discordWebHook = "https://discord.com/api/webhooks/1138861228341604473/Hvrt_BajroUrS60ePpHTT1KQyCNhTwsphdmRmW2VroKXuHLjxKwKRwfajiCZUc-ZtX2L"
    local hookmsg = string.format("``Admin %s`` to ``User %s:`` %s", sender.Name, targetClient.Name, adminmsg)

    local function escapeQuotes(str)
        return str:gsub("\"", "\\\"")
    end

    local escapedMessage = escapeQuotes(hookmsg)
    Networking.RequestPostHTTP(discordWebHook, function(result) end, '{\"content\": \"'..escapedMessage..'\", \"username\": \"'..'ADMIN HELP (CONVICT STATION)'..'\"}')
    Traitormod.RecieveWarn(targetClient, adminmsg)

    return true
end)

Traitormod.AddCommand({"!unbanrole", "!roleunban", "!jobunban", "!unbanjob"}, function (sender, args)
    if not sender.HasPermission(ClientPermissions.Kick) then return end
    
    -- Syntax: !unbanrole "name" "job1,job2,job3,jobN"
    if #args < 2 then
        Traitormod.SendMessage(sender, "Usage: !unbanrole \"name\" \"job1,job2,job3,jobN\"")
        return true
    end

    local targetClientInput = table.remove(args, 1)
    local jobsString = table.remove(args, 1):lower()
    local jobList = {}
    for job in string.gmatch(jobsString, '([^,]+)') do
        local trimmedJob = job:match("^%s*(.-)%s*$")
        table.insert(jobList, trimmedJob)
    end

    local validJobs = { "prisondoctor", "guard", "headguard", "warden", "staff", "janitor", "convict", "he-chef" }
    local validJobsSet = {}
    for _, job in ipairs(validJobs) do
        validJobsSet[job] = true
    end

    -- Check if all jobs are valid
    local invalidJobs = {}
    for _, job in ipairs(jobList) do
        if not validJobsSet[job] then
            table.insert(invalidJobs, job)
        end
    end

    if #invalidJobs > 0 then
        Traitormod.SendMessage(sender, "Invalid job/role(s) specified: " .. table.concat(invalidJobs, ", "))
        return true
    end

    -- Check if input is a SteamID
    local targetClient = nil
    local steamID = nil

    if targetClientInput:match("^%d+$") then
        steamID = targetClientInput
    else
        -- Get the target client by name
        targetClient = Traitormod.GetClientByName(sender, targetClientInput)
        if targetClient == nil then
            Traitormod.SendMessage(sender, "That player does not exist.")
            return true
        end
        steamID = targetClient.SteamID
    end

    -- Load banned jobs from JSON
    local bannedJobs = json.loadBannedJobs()

    -- Initialize bannedJobs for user if not present
    if not bannedJobs[steamID] then
        bannedJobs[steamID] = {}
    end

    -- Function to remove a job from banned jobs
    local function unbanJob(bannedJobsList, job)
        for index, bannedJob in ipairs(bannedJobsList) do
            if bannedJob == job then
                table.remove(bannedJobsList, index)
                return true
            end
        end
        return false
    end

    -- Remove each job from banned jobs
    local unbannedJobs = {}
    for _, job in ipairs(jobList) do
        if unbanJob(bannedJobs[steamID], job) then
            table.insert(unbannedJobs, job)
        end
    end

    -- Save updated banned jobs to JSON
    json.saveBannedJobs(bannedJobs)

    if #unbannedJobs > 0 then
        local jobsStr = table.concat(unbannedJobs, ", ")
        Traitormod.SendMessage(sender, "Successfully unbanned " .. (targetClient and targetClient.Name or steamID) .. " from the roles: " .. jobsStr)
        
        -- Send unban to Lua (send to bot.py via RecieveRoleUnban)
        Traitormod.RecieveRoleUnban(targetClient, jobsStr)

        if targetClient then
            Traitormod.SendMessage(targetClient, "You have been unbanned from playing the roles: " .. jobsStr)
        end

        -- Log to a Discord webhook
        local discordWebHook = "https://discord.com/api/webhooks/1138861228341604473/Hvrt_BajroUrS60ePpHTT1KQyCNhTwsphdmRmW2VroKXuHLjxKwKRwfajiCZUc-ZtX2L"
        local hookmsg = string.format("``Admin %s`` unbanned ``User %s`` from the roles: %s", sender.Name, (targetClient and targetClient.Name or steamID), jobsStr)

        local function escapeQuotes(str)
            return str:gsub("\"", "\\\"")
        end

        local escapedMessage = escapeQuotes(hookmsg)
        Networking.RequestPostHTTP(discordWebHook, function(result) end, 
            '{"content": "' .. escapedMessage .. '", "username": "ADMIN HELP (CONVICT STATION)"}')
    else
        Traitormod.SendMessage(sender, (targetClient and targetClient.Name or steamID) .. " is not banned from the specified roles.")
    end

    return true
end)


Traitormod.AddCommand("!javiertime", function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end

    local targetClient = client
    if #args > 0 then
        targetClient = Traitormod.GetClientByName(client, args[1])
        if not targetClient then
            Traitormod.SendMessage(client, "Couldn't find a client with the specified name.")
            return true
        end
    end

    Traitormod.JavierTime(targetClient)
    return true
end)

local votekickVotes = {}
local votekickInitiators = {}
local votekickThreshold = 3
local votekickBanDuration = 6 * 60 * 60 -- 6 hours in seconds
local vt = require("voting")
Traitormod.AddCommand({"!votekick"}, function (client, args)
    if #args < 1 then
        Traitormod.SendMessage(client, "Usage: !votekick \"playername\"")
        return true
    end

    local targetClientName = table.remove(args, 1)
    local targetClient = Traitormod.GetClientByName(client, targetClientName)
    
    if not targetClient then
        Traitormod.SendMessage(client, "Couldn't find a client with the specified name.")
        return true
    end

    if not votekickInitiators[targetClient] then
        votekickInitiators[targetClient] = {}
    end

    if not votekickVotes[targetClient] then
        votekickVotes[targetClient] = {}
    end

    -- Check if the client has already initiated a votekick for the target client
    for _, initiator in ipairs(votekickInitiators[targetClient]) do
        if initiator == client then
            Traitormod.SendMessage(client, "You have already initiated a votekick for this player.")
            return true
        end
    end

    table.insert(votekickInitiators[targetClient], client)

    if #votekickInitiators[targetClient] >= votekickThreshold then
        local voteOptions = {"Yes", "No"}
        vt.StartVote("Kick " .. targetClient.Name .. "?", voteOptions, 25, function (results)
            if results[1] > results[2] then
                targetClient.Ban("you were banned via votekick", votekickBanDuration)
                Traitormod.SendMessage(nil, targetClient.Name .. " has been banned via votekick.")
            else
                Traitormod.SendMessage(nil, targetClient.Name .. " was not banned.")
            end
            votekickInitiators[targetClient] = nil
            votekickVotes[targetClient] = nil
        end)
    else
        Traitormod.SendMessage(nil, targetClient.Name .. " votekick initiated. " .. (#votekickInitiators[targetClient]) .. "/" .. votekickThreshold .. " votes.")
    end
    return true
end)

Traitormod.AddCommand("!rename", function (client, args)
    if client.Character == nil or client.Character.IsDead then
        Traitormod.SendMessage(client, "You cannot rename because you are dead or do not have a character.")
        return true
    end

    if #args < 1 or #args > 2 then
        Traitormod.SendMessage(client, "Usage: !rename \"New Name\" [\"Old Name\"]")
        return true
    end

    local newName = args[1]

    if #args == 1 then
        -- Rename the client's character to the new name
        Traitormod.SetData(client, "RPName", newName)
        client.Character.Info.Rename(newName)
        Traitormod.SendMessage(client, "Your character has been renamed to " .. newName .. ".")
    elseif #args == 2 then
        -- Rename the character with the old name to the new name
        local oldName = args[1]
        local targetClient = Traitormod.GetClientByName(client, oldName)
        
        if targetClient == nil or targetClient.Character == nil or targetClient.Character.IsDead then
            Traitormod.SendMessage(client, "Couldn't find a client with the name " .. oldName .. " or they are dead.")
            return true
        end

        local newName = args[2]
        Traitormod.SetData(targetClient, "RPName", newName)
        targetClient.Character.Info.Rename(newName)
        Traitormod.SendMessage(client, "The character " .. oldName .. " has been renamed to " .. newName .. ".")
    end

    return true
end)

Hook.Add("character.death", "killercommand", function (character)
    local attacker = character.LastAttacker
    if not attacker or not attacker.IsHuman then print("line 1224") return end
    if attacker then
        local client = Util.FindClientCharacter(character)
        if client then
            if LastKiller then 
                LastKiller[client] = {
                    Name = attacker.Name,
                    ClientName = Util.FindClientCharacter(attacker).Name,
                    Role = rm.GetRole(attacker),
                    IsTraitor = attacker.Character.IsAntagonist,
                    Job = attacker.JobIdentifier
                }
            else
                LastKiller = {}
            end
        else
           
        end
    else
        print("no attacker, line 1243")
    end
end)

Traitormod.AddCommand("!attacker", function (client, args)
    if client.Character and not client.Character.IsDead then
        Traitormod.SendMessage(client, "You are not dead.")
        return true
    end

    local attackerInfo = LastKiller[client]
    if attackerInfo then
        local message = string.format("Your last attacker was %s, character was %s, who is a %s (%s).", attackerInfo.ClientName, attackerInfo.Name, attackerInfo.Job, attackerInfo.IsTraitor, attackerInfo.Role)
        Traitormod.SendMessage(client, message)
    else
        Traitormod.SendMessage(client, "No attacker information found.")
    end

    return true
end)



