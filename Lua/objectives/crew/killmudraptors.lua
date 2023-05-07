local objective = Traitormod.RoleManager.Objectives.KillMonsters:new()

objective.Name = "KillMudraptors"
objective.AmountPoints = 500
objective.Monster = {
    Identifier = "Mudraptor",
    Text = "Mudraptors",
    Amount = 5,
}

return objective
