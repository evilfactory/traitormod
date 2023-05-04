local role = Traitormod.RoleManager.Roles.Role:new()
role.Name = "Clown"
role.Antagonist = true


function role:Start()

    

    local text = self:Greet()
    local client = Traitormod.FindClientCharacter(self.Character)
    if client then
        Traitormod.SendTraitorMessageBox(client, text)
        Traitormod.UpdateVanillaTraitor(client, true, text)
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
    if #objs == 0 then
        objs(" > No objectives yet... Stay futile.")
    end

    return objs:concat("\n")
end

function role:Greet()
    local objectives = self:ObjectivesToString()

    local sb = Traitormod.StringBuilder:new()
    sb("You are now part of the Children of The Honkmother.\nComplete the objectives given to you to prove yourself worthy.\n\n")
    sb("Your objectives are:\n")
    sb(objectives)
    sb("\n\n")

    return sb:concat()
end

function role:OtherGreet()
    return ""
end

function role:FilterTarget(objective, character)
    if not self.SelectBotsAsTargets and character.IsBot then return false end

    if objective.Name == "Assassinate" and self.SelectUniqueTargets then
        for key, value in pairs(Traitormod.RoleManager.FindCharactersByRole("Traitor")) do
            local role = Traitormod.RoleManager.GetRole(value)

            for key, obj in pairs(role.Objectives) do
                if obj.Name == "Assassinate" and obj.Target == character then
                    return false
                end
            end
        end
    end

    if character.TeamID ~= CharacterTeamType.Team1 and not self.SelectPiratesAsTargets then
        return false
    end

    return Traitormod.RoleManager.Roles.Role.FilterTarget(self, objective, character)
end


return role
