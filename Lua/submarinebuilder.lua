local sb = {}

local linkedSubmarineHeader = [[<LinkedSubmarine description="" checkval="2040186250" price="1000" initialsuppliesspawned="false" type="Player" tags="Shuttle" gameversion="0.17.4.0" dimensions="1270,451" cargocapacity="0" recommendedcrewsizemin="1" recommendedcrewsizemax="2" recommendedcrewexperience="Unknown" requiredcontentpackages="Vanilla" name="%s" filepath="Content/Submarines/Selkie.sub" pos="-64,-392.5" linkedto="4" originallinkedto="0" originalmyport="0">%s</LinkedSubmarine>]]

local submarineSpawned = false

sb.UpdateLobby = function(submarineInfo)
    local submarines = Game.NetLobbyScreen.subs

    for key, value in pairs(submarines) do
        if value.Name == "submarineinjector" then
            table.remove(submarines, key)
        end
    end

    table.insert(submarines, submarineInfo)
    SubmarineInfo.AddToSavedSubs(submarineInfo)

    Game.NetLobbyScreen.subs = submarines
    Game.NetLobbyScreen.SelectedShuttle = submarineInfo

    for _, client in pairs(Client.ClientList) do
        client.LastRecvLobbyUpdate = 0
        Networking.ClientWriteLobby(client)
    end

    Game.SendMessage("Submarines Updated", 1)
end

sb.Submarines = {}

sb.AddSubmarine = function (name, path)
    table.insert(sb.Submarines, {Name = name, Data = File.Read(path)})
end

sb.UseSubmarine = function (name)
    Game.DispatchRespawnSub()

    for key, value in pairs(Game.GetRespawnSub().GetItems(true)) do
        local dockingPort = value.GetComponentString("DockingPort")
        if dockingPort then
            dockingPort.Undock()
        end
    end

    for _, submarine in pairs(Submarine.Loaded) do
        if submarine.Info.Name == name then
            return submarine
        end
    end
end

sb.BuildSubmarines = function()
    local submarineInjector = File.Read(Traitormod.Path .. "/Submarines/submarineinjector.xml")
    local result = ""

    for k, v in pairs(sb.Submarines) do
        result = result .. string.format(linkedSubmarineHeader, v.Name, v.Data)
    end

    local submarineText = string.format(submarineInjector, result)

    File.Write(Traitormod.Path .. "/Submarines/temp.xml", submarineText)
    local submarineInfoXML = SubmarineInfo(Traitormod.Path .. "/Submarines/temp.xml")
    submarineInfoXML.SaveAs(Traitormod.Path .. "/Submarines/temp.sub")

    local submarineInfo = SubmarineInfo(Traitormod.Path .. "/Submarines/temp.sub")

    sb.UpdateLobby(submarineInfo)
end

Hook.HookMethod("Barotrauma.Networking.GameServer", "StartGame", {}, function ()
    sb.BuildSubmarines()
end)

return sb