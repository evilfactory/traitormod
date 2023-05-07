local objective = Traitormod.RoleManager.Objectives.KillMonsters:new()

objective.Name = "KillMolochs"
objective.AmountPoints = 500
objective.Monster = {
    Identifier = "Moloch",
    Text = "Moloch",
    Amount = 1,
}

return objective
