local gm = {}

gm.Name = "Gamemode"

function gm:Start()
    
end

function gm:Think()

end

function gm:End()

end

function gm:RoundSummary()
    local text = ""

    text = text .. "Gamemode: " .. self.Name

    for character, role in pairs(Traitormod.RoleManager.RoundRoles) do
        text = text .. string.format("%s: %s\n", character.Name, role.Name)
    end

    return text
end

function gm:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    return o
end

return gm
