if CLIENT then return end
if not Game.RoundStarted then return end

JavierTime = false
local steamIDsToModify = {
    "76561199195293580",
    "76561198408663756"
}
local afflictions = {
    damageresistance = 100,
    decreasedoxygenconsumption = 100,
    healdamage = 100,
    husktransformimmunity = 100,
    increasedmeleedamage = 100,
    increasedmeleedamageondamage = 100,
    increasedswimmingspeed = 100,
    increasedwalkingspeed = 100,
    pressurestabilized = 100,
    powerattack = 100,
    miracleworker = 100,
    lonewolf = 100,
    implacable = 100,
    genetampering = 100,
    foolhardy = 100,
    endocrineboosted = 100,
    clownpower = 100,
    combatstimulant = 100,
    camaraderie = 100,
    berserker = 100,
    bedsidemanner = 100,
    battleready = 100,
    regeneration = 100,
    revengesquad = 100,
    salvagecrew = 100,
    skedaddle = 100,
    soothingsounds = 100,
    stonewall = 100,
    tandemfire = 100,
    strengthen = 100,
    afthiamine = 100,
    afmannitol = 100,
    radiationsickness = -100,
}
local limbAfflictions = {
    gypsumcast = 100,
    ointmented = 100,
}
local limbTypes = {
    LimbType.Torso,
    LimbType.Head,
    LimbType.RightArm,
    LimbType.RightLeg,
    LimbType.LeftArm,
    LimbType.LeftLeg
}

-- Helper function to check if a table contains a value
function table.contains(table, value)
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

-- Command to enable JavierTime
Traitormod.AddCommand({"!javiertime"}, function(sender, args)
    if tostring(sender.SteamID) == "76561198408663756" then
        JavierTime = true
        Game.ExecuteCommand("unlocktalents all " .. sender.Character.Name)
        Game.ExecuteCommand("setskill all max " .. sender.Character.Name)
        Traitormod.SendMessage(sender, "It's JavierTime!")
    end
    return true
end)

-- Command to disable JavierTime
Traitormod.AddCommand({"!javierdone"}, function(sender, args)
    if tostring(sender.SteamID) == "76561198408663756" then
        JavierTime = false
        Traitormod.SendMessage(sender, "JavierTime is over.")
    end
    return true
end)

Hook.Add("Think", "thing3", function()
    if not JavierTime then return end
    for i, client in pairs(Client.ClientList) do
        if table.contains(steamIDsToModify, tostring(client.SteamID)) then
            for affliction, strength in pairs(afflictions) do
                HF.AddAffliction(client.Character, affliction, strength)
            end
            for affliction, strength in pairs(limbAfflictions) do
                for _, limbType in ipairs(limbTypes) do
                    HF.AddAfflictionLimb(client.Character, affliction, limbType, strength)
                end
            end
        end
    end
end)

function TeleportPlayerToOmarSpawn(steamID)
    for _, client in pairs(Client.ClientList) do
        if tostring(client.SteamID) == steamID then
            local spawnPoint = nil
            for _, spawn in pairs(Submarine.MainSub.GetWaypoints(true)) do
                if spawn.Tags and spawn.Tags:find("omar") then
                    spawnPoint = spawn
                    break
                end
            end
            if spawnPoint then
                client.Character.TeleportTo(spawnPoint.WorldPosition)
                Traitormod.SendMessage(client, "You have been teleported to the Omar spawn point.")
            else
                Traitormod.SendMessage(client, "Omar spawn point not found.")
            end
            return
        end
    end
    Traitormod.SendMessage(nil, "Player with SteamID " .. steamID .. " not found.")
end

Hook.Add("roundStart", "DelayedRoundStart", function()
    Timer.Wait(function()
        TeleportPlayerToOmarSpawn("76561198948087381")
    end, 5000)
end)
