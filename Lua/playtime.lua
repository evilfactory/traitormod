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


-- A more optimized way : ( unimplemented )

-- local playtimes = {}


-- Hook.Add("roundStart", "Traitormod.Playtime.ClientDisconnected", function (client)
--     playtimes[]
-- end)


-- Hook.Add("roundEnd", "Traitormod.Playtime.ClientDisconnected", function (client)
--     playtimes[]
-- end)

-- Hook.Add("client.connected", "Traitormod.Playtime.ClientDisconnected", function (client)
--     playtimes[]
-- end)

-- Hook.Add("client.disconnected", "Traitormod.Playtime.ClientDisconnected", function (client)
--     Traitormod.AddData(client, "Playtime", amount)
-- end)