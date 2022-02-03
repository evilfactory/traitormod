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

-- 400 points = 200 experience
config.AmountExperienceWithPoints = function (x)
    return x * 0.5
end

-- Give weight based on the logarithm of experience
-- 100 experience = 4 chance
-- 1000 experience = 6 chance
config.AmountWeightWithPoints = function (x)
    return math.log(x + 1) -- add 1 because log of 0 is -infinity
end

config.ObjectiveConfig = {
    Assassinate = {
        Enabled = true,
        AmountPoints = 500,
    },

    Survive = {
        Enabled = true,
        AmountPoints = 250,
    },

    StealCaptainID = {
        Enabled = true,
        AmountPoints = 300,
    },
}

config.GamemodeConfig = {
    Assassination = {
        Enabled = true,
        WeightChance = 50,

        SelectionDelay = 1,

        NextTargetDelay = 30,
        SelectBotsAsTargets = false,

        -- Codewords, Names, None
        TraitorMethodCommunication = "Codewords",

        MinSubObjectives = 1,
        MaxSubObjectives = 2,
        SubObjectives = {"StealCaptainID", "Survive"},

        AmountTraitors = function (amountPlayers)
            if amountPlayers > 12 then return 3 end
            if amountPlayers > 8 then return 2 end
            return 1
        end,

        TraitorFilter = function (client)
            if client.character.HasJob("captain") then return false end

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

        BallastFloraInitialDelay = 20,
        BallastFloraDelay = 20,
    },
}

return config