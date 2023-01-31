local sb = {}

local linkedSubmarineHeader = [[<LinkedSubmarine description="" checkval="2040186250" price="1000" initialsuppliesspawned="false" type="Player" tags="Shuttle" gameversion="0.17.4.0" dimensions="1270,451" cargocapacity="0" recommendedcrewsizemin="1" recommendedcrewsizemax="2" recommendedcrewexperience="Unknown" requiredcontentpackages="Vanilla" name="%s" filepath="Content/Submarines/Selkie.sub" pos="-64,-392.5" linkedto="4" originallinkedto="0" originalmyport="0">%s</LinkedSubmarine>]]

sb.IsActive = function ()
    return Game.GetRespawnSub() ~= nil
end

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
end

sb.Submarines = {}

sb.AddSubmarine = function (path, name)
    local submarineInfo = SubmarineInfo(path)

    name = name or submarineInfo.Name

    local xml = tostring(submarineInfo.SubmarineElement)

    local _, endPos = string.find(xml, ">")
    local startPos, _ = string.find(xml, "</Submarine>")

    local data = string.sub(xml, endPos + 1, startPos - 1)

    table.insert(sb.Submarines, {Name = name, Data = data})

    return name
end

sb.FindSubmarine = function (name)
    for _, submarine in pairs(Submarine.Loaded) do
        if submarine.Info.Name == name then
            return submarine
        end
    end
end

sb.ResetSubmarineSteering = function (submarine)
    for _, item in pairs(submarine.GetItems(true)) do
        local steering = item.GetComponentString("Steering")
        if steering then
            steering.AutoPilot = true
            steering.MaintainPos = true
            steering.PosToMaintain = submarine.WorldPosition
            steering.UnsentChanges = true
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

Hook.HookMethod("Barotrauma.Networking.GameServer", "TryStartGame", {}, function ()
    sb.BuildSubmarines()
end)

Hook.Add("roundStart", "SubmarineBuilder.RoundStart", function ()
    if Game.GetRespawnSub() == nil then return end

    for _, item in pairs(Game.GetRespawnSub().GetItems(false)) do
        local dockingPort = item.GetComponentString("DockingPort")
        if dockingPort then
            dockingPort.Undock()
        end
    end

    local xPosition = 0
    local yPosition = Level.Loaded.Size.Y + 10000

    for _, value in pairs(sb.Submarines) do
        local submarine = sb.FindSubmarine(value.Name)

        if submarine then
            xPosition = xPosition + submarine.Borders.Width * 2
            submarine.SetPosition(Vector2(xPosition, yPosition))
            submarine.GodMode = true
        end

        sb.ResetSubmarineSteering(submarine)
    end
end)

return sb