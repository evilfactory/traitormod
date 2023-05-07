local objective = Traitormod.RoleManager.Objectives.Repair:new()

objective.Name = "RepairJunctions"
objective.AmountPoints = 300
objective.ItemIdentifier = {"junctionbox"}
objective.ItemText = "Junction Boxes"

return objective
