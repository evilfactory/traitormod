local role = Traitormod.RoleManager.Roles.Antagonist:new()

role.Name = "Defender"

function role:Start()

end

function role:Greet()
    return "Defender"
end

function role:OtherGreet()

end

return role
