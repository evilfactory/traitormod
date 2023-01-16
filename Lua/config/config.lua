local config = {}
config.DebugLogs = true

----- USER FEEDBACK -----
config.Language = "English"
config.SendWelcomeMessage = true
config.ChatMessageType = ChatMessageType.Private    -- Error = red | Private = green | Dead = blue | Radio = yellow

----- GAMEPLAY -----
config.Codewords = {
    "hull", "tabacco", "nonsense", "fish", "clown", "quartermaster", "fast", "possibility",
	"thalamus", "hungry", "water", "looks", "renegade", "angry", "green", "sink", "rubber",
	"mask", "sweet", "ice", "charybdis", "cult", "secret", "frequency",
	"husk", "rust", "ruins", "red", "boat", "cats", "rats", "blast",
	"tire", "trunk", "weapons", "threshers", "cargo", "method", "monkey"
}

config.AmountCodeWords = 2

config.OptionalTraitors = true        -- players can use !toggletraitor
config.RagdollOnDisconnect = false
config.EnableControlHusk = false     -- EXPERIMENTAL: enable to control husked character after death

-- This overrides the game's respawn shuttle, and uses it as a submarine injector, to spawn submarines in game easily. Respawn should still work as expected, but the shuttle submarine file needs to be manually added here.
-- Note: If this is disabled, traitormod will disable all functions related to submarine spawning.
config.OverrideRespawnSubmarine = false
config.RespawnSubmarineFile = "Content/Submarines/Selkie.sub"
config.RespawnText = "Respawn in %s seconds."

----- POINTS + LIVES -----
config.PermanentPoints = true      -- sets if points and lives will be stored in and loaded from a file
config.RemotePoints = nil
config.RemoteServerAuth = {}
config.PermanentStatistics = true  -- sets if statistics be stored in and loaded from a file
config.MaxLives = 5
config.MinRoundTimeToLooseLives = 180
config.RespawnedPlayersDontLooseLives = true
config.MaxExperienceFromPoints = 100000     -- if not nil, this amount is the maximum experience players gain from stored points (30k = lvl 10 | 38400 = lvl 12)
config.RemoveSkillBooks = true

config.FreeExperience = 50         -- temporary experience given every ExperienceTimer seconds
config.ExperienceTimer = 120

config.PointsGainedFromSkill = {
    medical = 30,
    weapons = 20,
    mechanical = 19,
    electrical = 19,
    helm = 9,
}

config.PointsLostAfterNoLives = function (x)
    return x * 0.75
end

config.AmountExperienceWithPoints = function (x)
    return x
end

-- Give weight based on the logarithm of experience
-- 100 experience = 4 chance
-- 1000 experience = 6 chance
config.AmountWeightWithPoints = function (x)
    return math.log(x + 10) -- add 1 because log of 0 is -infinity
end

----- GAMEMODE -----
config.GamemodeConfig = {
    Secret = {
        EndOnComplete = true,           -- end round when there are no assassination targets left
        EnableRandomEvents = true,
        EndGameDelaySeconds = 15,

        TraitorSelectDelayMin = 120,
        TraitorSelectDelayMax = 150,

        PointsGainedFromHandcuffedTraitors = 1000,
        DistanceToEndOutpostRequired = 5000,
        PointsGainedFromCrewMissionsCompleted = 1000,
        LivesGainedFromCrewMissionsCompleted = 1,


        AmountTraitors = function (amountPlayers)
            config.TestMode = false
            if amountPlayers > 12 then return 3 end
            if amountPlayers > 7 then return 2 end            
            if amountPlayers > 3 then return 1 end
            if amountPlayers == 1 then 
                Traitormod.SendMessageEveryone("1P testing mode - no points can be gained or lost") 
                config.TestMode = true
                return 1
            end
            print("Not enough players to start traitor mode.")
            return 0
        end,

        TraitorFilter = function (client)
            if client.Character.TeamID ~= CharacterTeamType.Team1 then return false end
            if not client.Character.IsHuman then return false end
            if client.Character.HasJob("captain") then return false end
            if client.Character.HasJob("securityofficer") then return false end

            return true
        end
    },

    PvP = {
        EnableRandomEvents = false, -- most events are coded to only affect the main submarine
        WinningPoints = 2500,
        WinningDeadPoints = 300,
        ShowSonar = true,
    },
}

config.RoleConfig = {
    Cultist = {
        SubObjectives = {"Assassinate", "Kidnap", "TurnHusk", "DestroyCaly"},
        MinSubObjectives = 2,
        MaxSubObjectives = 3,

        NextObjectiveDelayMin = 30,
        NextObjectiveDelayMax = 60,

        TraitorBroadcast = true,           -- traitors can broadcast to other traitors using !tc
        TraitorBroadcastHearable = false,  -- if true, !tc will be hearable in the vicinity via local chat
        TraitorDm = true,                  -- traitors can send direct messages to other players using !tdm

        -- Names, None
        TraitorMethodCommunication = "Names",

        SelectBotsAsTargets = true,
        SelectPiratesAsTargets = false,
    },

    HuskServant = {
        TraitorBroadcast = true,
    },

    Traitor = {
        SubObjectives = {"StealCaptainID", "Survive", "Kidnap", "PoisonCaptain"},
        MinSubObjectives = 2,
        MaxSubObjectives = 3,

        NextObjectiveDelayMin = 30,
        NextObjectiveDelayMax = 60,

        TraitorBroadcast = true,           -- traitors can broadcast to other traitors using !tc
        TraitorBroadcastHearable = false,  -- if true, !tc will be hearable in the vicinity via local chat
        TraitorDm = true,                  -- traitors can send direct messages to other players using !tdm

        -- Names, None
        TraitorMethodCommunication = "Names",

        SelectBotsAsTargets = true,
        SelectPiratesAsTargets = false,
        SelectUniqueTargets = true,     -- every traitor target can only be chosen once per traitor (respawn+false -> no end)
        PointsPerAssassination = 100,
    },
}

config.ObjectiveConfig = {
    Assassinate = {
        AmountPoints = 600,
    },

    Survive = {
        AlwaysActive = true,
        AmountPoints = 500,
        AmountLives = 1,
    },

    StealCaptainID = {
        AmountPoints = 1300,
    },

    Kidnap = {
        AmountPoints = 2500,
        Seconds = 100,
    },

    PoisonCaptain = {
        AmountPoints = 1600,
    },

    Husk = {
        AmountPoints = 800,
    },

    TurnHusk = {
        AmountPoints = 500,
        AmountLives = 2,
    },

    DestroyCaly = {
        AmountPoints = 500,
    },
}

----- EVENTS -----
config.RandomEventConfig = {
    Events = {
        dofile(Traitormod.Path .. "/Lua/config/randomevents/communicationsoffline.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/superballastflora.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/maintenancetoolsdelivery.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/medicaldelivery.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/ammodelivery.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/hiddenpirate.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/electricalfixdischarge.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/wreckpirate.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/beaconpirate.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/abysshelp.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/lightsoff.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/emergencyteam.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/piratecrew.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/outpostpirateattack.lua"),
    }
}

config.PointShopConfig = {
    Enabled = true,
    DeathTimeoutTime = 120,
    ItemCategories = {
        dofile(Traitormod.Path .. "/Lua/config/pointshop/cultist.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/traitor.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/security.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/maintenance.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/materials.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/medical.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/ores.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/other.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/experimental.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/deathspawn.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/ships.lua"),
    }
}

config.GhostRoleConfig = {
    Enabled = true,
    MiscGhostRoles = {
        ["Watcher"] = true,
        ["Mudraptor_pet"] = true,
    }
}

return config