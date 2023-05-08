local objective = Traitormod.RoleManager.Objectives.KillMonsters:new()

objective.Name = "KillPets"
objective.AmountPoints = 500
objective.Monster = {
    Identifiers = {"Balloon", "defensebot", "huskcontainer", "Orangeboy", "Peanut", "Mudraptor_pet", "Psilotoad"},
    Text = "Pets",
    Amount = 5,
}

return objective
