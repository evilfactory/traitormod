local role = Traitormod.RoleManager.Roles.Antagonist:new()

role.Name = "Pirate"
role.IsAntagonist = false

function role:Start()
    local text = self:Greet()
    local client = Traitormod.FindClientCharacter(self.Character)
    if client then
        Traitormod.SendTraitorMessageBox(client, text)
        Traitormod.UpdateVanillaTraitor(client, true, text)
    end
end

function role:Greet()
    local partners = Traitormod.StringBuilder:new()
    local traitors = Traitormod.RoleManager.FindCharactersByRole("Traitor")
    for _, character in pairs(traitors) do
        if character ~= self.Character then
            partners('"%s" ', character.Name)
        end
    end
    partners = partners:concat(" ")

    local sb = Traitormod.StringBuilder:new()
    sb("You are now a Separatist Agent!\nYou have separatist spies in the station (traitors) who you are allied with.\n")

    sb("Separatist Spies: %s\n", partners)

    if self.TraitorBroadcast then
        sb("\n\nUse !tc to communicate with the spies and other agents.")
    end

    return sb:concat()
end

function role:OtherGreet()
    local sb = Traitormod.StringBuilder:new()
    sb("Separatist Agent %s.", self.Character.Name)
    return sb:concat()
end

return role
