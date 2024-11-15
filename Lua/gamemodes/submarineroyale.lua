-- lmao

local weightedRandom = dofile(Traitormod.Path .. "/Lua/weightedrandom.lua")
local gm = Traitormod.Gamemodes.Gamemode:new()

gm.Name = "SubmarineRoyale"
gm.RequiredGamemode = "sandbox"

gm.badPositions = {}
gm.badSubmarines = {}
gm.radiationEnabled = false

local radiationPrefab = AfflictionPrefab.Prefabs["radiationsickness"]
local antiRadPrefab = ItemPrefab.GetItemPrefab("antirad")


local function StringStarts(String,Start)
    return string.sub(String,1,string.len(Start))==Start
end


function gm:FindGoodPosition()
    local goodPositions = {}

    for key, value in ipairs(Level.Loaded.PositionsOfInterest) do
        if not self.badPositions[value] and value.PositionType == PositionType.MainPath then
            table.insert(goodPositions, value)
        end
    end

    return goodPositions[math.random(1, #goodPositions)]
end


function gm:FindGoodSubmarines()
    local candidates = {}

    for key, value in pairs(Submarine.Loaded) do
        if not self.badSubmarines[value] and StringStarts(value.Info.Name, "Player") then
            table.insert(candidates, value)
            self.badSubmarines[value] = true
        end
    end

    return candidates
end

local function SpawnBeacon(name, position)
    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.Prefabs["sonarbeacon"], position, nil, nil, function(item)
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.Prefabs["batterycell"], item.OwnInventory, nil, nil, function(bat)
            bat.Indestructible = true

            local interface = item.GetComponentString("CustomInterface")

            interface.customInterfaceElementList[1].State = true
            interface.customInterfaceElementList[2].Signal = name

            item.CreateServerEvent(interface, interface)
        end)
    end)
end

local function GetRandomTurret(submarine)
    local turrets = {}
    for key, value in pairs(submarine.GetItems(false)) do
        if value.HasTag("turret") then
            table.insert(turrets, value)
        end
    end

    return turrets[math.random(#turrets)]
end

local function SpawnEnemyCharacter(submarine, role, orders)
    local info = CharacterInfo(Identifier("human"))
    info.Job = Job(JobPrefab.Get(role), false)

    submarine.TeamID = CharacterTeamType.Team2

    local waypoint = WayPoint.SelectCrewSpawnPoints({info}, submarine)[1]
    local character = Character.Create(info, waypoint.WorldPosition, info.Name, 0, false, true)

    character.TeamID = CharacterTeamType.Team2
    character.GiveJobItems(false, waypoint)

    if orders then
        for key, value in pairs(orders) do
            local order = nil
            if value == "operateweapons" then
                local turret = GetRandomTurret(submarine)

                order = Order(OrderPrefab.Prefabs[value], turret, turret.GetComponentString("Turret"))
            else
                order = Order(OrderPrefab.Prefabs[value], nil, nil)
            end

            character.SetOrder(order, true, true, true)
        end
    end

    if role == "medicaldoctor" then
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("revolver"), character.Inventory, nil, nil, function (item)
            for i = 1, 6, 1 do
                Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("revolverround"), character.Inventory)       
            end
        end)
    end
end

function gm:StartRadiation(args, client)
    for key, value in pairs(Client.ClientList) do
        local message = "Radiation has started affecting the area, everyone will start to receive a small dosage of radiation until they die, killing other players will cause them to drop Anti Rad. Good luck."

        local chatMessage = ChatMessage.Create("", message, ChatMessageType.Error, nil)
        local chatMessageBox = ChatMessage.Create("", message, ChatMessageType.MessageBox, nil)
        Game.SendDirectChatMessage(chatMessage, value) 
        Game.SendDirectChatMessage(chatMessageBox, value) 
    end

    self.radiationEnabled = true

    return true
end


function gm:PreStart()
    if Traitormod.SubmarineBuilder == nil then return end

    Traitormod.SubmarineBuilder.AddSubmarine(Traitormod.Path .. "/Submarines/Royale/SmallLoot.sub", "+Small Loot", true)

    if math.random() > 0.5 then
        Traitormod.SubmarineBuilder.AddSubmarine(Traitormod.Path .. "/Submarines/Royale/BigLoot.sub", "+Cargo Ship", true)
    else
        Traitormod.SubmarineBuilder.AddSubmarine(Traitormod.Path .. "/Submarines/Royale/BigLoot2.sub", "+Attack Ship", true)
    end

    Traitormod.SubmarineBuilder.AddSubmarine(Traitormod.Path .. "/Submarines/Royale/Shuttle_Railgun_Mod.sub", "+Railgun Module", true)
    Traitormod.SubmarineBuilder.AddSubmarine(Traitormod.Path .. "/Submarines/Royale/Chaingun_Mod.sub", "+Chaingun Module", true)
    Traitormod.SubmarineBuilder.AddSubmarine(Traitormod.Path .. "/Submarines/Royale/coilgun_mod.sub", "+Coilgun Module", true)

    Traitormod.SubmarineBuilder.AddSubmarine(Traitormod.Path .. "/Submarines/Royale/coilgun_mod.sub", "+Coilgun Module", true)

    for i = 1, #Client.ClientList + 1, 1 do
        Traitormod.SubmarineBuilder.AddSubmarine(Traitormod.Path .. "/Submarines/Royale/PlayerSubmarine_1.sub", "Player - " .. i, true)
    end
end

function gm:Start()
    if Traitormod.SubmarineBuilder == nil then return end
    
    Traitormod.DisableRespawnShuttle = true

    for key, value in pairs(Client.ClientList) do
        local message = "Welcome to Submarine Royale!\n\nUse the command !players to see in which submarine are the players located."

        local chatMessage = ChatMessage.Create("", message, ChatMessageType.Private, nil)
        Game.SendDirectChatMessage(chatMessage, value) 
    end

    for key, value in pairs(Item.ItemList) do
        local wifiComponent = value.GetComponentString("WifiComponent")
        if wifiComponent then
            wifiComponent.Range = 99999999999999

            local property = wifiComponent.SerializableProperties[Identifier("Range")]
            Networking.CreateEntityEvent(value, Item.ChangePropertyEventData(property, wifiComponent))
        end
    end

    local submarines = self:FindGoodSubmarines()

    for key, value in pairs(Client.ClientList) do
        if value.Character then   
            local submarineIndex = math.random(1, #submarines)   
            local submarine = submarines[submarineIndex]

            local goodPosition = self:FindGoodPosition()

            Game.Explode(goodPosition.Position.ToVector2(), 100, 99999, 99999, 99999, 99999, 9999, 99999)

            submarine.SetPosition(goodPosition.Position.ToVector2())
            self.badPositions[goodPosition] = true

            value.Character.TeleportTo(submarine.GetHulls(false)[1].WorldPosition)

            value.Character.Info.IncreaseSkillLevel("helm", 100)
            value.Character.Info.IncreaseSkillLevel("weapons", 100)
            value.Character.Info.IncreaseSkillLevel("medical", 100)
            value.Character.Info.IncreaseSkillLevel("electrical", 100)
            value.Character.Info.IncreaseSkillLevel("mechanical", 100)

            table.remove(submarines, submarineIndex)
            AutoItemPlacer.RegenerateLoot(submarine)
            submarine.GodMode = false
        end
    end

    for key, value in pairs(submarines) do
        local goodPosition = self:FindGoodPosition()
        value.SetPosition(goodPosition.Position.ToVector2())
        self.badPositions[goodPosition] = true
    end

    for key, value in pairs(Submarine.Loaded) do
        if StringStarts(value.Info.Name, "+") then
            local goodPosition = self:FindGoodPosition()
            value.SetPosition(goodPosition.Position.ToVector2())
            self.badPositions[goodPosition] = true  
            AutoItemPlacer.RegenerateLoot(value)
            value.GodMode = false
        end

        if value.Info.Name == "+Cargo Ship" then
            local crews = {
                { Job = "captain" },
                { Job = "securityofficer" },
                { Job = "medicaldoctor", Orders = {"rescue"} },
            }
            for key, crew in pairs(crews) do
                SpawnEnemyCharacter(value, crew.Job, crew.Orders)
            end
        end

        if value.Info.Name == "+Attack Ship" then
            local crews = {
                { Job = "captain" },
                { Job = "securityofficer", Orders = {"operateweapons"} },
                { Job = "securityofficer" },
                { Job = "medicaldoctor", Orders = {"rescue"} },
            }
            for key, crew in pairs(crews) do
                SpawnEnemyCharacter(value, crew.Job, crew.Orders)
            end
        end
    end

    for key, value in pairs(Level.Loaded.Wrecks) do
        SpawnBeacon(value.Info.Name, value.WorldPosition)
    end

    if Level.Loaded.BeaconStation then
        SpawnBeacon(Level.Loaded.BeaconStation.Info.Name, Level.Loaded.BeaconStation.WorldPosition)
    end

    local this = self
    local thisRoundID = Traitormod.RoundNumber
    Timer.Wait(function ()
        if thisRoundID ~= Traitormod.RoundNumber then return end
        this:StartRadiation()
    end, 1000 * 60 * 5)

    Hook.Add("characterDeath", "SubmarineRoyale.SpawnAntiRad", function (character)
        if not character.IsHuman then return end

        Entity.Spawner.AddItemToSpawnQueue(antiRadPrefab, character.Inventory, nil, nil, function(item)
            item.body.SetTransform(character.WorldPosition, 0)
        end)

        if character.CauseOfDeath == nil or character.CauseOfDeath.Killer == nil then 
            return
        end

        local attacker = character.CauseOfDeath.Killer

        if attacker.IsHuman then
            attacker.Info.GiveExperience(5000)
        end
    end)


    Traitormod.AddCommand({"!players"}, function (client, args)
        if client.Character == nil or not client.InGame then
            Traitormod.SendMessage(client, Traitormod.Language.CMDAliveToUse)
            return true
        end

        local text = ""

        local center = client.Character.WorldPosition
        for key, value in pairs(Client.ClientList) do
            if value.Character and not value.Character.IsDead then
                local target = value.Character.WorldPosition

                local distance = Vector2.Distance(center, target) * Physics.DisplayToRealWorldRatio
        
                local diff = center - target
        
                local angle = math.deg(math.atan2(diff.X, diff.Y)) + 180
        
                local function degreeToOClock(v)
                    local oClock = math.floor(v / 30)
                    if oClock == 0 then oClock = 12 end
                    return oClock .. " o'clock"
                end

                local submarineName = value.Character.Submarine and value.Character.Submarine.Info.Name or "Unknown"

                text = text .. string.format(Traitormod.Language.CMDLocatePlayer, value.Name, math.floor(distance), degreeToOClock(angle), submarineName) .. "\n"
            end
        end

        Game.SendDirectChatMessage("", text, nil, ChatMessageType.Error, client)

        return true
    end)
end

function gm:End()
    Hook.Remove("characterDeath", "SubmarineRoyale.SpawnAntiRad")
    Traitormod.RemoveCommand("!players")
end

function gm:Think()
    local aliveClientCount = 0
    for _, client in pairs(Client.ClientList) do
        if client.Character and not client.Character.IsDead and client.Character.IsHuman then
            aliveClientCount = aliveClientCount + 1
        end
    end

    if aliveClientCount < 2 and not self.Ending then
        Traitormod.SendMessageEveryone(Traitormod.Language.SubmarineRoyaleEnd)
        Timer.Wait(function ()
            Game.EndGame()
        end, 5000)

        self.Ending = true
    end

    if not self.radiationEnabled then return end

    for key, value in pairs(Client.ClientList) do
        if value.Character and not value.Character.IsDead then
            local char = value.Character
            local limb = char.AnimController.MainLimb

            char.CharacterHealth.ApplyAffliction(limb, radiationPrefab.Instantiate(0.0025))
        end
    end
end


return gm
