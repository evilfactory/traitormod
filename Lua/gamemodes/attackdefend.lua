local weightedRandom = dofile(Traitormod.Path .. "/Lua/weightedrandom.lua")
local gm = Traitormod.Gamemodes.Gamemode:new()

gm.Name = "AttackDefend"
gm.RequiredGamemode = "sandbox"

local function SpawnCharacter(client, team, existingCharacter)
    if client.SpectateOnly or client.CharacterInfo == nil then return false end

    if not existingCharacter then
        local spawnPoint = team.Spawns[math.random(1, #team.Spawns)]
        local character = Character.Create(client.CharacterInfo, spawnPoint.WorldPosition, client.CharacterInfo.Name, 0, true, true)

        character.TeamID = team.TeamID

        client.SetClientCharacter(character)
        character.GiveJobItems()
        character.LoadTalents()

        character.TeleportTo(spawnPoint.WorldPosition)
    else
        local spawnPoint = team.Spawns[math.random(1, #team.Spawns)]

        existingCharacter.SetOriginalTeam(team.TeamID)
        existingCharacter.UpdateTeam()
        existingCharacter.TeleportTo(spawnPoint.WorldPosition)

        local innerClothes = existingCharacter.Inventory.GetItemInLimbSlot(InvSlotType.InnerClothes)
        if innerClothes then
            innerClothes.SpriteColor = team.Color
            local color = innerClothes.SerializableProperties[Identifier("SpriteColor")]
            Networking.CreateEntityEvent(innerClothes, Item.ChangePropertyEventData(color, innerClothes))
        end

        local card = existingCharacter.Inventory.GetItemInLimbSlot(InvSlotType.Card)

        if card then
            card.Drop()
            Entity.Spawner.AddEntityToRemoveQueue(card)
        end

        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("idcard"), existingCharacter.Inventory, nil, nil, function (item)
            item.GetComponentString("IdCard").Initialize(spawnPoint, existingCharacter)
        end, true, false, InvSlotType.Card)
    end
end

local function ChooseTeam(client, team1, team2)
    for key, value in pairs(team1.Members) do
        if value == client then return end
    end
    for key, value in pairs(team2.Members) do
        if value == client then return end
    end

    if #team1.Members > #team2.Members then
        table.insert(team2.Members, client)
    elseif #team1.Members < #team2.Members then
        table.insert(team1.Members, client)
    else
        if math.random() > 0.5 then
            table.insert(team1.Members, client)
        else
            table.insert(team2.Members, client)
        end
    end
end

function gm:Start()
    Traitormod.DisableRespawnShuttle = true
    Traitormod.DisableMidRoundSpawn = true

    if self.LockSubmarines then
        Submarine.LockX = true
        Submarine.LockY = true
    end

    self.Respawns = {}
    self.DefendCountDown = self.DefendTime * 60
    self.LastDefendCountDown = self.DefendTime * 60

    local teams = {}
    self.Teams = teams
    teams[1] = {}
    teams[1].Name = "Defender Team"
    teams[1].Spawns = {}
    teams[1].Members = {}
    teams[1].TeamID = CharacterTeamType.Team1
    teams[1].RespawnTime = self.DefendRespawn
    teams[1].Color = Color.Blue
    teams[2] = {}
    teams[2].Name = "Attacker Team"
    teams[2].Spawns = {}
    teams[2].Members = {}
    teams[2].TeamID = CharacterTeamType.Team2
    teams[2].RespawnTime = self.AttackRespawn
    teams[2].Color = Color.Red

    for key, value in pairs(Item.ItemList) do
        if value.GetComponentString("Reactor") then
            if value.HasTag("redteam") then
                teams[1].Reactor = value
            end
        end
    end

    teams[1].CheckWinCondition = function ()
        if self.DefendCountDown <= 0 then
            return true
        end
        return false
    end

    teams[2].CheckWinCondition = function ()
        if teams[1].Reactor and teams[1].Reactor.Condition <= 1 then
            return true
        end
        return false
    end

    for key, value in pairs(Submarine.MainSub.GetWaypoints(true)) do
        if value.AssignedJob then
            if value.AssignedJob.Identifier == "mechanic" then
                table.insert(teams[1].Spawns, value)
            elseif value.AssignedJob.Identifier == "engineer" then
                table.insert(teams[2].Spawns, value)
            end
        end
    end

    local clients = Client.ClientList
    for i = 1, #clients, 1 do
        ChooseTeam(clients[i], teams[1], teams[2])
    end

    for _, team in pairs(teams) do
        for _, member in pairs(team.Members) do
            if member.Character then
                SpawnCharacter(member, team, member.Character)
            end
        end
    end

    Hook.Add("client.connected", "Traitormod.AttackDefend.ClientConnected", function (client)
        ChooseTeam(client, teams[1], teams[2])
    end)
end

function gm:End()
    Hook.Remove("client.connected", "Traitormod.AttackDefend.ClientConnected")

    if self.LockSubmarines then
        Submarine.LockX = false
        Submarine.LockY = false
    end

    -- first arg = mission id, second = message, third = completed, forth = list of characters
    return nil
end

function gm:Think()
    if self.Ending then return end
    self.DefendCountDown = self.DefendCountDown - 1/60

    local max = 30
    if self.DefendCountDown <= 10 then max = 1 end
    if self.LastDefendCountDown - self.DefendCountDown > max then
        for _, client in pairs(Client.ClientList) do
            Traitormod.SendChatMessage(client, "The defender team has " .. math.ceil(self.DefendCountDown) .. " seconds left to defend the reactor!", Color.GreenYellow)
        end
        self.LastDefendCountDown = self.DefendCountDown
    end

    for _, team in pairs(self.Teams) do
        for _, member in pairs(team.Members) do
            if not member.SpectateOnly and (not member.Character or member.Character.IsDead) then
                if self.Respawns[member] == nil then
                    self.Respawns[member] = team.RespawnTime
                else
                    self.Respawns[member] = self.Respawns[member] - 1/60
                end

                if self.Respawns[member] <= 0 then
                    self.Respawns[member] = nil
                    SpawnCharacter(member, team)
                end
            end
        end

        if team.CheckWinCondition() then
            self.Ending = true
            for _, client in pairs(Client.ClientList) do
                Traitormod.SendMessage(client, team.Name .. " won the game!", "InfoFrameTabButton.Mission")
            end

            for _, member in pairs(team.Members) do
                local points = Traitormod.AwardPoints(member, self.WinningPoints)
                Traitormod.SendMessage(member, string.format(Traitormod.Language.ReceivedPoints, points), "InfoFrameTabButton.Mission")    
            end
            Timer.Wait(function ()
                Game.EndGame()
            end, 5000)
        end
    end
end


return gm
