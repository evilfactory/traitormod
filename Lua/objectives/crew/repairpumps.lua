local objective = Traitormod.RoleManager.Objectives.Repair:new()

objective.Name = "RepairPumps"
objective.AmountPoints = 300
objective.ItemIdentifier = {"smallpump", "pump"}
objective.ItemText = "Pumps"

return objective
