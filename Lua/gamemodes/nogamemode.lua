local nogamemode = {}

nogamemode.Name = "nogamemode"

nogamemode.Start = function ()
    
end

nogamemode.Think = function ()
    
end

nogamemode.End = function ()
    return Traitormod.Language.NoTraitors
end

nogamemode.GetRoundSummary = function ()
    return "No active gamemode."
end

return nogamemode