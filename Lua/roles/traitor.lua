local role = Traitormod.RoleManager.Roles.Role:new()
role.Name = "Traitor"

function role:Start()
    local assassinate = Traitormod.RoleManager.Objectives.Assassinate:new()

    local target = self:FindValidTarget(assassinate)
    if assassinate:Start(self.Character, target) then
        self:AssignObjective(assassinate)
    end

    local pool = {}
    for key, value in pairs(self.SubObjectives) do pool[key] = value end

    local toRemove = {}
    for key, value in pairs(pool) do
        local objective = Traitormod.RoleManager.FindObjective(value)
        if objective ~= nil then
            objective = objective:new()
            if objective.AlwaysActive and objective:Start(self.Character) then
                self:AssignObjective(objective)
                table.insert(toRemove, key)
            end
        end
    end
    for key, value in pairs(toRemove) do table.remove(pool, value) end

    for i = 1, 3, 1 do
        local objective = Traitormod.RoleManager.RandomObjective(pool)
        if objective == nil then break end

        objective = objective:new()

        local target = self:FindValidTarget(objective)

        if objective:Start(self.Character, target) then
            self:AssignObjective(objective)
            for key, value in pairs(pool) do
                if value == objective.Name then
                    table.remove(pool, key)
                end
            end
        end
    end

    local text = self:Greet()
    local client = Traitormod.FindClientCharacter(self.Character)
    if client then
        Traitormod.SendTraitorMessageBox(client, text)
        Traitormod.UpdateVanillaTraitor(client, true, text)
    end
end

function role:Greet()
    
    local text = ""
    local mainPart = ""
    local subPart = ""
    local partners = ""

    for key, objective in pairs(self.Objectives) do
        if objective.Name == "Assassinate" then
            mainPart = mainPart .. " > " .. objective.ObjectiveText .. "\n"
        else
            subPart = subPart .. " > " .. objective.ObjectiveText .. "\n"
        end
    end

    local traitors = Traitormod.RoleManager.FindCharactersByRole("Traitor")
    for k, v in pairs(traitors) do
        if v ~= self.Character then
            partners = partners .. "\"" .. v.Name .. "\" "
        end
    end

    text = text .. "You are a traitor!\n\n"
    text = text .. "Your main objectives are:\n"
    text = text .. mainPart
    if subPart ~= "" then
        text = text .. "\nYour secondary objectives are:\n"
        text = text .. subPart
    end
    if #traitors < 2 then
        text = text .. "\nYou are the only traitor."
    else
        text = text .. "\nPartners: " .. partners
    end

    local sb = {}
    

    return table.concat(s)
end

function role:OtherGreet()
    local text = ""

    

    return text
end

return role