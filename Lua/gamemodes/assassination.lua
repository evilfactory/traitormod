local gm = Traitormod.Gamemodes.Gamemode:new()
local weightedRandom = dofile(Traitormod.Path .. "/Lua/weightedrandom.lua")

gm.Name = "Assassination"

function gm:Start()
    print(gm.Config)
    gm:SelectTraitors()
end

function gm:SelectTraitors()
    local this = self
    local thisRoundNumber = Traitormod.RoundNumber

    local delay = 1

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

return gm
