local config = {}

config.Language = "English"

config.Codewords = {
    "hull", "tabacco", "nonsense", "fish", "clown", "quartermaster", "fast", "possibility",
	"thalamus", "hungry", "water", "looks", "renegade", "angry", "green", "sink", "rubber",
	"mask", "sweet", "ice", "charybdis", "cult", "secret", "frequency",
	"husk", "rust", "ruins", "red", "boat", "cats", "rats", "blast",
	"tire", "trunk", "weapons", "threshers", "cargo", "method", "monkey"
}

config.AmountCodeWords = 2

config.PermanentPoints = true

config.MaxLives = 4
config.DistanceToEndOutpostRequired = 5000

-- looses half points
config.PointsLostAfterNoLives = function (x)
    return x * 0.75
end

-- 400 points = 200 experience
config.AmountExperienceWithPoints = function (x)
    return x * 0.5
end

-- Give weight based on the logarithm of experience
-- 100 experience = 4 chance
-- 1000 experience = 6 chance
config.AmountWeightWithPoints = function (x)
    return math.log(x + 10) -- add 1 because log of 0 is -infinity
end

config.ObjectiveConfig = {
    Assassinate = {
        Enabled = true,
        AmountPoints = 700,
    },

    Survive = {
        Enabled = true,
        AmountPoints = 2500,
    },

    StealCaptainID = {
        Enabled = true,
        AmountPoints = 1500,
    },

    KidnapSecurity = {
        Enabled = true,
        AmountPoints = 4500,
        Seconds = 500,
    },
}

config.GamemodeConfig = {
    Assassination = {
        Enabled = true,
        WeightChance = 50,

        SelectionDelay = 60,

        NextTargetDelay = 60,
        SelectBotsAsTargets = true,

        -- Codewords, Names, None
        TraitorMethodCommunication = "Names",

        MinSubObjectives = 1,
        MaxSubObjectives = 2,
        SubObjectives = {"StealCaptainID", "Survive", "KidnapSecurity"},

        AmountTraitors = function (amountPlayers)
            if amountPlayers > 12 then return 3 end
            if amountPlayers > 5 then return 2 end
            return 1
        end,

        TraitorFilter = function (client)
            if client.character.HasJob("captain") then return false end
            if client.character.HasJob("securityofficer") then return false end

            return true
        end
    }
}

config.RandomEventConfig = {
    AnyRandomEventChance = 10, -- percentage

    CommunicationsOffline = {
        Enabled = true,
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