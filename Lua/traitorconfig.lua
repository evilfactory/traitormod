local config = {}

local codewords = {
	"hull", "tabacco", "nonsense", "fish", "clown", "quartermaster", "fast", "possibility",
	"thalamus", "hungry", "water", "looks", "renegade", "angry", "green", "sink", "rubber",
	"mask", "sweet", "ice", "charybdis", "cult", "secret", "frequency",
	"husk", "rust", "ruins", "red", "boat", "cats", "rats", "blast",
	"tire", "trunk", "weapons", "threshers", "cargo", "method", "monkey"
}


config.codewords = codewords
config.amountCodewords = 2
config.traitorSpawnDelay = 60
config.nextMissionDelay = 60
config.chooseBotsAsTraitorTargets = true

config.endRoundWhenAllTraitorsDie = false
config.endRoundDelayInSeconds = 60

config.overrideDefaultTraitors = true -- never set this to false

config.assassinationEnabled = true

config.infiltrationEnabled = true -- set this to false for the respawn shuttles to work
config.infiltrationChance = 20
config.infiltrationShipGodModeDistance = 40000

config.pincerEnabled = true
config.pincerChance = 20 -- infiltration chance has priority

config.thethingEnabled = false
config.thethingChance = 50

config.enableCommunicationsOffline = false
config.communicationsOfflineChance = 15

-- Gameplay Options
config.enableSabotage = true -- allow everyone to sabotage
config.enableWifiChat = true -- fixes wifi chat
config.disableCrewMenu = true -- disables the crew menu by changing everyone's team to friendly npc

-- Traitor Selection Options
config.roundEndPercentageIncrease = 10
config.firstJoinPercentage = 10
config.traitorPercentageSet = 5
config.traitorPenalty = 5

-- >=12 players = 3 traitors, >=8 players = 2 traitors, default = 1 traitor
config.getAmountTraitors = function (amountClients)
	if amountClients >= 12 then return 3 end -- if theres 12 or more players, 3 traitors will be selected

    if amountClients >= 8 then return 2 end -- if theres 8 or more players, 2 traitors will be selected

    return 1 -- if theres less than 8 players, there will only one traitor
end

-- infiltration traitors, the things and assassination traitors will be selected equally
config.getAmountInfiltrationTraitors = config.getAmountTraitors
config.getAmountPincerOperatives = config.getAmountTraitors
config.getAmountTheThings = config.getAmountTraitors


return config;