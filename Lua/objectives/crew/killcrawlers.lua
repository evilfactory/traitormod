local objective = Traitormod.RoleManager.Objectives.KillMonsters:new()

objective.Name = "KillCrawlers"
objective.AmountPoints = 350
objective.Monster = {
    Identifier = "Crawler",
    Text = "Crawlers",
    Amount = 8,
}

return objective
