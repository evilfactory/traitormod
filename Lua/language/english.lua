local language = {}
language.Name = "English"

language.TipText = "Pro Tip: "
language.Tips = {
    "You can use !shop to spawn as creatures when you are dead.",
    "Traitors have access to a special traitor shop. Use !shop to open it.",
    "You can use !traitor to get information about your traitor status.",
    "You can use !help to get a list of all available commands.",
    "You can use !write to write text to a logbook that spawns when you die.",
    "The warden and head guard can never be traitors.",
    "Ghost roles might become available when you are dead, you can use !ghostrole to claim them.",
    "Typing !kill in chat as a ghost role simply returns it to the list of available ghost roles, rather than killing it.",
    "Fabricating, fixing hulls, healing and killing monsters grant you points.",
    "Doctors and normal guards can be traitors, but at a lower chance.",
    "If you have the Warden's ID, you can send a global announcement via !announce. Use this to communicate with the crew that do not have radios, or issue announcements for the prisoners and such. Make sure the ID doesn't get in the wrong hands though..",
    "Join our discord! discord.gg/SqeTDM9KSP"
}

language.Help = "\n!help - shows this help message\n!helptraitor - shows all traitor commands\n!helpadmin - lists all admin commands\n!traitor - show traitor information\n!pointshop - opens the point shop\n!points - show your points and lives\n!alive - list alive players (only while dead)\n!locatesub - shows you the distance and direction of the submarine, only for monsters\n!suicide - kills your character\n!version - shows running version of the traitormod\n!write - writes to your death logbook\n!announce [msg] - if you have the warden's ID, sends an announcement"
language.HelpTraitor = "\n!toggletraitor - toggles if the player can be selected as traitor\n!tc [msg] - sends a message to all traitors\n!tdm [Name] [msg] - sends a anonymous msg to given player"
language.HelpAdmin = "\n!traitoralive - check if all traitors died\n!roundinfo - show round information (spoiler!)\n!allpoints - shows point amounts of all connected clients\n!addpoint [Client] [+/-Amount] - add points to a client\n!addlife [Client] [+/-Amount] - add life(s) to a client\n!revive [Client] - revives a given client character\n!void [Character Name] - sends a character to the void\n!unvoid [Character Name] - brings a character back from the void\n!vote [text] [option1] [option2] [...] - starts a vote on the server\n!intercom [msg] - sends a global announcement as 'intercom'"

language.NoTraitor = "You aren't a traitor."
language.TraitorOn = "You can be selected as traitor."
language.TraitorOff = "You can not be chosen traitor.\n\nUse !toggletraitor to change that."
language.RoundNotStarted = "Round not started."

language.AllTraitorsDead = "All traitors dead!"
language.TraitorsAlive = "There's still traitors alive."

language.Alive = "Alive"
language.Dead = "Dead"

language.KilledByTraitor = "Your death may be caused by a traitor on a secret mission."

language.TraitorWelcome = "You are a traitor!"
language.TraitorDeath = "You have failed in your mission. As a result, the mission has been canceled and you will come back as part of the crew.\n\nYou are no longer a traitor, so play nice!"
language.TraitorDirectMessage = "You received a secret message from a traitor:\n"
language.TraitorBroadcast = "[Traitor %s]: %s"

language.AgentNoticeCodewords = "There are other agents on this submarine. You dont know their names, but you do have a method of communication. Use the code words to greet the agent and code response to respond. Disguise such words in a normal-looking phrase so the crew doesn't suspect anything."

language.AgentNoticeNoCodewords = "There are other agents on this submarine. You know their names, cooperate with them so you have a higher chance of success."

language.AgentNoticeOnlyTraitor = "You are the only traitor on this ship, proceed with caution."

language.RoundSummary = "| Round Summary |"
language.Gamemode = "Gamemode: %s"
language.RandomEvents = "Random Events: %s"
language.ObjectiveCompleted = "Objective completed: %s"
language.ObjectiveFailed = "Objective failed: %s"

language.CrewWins = "The crew successfully completed their mission!"
language.TraitorHandcuffed = "The crew handcuffed the traitor %s."
language.TraitorsWin = "The traitors succeeded in completing their objectives!"

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

language.ObjectiveSurvive = "Complete at least one objective and survive the shift."
language.ObjectiveStealCaptainID = "Steal the warden's ID."
language.ObjectiveKidnap = "Handcuff %s for %s seconds."
language.ObjectivePoisonCaptain = "Poison %s with %s."
language.SavePrisoner = "Free %s from this filthy prison."
language.ObjectiveWreckGift = "Grab the gift"

language.ObjectiveText = "Assassinate the crew in order to complete your mission."

language.AssassinationNextTarget = "Stay low until further instructions."
language.AssassinationNewObjective = "Your next assassination target is %s."
language.HuskNewObjective = "Your next husk target is %s."
language.AssassinationEveryoneDead = "Good job agent, you did it!"

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

return language
