local role = Traitormod.RoleManager.Roles.Antagonist:new()

role.Name = "Attacker"

function role:Start()

end

function role:Greet()
    return "Attacker"
end

function role:OtherGreet()

end

return role
