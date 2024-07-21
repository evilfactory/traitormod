local gm = {}

gm.Name = "Gamemode"

function gm:PreStart()
    Traitormod.Pointshop.Initialize(self.PointshopCategories or {})

    local json = require("json")

    Hook.Patch("Barotrauma.Networking.GameServer", "AssignJobs", function (instance, ptable)
        local gamemode = Traitormod.SelectedGamemode
        if not gamemode or not gamemode.RoleLock then 
            print("No RoleLock found.")
            return 
        end
    
        for index, client in pairs(ptable["unassigned"]) do
            local jobName = client.AssignedJob.Prefab.Identifier.ToString()
            local flag = false
    
            for role, params in pairs(gamemode.RoleLock.LockedRoles) do
                if jobName == role then
                    if gamemode.RoleLock.LockIf(client, params) then 
                        flag = true
                        print(string.format("Client %s meets RoleLock condition for job %s", client.Name, jobName))
                    end
                    break
                end
            end
    
            if flag then
                Traitormod.SendMessage(client, string.format(Traitormod.Language.RoleLocked, jobName))
                client.AssignedJob = Traitormod.GetJobVariant(gamemode.RoleLock.SubstituteRoles[math.random(1, #gamemode.RoleLock.SubstituteRoles)])
                print(string.format("Client %s reassigned to new job due to RoleLock", client.Name))
            end
        end
    end, Hook.HookMethodType.After)

    Hook.Patch("Barotrauma.Networking.GameServer", "AssignJobs", function (instance, ptable)
        local validJobs = { "prisondoctor", "guard", "headguard", "warden", "staff", "janitor", "convict", "he-chef" }
    
        -- Load banned jobs from JSON
        local bannedJobs = json.loadBannedJobs()
        print("Banned jobs loaded: ", bannedJobs)
    
        for index, client in pairs(ptable["unassigned"]) do
            local jobName = client.AssignedJob.Prefab.Identifier.ToString()
            local steamID = client.SteamID
            local flag = false
    
            print(string.format("Checking client %s with job %s and SteamID %s", client.Name, jobName, steamID))
    
            -- Check if the client is banned from the assigned job
            if bannedJobs[steamID] then
                for _, bannedJob in ipairs(bannedJobs[steamID]) do
                    if jobName == bannedJob then
                        flag = true
                        print(string.format("Client %s is banned from job %s", client.Name, jobName))
                        break
                    end
                end
            end
    
            -- If the client is banned from the job, find a substitute role
            if flag then
                local substituteRoles = {}
    
                -- Create a list of jobs that the client is not banned from
                for _, validJob in ipairs(validJobs) do
                    local isBanned = false
    
                    for _, bannedJob in ipairs(bannedJobs[steamID]) do
                        if validJob == bannedJob then
                            isBanned = true
                            break
                        end
                    end
    
                    if not isBanned then
                        table.insert(substituteRoles, validJob)
                    end
                end
    
                -- Choose a random job from the substitute roles
                if #substituteRoles > 0 then
                    local newJobName = substituteRoles[math.random(1, #substituteRoles)]
                    client.AssignedJob = Traitormod.GetJobVariant(newJobName)
                    Traitormod.SendMessage(client, "You have been banned from playing the role: " .. jobName .. ", Appeal in discord https://discord.gg/nv8Zz32PxK")
                    print(string.format("Client %s reassigned to new job %s due to job ban", client.Name, newJobName))
                else
                    print("No available substitute roles found for client " .. client.Name)
                end
            end
        end
    end, Hook.HookMethodType.After)

    --[[Hook.Patch("Barotrauma.Networking.GameServer", "AssignJobs", function (instance, ptable)
        -- Determine the client with the most votes for warden
        local maxVotes = 0
        local wardenClientName = nil
        for clientName, votes in pairs(WardenVoteResults) do
            if votes > maxVotes then
                maxVotes = votes
                wardenClientName = clientName
            end
        end
    
        if not wardenClientName then
            print("No warden selected by vote.")
            return
        end
    
        for index, client in pairs(ptable["unassigned"]) do
            local jobName = client.AssignedJob.Prefab.Identifier.ToString()
    
            -- Ensure only the voted client becomes the warden
            if jobName == "warden" then
                if client.Name ~= wardenClientName then
                    local validJobs = { "prisondoctor", "guard", "headguard", "staff", "janitor", "convict", "he-chef" }
                    local newJobName = validJobs[math.random(1, #validJobs)]
                    client.AssignedJob = Traitormod.GetJobVariant(newJobName)
                    Traitormod.SendMessage(client, "You have been reassigned from the warden role to: " .. newJobName)
                    print(string.format("Client %s reassigned to new job %s due to warden vote", client.Name, newJobName))
                else
                    print(string.format("Client %s assigned as warden based on vote", client.Name))
                end
            end
        end
    end, Hook.HookMethodType.After)]]    
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
