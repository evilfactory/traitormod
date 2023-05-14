local objective = Traitormod.RoleManager.Objectives.KillMonsters:new()

objective.Name = "KillSmallMonsters"
objective.AmountPoints = 500
objective.Monster = {
    Identifiers = {"Crawler", "Crawlerhusk", "Husk", "Tigerthresher", "Bonethresher", "Mudraptor", "Mudraptor_unarmored", "Spineling"},
    Text = "Small Creatures",
    Amount = 6,
}

return objective
