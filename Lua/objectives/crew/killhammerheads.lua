local objective = Traitormod.RoleManager.Objectives.KillMonsters:new()

objective.Name = "KillHammerheads"
objective.AmountPoints = 600
objective.Monster = {
    Identifier = "Hammerhead",
    Text = "Hammerheads",
    Amount = 3,
}

return objective
