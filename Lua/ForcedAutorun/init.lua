if CLIENT then return end

Traitormod = {}
Traitormod.VERSION = "2.5"

print(">> Traitor Mod v" .. Traitormod.VERSION)
print(">> I thank Evil Factory and all the other contributors for making this fork possible.")
print(">> Made by RICKY#3939, however Evil Factory made most of the mod.")

local path = table.pack(...)[1]

Traitormod.Path = path

dofile(Traitormod.Path .. "/Lua/traitormod.lua")
