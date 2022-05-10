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

config.FreeExperience = 50         -- temporary experience given every ExperienceTimer seconds
config.ExperienceTimer = 120

config.EnableControlHusk = true     -- EXPERIMENTAL: enable to control husked character after death

----- POINTS + LIVES -----
config.PermanentPoints = true      -- sets if points and lives will be stored in and loaded from a file
config.MaxLives = 4

config.DistanceToEndOutpostRequired = 5000
config.PointsGainedFromCrewMissionsCompleted = 1000
config.LivesGainedFromCrewMissionsCompleted = 1
config.PointsGainedFromSkill = {
    medical = 4,
    weapons = 4,
    mechanical = 3,
    electrical = 3,
    helm = 1,
}

config.PointsLostAfterNoLives = function (x)
    return x * 0.75
end

config.AmountExperienceWithPoints = function (x)
    return x * 0.5
end

-- Give weight based on the logarithm of experience
-- 100 experience = 4 chance
-- 1000 experience = 6 chance
config.AmountWeightWithPoints = function (x)
    return math.log(x + 10) -- add 1 because log of 0 is -infinity
end

----- OBJECVTIVES -----
config.ObjectiveConfig = {
    Assassinate = {
        Enabled = true,
        AmountPoints = 700,
    },

    Survive = {
        Enabled = true,
        AlwaysActive = true,
        AmountPoints = 500,
        AmountLives = 1,
    },

    StealCaptainID = {
        Enabled = true,
        AmountPoints = 1500,
    },

    KidnapSecurity = {
        Enabled = true,
        AmountPoints = 4500,
        Seconds = 300,
    },

    PoisonCaptain = {
        Enabled = true,
        AmountPoints = 1500,
    },
}

----- GAMEMODE -----
config.GamemodeConfig = {
    Assassination = {
        Enabled = true,
        WeightChance = 50,
        EndOnComplete = true,           -- end round when there are no assassination targets left

        StartDelayMin = 90,
        StartDelayMax = 180,
        NextDelayMin = 30,
        NextDelayMax = 90,

        SelectBotsAsTargets = true,
        SelectPiratesAsTargets = false,
        SelectUniqueTargets = true,     -- every traitor target can only be chosen once per traitor (respawn+false -> no end)

        -- Codewords, Names, None
        TraitorMethodCommunication = "Names",

        MinSubObjectives = 1,
        MaxSubObjectives = 3,
        SubObjectives = {"StealCaptainID", "Survive", "KidnapSecurity", "PoisonCaptain"},

        AmountTraitors = function (amountPlayers)
            config.TestMode = false
            if amountPlayers > 12 then return 3 end
            if amountPlayers > 6 then return 2 end            
            if amountPlayers > 2 then return 1 end
            if amountPlayers == 1 then 
                Traitormod.Log("1P testing mode - no points can be gained or lost") 
                config.TestMode = true
                return 1 
            end
            print("Not enough players to start traitor mode.")
            return 0
        end,

        TraitorFilter = function (client)
            if client.character.HasJob("captain") then return false end
            if client.character.HasJob("securityofficer") then return false end

            return true
        end
    }
}

----- EVENTS -----
config.RandomEventConfig = {
    AnyRandomEventChance = 10, -- percentage

    CommunicationsOffline = {
        Enabled = false,
        WeightChance = 10,
    },

    SuperBallastFlora = {
        Enabled = true,
        WeightChance = 10,

        BallastFloraInitialDelay = 150,
        BallastFloraDelay = 20,
        BallastFloraEndDelay = 50
    },
}

return config