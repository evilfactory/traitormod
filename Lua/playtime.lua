Hook.Add("think", "Traitormod.Playtime.think", function()
    for index, client in pairs(Client.ClientList) do
        Traitormod.AddData(client, "Playtime", 1/60)
    end
end)

Traitormod.AddCommand({"!playtime", "!pt"}, function (client, args)
    Traitormod.SendChatMessage(
        client,
        string.format(Traitormod.Language.CMDPlaytime, Traitormod.FormatTime(math.ceil(Traitormod.GetData(client, "Playtime") or 0))),
        Color.Green
    )
    return true
end)