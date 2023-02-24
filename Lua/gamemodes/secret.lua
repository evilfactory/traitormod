local weightedRandom = dofile(Traitormod.Path .. "/Lua/weightedrandom.lua")
local gm = Traitormod.Gamemodes.Gamemode:new()

gm.Name = "Secret"

function gm:CharacterDeath(character)
    local client = Traitormod.FindClientCharacter(character)

    -- if character is valid player
    if client == nil or
        character == nil or
        character.IsHuman == false or
        character.ClientDisconnected == true or
        character.TeamID == 0 then
        return
    end

    if Traitormod.RoundTime < Traitormod.Config.MinRoundTimeToLooseLives then
        return
    end

    if Traitormod.LostLivesThisRound[client.SteamID] == nil then
        Traitormod.LostLivesThisRound[client.SteamID] = true
    else
        return
    end

    local liveMsg, liveIcon = Traitormod.AdjustLives(client, -1)

    Traitormod.SendMessage(client, liveMsg, liveIcon)
end

function gm:Start()
    local this = self

    if self.EnableRandomEvents then
        Traitormod.RoundEvents.Initialize()
    end

    Hook.Add("characterDeath", "Traitormod.Secret.CharacterDeath", function(character, affliction)
        this:CharacterDeath(character)
    end)

    self.TraitorType = Traitormod.RoleManager.Roles[weightedRandom.Choose(self.TraitorTypeChance)]

    if self.TraitorType.Name == "Cultist" then
        self.RoundEndIcon = "oneofus"
        Game.EnableControlHusk(true)
    else
        Game.EnableControlHusk(false)
    end

    self:SelectAntagonists(self.TraitorType)
end

function gm:AwardCrew()
    local missionType = {}

    for key, value in pairs(MissionType) do
        missionType[value] = key
    end

    local missionReward = 0
    for _, mission in pairs(Traitormod.RoundMissions) do
        if mission.Completed then
            local type = missionType[mission.Prefab.Type]
            local missionValue = self.MissionPoints.Default

            for key, value in pairs(self.MissionPoints) do
                if key == type then
                    missionValue = value
                end
            end

            missionReward = missionReward + missionValue
        end
    end

    for key, value in pairs(Client.ClientList) do
        if value.Character ~= nil
            and value.Character.IsHuman
            and not value.SpectateOnly
            and not value.Character.IsDead
        then
            local role = Traitormod.RoleManager.GetRole(value.Character)

            local wasAntagonist = false
            if role ~= nil then
                wasAntagonist = role.IsAntagonist
            end

            -- if client was no traitor, and in reach of end position, gain a live
            if not wasAntagonist and Traitormod.EndReached(value.Character, self.DistanceToEndOutpostRequired) then
                local msg = ""

                -- award points for mission completion
                if missionReward > 0 then
                    local points = Traitormod.AwardPoints(value, missionReward
                        , true)
                    msg = msg ..
                        Traitormod.Language.CrewWins ..
                        " " .. string.format(Traitormod.Language.PointsAwarded, points) .. "\n\n"
                end

                local lifeMsg, icon = Traitormod.AdjustLives(value,
                    (self.LivesGainedFromCrewMissionsCompleted or 1))
                if lifeMsg then
                    msg = msg .. lifeMsg .. "\n\n"
                end

                if msg ~= "" then
                    Traitormod.SendMessage(value, msg, icon)
                end
            end
        end
    end
end

function gm:CheckHandcuffedTraitors(character)
    if character.IsDead then return end
    
    local item = character.Inventory.GetItemInLimbSlot(InvSlotType.RightHand)
    if item ~= nil and item.Prefab.Identifier == "handcuffs" then
        for key, value in pairs(Client.ClientList) do
            local role = Traitormod.RoleManager.GetRole(value.Character)
            if (role == nil or not role.IsAntagonist) and value.Character and not value.Character.IsDead then
                local points = Traitormod.AwardPoints(value, self.PointsGainedFromHandcuffedTraitors)
                local text = string.format(Traitormod.Language.TraitorHandcuffed, character.Name)
                text = text .. "\n\n" .. string.format(Traitormod.Language.PointsAwarded, points)
                Traitormod.SendMessage(value, text, "InfoFrameTabButton.Mission")
            end
        end
    end
end

function gm:TraitorResults()
    local success = false

    local sb = Traitormod.StringBuilder:new()

    local antagonists = {}
    for character, role in pairs(Traitormod.RoleManager.RoundRoles) do
        if role.IsAntagonist then
            table.insert(antagonists, character)
        end

        if role.IsAntagonist then
            sb("%s %s", role.Name, character.Name)
            sb("\n")

            local objectives = 0
            local pointsGained = 0

            for key, value in pairs(role.Objectives) do
                if value:IsCompleted() then
                    objectives = objectives + 1
                    pointsGained = pointsGained + value.AmountPoints
                end
            end

            if objectives > 0 then
                success = true
            end

            sb("Objectives Completed: %s - Points Gained: %s\n", objectives, pointsGained)
        end
    end

    if success then
        Traitormod.Stats.AddStat("Rounds", "Traitor rounds won", 1)
    else
        Traitormod.Stats.AddStat("Rounds", "Crew rounds won", 1)
    end

    -- first arg = mission id, second = message, third = completed, forth = list of characters
    return {TraitorMissionResult(self.RoundEndIcon or Traitormod.MissionIdentifier, sb:concat(), success, antagonists)}
end

function gm:End()
    for key, character in pairs(Traitormod.RoleManager.FindAntagonists()) do
        self:CheckHandcuffedTraitors(character)
    end

    gm:AwardCrew()

    Hook.Remove("characterDeath", "Traitormod.Secret.CharacterDeath");
end

function gm:SelectAntagonists(role)
    local this = self
    local thisRoundNumber = Traitormod.RoundNumber

    local delay = math.random(self.TraitorSelectDelayMin, self.TraitorSelectDelayMax)

    Timer.Wait(function()
        if thisRoundNumber ~= Traitormod.RoundNumber or not Game.RoundStarted then return end

        local clientWeight = {}
        local traitorChoices = 0
        local playerInGame = 0
        for key, value in pairs(Client.ClientList) do
            -- valid traitor choices must be ingame, player was spawned before (has a character), is no spectator
            if value.InGame and value.Character and not value.SpectateOnly then
                -- filter by config
                if this.TraitorFilter(value) > 0 and Traitormod.GetData(value, "NonTraitor") ~= true then
                    -- players are alive or if respawning is on and config allows dead traitors (not supported yet)
                    if not value.Character.IsDead then
                        clientWeight[value] = (Traitormod.GetData(value, "Weight") or 0) * this.TraitorFilter(value)
                        traitorChoices = traitorChoices + 1
                    end
                end
                playerInGame = playerInGame + 1
            end
        end

        if traitorChoices == 0 then
            if Game.ServerSettings.AllowRespawn or MidRoundSpawn then
                -- if more players to come, retry
                Traitormod.Debug("Currently no valid player characters to assign traitors. Retrying...")
                this:SelectAntagonists(role)
            else
                -- else this will never change, abort
                Traitormod.Log("No players to assign traitors")
            end

            return
        end

        local amountTraitors = this.AmountTraitors(playerInGame)
        if amountTraitors > traitorChoices then
            amountTraitors = traitorChoices
            Traitormod.Log("Not enough valid players to assign all traitors... New amount: " .. tostring(amountTraitors))
        end

        local antagonists = {}
        local roles = {}

        for i = 1, amountTraitors, 1 do
            local index = weightedRandom.Choose(clientWeight)

            if index ~= nil then
                Traitormod.Log("Chose " ..
                    index.Character.Name .. " as traitor. Weight: " .. math.floor(clientWeight[index] * 100) / 100)

                table.insert(antagonists, index.Character)
                table.insert(roles, role:new())

                clientWeight[index] = nil

                Traitormod.SetData(index, "Weight", 0)
            end
        end

        Traitormod.RoleManager.AssignRoles(antagonists, roles)

    end, delay * 1000)
end

function gm:Think()
    local ended = true
    local anyTraitorMission = false

    for key, value in pairs(Character.CharacterList) do
        if not value.IsDead and value.IsHuman and value.TeamID == CharacterTeamType.Team1 then
            local role = Traitormod.RoleManager.GetRole(value)
            if role == nil or not role.IsAntagonist then
                ended = false
            else
                if role.Objectives then
                    for key, objective in pairs(role.Objectives) do
                        if objective.Name == "Assassinate" or objective.Name == "Husk" then
                            anyTraitorMission = true
                        end
                    end
                end
            end
        end
    end

    if not anyTraitorMission then
        ended = false
    end

    if not self.Ending and Game.RoundStarted and self.EndOnComplete and ended then
        local delay = self.EndGameDelaySeconds or 0

        Traitormod.SendMessageEveryone(Traitormod.Language.TraitorsWin)
        Traitormod.Log("Secret gamemode complete. Ending round in " .. delay)

        Timer.Wait(function ()
            Game.EndGame()
        end, delay * 1000)

        self.Ending = true
    end
end

return gm
