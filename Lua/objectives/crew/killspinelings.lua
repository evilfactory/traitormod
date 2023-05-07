local objective = Traitormod.RoleManager.Objectives.KillMonsters:new()

objective.Name = "KillSpinelings"
objective.AmountPoints = 400
objective.Monster = {
    Identifier = "Spineling",
    Text = "Spinelings",
    Amount = 10,
}

return objective
