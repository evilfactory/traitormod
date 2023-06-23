local objective = Traitormod.RoleManager.Objectives.KillMonsters:new()

objective.Name = "KillLargeMonsters"
objective.AmountPoints = 650
objective.Monster = {
    Identifiers = {"Moloch", "Molochblack", "Hammerhead", "Hammerheadgold", "Hammerheadmatriarch", "Spineling_giant", "Mudraptor_veteran", "Crawlerbroodmother", "Watcher", "Fractalguardian"},
    Text = Traitormod.Language.LargeCreatures,
    Amount = 1,
}

return objective
