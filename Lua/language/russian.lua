local language = {}
language.Name = "Russian"

language.TipText = "Совет: "
language.Tips = {
    "Вы можете использовать !pointshop чтобы стать сувществом, когда вы мертвы.",
    "У предателей есть доступ в свой особый магазин. Используйте !pointshop чтобы открыть его.",
    "Вы можете использовать !role чтобы получить информацию о статусе вашей конкретной роли.",
    "Вы можете использовать !help чтобы получить список всех доступных команд.",
    "Вы можете использоватьe !write чтобы написать сообщение, которое останется в кпк после вашей смерти.",
    "Капитан и Оффицеры Службы Безопасности не могут быть предателями.",
    "Роли станут доступны когда вы умрете, вы можете использовать !ghostrole чтобы использовать их.",
    "Использование команды !kill в чате просто переносит вас обратно в список наблюдателей, не убивая роль.",
    "Смерть в первые 15 секунд после перерождения за существо полностью возмещает его стоимость."
}

language.Help = "\n!help - показывает это сообщение помощи\n!helptraitor - показывает все команды предателя\n!helpadmin - показывает все команды администратора\n!traitor - показывает информацию о предателе\n!pointshop - открывает магазин очков\n!points - показывает ваши очки и жизни\n!alive - показывает список живых игроков (только во время смерти)\n! locatesub - показывает расстояние и направление подводной лодки, только для монстров\n!suicide - убивает вашего персонажа\n!version - показывает текущую версию трейтормода\n!write - записывает в ваш журнал смерти\n!roundtime - показывает текущее время раунда."
language.HelpTraitor = "\n!toggletraitor - переключает, может ли игрок быть выбран предателем\n!tc [msg] - отправляет сообщение всем предателям\n!tannounce [msg] - отправляет объявление для предателей\n!tdm [Имя] [msg] - отправляет анонимное сообщение данному игроку"
language.HelpAdmin = "\n!traitoralive - проверить, все ли предатели умерли\n!roundinfo - показать информацию о раунде (спойлер!)\n!allpoints - показывает количество очков у всех подключенных клиентов\n!addpoint [Client] [+/-Amount] - добавить очки клиенту\n!addlife [Client] [+/-Amount] - добавить жизнь(и) клиенту\n! оживить [клиент] - оживить персонажа данного клиента\n!void [имя персонажа] - отправить персонажа в пустоту\n!unvoid [имя персонажа] - вернуть персонажа из пустоты\n!vote [текст] [опция1] [опция2] [...] - начать голосование на сервере\n!giveghostrole [текст] [персонаж] - назначить персонажа с указанным именем на роль призрака."

language.TestingMode = "Режим тестирования 1P - нельзя набрать или потерять очки"

language.NoTraitor = "Вы не предатель"
language.TraitorOn = "Вы можете быть выбраны в качестве предателя"
language.TraitorOff = "Вы не можете быть выбраны в качестве предателя.\n\nИспользуйте !toggletraitor, чтобы изменить это."
language.RoundNotStarted = "Раунд не начался"

language.ReceivedPoints = "Вы получили %s очков"

language.AllTraitorsDead = "Все предатели мертвы!"
language.TraitorsAlive = "Есть живые предатели..."

language.Alive = "Жив"
language.Dead = "Мертв"

language.KilledByTraitor = "Ваша смерть может быть вызвана предателем, выполняющим секретное задание"

language.TraitorWelcome = "Вы - предатель!"
language.TraitorDeath = "Вы провалили задание. В результате миссия была отменена, и вы вернетесь в составе команды.\n\nВы больше не предатель, так что играйте хорошо!"
language.TraitorDirectMessage = "Вы получили секретное сообщение от предателя:\n"
language.TraitorBroadcast = "[Предатель %s]: %s"

language.NoObjectivesYet = " > Целей пока нет... Ждите дальнейших указаний."

language.MainObjectivesYou = "Ваши главные цели:"
language.SecondaryObjectivesYou = "Ваши второстепенные цели:"
language.MainObjectivesOther = "Их главными целями были:"
language.SecondaryObjectivesOther = "Их второстепенными целями были:"

language.CrewMember = "Вы член экипажа подводной лодки.\n\nВам были назначены следующие бонусные цели.\n\n"

language.SoloAntagonist = "Вы единственный антагонист."
language.Partners = "Напарники: %s"
language.TcTip = "Используйте !tc для общения с вашими напарниками"

language.TraitorYou = "Вы предатель!"
language.TraitorOther = "Предатель %s"
language.HonkMotherYou = "Вы дитя Красного Носа!"
language.HonkMotherOther = "Клоун %s"
language.CultistYou = "Вы культист хаска!\nЛюди, которых вам удалось превратить в хасков, будут на вашей стороне и смогут помочь вам."
language.CultistOther = "Культист %s"
language.HuskServantYou = "Теперь вы слуга церкви хаска!\nВы напрямую выполняете приказы культистов церкви хаска."
language.HuskServantOther = "Слуга Хаска %s."
language.HuskCultists = "Культисты Хаска: %s\n"
language.HuskServantTcTip = "Вы не можете говорить, но вы можете использовать !tc для общения с культистами хаска."

language.AgentNoticeCodewords = "На этой подводной лодке есть и другие агенты. Вы не знаете их имен, но у вас есть способ общения. Используйте кодовые слова для приветствия агента и кодовый ответ для ответа. Замаскируйте эти слова в обычную фразу, чтобы экипаж ничего не заподозрил"

language.AgentNoticeNoCodewords = "На этой подводной лодке есть и другие агенты. Вы знаете их имена, сотрудничайте с ними, так у вас будет больше шансов на успех."

language.AgentNoticeOnlyTraitor = "Вы единственный предатель на этом корабле, действуйте осторожно"

language.GhostRoleAvailable = "[Роли] Доступна новая роль: %s (введите в чате ‖color:gui.orange‖!ghostrole %s‖color:end‖, чтобы принять)"
language.GhostRolesDisabled = "Роли отключены"
language.GhostRolesSpectator = "Только наблюдатели могут использовать роли"
language.GhostRolesInGame = "Вы должны быть в игре, чтобы использовать роли призраков"
language.GhostRolesDead = "(Мертв)"
language.GhostRolesTaken = "(Уже взяты)"
language.GhostRolesNotFound = "Роль не найдена, вы правильно ввели имя? Доступные роли: \n\n"
language.GhostRolesTook = "Кто-то уже взял эту роль."
language.GhostRolesAlreadyDead = "Похоже, эта роль уже мертва, жаль!"
language.GhostRolesReminder = "Доступны роли: %s\n\nУкажите имя роли, чтобы выбрать роль."

language.MidRoundSpawnWelcome = ">> Возрождение посреди раунда активно! <<\n\nРаунд уже начался, но вы можете появиться мгновенно!"
language.MidRoundSpawn = "Вы хотите появиться мгновенно или дождаться следующего раунда?\n"
language.MidRoundSpawnMission = "> Возродиться"
language.MidRoundSpawnCoalition = "> Возродиться в Коалиции"
language.MidRoundSpawnSeparatists = "> Возродиться у сепаратистов"
language.MidRoundSpawnWait = "> Ждать"

language.RoundSummary = "| Краткое содержание раунда |"
language.Gamemode = "Режим игры: %s"
language.RandomEvents = "Случайные события: %s"
language.ObjectiveCompleted = "Задач выполнено: %s"
language.ObjectiveFailed = "Задач провалено: %s"

language.CrewWins = "Экипаж успешно выполнил задание!"
language.TraitorHandcuffed = "Экипаж заковал предателя в наручники %s"
language.TraitorsWin = "Предатели успешно выполнили свои задачи!"

language.TraitorsRound = "Предатели раунда:"
language.NoTraitors = "Предателей нет"
language.TraitorAlive = "Вы выжили будучи предателем"

language.PointsInfo = "У вас %s очков и %s/%s жизней"
language.TraitorInfo = "Ваш шанс стать предателем составляет %s%%, по сравнению с остальными членами экипажа."

language.Points = " (%s очков)"
language.Experience = " (%s опыта)"

language.SkillsIncreased = "Хорошая работа по улучшению ваших навыков"
language.PointsAwarded = "Вы получили %s очков"
language.PointsAwardedRound = "В этом раунде вы получили:\n%s очков"
language.ExperienceAwarded = "Вы получили %s опыта"

language.LivesGained = "Вы набрали %s. Теперь у вас есть %s/%s жизней"
language.ALife = "жизнь"
language.Lives = " жизни"
language.Death = "Вы потеряли жизнь. У вас осталось %s, прежде чем вы потеряете очки"
language.NoLives = "Вы потеряли все свои жизни. В результате вы потеряли часть очков"
language.MaxLives = "У вас максимальное количество жизней"

language.Codewords = "Кодовые слова: %s"
language.CodeResponses = "Кодовые ответы: %s"

language.OtherTraitors = "Список предателей: %s"

language.CommandTip = "(Введите !traitor в чате, чтобы показать это сообщение снова)"
language.CommandNotActive = "Эта команда деактивирована"

language.Completed = "(Завершено)"

language.Objective = "Основные цели:"
language.SubObjective = "Доп. цели (необязательные):"

language.NoObjectives = "Нет целей"
language.NoObjectivesYet = "Целей пока нет..."

language.ObjectiveAssassinate = "Уничтожить %s"
language.ObjectiveAssassinateDrunk = "Убить %s, будучи пьяным"
language.ObjectiveAssassinatePressure = "Раздавить %s высоким давлением"
language.ObjectiveBananaSlip = "Заставить поскользнуться %s на бананах (%s/%s) раз"
language.ObjectiveDestroyCaly = "Разрушить %s каликсанид(а)"
language.ObjectiveDrunkSailor = "Напоить %s более чем на 80%"
language.ObjectiveGrowMudraptors = "Вырастить (%s/%s) грязевых рапторов"
language.ObjectiveHusk = "Полностью превратить %s хаска"
language.ObjectiveTurnHusk = "Превратить себя в хаска"
language.ObjectiveSurvive = "Выполнить хотя бы одну задачу и пережить смену"
language.ObjectiveStealCaptainID = "Украсть удостоверение капитана"
language.ObjectiveStealID = "Украсть удостоверение %s на %s секунд"
language.ObjectiveKidnap = "Надеть наручники на %s на %s секунд"
language.ObjectivePoisonCaptain = "Отравить %s используя %s"
language.ObjectiveWreckGift = "Захватить подарок"

language.ObjectiveFinishAllObjectives = "Завершить все цели и получить 1 жизнь"
language.ObjectiveFinishRoundFast = "Завершить раунд менее чем за 20 минут"
language.ObjectiveHealCharacters = "Вылечить на (%s/%s) хп"
language.ObjectiveKillMonsters = "Убить (%s/%s) %s"
language.ObjectiveRepair = "Починить (%s/%s) %s"
language.ObjectiveRepairHull = "Заварить (%s/%s) пробоин в корпусе"
language.ObjectiveSecurityTeamSurvival = "Убедитесь, что хотя бы один оффицер службы безопасности выжил"

language.ObjectiveText = "Убейте экипаж, чтобы завершить миссию"

language.AssassinationNextTarget = "Не высовываться до дальнейших указаний"
language.AssassinationNewObjective = "Ваша следующая цель для убийства - %s"
language.CultistNextTarget = "Церковь хаска ценит ваши усилия, скоро будет назначена новая цель"
language.HuskNewObjective = "Ваша следующая цель - %s"
language.AssassinationEveryoneDead = "Отличная работа агент, вы справились!"
language.HonkmotherNextTarget = "Красный нос доволен вашей работой, но вам еще многое предстоит сделать, ждите дальнейших указаний."
language.HonkmotherNewObjective = "Ваша следующая цель - %s, раздавите её давлением."

language.AbyssHelpPart1 = "Входящий сигнал бедствия... п---гит-! -ы -----яли в безд-- и н-м н--на -о--щь бл-к-рат-р за--щил нас вн--. Вз--ен м- предл---ем что-н--удь, ч-о у н-с е--ь, вк-ю-ая н-ши ---0 оч-ков"
language.AbyssHelpPart2 = "Передача прерывается сразу после этого."
language.AbyssHelpPart3 = "Не могу поверить, что мы выбрались живыми, спасибо вам большое! Вот очки, которые я обещал, возьмите этот грузовой скутер и журнал внутри. В журнале должны быть обещанные очки"
language.AbyssHelpPart4 = "Вот дерьмо! Кто-то пришел! Огромное спасибо! Пожалуйста, найдите способ вытащить нас отсюда, я дам вам %s моих очков, если вы сможете вытащить меня живым."
language.AbyssHelpPart5 = "Вы можете попробовать достать новый аккумулятор для этой подводной лодки и починить ее."
language.AbyssHelpDead = "Думаю, этим все и закончится...."

language.AmmoDelivery = "В оружейную зону субмарины доставлены боеприпасы и снаряды для рельсотрона."
language.BeaconPirate = "Поступили сообщения о печально известном пирате в УЗК, терроризирующем эти воды. Недавно пират был обнаружен на станции маяка - уничтожьте пирата, чтобы получить награду в %s очков для всего экипажа."
language.WreckPirate = "Поступили сообщения о печально известном пирате в УЗК, терроризирующем эти воды, недавно пират был обнаружен внутри затонувшей подводной лодки - ликвидируйте пирата, чтобы получить награду в %s очков для всего экипажа."
language.PirateInside = "Внимание! Опасный пират в УЗК был обнаружен внутри главной подводной лодки!"
language.PirateKilled = "Пират в УЗК убит, команда получила награду в %s очков."

language.ClownMagic = "Вы чувствуете странное ощущение, и внезапно оказываетесь в другом месте"
language.CommunicationsOffline = "Что-то вмешивается во все наши системы связи. По оценкам, связь будет отключена не менее чем на %s минут."
language.CommunicationsBack = "Связь восстановлена"
language.EmergencyTeam = "Группа инженеров и механиков прибыла на подводную лодку, чтобы помочь с ремонтом"
language.LightsOff = "Все огни внезапно погасли, но питание по-прежнему включено? Что происходит?"
language.MaintenanceToolsDelivery = "В грузовой отсек корабля доставлены инструменты для технического обслуживания. Инструменты находятся в желтом ящике"
language.MedicalDelivery = "В медицинский отсек корабля доставлено медицинское оборудование. Медицинские принадлежности находятся в красном медицинском ящике"
language.PrisonerAboard = "На борту подводной лодки находится заключенный, держите его живым и в наручниках, пока подводная лодка не прибудет в пункт назначения, чтобы команда получила %s очков"
language.PrisonerYou = "Вы - заключенный! Если вам удастся отойти от подводной лодки на 500 метров, вы будете вознаграждены суммой в размере %s очков."
language.PrisonerSuccess = "Заключенный был успешно доставлен, экипаж получил награду в %s очков."
language.PrisonerFail = "Заключенный сбежал, и награда за транспортировку была отменена"
language.OxygenSafe = "Кислород из генератора кислорода теперь снова безопасен для дыхания"
language.OxygenHusk = "Кислородный генератор был саботирован и теперь содержит яйца трупных паразитов. У тех, кто дышит этим воздухом есть около 15 секунд, чтобы достать подводную маску или скафандр, прежде чем вы получите достаточно большую дозу!"
language.OxygenPoison = "Кислородный генератор был саботирован и теперь содержит страданит. У тех, кто дышит этим воздухом есть около 15 секунд, чтобы достать подводную маску или скафандр, прежде чем вы получите достаточно большую дозу!"
language.PirateCrew = "Внимание! В этих водах замечен пиратский корабль! Уничтожьте пиратский реактор или убейте всех пиратов, чтобы получить награду в %s очков для всего экипажа"
language.PirateCrewYou = "Вы являетесь частью пиратской команды этой подводной лодки! Защитите подводную лодку от любых грязных коалиций, пытающихся получить то, что принадлежит вам!"
language.PirateCrewSuccess = "Пираты сдались, команда получила награду в %s очков."

language.ShadyMissionPart1 = "Вы засекли странную радиопередачу, похоже, они ищут кого-то, кто выполнит для них работу."
language.ShadyMissionPart2 = "\"О, привет! Мы ищем человека, который выполнит для нас одно простое задание. Мы готовы заплатить за него до 3000 очков. Заинтересованы?\""
language.ShadyMissionPart2Answer = "Конечно! Что это?"
language.ShadyMissionPart3 = "\"В этом районе, куда направляется ваша подводная лодка, есть старая разбитая подводная лодка, где нам нужно разместить некоторые припасы. Поскольку сейчас у нас нет припасов, вам придется достать их самостоятельно. Нам понадобится минимум 8 любых медицинских предметов, 4 кислородных баллона, 2 заряженных пистолета любого типа и специальный гидролокационный маяк. За эти припасы мы заплатим 1500 очков, если вы добавите другие припасы, мы дадим вам до 1500 дополнительных очков.\""
language.ShadyMissionPart3Answer = "Звучит подозрительно, зачем вам понадобилось класть эти припасы в затонувшую подводную лодку?!"
language.ShadyMissionPart4 = "\"Теперь это не твое дело, сделаешь ты это или нет?\""
language.ShadyMissionPart4AnswerAccept = "Принять предложение"
language.ShadyMissionPart4AnswerDeny = "Отклонить предложение"
language.ShadyMissionPart5 = "\"Отлично! Просто положите все припасы и специальный сонарный маяк в металлический ящик и оставьте его на затонувшем корабле.\""
language.ShadyMissionPart5Answer = "Я сделаю все возможное"
language.ShadyMissionBeacon = "‖color:gui.red‖Кажется, маяк был модифицирован.\nСзади висит записка, гласящая: \"8 Медицинских предмета, 4 Кислороднх баллона и 2 заряженых пушки.\"‖color:end‖"

language.SuperBallastFlora = "В этой области обнаружена высокая концентрация спор балластной флоры, рекомендуется обыскать насосы на предмет балластной флоры!"

language.Answer = "Ответить"
language.Ignore = "Игнорировать"

language.SecretSummary = "Задачи выполнены: %s - Очки получены: %s\n"
language.SecretTraitorAssigned = "Вы были избраны предателем, проголосуйте,им именно вы хотите быть."

language.ItemsBought = "Предметы, купленные в магазине"
language.CrewBoughtItem = "Игроки купили предметы в магазине"
language.PointsGained = "Общее количество набранных очков"
language.PointsLost = "Общее количество потерянных очков"
language.Spawns = "Появившиеся игроки"
language.Traitor = "Выбран в качестве предателя"
language.TraitorDeaths = "Умер предатель"
language.TraitorMainObjectives = "Основные задачи выполнены"
language.TraitorSubObjectives = "Доп. цели выполнени"
language.CrewDeaths = "Смерти"
language.Rounds = "Общая статистика раунда"

language.Yes = "Да"
language.No = "Нет"

language.PointshopInGame = "Вы должны быть в игре, чтобы использовать магазин"
language.PointshopCannotBeUsed = "Этот товар нельзя приобрести в данный момент"
language.PointshopWait = "Вам придется подождать %s секунд, прежде чем вы сможете приобрести этот товар"
language.PointshopNoPoints = "У вас недостаточно очков для покупки этого товара"
language.PointshopNoStock = "Этого товара нет в наличии"
language.PointshopPurchased = "Приобретено \"%s\" за %s баллов\n\nНовый баланс очков составляет: %s очков."
language.PointshopGoBack = ">> Вернуться назад <<"
language.PointshopCancel = ">> Отменить <<"
language.PointshopWishBuy = "Ваш текущий баланс: %s очков\nЧто вы хотите купить?"
language.PointshopInstallation = "товар, который вы собираетесь купить, будет установлен в вашем точном месте, вы не сможете переместить его в другое место, хотите ли вы продолжить?\n"
language.PointshopNotAvailable = "Магазин недоступен."
language.PointshopWishCategory = "Ваш текущий баланс: %s очков\nВыберите категорию."
language.PointshopRefunded = "Вам было возвращено %s очков за покупку %s"


language.Pointshop = {
    fakehandcuffs = "Поддельные наручники",
    choke = "Чокер",
    choke_desc = "‖color:gui.red‖Заглушает цель‖color:end‖",
    jailgrenade = "DarkRP Тюремная граната",
    jailgrenade_desc = "‖color:gui.red‖ Особая граната с интересным сюрпризом...‖color:end‖",
    clowngearcrate = "Ящик клоунского снаряжения",
    clowntalenttree = "Дерево талантов клоуна",
    invisibilitygear = "Скафандр невидимости",
    clownmagic = "Магия клоуна (случайным образом меняет местами людей)",
    randomizelights = "Случайное освещение",
    fuelrodlowquality = "Пустой топливный стержень",
    gardeningkit = "Набор для садоводства",
    randomitem = "Случайный предмет",
    clownsuit = "Костюм клоуна",
    randomegg = "Случайное яйцо",
    assistantbot = "Бот-помощник",
    firemanscarrytalent = "Талант 'перенос на плече'",
    stungunammo = "Патроны для электрошокера (x4)",
    revolverammo = "Патроны для револьвера (x6)",
    smgammo = "Магазин для ПП (x2)",
    shotgunammo = "Снаряды для дробовика (x8)",
    streamchalk = "Потоковый мел",
    uri = "Ури - инопланетный корабль",
    seashark = "Морская акула МК II",
    Beaver = "Барсук",
    huskattractorbeacon = "Маяк аттрактора хаска",
    huskautoinjector = "Автоинжектор Хаска",
    huskedbloodpack = "Зараженная кровь",
    spawnhusk = "Призвать хасков",
    huskoxygensupply = "Подача зараженного кислорода",
    explosiveautoinjector = "Взрывной автоинжектор",
    teleporterrevolver = "Револьвер телепортации",
    poisonoxygensupply = "Подача ядовитого кислорода",
    turnofflights = "Выключить свет на 3 минуты",
    turnoffcommunications = "Выключить связь на 2 минуты",
    spawnascrawler = "Появиться в виде Ползуна",
    spawnascrawlerhusk = "Появиться в виде Ползуна-хаска",
    spawnaslegacycrawler = "Появиться в виде Ползуна(устаревшее)",
    spawnaslegacyhusk = "Появиться в виде Хаска(устаревшее)",
    spawnascrawlerbaby = "Появиться в виде Детеныша ползуна",
    spawnasmudraptorbaby = "Появиться в виде Детеныша грязевого раптора",
    spawnasthresherbaby = "Появиться в виде Детеныша акульего тигра",
    spawnasspineling = "Появиться в виде Шипостая",
    spawnasmudraptor = "Появиться в виде Грязевого раптор",
    spawnasmantis = "Появиться в виде Богомола",
    spawnashusk = "Появиться в виде Хаска",
    spawnashuskedhuman = "Появиться в виде Человека-хаска",
    spawnasbonethresher = "Появиться в виде Костяного акульего тигра",
    spawnastigerthresher = "Появиться в виде Акульего тигра",
    spawnaslegacymoloch = "Появиться в виде Молоха(устаревшее)",
    spawnaslegacycarrier = "Появиться в виде Разносчика(устаревшее)",
    spawnashammerhead = "Появиться в виде Молотоглава",
    spawnasfractalguardian = "Появиться в виде Фрактального стража",
    spawnasgiantspineling = "Появиться в виде Гигантского шипостая",
    spawnasveteranmudraptor = "Появиться в виде Грязевого раптора-ветерана",
    spawnaslatcher = "Появиться в виде Блокиратора",
    spawnascharybdis = "Появиться в виде Харибдаы",
    spawnasendworm = "Появиться в виде Червя рока",
    spawnaspeanut = "Появиться в виде Орешка",
    spawnasorangeboy = "Появиться в виде Оранжевого парня",
    spawnascthulhu = "Появиться в виде Ктулху",
    spawnaspsilotoad = "Появиться в виде Псиложабы",
    clown = "Магазин клоунов",
    cultist = "Магазин культистов",
    traitor = "Магазин предателей",
    deathspawn = "Переродиться",
    wiring = "Проводка",
    ores = "Руды",
    security = "Безопасность",
    ships = "Корабли",
    materials = "Материалы",
    medical = "Медицина",
    maintenance = "Обслуживание",
    other = "Прочее",
    idcardlocator = "Локатор удостоверений личности",
    idcardlocator_desc = "‖color:gui.red‖Локатор удостоверений личности‖color:end‖",
    idcardlocator_result = "%s - %s - %s метров",
}

language.FakeHandcuffsUsage = "Вы можете освободиться от этих наручников, используя !fhc"

language.ShipTooCloseToWall = "Невозможно купить корабль, позиция слишком близко к стене уровня."
language.ShipTooCloseToShip = "Невозможно купить корабль, позиция находится слишком близко к другой подводной лодке."

language.Pets = "Питомцы"
language.SmallCreatures = "Мелкие существа"
language.LargeCreatures = "Крупные существа"
language.AbyssCreature = "Существо бездны"
language.ElectricalDevices = "Электрические устройства"
language.MechanicalDevices = "Механические устройства"

language.CMDAliveToUse = "Вы должны быть живы, чтобы использовать эту команду"
language.CMDNoRole = "У вас нет особой роли"
language.CMDAlreadyDead = "Вы уже мертвы!"
language.CMDHandcuffed = "Вы не можете использовать эту команду, пока скованы наручниками"
language.CMDKnockedDown = "Вы не можете использовать эту команду, пока вы без сознания"
language.GamemodeNone = "Режим игры: Нет"
language.CMDPermisionPoints = "У вас нет прав на добавление очков"
language.CMDInvalidNumber = "Неверное значение числа"
language.CMDClientNotFound = "Не удалось найти клиента с этим именем / steamID"
language.CMDCharacterNotFound = "Не удалось найти персонажа с указанным именем"
language.CMDAdminAddedPointsEveryone = "Администратор добавил %s очков всем"
language.CMDAdminAddedPoints = "Администратор добавил %s очков %s"
language.CMDAdminAddedLives = "Администратор добавил %s жизней %s"
language.CMDOnlyMonsters = "Только монстры могут использовать эту команду"
language.CMDLocateSub = "Подводная лодка находится на расстоянии %sм от вас, в %s"
language.CMDRoundTime = "Этот раунд длится уже %s минут"

return language