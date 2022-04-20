if CLIENT then return end

Traitormod = {}

local path = table.pack(...)[1]

Traitormod.Path = path

dofile(Traitormod.Path .. "/Lua/traitormod.lua")