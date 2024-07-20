local gm = {}

gm.Name = "Gamemode"

function gm:PreStart()
    Traitormod.Pointshop.Initialize(self.PointshopCategories or {})

    Hook.Patch("Barotrauma.Networking.GameServer", "AssignJobs", function (instance, ptable)
        local gamemode = Traitormod.SelectedGamemode
        if gamemode.RoleLock == nil then return end

        for index, client in pairs(ptable["unassigned"]) do
            local flag = false
            local jobName = client.AssignedJob.Prefab.Identifier.ToString()
            for role, params in pairs(gamemode.RoleLock.LockedRoles) do
                if jobName == role then
                    if gamemode.RoleLock.LockIf(client, params) then 
                        flag = true
                    end
                    break
                end
            end
            if flag then
                Traitormod.SendMessage(client, string.format(Traitormod.Language.RoleLocked, jobName))
                client.AssignedJob = Traitormod.GetJobVariant(gamemode.RoleLock.SubstituteRoles[math.random(1, #gamemode.RoleLock.SubstituteRoles)])
            end
        end
    end, Hook.HookMethodType.After)
end

function gm:Start()

end

function gm:Think()

end

function gm:End()

end

function gm:TraitorResults()

end

function gm:RoundSummary()
    local sb = Traitormod.StringBuilder:new()

    sb("Gamemode: %s\n", self.Name)

    for character, role in pairs(Traitormod.RoleManager.RoundRoles) do
        local text = role:OtherGreet()
        if text then
            sb("\n%s\n", role:OtherGreet())
        end
    end

    return sb:concat()
end

function gm:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    return o
end

return gm
