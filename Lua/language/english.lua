local language = {}
language.Name = "English"

language.TipText = "Pro Tip: "
language.Tips = {
    "You can use !shop to spawn as creatures when you are dead.",
    "Traitors have access to a special traitor shop. Use !shop to open it.",
    "You can use !traitor to get information about your traitor status.",
    "You can use !help to get a list of all available commands.",
    "You can use !write to write text to a logbook that spawns when you die.",
    "The warden, guards, and head guard can never be traitors.",
    "Ghost roles might become available when you are dead, you can use !ghostrole to claim them.",
    "Typing !kill in chat as a ghost role simply returns it to the list of available ghost roles, rather than killing it.",
    "Fabricating, fixing hulls, healing and killing monsters grant you points.",
    "Doctors can be traitors, but at a lower chance.",
    "If you have the Warden's ID, you can send a global announcement via !announce. Use this to communicate with the crew that do not have radios, or issue announcements for the prisoners and such. Make sure the ID doesn't get in the wrong hands though..",
    "Join our discord! discord.gg/SqeTDM9KSP",
    "Got RDMed? You can send a message to all available admins with the '.ahelp' command.",
    "Type !role to see information about your role.",
    "Dying in the first 15 seconds as a creature refunds the price of it fully."
}

language.Help = "\n!role - see info about your current role\n!help - shows this help message\n!helptraitor - shows all traitor commands\n!helpadmin - lists all admin commands\n!traitor - show traitor information\n!pointshop - opens the point shop\n!points - show your points and lives\n!locatesub - shows you the distance and direction of the submarine, only for monsters\n!suicide - kills your character\n!version - shows running version of the traitormod\n!write - writes to your death logbook\n!announce [msg] - if you have the warden's ID, sends an announcement\n!alive - if you're dead; see all players, their jobs and if they're dead or alive"
language.HelpTraitor = "\n!toggletraitor - toggles if the player can be selected as traitor\n!tc [msg] - sends a message to all traitors\n!tdm [Name] [msg] - sends a anonymous msg to given player"
language.HelpAdmin = "\n!traitoralive - check if all traitors died\n!roundinfo - show round information (spoiler!)\n!allpoints - shows point amounts of all connected clients\n!addpoint [Client] [+/-Amount] - add points to a client\n!addlife [Client] [+/-Amount] - add life(s) to a client\n!revive [Client] - revives a given client character\n!void [Character Name] - sends a character to the void\n!unvoid [Character Name] - brings a character back from the void\n!vote [text] [option1] [option2] [...] - starts a vote on the server\n!intercom [msg] - sends a global announcement as 'intercom'"

language.NoTraitor = "You aren't a traitor."
language.TraitorOn = "You can be selected as traitor."
language.TraitorOff = "You can not be chosen traitor.\n\nUse !toggletraitor to change that."
language.RoundNotStarted = "Round not started."

language.ReceivedPoints = "You have received %s points."

language.AllTraitorsDead = "All traitors dead!"
language.TraitorsAlive = "There's still traitors alive."

language.Alive = "Alive"
language.Dead = "Dead"

language.KilledByTraitor = "Your death may be caused by a traitor on a secret mission."

language.TraitorWelcome = "You are a traitor!"
language.TraitorDeath = "You have failed in your mission. As a result, the mission has been canceled and you will come back as part of the crew.\n\nYou are no longer a traitor, so play nice!"
language.TraitorDirectMessage = "You received a secret message from a traitor:\n"
language.TraitorBroadcast = "[Traitor %s]: %s"
language.ClownBroadcast = "[Clown %s]: %s"
language.CultistBroadcast = "[Cultist %s]: %s"
language.PirateBroadcast = "[Pirate %s]: %s"
language.HuskBroadcast = "[Husk Servant %s]: %s"

language.NoObjectivesYet = " > No objectives yet... Stay futile."

language.MainObjectivesYou = "Your main objectives are:"
language.SecondaryObjectivesYou = "Your secondary objectives are:"
language.MainObjectivesOther = "Their main objectives were:"
language.SecondaryObjectivesOther = "Their secondary objectives were:"

language.CrewMember = "You are crew member of the station.\n\nYou have been assigned the following bonus objectives.\n\n"
language.PrisonerMessage = "You are a convict of the station.\n\nYou have been assigned the following bonus objectives.\n\n"

language.SoloAntagonist = "You are the only antagonist."
language.Partners = "Partners: %s"
language.TcTip = "Use !tc to communicate with your partners."

language.TraitorYou = "You are a traitor!"
language.TraitorOther = "Traitor %s."
language.HonkMotherYou = "You are a Honkmother Clown!"
language.HonkMotherOther = "Honkmother Clown %s."
language.CultistYou = "You are a Husk Cultist!\nHumans that you manage to turn into a husk will be in your side and may help you."
language.CultistOther = "Cultist %s."
language.HuskServantYou = "You are now a Husk Servant!\nYou directly follow orders made by the Husk Cultists."
language.HuskServantOther = "Husk Servant %s."
language.HuskCultists = "Husk Cultists: %s\n"
language.HuskServantTcTip = "You cannot speak, but you can use !tc to communicate with the Husk Cultists."

language.AgentNoticeCodewords = "There are other agents on this submarine. You dont know their names, but you do have a method of communication. Use the code words to greet the agent and code response to respond. Disguise such words in a normal-looking phrase so the crew doesn't suspect anything."

language.AgentNoticeNoCodewords = "There are other agents on this submarine. You know their names, cooperate with them so you have a higher chance of success."

language.AgentNoticeOnlyTraitor = "You are the only traitor on this ship, proceed with caution."

language.GhostRoleAvailable = "[Ghost Role] New ghost role available: %s (type in chat ‖color:gui.orange‖!ghostrole %s‖color:end‖ to accept)"
language.GhostRolesDisabled = "Ghost roles are disabled."
language.GhostRolesSpectator = "Only spectators can use ghost roles."
language.GhostRolesInGame = "You must be in game to use ghost roles."
language.GhostRolesDead = "(Dead)"
language.GhostRolesTaken = "(Already Taken)"
language.GhostRolesNotFound = "Ghost role not found, did you type the name correctly? Available roles: \n\n"
language.GhostRolesTook = "Someone already took this ghost role."
language.GhostRolesAlreadyDead = "Seems this ghost role is already dead, too bad!"
language.GhostRolesReminder = "Ghost roles available: %s\n\nUse !ghostrole name to pick a role."

language.MidRoundSpawnWelcome = ">> MidRoundSpawn active! <<\nThe round has already started, but you can spawn instantly!"
language.MidRoundSpawn = "Do you want to spawn instantly or wait for the next respawn?\n"
language.MidRoundSpawnMission = "> Spawn"
language.MidRoundSpawnCoalition = "> Spawn Coalition"
language.MidRoundSpawnSeparatists = "> Spawn Separatists"
language.MidRoundSpawnWait = "> Wait"

language.RoundSummary = "| Round Summary |"
language.Gamemode = "Gamemode: %s"
language.RandomEvents = "Random Events: %s"
language.ObjectiveCompleted = "Objective completed: %s"
language.ObjectiveFailed = "Objective failed: %s"

language.CrewWins = "The crew successfully completed their mission!"
language.TraitorHandcuffed = "The crew handcuffed the traitor %s."
language.TraitorsWin = "The traitors succeeded in completing their objectives!"

language.CMDPlaytime = "Your playtime is %s."

language.TraitorsRound = "Traitors of the round:"
language.NoTraitors = "No traitors."
language.TraitorAlive = "You survived as a traitor."

language.PointsInfo = "You have %s points and %s/%s lives."
language.TraitorInfo = "Your traitor chance is %s%%, compared to the rest of the crew."

language.Points = " (%s Points)"
language.Experience = " (%s XP)"

language.SkillsIncreased = "Good job on improving your skills."
language.PointsAwarded = "You have been awarded %s points."
language.PointsAwardedRound = "This round you gained:\n%s points"
language.ExperienceAwarded = "You gained %s XP."

language.LivesGained = "You gained %s. You now have %s/%s Lives."
language.ALife = "one life"
language.Lives = " lives"
language.Death = "You lost a life. You have %s left before you lose points."
language.NoLives = "You lost all your lives. As a result you lose some points."
language.MaxLives = "You have the maximum amount of lives."

language.Codewords = "Code Words: %s"
language.CodeResponses = "Code Responses: %s"

language.OtherTraitors = "All Traitors: %s"

language.CommandTip = "(Type !traitor in chat to show this message again.)"
language.CommandNotActive = "This command is deactivated."

language.Completed = " (Completed)"

language.Objective = "Main Objectives:"
language.SubObjective = "Sub Objectives (optional):"

language.NoObjectives = "No objectives."
language.NoObjectivesYet = "No targets yet..."

language.ObjectiveAssassinate = "Assassinate %s."
language.ObjectiveAssassinateDrunk = "Assassinate %s while drunk"
language.ObjectiveAssassinatePressure = "Crush %s with high pressure"
language.ObjectiveBananaSlip = "Slip %s on bananas (%s/%s) times."
language.ObjectiveStealID = "Steal the %s's ID for %s seconds."
language.ObjectiveConvert = "Put a clown mask on %s, then eliminate him."
language.ObjectiveDestroyCaly = "Deconstruct %s Calyxanide(s)."
language.ObjectiveDrunkSailor = "Give %s more than 80% drunkness."
language.ObjectiveGrowMudraptors = "Grow (%s/%s) mudraptors."
language.ObjectiveHusk = "Turn %s into a full husk."
language.ObjectiveTurnHusk = "Turn yourself into a husk."
language.ObjectiveSurvive = "Complete at least one objective and survive the shift."
language.ObjectiveStealCaptainID = "Steal the warden's ID."
language.ObjectiveKidnap = "Handcuff %s for %s seconds."
language.ObjectivePoisonCaptain = "Poison %s with %s."
language.ObjectiveWreckGift = "Grab the gift"

language.ObjectiveFinishAllObjectives = "Finish all objectives and gain 1 live."
language.ObjectiveFinishRoundFast = "Finish the round in less than 20 minutes."
language.ObjectiveHealCharacters = "Do (%s/%s) points of healing."
language.ObjectiveKillMonsters = "Kill (%s/%s) %s."
language.ObjectiveRepair = "Repair (%s/%s) %s"
language.ObjectiveRepairHull = "Repair (%s/%s) damage from the hull."
language.ObjectiveSecurityTeamSurvival = "Make sure at least one member of the security team survives."
language.ObjectiveCleanBody = "Dump %s's body out the airlock once they have expired."
language.ObjectiveCrewSurvival = "Ensure atleast 3 members of the crew survive."
language.ObjectivePrisoner = "Ensure atleast %s convicts are in their cells at the end of the round."

language.ObjectiveText = "Assassinate the crew in order to complete your mission."

language.AssassinationNextTarget = "Stay low until further instructions."
language.AssassinationNewObjective = "Your next assassination target is %s."
language.CultistNextTarget = "The church of husk values your efforts, a new target shall be assigned soon."
language.HuskNewObjective = "Your next husk target is %s."
language.AssassinationEveryoneDead = "Good job agent, you did it!"
language.HonkmotherNextTarget = "Honkmother is pleased with your work, but there is still more to do, wait for further instructions."
language.HonkmotherNewObjective = "Your next target is %s."

language.AbyssHelpPart1 = "Incoming Distress Call... H---! -e-----uck i- --e abys-- W- n--d -e-- A l--her dr---e- us d--- her-. ---se -e a-e of--ring ----thing w- -ave, inclu--- our ---0 -o------"
language.AbyssHelpPart2 = "The transmission cuts out right after."
language.AbyssHelpPart3 = "I can't believe we made it out alive, thank you so much! Here are the points I promised, take this cargo scooter and the LogBook inside. The LogBook should contain the points I promised."
language.AbyssHelpPart4 = "Holy shit! Someone came! Thank you so much! Please find a way to get us out here, I'll give you %s of my points if you can get me out alive."
language.AbyssHelpPart5 = "You could try to get a new battery for this submarine and fix it up."
language.AbyssHelpDead = "I guess that's how it ends...."

language.AmmoDelivery = "A delivery of explosive coilgun ammo and railgun shells has been made to the armoury area of the submarine."
language.BeaconPirate = "There have been reports about a notorious pirate with a PUCS suit terrorizing these waters, the pirate was detected recently inside a beacon station - eliminate the pirate to claim a reward of %s points for the entire crew."
language.WreckPirate = "There have been reports about a notorious pirate with a PUCS suit terrorizing these waters, the pirate was detected recently inside a wrecked submarine - eliminate the pirate to claim a reward of %s points for the entire crew."
language.PirateInside = "Attention! A dangerous PUCS pirate has been detected inside the main submarine!"
language.PirateKilled = "The PUCS pirate has been killed, the crew has received a reward of %s points."

language.ClownMagic = "You feel a strange sensation, and suddenly you're somewhere else."
language.CommunicationsOffline = "Something is interfering with all our communications systems. It's been estimated that communications will be offline for atleast %s minutes."
language.CommunicationsBack = "Communications are back online."
language.EmergencyTeam = "A group of engineers and mechanics have entered the submarine to assist with repairs."
language.LightsOff = "All lights suddenly turn off, but power is still on? What's going on?"
language.MaintenanceToolsDelivery = "A delivery of maintenance tools has been made into the cargo area of the ship. The supplies are inside a yellow crate."
language.MedicalDelivery = "A medical delivery has been made into the medical area of the ship. The medical supplies are inside a red medical crate."
language.PrisonerAboard = "A prisoner is aboard the submarine, keep the prisoner alive and handcuffed until the submarine arrives at it's destination for the crew to receive %s Points."
language.PrisonerYou = "You are a prisoner! If you manage to get 500 meters away from the submarine, you will be rewarded with %s points."
language.PrisonerSuccess = "The prisoner has been successfully transported, the crew has received a reward of %s points."
language.PrisonerFail = "The prisoner has escaped and the transportation reward has been cancelled."
language.OxygenSafe = "The oxygen from the oxygen generator is now safe to breathe again."
language.OxygenHusk = "The oxygen generator has been sabotaged and is now giving husk to whoever breathes it's air, you have about 15 seconds to get a diving mask or a diving suit before you receive a high enough dose!"
language.OxygenPoison = "The oxygen generator has been sabotaged and is now giving sufforin to whoever breathes it's air, you have about 15 seconds to get a diving mask or a diving suit before you receive a high enough dose!"
language.PirateCrew = "Attention! A pirate ship has been spotted in these waters! Destroy the pirate's reactor or kill all pirates to claim a reward of %s points for the entire crew"
language.PirateCrewYou = "You are part of this submarine's pirate crew! Defend the submarine from any filthy coalitions trying to get what is yours!"
language.PirateCrewSuccess = "The pirates have succumbed, the crew has received a reward of %s points."

language.ShadyMissionPart1 = "You pickup a weird radio transmission, it sounds like they are looking for someone to do a job for them."
language.ShadyMissionPart2 = "\"Oh hello there! We are looking for someone to do a simple task for us. We are willing to pay up to 3000 points for it. Interested?\""
language.ShadyMissionPart2Answer = "Sure! What's it?"
language.ShadyMissionPart3 = "\"In this area where your submarine is heading through, there's an old wrecked submarine where we need to place some supplies. Because we don't have the supplies available right now, you are going to need to get the supplies yourself. We are going to need at least 8 of any medical item, 4 oxygen tanks, 2 loaded firearms of any type and a special sonar beacon. We will be paying 1500 points for these supplies, if you add any other supplies, we will give you up to 1500 additional points.\""
language.ShadyMissionPart3Answer = "This sounds fishy, why would you want to put these supplies in a wrecked submarine?!"
language.ShadyMissionPart4 = "\"Now this is none of your business, will you do it or not?\""
language.ShadyMissionPart4AnswerAccept = "Accept the offer"
language.ShadyMissionPart4AnswerDeny = "Deny the offer"
language.ShadyMissionPart5 = "\"Great! Just put all the supplies and the special sonar beacon in a metal crate and leave it in the wreck.\""
language.ShadyMissionPart5Answer = "I'll do my best"
language.ShadyMissionBeacon = "‖color:gui.red‖It looks like this sonar beacon was modified.\nBehind it there's a note saying: \"8 medical items, 4 oxygen tanks and 2 loaded firearms.\"‖color:end‖"

language.SuperBallastFlora = "High concentration of ballast flora spores has been detected in this area, it's advised to search pumps for ballast flora!"

language.Answer = "Answer"
language.Ignore = "Ignore"

language.SecretSummary = "Objectives Completed: %s - Points Gained: %s\n"
language.SecretTraitorAssigned = "You have been assigned to be a traitor, vote which type you want to be."

language.ItemsBought = "Items bought from point shop"
language.CrewBoughtItem = "Players bought items from point shop"
language.PointsGained = "Total points gained"
language.PointsLost = "Total points lost"
language.Spawns = "Spawned human characters"
language.Traitor = "Chosen as traitor"
language.TraitorDeaths = "Died as traitor"
language.TraitorMainObjectives ="Main Objectives successful"
language.TraitorSubObjectives = "Sub Objectives successful"
language.CrewDeaths = "Deaths"
language.Rounds = "General Round stats"

language.Yes = "Yes"
language.No = "No"

language.PointshopInGame = "You must be in game to use the Pointshop."
language.PointshopCannotBeUsed = "This product cannot be used at the moment."
language.PointshopWait = "You have to wait %s seconds before you can use this product."
language.PointshopNoPoints = "You do not have enough points to buy this product."
language.PointshopNoStock = "This product is out of stock."
language.PointshopPurchased = "Purchased \"%s\" for %s points\n\nNew point balance is: %s points."
language.PointshopGoBack = ">> Go back <<"
language.PointshopCancel = ">> Cancel <<"
language.PointshopWishBuy = "Your current balance: %s points\nWhat do you wish to buy?"
language.PointshopInstallation = "The product that you are about to buy will spawn an installation in your exact location, you won't be able to move it else where, do you wish to continue?\n"
language.PointshopNotAvailable = "Point Shop not available."
language.PointshopWishCategory = "Your current balance: %s points\nChoose a category."
language.PointshopRefunded = "You have been refunded %s points for your %s purchase"


language.Pointshop = {
    revivalfluid = "Revival Fluid",
    revivalfluid_desc = "‖color:gui.yellow‖Revives a dead corpse as a husk‖color:end‖",
    fakehandcuffs = "Fake Cuffs",
    choke = "Chocker",
    randomcoma = "Put random person into coma (Dangerous)",
    hammerbuff = "Toy Hammer (Buffed)",
    arthurmorgan = "Mycobacterium tuberculosis Sample",
    ClownEnsemble = "Clown Ensemble",
    HonkmotherClothes = "Mother's Ensemble (Armor Plated)",
    separatistgear = "Separatist Gear",
    choke_desc = "‖color:gui.red‖Silences the target‖color:end‖",
    jailgrenade = "DarkRP Jail Grenade",
    jailgrenade_desc = "‖color:gui.red‖A special grenade with an interesting surprise...‖color:end‖",
    clowngearcrate = "Clown Gear Crate",
    clowngear = "Clown Gear",
    clowntalenttree = "Clown Talent Tree",
    enrollclown = "Enroll into Clown College",
    PsychoClown = "Psycho Clown",
    invisibilitygear = "Invisibility Gear",
    clownmagic = "Clown Magic (Randomly swaps places of people)",
    randomizelights = "Randomize Lights",
    fuelrodlowquality = "Low Quality Fuel Rod",
    gardeningkit = "Gardening Kit",
    randomitem = "Random Item",
    clownsuit = "Clown Suit",
    randomegg = "Random Egg",
    assistantbot = "Assistant Bot",
    firemanscarrytalent = "Firemans Carry Talent",
    stungunammo = "Stun Gun Ammo (x4)",
    revolverammo = "Revolver Ammo (x6)",
    smgammo = "SMG Magazine (x2)",
    shotgunammo = "Shotgun Shells (x8)",
    streamchalk = "Stream Chalk",
    barsuktwo = "Prisoner Transport Barsuk",
    rescueshuttle = "Coalition Rescue Shuttle",
    uri = "Uri - Alien Ship",
    seashark = "Sea shark Mark II",
    barsuk = "Barsuk",
    huskattractorbeacon = "Husk Attractor Beacon",
    huskautoinjector = "Husk Auto-Injector",
    huskedbloodpack = "Husked Blood Pack",
    spawnhusk = "Spawn Husk",
    huskoxygensupply = "Husk Oxygen Supply",
    explosiveautoinjector = "Explosive Auto-Injector",
    teleporterrevolver = "Teleporter Revolver",
    poisonoxygensupply = "Poison Oxygen Supply",
    turnofflights = "Turn Off Lights For 3 Minutes",
    insaneclown = "Summon Insane Clown",
    autoclown = "Clown Auto-Injector",
    turnoffcommunications = "Turn Off Communications For 2 Minutes",
    spawnascrawler = "Spawn as Crawler",
    spawnascrawlerhusk = "Spawn as Crawler Husk",
    spawnaslegacycrawler = "Spawn as Legacy Crawler",
    spawnaslegacyhusk = "Spawn as Legacy Husk (horrible)",
    spawnascrawlerbaby = "Spawn as Crawler Baby",
    spawnasmudraptorbaby = "Spawn as Mudraptor Baby",
    spawnasthresherbaby = "Spawn as Thresher Baby",
    spawnasspineling = "Spawn as Spineling",
    spawnasmudraptor = "Spawn as Mudraptor",
    spawnasmantis = "Spawn as Mantis",
    spawnashusk = "Spawn as Husk",
    spawnashuskedhuman = "Spawn as Husked Human",
    spawnasbonethresher = "Spawn as Bone Thresher",
    spawnastigerthresher = "Spawn as Tiger Thresher",
    spawnaslegacymoloch = "Spawn as Legacy Moloch",
    spawnaslegacycarrier = "Spawn as Legacy Carrier",
    spawnashammerhead = "Spawn as Hammerhead",
    spawnasfractalguardian = "Spawn as Fractal Guardian",
    spawnasfractalguardian2 = "Spawn as Fractal Guardian 2",
    spawnasfractalguardian3 = "Spawn as Fractal Guardian 3",
    spawnasgiantspineling = "Spawn as Giant Spineling",
    spawnasveteranmudraptor = "Spawn as Veteran Mudraptor",
    spawnaslatcher = "Spawn as Latcher",
    spawnascharybdis = "Spawn as Charybdis",
    spawnasendworm = "Spawn as Endworm",
    spawnaspeanut = "Spawn as Peanut",
    spawnasorangeboy = "Spawn as Orange Boy",
    spawnascthulhu = "Spawn as Cthulu",
    spawnascyborgworm = "Spawn as Cyborg worm",
    spawnashammerheadmar = "Spawn as Hammerhead Matriarch",
    spawnaspsilotoad = "Spawn as Psilotoad",
    unknownsignal = "Mysterious Signal",
    separatist = "Separatist Fighter",
    Dropship = "Coalition Dropship",
    unknownwreck = "Unknown",
    clown = "Clown",
    cultist = "Cultist",
    traitor = "Traitor",
    deathspawn = "Death Spawn",
    wiring = "Wiring",
    ores = "Ores",
    security = "Security",
    ships = "Ships",
    materials = "Materials",
    medical = "Medical",
    maintenance = "Maintenance",
    other = "Other",
    traitormedic = "Traitor Doctor",
    eventmanager = "Event Manager Spawn",
    prisoner = "Convict Uplink",
    chef = "Cooking",
    janitor = "Janitorial",
    eventships = "Event Manager Ships",
    idcardlocator = "Id Card Locator",
    idcardlocator_desc = "‖color:gui.red‖Id Card Locator‖color:end‖",
    idcardlocator_result = "%s - %s - %s meters away",
}

language.FakeHandcuffsUsage = "You can free yourself from these handcuffs using !fhc"

language.ShipTooCloseToWall = "Cannot spawn ship, position is too close to a level wall."
language.ShipTooCloseToShip = "Cannot spawn ship, position is too close to another submarine."

language.Pets = "Pets"
language.SmallCreatures = "Small Creatures"
language.LargeCreatures = "Large Creatures"
language.AbyssCreature = "Abyss Creature"
language.ElectricalDevices = "Electrical Devices"
language.MechanicalDevices = "Mechanical Devices"

language.MaleNames = {"Liam","Noah","James","Oliver","Benjamin","Elijah","Lucas","Mason","Logan","Alexander","Ethan","Jacob","Michael","Daniel",
"Henry","Jackson","Sebastian","Aiden","Matthew","Samuel","David","Joseph","Carter","Owen","Wyatt","John","Jack","Luke","Jayden","Dylan",
"Grayson","Levi","Isaac","Gabriel","Julian","Mateo","Anthony","Jaxon","Lincoln","Joshua","Christopher","Andrew","Theodore","Caleb","Ryan",
"Asher","Nathan","Thomas","Leo","Isaiah","Charles","Josiah","Hudson","Christian","Hunter","Connor","Eli","Ezra","Aaron","Landon","Adrian",
"Jonathan","Nolan","Jeremiah","Easton","Elias","Colton","Cameron","Carson","Robert","Angel","Maverick","Nicholas","Dominic","Jaxson",
"Greyson","Adam","Ian","Austin","Santiago","Jordan","Cooper","Brayden","Roman","Evan","Ezekiel","Xavier","Jose","Jace","Jameson","Leonardo",
"Bryson","Axel","Everett","Parker","Kayden","Miles","Sawyer","Jason","Gordon","Timothy","Justin","Brett","Marco","Joe","Jones","Richard",
"Darwin","Jay","Stephen","Jeremy","Fritz","Kevin","Stuart","William","Preston","Dallas","Tobias","Hugo","Yousef","Jeff","Alan",
"Peter","Patrick","Bruce","Tyler","Muhhamed","Abe","Adan","Ahmed","Aldo","Allan","Alonso","Alton","Alvaro","Alvin",
"Andres","Anton","Antony","Arkadi","Arron","Arthur","Arturo","Avery","Barney","Barry","Barton","Ben","Bennie","Bertram","Bill",
"Bo","Boyce","Boyd","Brady","Brian","Britt","Bruno","Bryce","Burl","Burt","Carlos","Carlton","Carmen","Chance","Christoper",
"Chuck","Claude","Dan","Darius","Darrin","Delbert","Dewey","Devin","Dewitt","Dimitry","Dominick","Donn","Dorsey",
"Edgar","Edison","Eldridge","Elmer","Erich","Erik","Ernie","Esteban","Everette","Ezequiel","Filiberto","Frances","Franklin", "Garrett",
"Gerard","Glenn","Gregor","Hal","Harlan","Harrison","Harry","Hector","Herman","Hobert","Igor","Irwin","Ivan","Jackie","Jaime","Jamey","Jan","Jared",
"Jarrod","Jarvis","Jc","Jean","Jerald","Jerrell","Jerrod","Jess","Joel","Johny","Jorge","Josef",
"Jude","Julius","Keith","Kendall","Keneth","Kenton","Kerry","Keven","Kim","Kip","Lamont","Lane","Lanny","Lee","Len","Lenny","Lionel","Lynn",
"Lynwood","Malcom","Manuel","Marc","Marcel","Marcelino","Marcellus","Mathew","Matt","Maurice","Mauricio","Mckinley","Mechislav","Merrill","Messiah",
"Micheal","Milton","Minh","Mitchel","Mitrofan","Mohammad","Monte","Morton","Mose","Murray","Neal","Neil","Nick","Norman","Omari","Orval",
"Oscar","Pedro","Pete","Quincy","Ramon","Randall","Raphael","Raymon","Reed","Reggie","Reginald","Renato","Rene","Rob",
"Roderick","Roland","Romeo","Ronnie","Rosendo","Roy","Rupert","Sammie","Saul","Sergei","Seth","Shelby","Sidney","Simon","Son",
"Sonny","Steve","Stevie","Sylvester","Terrance","Terrell","Timur","Tod","Todd","Tommie","Tory","Travis","Tyson","Ulof","Waldo",
"Warner","Vasili","Wilford","Will","Willie","Willy","Winston","Virgil","Virgilio","Zachary","Clark","Johnathan","Sans","Kieran","Javier","Leviticus",
"Angelo","Colm","Rains","Flaco","Jean-Luc","Zubin","Dutch","Hercule","Gaylord","Banana","Xalamus","Foob","Dillinger","Carl","Freddie","Micah","Uncle","Mr.","Artie"}

language.FemaleNames = {"Emma","Olivia","Ava","Isabella","Sophia","Charlotte","Mia","Amelia","Harper","Evelyn","Abigail","Emily","Penelope",
"Elizabeth","Mila","Ella","Avery","Ashlynn","Camila","Aria","Scarlett","Victoria","Madison","Luna","Grace","Chloe","Layla","Riley",
"Zoey","Nora","Lily","Eleanor","Hannah","Lillian","Addison","Aubrey","Ellie","Stella","Natalie","Zoe","Leah","Hazel","Violet","Aurora",
"Savannah","Audrey","Brooklyn","Bella","Claire","Skylar","Lucy","Sarah","Paisley","Everly","Anna","Caroline","Nova","Genesis","Emilia",
"Kennedy","Samantha","Maya","Willow","Kinsley","Naomi","Aaliyah","Elena","Ariana","Allison","Gabriella","Alice","Madelyn","Cora","Ruby","Eva",
"Serenity","Autumn","Adeline","Hailey","Gianna","Valentina","Isla","Eliana","Quinn","Nevaeh","Ivy","Sadie","Piper","Lydia","Alexa","Josephine",
"Emery","Julia","Delilah","Arianna","Vivian","Kaylee","Sophie","Brielle","Madeline","Alyx","Jaida","Veronica","Jade","Lisa","Jessica","Rebecca",
"Guenevere","Sandra","Monika","Melissa","Fiona","Bailey","Carmen","Megan","Bethany","Hollie","Isabelle","Carly","Katie","Anika","Scarlet", 
"Ayala","Jenny","Amy","Karen","Albertine","Alexia","Alfredia","Alice","Alita","Alla","Alta","Althea","Alyce","Amee","Amira","Annette","Ara",
"Arcelia","Arie","Armanda","Aryanna","Ashley","Ashly","Astrid","Avril","Azul","Barbra","Beaulah","Bell","Bertha","Bettyann","Beverley","Bridgett",
"Candace","Cara","Carie","Carla","Cathleen","Cathy","Cecille","Christiana","Christine","Cinda","Cleopatra","Codi","Corinne",
"Creola","Criselda","Dahlia","Danielle","Dannette","Darleen","Deborah","Denise","Denisha","Dona","Doria","Dorthy","Elinor","Eliza",
"Elliana","Emerald","Emilee","Erica","Erline","Ethel","Eugenia","Fanny","Fernanda","Glenda","Gloria","Hortensia","Ilene","Ina","Inga",
"Iris","Jacquline","Janee","Janessa","Janie","Jeanene","Jenine","Jina","Jodee","Joy","Joyce","Juana","Julianne","Jutta","Karyn","Katerina",
"Katherina","Kathy","Katrina","Kellie","Kenna","Keri","Kizzie","Kristeen","Kristie","Larissa","Larita","Lauren","Laurie","Laurinda","Lavinia",
"Leanne","Leila","Lelah","Lena","Leola","Lindy","Liza","Lola","Lora","Lorriane","Lorrie","Macey","Mafalda","Maira","Majorie","Marcy",
"Margaret","Margeret","Mariela","Marin","Marissa","Marla","Maryann","Marylee","Masako","Maudie","Maybell","Mechelle","Melany","Melba",
"Michele","Mikaela","Miranda","Muoi","Natalia","Natashia","Nicole","Nola","Noriko","Page","Pamela","Paula","Peggie","Phoenix","Priscilla",
"Randi","Reatha","Renata","Rhonda","Roberta","Roselle","Rosina","Roslyn","Rowena","Ruthie","Sabrina","Sage","Sanda","Sara","Serena","Sharie","Shayla",
"Shelly","Sherise","Sherita","Sherry","Shin","Shirlee","Siena","Socorro","Stefany","Stephane","Summer","Susy","Synthia","Tania",
"Tanika","Tanya","Tawanda","Tera","Tessie","Thea","Tisha","Tracy","Trista","Trudie","Trudy","Valerie","Vanessa","Velma","Yahaira","Zandra","Kieran","Ms.","Mrs.","Miss","Aunt","Artie"}

language.LastNames = {"Smith","Hall","Stewart","Price","Johnson","Allen","Sanchez","Bennett","Jones","Williams","Young","Morris","Wood",
"Hernandez","Rogers","Barnes","Brown","King","Reed","Ross","Davis","Wright","Cook","Henderson","Miller","Lopez","Morgan","Coleman","Wilson",
"Hill","Bell","Jenkins","Moore","Scott","Murphy","Perry","Taylor","Green","Bailey","Powell","Anderson","Adams","Rivera","Long","Thomas",
"Baker","Cooper","Patterson","Jackson","Gonzalez","Richardson","Hughes","White","Nelson","Cox","Flores","Harris","Carter","Howard",
"Washington","Martin","Mitchell","Ward","Butler","Thompson","Perez","Torres","Simmons","Garcia","Roberts","Peterson","Foster","Martinez",
"Turner","Gray","Gonzales","Robinson","Phillips","Ramirez","Bryant","Clark","Campbell","James","Alexander","Rodriguez","Parker","Watson",
"Russell","Lewis","Evans","Brooks","Griffin","Lee","Edwards","Kelly","Diaz","Walker","Collins","Sanders","Hayes","Freeman","Coomer","Judson",
"Boris","Golden","Gatz","Afton","Donaldson","Wolfe","Boseman","Winston","Saulisbury","Clement","Bannon","Breen","Wayne","Truman","Humphrey",
"Nuttingham","Bateman","Dimitrev","Marx","Aguilar","Aker","Angles","Ashley","Atterbury","Avery","Banks","Bartolomeo","Basnett",
"Baumgardner","Beltran","Bergman","Berlin","Berner","Blackwell","Blakley","Boman","Bonham","Books","Box","Bradley","Brady","Breeki",
"Buckley","Burke","Bushman","Callahan","Carey","Carroll","Case","Castillo","Castro","Chandler","Chaney","Chapman",
"Chiu","Clements","Clothier","Cluck","Cobble","Colpitts","Combs","Connors","Cork","Cortese","Craig","Cuevas","Danko","Day",
"Delange","Deloney","Deras","Dews","Dimauro","Dollinger","Donovan","Dorado","Dudley","Duplantier","Dyer","Eastman","Elliott","Ellison","Escobar",
"Feinberg","Feinman","Fesler","Fleig","Flowers","Fonte","Frye","Gadberry","Gallagher","Gallardo","Gears","Geist","Gomez",
"Goodin","Gordon","Gould","Graves","Gregory","Gumbs","Hajek","Hallett","Hampton","Hardy","Harp","Hebert","Hedrick",
"Hefner","Heuer","Higgins","Hillard","Hines","Hinton","Hocker","Hoffman","Holter","House","Huber","Hurley","Hutchinson",
"Huynh","Jack","Keller","Kidd","Kinney","Klein","Knowles","Krall","Kramer","Lane","Larsen","Lavey","Lawrence","Lawson",
"Leonard","Lester","Linares","Little","Lowe","Lozano","Lucas","Lyons","Malone","Mansfield","Marchi","Marquez","Mason","Maxwell","Maynard",
"Maynes","Mcclure","Mcdowell","McLeroy","McNeal","Mcneil","Mead","Meals","Meisner","Mell","Mendel","Mendez","Meza","Molina","Monroe","Mooney",
"Moran","Moses","Mosley","Mulford","Mungo","Navarro","Newton","Nicolosi","Nunez","Ordway","Ouellette","Palmieri","Parchman",
"Parks","Patel","Pearson","Petersen","Phoenix","Pickett","Planck","Pollard","Pool","Poole","Preston","Proctor","Quinn",
"Radebaugh","Radice","Ram","Ramos","Rangel","Reeves","Reynolds","Rhymer","Riddle","Riles","Rios","Robertson","Rolfe","Roman",
"Rosewood","Rowe","Sacks","Santillan","Santistevan","Saunders","Sawyer","Schmitt","Serrano","Severance","Sexton","Shah","Simpson",
"Southworth","Sparks","Stalvey","Stanley","Stein","Stogner","Suarez","Summers","Summitt","Sunderland","Swanger","Swanson","Sykes","Tamashiro",
"Tate","Terry","Thompkins","Tootle","Tseng","Tyson","Ulrich","Walls","Vaughn","Vazquez","Veach","Weaver","Velazquez","Welden","Wheeling",
"Whitely","Wiley","Williams","Zhang","Barotrauma","van der Linde","Matthews","Pinhead","Marston","Escuella","MacGuire","Trelawny","Duffy","Cornwall",
"O'Driscoll","Bronte","Falls","Hernández","Granger","Adler","Picard","Hawley","Federman","Horowitz","Cantor","Compson","Dickens","Fussar","Valdespino",
"Boolean","Man","Harnley","Guitar","Fentanyl","Bones","Dingle","Delcan","Truther","Leana","Dolittle","Gaylord",""}

return language
