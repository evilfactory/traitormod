local vt = {}

local textPromptUtils = require("textpromptutils")

vt.Votes = {}

vt.StartVote = function (text, options, time, completed, clients)
    if clients == nil then clients = Client.ClientList end

    local voteData = {}

    table.insert(vt.Votes, voteData)

    local voteId = #vt.Votes

    voteData.Time = Timer.GetTime() + time
    voteData.OnCompleted = completed
    voteData.Results = {}
    voteData.Clients = {}
    for i = 1, #options, 1 do
        voteData.Results[i] = 0
    end
    for index, value in ipairs(clients) do
        voteData.Clients[value] = -1
    end

    local max = 0
    local amount = 0

    for key, client1 in pairs(clients) do
        max = max + 1
        textPromptUtils.Prompt(text, options, client1, function (id, client2)
            if voteData.Completed then return end

            local option = options[id]

            if option == nil then return end
            
            voteData.Results[id] = voteData.Results[id] + 1
            voteData.Clients[client2] = id

            amount = amount + 1

            if amount == max then
                voteData.Completed = true
                table.remove(vt.Votes, voteId)
                voteData.OnCompleted(voteData.Results, voteData.Clients)
            end
        end)
    end
end

Hook.Add("think", "Traitormod.Voting.Think", function ()
    for key, voteData in pairs(vt.Votes) do
        if Timer.GetTime() > voteData.Time then
            voteData.Completed = true
            table.remove(vt.Votes, key)
            voteData.OnCompleted(voteData.Results, voteData.Clients)
            break
        end
    end
end)

Traitormod.AddCommand("!vote", function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end
    if not client.InGame then
        Traitormod.SendMessage(client, "You must be in game to use this command.")
        return true
    end

    if #args < 3 then
        Traitormod.SendMessage(client, "Usage: !vote \"Text Here\" \"Option 1\" \"Option 2\" ... \"Option N\"")
        return true
    end

    local text = table.remove(args, 1)

    vt.StartVote(text, args, 25, function (results)
        local message = Traitormod.StringBuilder:new()
        message("Vote results: %s\n\n", text)
        for key, value in pairs(results) do
            message("%s: %s Votes\n", args[key], value)
        end

        for key, target in pairs(Client.ClientList) do
            local chatMessage = ChatMessage.Create("", message:concat(), ChatMessageType.Default, nil, nil)
            chatMessage.Color = Color(255, 255, 255, 255)
            Game.SendDirectChatMessage(chatMessage, target)
        end
    end)

    return true
end)

Traitormod.AddCommand({"!startwardenvote"}, function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end
    if not client.InGame then
        Traitormod.SendMessage(client, "You must be in game to use this command.")
        return true
    end

    -- Filter clients with the "warden" job
    wardenCandidates = {}
    for _, client in pairs(Client.ClientList) do
        if client.AssignedJob and client.AssignedJob.Prefab.Identifier == "warden" then
            table.insert(wardenCandidates, client)
        end
    end

    if #wardenCandidates == 0 then
        Traitormod.SendMessage(client, "No clients have the 'warden' job.")
        return true
    end

    wardenVotes = {}
    wardenVoteInProgress = true
    wardenVoteTimer = Timer.GetTime() + 25 -- 25 seconds vote time

    -- Announce vote start and options
    Traitormod.SendMessage(nil, "Vote for Warden started!")
    Traitormod.SendMessage(nil, "Options:")
    for i, candidate in ipairs(wardenCandidates) do
        Traitormod.SendMessage(nil, string.format("%d. %s", i, candidate.Name))
    end

    return true
end)

Traitormod.AddCommand({"!votewarden"}, function (client, args)
    if not wardenVoteInProgress then
        Traitormod.SendMessage(client, "No warden vote in progress.")
        return true
    end

    if #args < 1 then
        Traitormod.SendMessage(client, "Usage: !votewarden (number)")
        return true
    end

    local voteNumber = tonumber(args[1])
    if not voteNumber or voteNumber < 1 or voteNumber > #wardenCandidates then
        Traitormod.SendMessage(client, "Invalid vote number.")
        return true
    end

    wardenVotes[client] = voteNumber
    Traitormod.SendMessage(client, "Your vote has been cast.")

    return true
end)

Hook.Add("think", "Traitormod.WardenVoting.Think", function ()
    if wardenVoteInProgress and Timer.GetTime() > wardenVoteTimer then
        wardenVoteInProgress = false

        -- Count votes
        local voteCounts = {}
        for i = 1, #wardenCandidates do
            voteCounts[i] = 0
        end

        for _, vote in pairs(wardenVotes) do
            if voteCounts[vote] then
                voteCounts[vote] = voteCounts[vote] + 1
            end
        end

        -- Determine the winner
        local maxVotes = 0
        local winnerIndex = nil
        for i, count in ipairs(voteCounts) do
            if count > maxVotes then
                maxVotes = count
                winnerIndex = i
            end
        end

        if winnerIndex then
            local winner = wardenCandidates[winnerIndex]
            Traitormod.SendMessage(nil, string.format("Warden Vote Results:\nWinner: %s with %d votes", winner.Name, maxVotes))
        else
            Traitormod.SendMessage(nil, "Warden Vote Results:\nNo votes cast.")
        end

        -- Assign warden role based on vote results
        for _, client in pairs(Client.ClientList) do
            local jobName = client.AssignedJob.Prefab.Identifier.ToString()
            if jobName == "warden" and client ~= wardenCandidates[winnerIndex] then
                local validJobs = { "prisondoctor", "guard", "headguard", "staff", "janitor", "convict", "he-chef" }
                local newJobName = validJobs[math.random(1, #validJobs)]
                client.AssignedJob = Traitormod.GetJobVariant(newJobName)
                Traitormod.SendMessage(client, "You have been reassigned from the warden role to: " .. newJobName)
                print(string.format("Client %s reassigned to new job %s due to warden vote", client.Name, newJobName))
            end
        end
    end
end)

return vt