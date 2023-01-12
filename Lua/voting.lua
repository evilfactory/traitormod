local vt = {}

local textPromptUtils = require("textpromptutils")

vt.Votes = {}

vt.StartVote = function (text, options, time, completed)
    local voteData = {}

    table.insert(vt.Votes, voteData)

    local voteId = #vt.Votes

    voteData.Time = Timer.GetTime() + time
    voteData.OnCompleted = completed
    voteData.Results = {}
    for i = 1, #options, 1 do
        voteData.Results[i] = 0
    end

    local max = 0
    local amount = 0

    for key, client1 in pairs(Client.ClientList) do
        max = max + 1
        textPromptUtils.Prompt(text, options, client1, function (id, client2)
            if voteData.Completed then return end

            local option = options[id]

            if option == nil then return end
            
            voteData.Results[id] = voteData.Results[id] + 1

            amount = amount + 1

            if amount == max then
                voteData.OnCompleted(voteData.Results)
                voteData.Completed = true
                table.remove(vt.Votes, voteId)
            end
        end)
    end
end

Hook.Add("think", "Traitormod.Voting.Think", function ()
    for key, voteData in pairs(vt.Votes) do
        if Timer.GetTime() > voteData.Time then
            voteData.OnCompleted(voteData.Results)
            voteData.Completed = true
            table.remove(vt.Votes, key)
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

return vt