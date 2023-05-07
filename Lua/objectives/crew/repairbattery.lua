local objective = Traitormod.RoleManager.Objectives.Repair:new()

objective.Name = "RepairBattery"
objective.AmountPoints = 300
objective.ItemIdentifier = {"battery"}
objective.ItemText = "Batteries"

return objective
