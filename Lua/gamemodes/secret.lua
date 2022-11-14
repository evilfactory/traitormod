local weightedRandom = dofile(Traitormod.Path .. "/Lua/weightedrandom.lua")
local gm = Traitormod.Gamemodes.Gamemode:new()

gm.Name = "Secret"

function gm:Start()
    gm:SelectTraitors()
end

function gm:End()
    local success = false

    local sb = Traitormod.StringBuilder:new()

    local traitors = {}
    for character, role in pairs(Traitormod.RoleManager.RoundRoles) do
        if role.Name == "Traitor" then
            table.insert(traitors, character)

            sb(character.Name)
            sb("\n")

            local assassinateObjectives = 0
            local otherObjectives = 0
            local pointsGained = 0

            for key, value in pairs(role.Objectives) do
                if value:IsCompleted() then
                    if value.Name == "Assassinate" then
                        assassinateObjectives = assassinateObjectives + 1
                    else
                        otherObjectives = otherObjectives + 1
                    end
                    pointsGained = pointsGained + value.AmountPoints
                end
            end

            sb("Assassinations: %s\n", assassinateObjectives)
            sb("Other objectives: %s\n", otherObjectives)
            sb("Points Gained: %s\n", pointsGained)
        end
    end

    -- first arg = mission id, second = message, third = completed, forth = list of characters
    return {TraitorMissionResult(Traitormod.MissionIdentifier, sb:concat(), success, traitors)}
end

function gm:SelectTraitors()
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
                if this.TraitorFilter(value) and Traitormod.GetData(value, "NonTraitor") ~= true then
                    -- players are alive or if respawning is on and config allows dead traitors (not supported yet)
                    if not value.Character.IsDead then
                        clientWeight[value] = Traitormod.GetData(value, "Weight") or 0
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
                this:SelectTraitors()
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

        local traitors = {}
        local roles = {}

        for i = 1, amountTraitors, 1 do
            local index = weightedRandom.Choose(clientWeight)

            if index ~= nil then
                Traitormod.Log("Chose " ..
                    index.Character.Name .. " as traitor. Weight: " .. math.floor(clientWeight[index] * 100) / 100)

                table.insert(traitors, index.Character)
                table.insert(roles, Traitormod.RoleManager.Roles.Traitor:new())

                clientWeight[index] = nil

                Traitormod.SetData(index, "Weight", 0)
            end
        end

        Traitormod.RoleManager.AssignRoles(traitors, roles)

    end, delay * 1000)
end

function gm:Think()
    local ended = true

    for key, value in pairs(Character.CharacterList) do
        local role = Traitormod.RoleManager.GetRoleByCharacter(value)
        if role == nil or not role.Antagonist then
            ended = false
        end
    end

    if self.EndOnComplete and ended then
        local delay = self.EndGameDelaySeconds or 0

        Traitormod.SendMessageEveryone(Traitormod.Language.TraitorsWin)
        Traitormod.Log("Secret gamemode complete. Ending round in " .. delay)

        Timer.Wait(function ()
            Game.EndGame()
        end, delay * 1000)
    end
end

return gm
