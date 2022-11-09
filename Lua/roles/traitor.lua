local role = Traitormod.RoleManager.Roles.Role:new()
role.Name = "Traitor"
role.Antagonist = true

function role:AssasinationLoop(first)
    local this = self
    
    local assassinate = Traitormod.RoleManager.Objectives.Assassinate:new()
    assassinate:Init(self.Character)
    local target = self:FindValidTarget(assassinate)
    if assassinate:Start(target) then
        self:AssignObjective(assassinate)

        assassinate.OnAwarded = function ()
            local delay = math.random(this.NextDelayMin, this.NextDelayMax)
            Timer.Wait(function (...)
                this:AssasinationLoop()
            end, delay)
        end

        local client = Traitormod.FindClientCharacter(self.Character)

        if client and not first then
            Traitormod.SendMessage(client, string.format(Traitormod.Language.AssassinationNewObjective, target.Name), "GameModeIcon.pvp")
            Traitormod.UpdateVanillaTraitor(client, true, self:Greet())  
        end
    else
        Timer.Wait(function ()
            this:AssasinationLoop()
        end, 5000)
    end
end

function role:Start()
    self:AssasinationLoop(true)

    local pool = {}
    for key, value in pairs(self.SubObjectives) do pool[key] = value end

    local toRemove = {}
    for key, value in pairs(pool) do
        local objective = Traitormod.RoleManager.FindObjective(value)
        if objective ~= nil then
            objective = objective:new()
            objective:Init(self.Character)
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
        objective:Init(self.Character)
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

---@return string mainPart, string subPart
function role:ObjectivesToString()
    local primary = Traitormod.StringBuilder:new()
    local secondary = Traitormod.StringBuilder:new()

    for _, objective in pairs(self.Objectives) do
        -- Assassinate objectives are primary
        local buf = objective.Name == "Assassinate" and primary or secondary
        buf:append(" > ", objective.Text)
    end
    if #primary == 0 then
        primary(" > No objectives yet... Stay furtile.")
    end

    return primary:concat("\n"), secondary:concat("\n")
end
function role:Greet()
    local partners = Traitormod.StringBuilder:new()
    local traitors = Traitormod.RoleManager.FindCharactersByRole("Traitor")
    for _, character in pairs(traitors) do
        if character ~= self.Character then
            partners('"%s"\n', character.Name)
        end
    end
    partners = partners:concat(" ")
    local primary, secondary = self:ObjectivesToString()

    local sb = Traitormod.StringBuilder:new()
    sb("You are a traitor!\n\n")
    sb("Your main objectives are:\n")
    sb(primary)
    sb("\n\nYour secondary objectives are:\n")
    sb(secondary)
    sb("\n\n")
    if #traitors < 2 then
        sb("You are the only traitor.")
    else
        sb("Partners: ")
        sb(partners)
    end
    return sb:concat()
end

function role:OtherGreet()
    local sb = Traitormod.StringBuilder:new()
    local primary, secondary = self:ObjectivesToString()
    sb("Traitor %s.", self.Character.Name)
    sb("\nTheir main objectives were:\n")
    sb(primary)
    sb("\nTheir secondary objectives were:\n")
    sb(secondary)
    return sb:concat()
end

return role