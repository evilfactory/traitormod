local role = Traitormod.RoleManager.Roles.Role:new()
role.Name = "Crew"
role.Antagonist = false

function role:Start()
    local job = self.Character.Info.Job.Prefab.Identifier.Value
    
    local availableObjectives = self.AvailableObjectives[job]

    if not availableObjectives or #availableObjectives == 0 then
        return
    end

    local pool = {}
    for key, value in pairs(availableObjectives) do pool[key] = value end

    for i = 1, 3, 1 do
        local objective = Traitormod.RoleManager.RandomObjective(pool)
        if objective == nil then break end

        objective = objective:new()

        local character = self.Character
        objective:Init(character)
        local target = self:FindValidTarget(objective)

        if objective:Start(target) then
            self:AssignObjective(objective)
            for key, value in pairs(pool) do
                if value == objective.Name then
                    table.remove(pool, key)
                end
            end
        end
    end

    local finishObjectives = Traitormod.RoleManager.FindObjective("FinishAllObjectives"):new()
    finishObjectives:Init(self.Character)
    self:AssignObjective(finishObjectives)


    local text = self:Greet()
    local client = Traitormod.FindClientCharacter(self.Character)
    if client and not self.Character.HasJob("convict") then
        Traitormod.SendChatMessage(client, text, Color.MediumSpringGreen)
    elseif client then
        Traitormod.SendChatMessage(client, text, Color.MonoGameOrange)
    end
end


function role:End(roundEnd)

end

---@return string objectives
function role:ObjectivesToString()
    local objs = Traitormod.StringBuilder:new()

    for _, objective in pairs(self.Objectives) do
        if objective:IsCompleted() then
            objs:append(" > ", objective.Text, Traitormod.Language.Completed)
        else
            objs:append(" > ", objective.Text, string.format(Traitormod.Language.Points, objective.AmountPoints))
        end
    end

    return objs:concat("\n")
end

function role:Greet()
    local objectives = self:ObjectivesToString()

    local sb = Traitormod.StringBuilder:new()
    if self.Character.HasJob("convict") then
        sb(Traitormod.Language.PrisonerMessage)
    else
        sb(Traitormod.Language.CrewMember)
    end
    sb(objectives)

    return sb:concat()
end

function role:OtherGreet()
    return nil -- No other greet.
end


return role
