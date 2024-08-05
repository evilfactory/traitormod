Hook.Add("RoundStart","timer",function()
    RoundStartTime = os.time()
end)


Hook.Add("character.death","prisonerdeath",function(character)
    local roundTime = os.time() - RoundStartTime
    if roundtime >= 300 then return end
    if character.JobIdentifier == "convict" then
        print(character.Name)
        if character.LastAttacker.JobIdentifier == "convict" then
            Traitormod.RoundEvents.SendEventMessage(character.LastAttacker.Name.." is to be excecuted for killing fellow prisoner's, the warden shall be the excecutioner.", nil, Color.Red)
        end
    end
end)