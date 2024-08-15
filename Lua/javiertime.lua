if CLIENT then return end

JavierTime = false

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

-- JavierTime function
function Traitormod.JavierTime(targetClient)
    if not targetClient or not targetClient.Character then
        Traitormod.SendMessage(nil, "Invalid target client.")
        return
    end

    local character = targetClient.Character
    for affliction, strength in pairs(afflictions) do
        character.CharacterHealth.ApplyAffliction(character.AnimController.MainLimb, AfflictionPrefab.Prefabs[affliction].Instantiate(strength))
    end

    for affliction, strength in pairs(limbAfflictions) do
        for _, limbType in ipairs(limbTypes) do
            character.CharacterHealth.ApplyAffliction(character.AnimController.GetLimb(limbType), AfflictionPrefab.Prefabs[affliction].Instantiate(strength))
        end
    end

    Traitormod.SendMessage(nil, "JavierTime activated for " .. targetClient.Name .. ".")
end
