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

Hook.Add("chatMessage", "thing", function(message, sender)
    local normalizedMessage = message:lower():gsub("^%s*(.-)%s*$", "%1")
    if tostring(sender.SteamID) == "76561198408663756" and normalizedMessage == "javiertime" then
        JavierTime = true
        Game.ExecuteCommand("unlocktalents all " .. sender.Character.Name)
        Game.ExecuteCommand("setskill all max " .. sender.Character.Name)
        print("Its javiertime")
    end
end)

Hook.Add("chatMessage", "thing2", function(message, sender)
    local normalizedMessage = message:lower():gsub("^%s*(.-)%s*$", "%1")
    if tostring(sender.SteamID) == "76561198408663756" and normalizedMessage == "javierdone" then
        JavierTime = false
    end
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

-- Helper function to check if a table contains a value
function table.contains(table, value)
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

Hook.Add("roundEnd","thing4",function()
    JavierTime = false
end)