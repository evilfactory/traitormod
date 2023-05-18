local rm = {}

rm.Roles = {}
rm.Objectives = {}

rm.RoundRoles = {}

rm.FindObjective = function(name)
    return rm.Objectives[name]
end

rm.RandomObjective = function(allowedObjectives)
    if allowedObjectives == nil then
        for key, value in pairs(rm.Objectives) do
            table.insert(allowedObjectives, key)
        end
    end

    local objectives = {}

    for _, objective in pairs(rm.Objectives) do
        for _, allowedName in pairs(allowedObjectives) do
            if objective.Name == allowedName then
                table.insert(objectives, objective)
            end
        end
    end

    return objectives[Random.Range(1, #objectives + 1)]
end

rm.AddObjective = function(objective)
    rm.Objectives[objective.Name] = objective

    if Traitormod.Config.ObjectiveConfig[objective.Name] ~= nil then
        for key, value in pairs(Traitormod.Config.ObjectiveConfig[objective.Name]) do
            objective[key] = value
        end
    end

    objective.Static()
end

rm.CheckObjectives = function(endRound)
    for character, role in pairs(rm.RoundRoles) do
        if not character.IsDead and role.Objectives then
            for _, objective in pairs(role.Objectives) do
                if objective.EndRoundObjective == endRound and not objective.Awarded then
                    if objective:IsCompleted() then
                        objective:Award()
                    elseif objective:IsFailed() then
                        objective:Fail()
                    end
                end
            end
        end
    end
end

rm.FindRole = function(name)
    return rm.Roles[name]
end

rm.AddRole = function(role)
    rm.Roles[role.Name] = role

    if Traitormod.Config.RoleConfig[role.Name] ~= nil then
        for key, value in pairs(Traitormod.Config.RoleConfig[role.Name]) do
            role[key] = value
        end
    end
end

rm.AssignRole = function(character, newRole)
    if rm.RoundRoles[character] ~= nil then
        error("character" .. character.Name .. " already has a role.", 2)
    end

    Traitormod.Log("Assigned role " .. newRole.Name .. " to " .. character.Name .. ".")

    for key, role in pairs(rm.RoundRoles) do
        if role.Name == newRole.Name then
            role:NewMember(key)
        end
    end

    rm.RoundRoles[character] = newRole

    newRole:Init(character)
    newRole:Start()
end

rm.TransferRole = function(character, oldRole)
    rm.RoundRoles[oldRole.Character] = nil
    rm.RoundRoles[character] = oldRole

    oldRole:Transfer(character)
end

rm.RemoveRole = function (character)
    local role = rm.GetRole(character)
    if role == nil then return end

    role:End()
    rm.RoundRoles[character] = nil

    Traitormod.Log("Removed role " .. role.Name .. " from " .. character.Name .. ".")
end

rm.AssignRoles = function(characters, newRoles)
    for key, value in pairs(characters) do
        if rm.RoundRoles[value] ~= nil then
            error("character" .. value.Name .. " already has a role.", 2)
        end
    end

    for i = 1, #characters, 1 do
        for character, role in pairs(rm.RoundRoles) do
            if newRoles[i].Name == role.Name then
                role:NewMember(character)
            end
        end
    end

    for i = 1, #characters, 1 do
        rm.RoundRoles[characters[i]] = newRoles[i]
        newRoles[i]:Init(characters[i])
    end

    for i = 1, #characters, 1 do
        newRoles[i]:Start()
    end
end

rm.HasRole = function (character, name)
    local role = rm.GetRole(character)
    if role == nil then return false end
    return role.Name == name
end

rm.FindCharactersByRole = function(name)
    local characters = {}

    for character, role in pairs(rm.RoundRoles) do
        if role.Name == name then
            table.insert(characters, character)
        end
    end

    return characters
end

rm.FindAntagonists = function()
    local characters = {}

    for character, role in pairs(rm.RoundRoles) do
        if role.IsAntagonist then
            table.insert(characters, character)
        end
    end

    return characters
end

rm.GetRole = function(character)
    if character == nil then return nil end

    return rm.RoundRoles[character]
end

rm.IsAntagonist = function (character)
    local role = rm.GetRole(character)
    if role == nil then return false end
    return role.IsAntagonist
end

rm.IsSameRole = function (character1, character2)
    local role1, role2

    if type(character1) == "table" then
        role1 = character1
    else
        role1 = rm.GetRole(character1)
    end

    if type(character2) == "table" then
        role2 = character2
    else
        role2 = rm.GetRole(character2)
    end

    if role1 == nil or role2 == nil then return false end

    return role1.Name == role2.Name
end

rm.CallObjectiveFunction = function (functionName, ...)
    for character, role in pairs(rm.RoundRoles) do
        if not character.IsDead and role.Objectives then
            for _, objective in pairs(role.Objectives) do
                if objective[functionName] then
                    objective[functionName](objective, ...)
                end
            end
        end
    end
end

Hook.Add("think", "Traitormod.RoleManager.Think", function()
    if not Game.RoundStarted then return end
    rm.CheckObjectives(false)
end)

Hook.Add("characterDeath", "Traitormod.RoleManager.CharacterDeath", function(deadCharacter)
    rm.CallObjectiveFunction("CharacterDeath", deadCharacter)

    local role = rm.GetRole(deadCharacter)
    if role then
        role:End()
    end
end)

Hook.Patch("Barotrauma.Items.Components.Repairable", "StopRepairing", function (instance, ptable)
    rm.CallObjectiveFunction("StopRepairing", instance.Item, ptable["character"])
end)

Hook.Patch("Barotrauma.HumanAIController", "StructureDamaged", function (instance, ptable)
    local damage = ptable["damageAmount"]

    if damage > 0 then return end
    if ptable["character"] == nil then return end

    rm.CallObjectiveFunction("HullRepaired", ptable["character"], damage)
end, Hook.HookMethodType.After)

Hook.Patch("Barotrauma.Character", "TryAdjustHealerSkill", function (character, ptable)
    local healer = ptable["healer"]
    local healthChange = ptable["healthChange"]

    rm.CallObjectiveFunction("CharacterHealed", character, healer, healthChange)
end, Hook.HookMethodType.After)

rm.EndRound = function ()
    rm.CheckObjectives(true)

    for key, role in pairs(rm.RoundRoles) do
        role:End(true)
    end

    rm.RoundRoles = {}
end

return rm
