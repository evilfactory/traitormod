local objective = Traitormod.RoleManager.Objectives.Repair:new()

objective.Name = "RepairMechanical"
objective.AmountPoints = 300
objective.ItemIdentifier = {"smallpump", "pump", "oxygenerator", "shuttleoxygenerator", "outpostoxygenerator", "deconstructor", "fabricator", "engine", "largeengine", "shuttleengine", "coilgunloader", "pulselaserloader", "depthchargeloader", "railgunloader", "chaingunloader", "flakcannonloader"}
objective.ItemText = Traitormod.Language.MechanicalDevices

return objective
