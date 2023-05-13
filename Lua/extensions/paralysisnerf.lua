local extension = {}

extension.CureTime = 60 * 60 * 7 -- 7 minutes

extension.Init = function ()
    local timer = {}

    Hook.Add("think", "ParalysisNerf", function (...)
        for _, client in pairs(Client.ClientList) do
            local character = client.Character
            if character then
                if character.CharacterHealth.GetAfflictionStrength("paralysis") > 0 then
                    if not timer[character] then
                        timer[character] = 0
                    end

                    timer[character] = timer[character] + 1

                    if timer[character] > extension.CureTime then -- 7 minutes
                        character.CharacterHealth.ApplyAffliction(character.AnimController.MainLimb, AfflictionPrefab.Prefabs["paralysis"].Instantiate(-1))
                    end
                elseif timer[character] then
                    timer[character] = 0
                end

                local affResistance = character.CharacterHealth.GetAffliction("paralysisresistance")
                if affResistance and affResistance.Strength > 0 then
                    local affliction = character.CharacterHealth.GetAffliction("paralysis", true)
                    if affliction then
                        affliction._strength = affliction._strength - 0.05
                    end
                end
            end
        end
    end)

    Hook.Add("roundEnd", "ParalysisNerf.RoundEnd", function (...)
        timer = {}
    end)
end

return extension