local role = Traitormod.RoleManager.Roles.Antagonist:new()
role.Name = "Cultist"

function role:CultistLoop(first)
    if not Game.RoundStarted then return end
    if self.RoundNumber ~= Traitormod.RoundNumber then return end

    local this = self

    local husk = Traitormod.RoleManager.Objectives.Husk:new()
    husk:Init(self.Character)
    local target = self:FindValidTarget(husk)
    if not self.Character.IsDead and husk:Start(target) then
        self:AssignObjective(husk)

        local client = Traitormod.FindClientCharacter(self.Character)

        husk.OnAwarded = function()
            if client then
                Traitormod.SendMessage(client, Traitormod.Language.CultistNextTarget, "")
                Traitormod.Stats.AddClientStat("TraitorMainObjectives", client, 1)
            end

            local delay = math.random(this.NextObjectiveDelayMin, this.NextObjectiveDelayMax) * 1000
            Timer.Wait(function(...)
                this:CultistLoop()
            end, delay)
        end


        if client and not first then
            Traitormod.SendMessage(client, string.format(Traitormod.Language.HuskNewObjective, target.Name),
                "GameModeIcon.pvp")
            Traitormod.UpdateVanillaTraitor(client, true, self:Greet())
        end
    else
        Timer.Wait(function()
            this:CultistLoop()
        end, 5000)
    end
end

function role:Start()
    Traitormod.Stats.AddCharacterStat("Traitor", self.Character, 1)

    self.Character.AddAbilityFlag(AbilityFlags.IgnoredByEnemyAI) -- husks ignore the cultists

    self:CultistLoop(true)

    local pool = {}
    for key, value in pairs(self.SubObjectives) do pool[key] = value end

    local toRemove = {}
    for key, value in pairs(pool) do
        local objective = Traitormod.RoleManager.FindObjective(value)
        if objective ~= nil and objective.AlwaysActive then
            objective = objective:new()

            local character = self.Character

            objective:Init(character)
            objective.OnAwarded = function ()
                Traitormod.Stats.AddCharacterStat("TraitorSubObjectives", character, 1)
            end

            if objective:Start(character) then
                self:AssignObjective(objective)
                table.insert(toRemove, key)
            end
        end
    end
    for key, value in pairs(toRemove) do table.remove(pool, value) end

    for i = 1, math.random(self.MinSubObjectives, self.MaxSubObjectives), 1 do
        local objective = Traitormod.RoleManager.RandomObjective(pool)
        if objective == nil then break end

        objective = objective:new()

        local character = self.Character

        objective:Init(character)
        local target = self:FindValidTarget(objective)

        objective.OnAwarded = function ()
            Traitormod.Stats.AddCharacterStat("TraitorSubObjectives", character, 1)
        end

        if objective:Start(target) then
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
        Traitormod.SendTraitorMessageBox(client, text, "oneofus")
        Traitormod.UpdateVanillaTraitor(client, true, text, "oneofus")
    end
end


function role:End(roundEnd)
    local client = Traitormod.FindClientCharacter(self.Character)
    if not roundEnd and client then
        --Traitormod.SendMessage(client, Traitormod.Language.TraitorDeath, "InfoFrameTabButton.Traitor")
        Traitormod.UpdateVanillaTraitor(client, false)
    end
end

---@return string mainPart, string subPart
function role:ObjectivesToString()
    local primary = Traitormod.StringBuilder:new()
    local secondary = Traitormod.StringBuilder:new()

    for _, objective in pairs(self.Objectives) do
        -- Husk objectives are primary
        local buf = objective.Name == "Husk" and primary or secondary

        if objective:IsCompleted() or objective.Awarded then
            buf:append(" > ", objective.Text, Traitormod.Language.Completed)
        else
            buf:append(" > ", objective.Text, string.format(Traitormod.Language.Points, objective.AmountPoints))
        end
    end
    if #primary == 0 then
        primary(Traitormod.Language.NoObjectivesYet)
    end

    return primary:concat("\n"), secondary:concat("\n")
end

function role:Greet()
    local partners = Traitormod.StringBuilder:new()
    local traitors = Traitormod.RoleManager.FindAntagonists()
    for _, character in pairs(traitors) do
        if character ~= self.Character then
            partners('"%s" ', character.Name)
        end
    end
    partners = partners:concat(" ")
    local primary, secondary = self:ObjectivesToString()

    local sb = Traitormod.StringBuilder:new()
    sb("%s\n\n", Traitormod.Language.CultistYou)
    sb("%s\n", Traitormod.Language.MainObjectivesYou)
    sb(primary)
    sb("\n\n%s\n", Traitormod.Language.SecondaryObjectivesYou)
    sb(secondary)
    sb("\n\n")
    if #traitors < 2 then
        sb(Traitormod.Language.SoloAntagonist)
    else
        sb(Traitormod.Language.Partners, partners)
        sb("\n")

        if self.TraitorBroadcast then
            sb(Traitormod.Language.TcTip)
        end
    end
    
    return sb:concat()
end

function role:OtherGreet()
    local sb = Traitormod.StringBuilder:new()
    local primary, secondary = self:ObjectivesToString()
    sb(Traitormod.Language.CultistOther, self.Character.Name)
    sb("\n%s\n", Traitormod.Language.MainObjectivesOther)
    sb(primary)
    sb("\n%s\n", Traitormod.Language.SecondaryObjectivesOther)
    sb(secondary)
    return sb:concat()
end

function role:FilterTarget(objective, character)
    if not self.SelectBotsAsTargets and character.IsBot then return false end

    if character.TeamID ~= CharacterTeamType.Team1 and not self.SelectPiratesAsTargets then
        return false
    end

    local aff = character.CharacterHealth.GetAffliction("huskinfection", true)

    if aff ~= nil and aff.Strength > 1 then
        return false
    end

    return Traitormod.RoleManager.Roles.Antagonist.FilterTarget(self, objective, character)
end

Hook.Add("husk.clientControlHusk", "Traitormod.Cultist.HuskControl", function (client, husk)
    local cultist
    for _, character in pairs(Traitormod.RoleManager.FindCharactersByRole("Cultist")) do
        if character.Name == client.Name then
            cultist = Traitormod.RoleManager.GetRole(character)
            break
        end
    end

    if cultist then
        Traitormod.RoleManager.TransferRole(client.Character, cultist)
    else
        Traitormod.RoleManager.AssignRole(client.Character, Traitormod.RoleManager.Roles.HuskServant:new())
    end
end)

return role
