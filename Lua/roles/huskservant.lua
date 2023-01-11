local role = Traitormod.RoleManager.Roles.Antagonist:new()

role.Name = "HuskServant"
role.IsAntagonist = false

function role:Start()
    local text = self:Greet()
    local client = Traitormod.FindClientCharacter(self.Character)
    if client then
        Traitormod.SendTraitorMessageBox(client, text, "oneofus")
        Traitormod.UpdateVanillaTraitor(client, true, text, "oneofus")
    end
end

function role:Greet()
    local partners = Traitormod.StringBuilder:new()
    local traitors = Traitormod.RoleManager.FindCharactersByRole("Cultist")
    for _, character in pairs(traitors) do
        if character ~= self.Character then
            partners('"%s"\n', character.Name)
        end
    end
    partners = partners:concat(" ")

    local sb = Traitormod.StringBuilder:new()
    sb("You are now a Husk Servant!\nYou directly follow orders made by the Husk Cultists.\n")

    sb("Husk Cultists: %s\n", partners)

    if self.TraitorBroadcast then
        sb("\n\nYou cannot speak, but you can use !tc to communicate with the Husk Cultists.")
    end

    return sb:concat()
end

function role:OtherGreet()
    local sb = Traitormod.StringBuilder:new()
    sb("Husk Servant %s.", self.Character.Name)
    return sb:concat()
end

return role
