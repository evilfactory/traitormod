if CLIENT then return end

Traitormod = {}
Traitormod.VERSION = "2.1.1-SNAPSHOT"

print(">> Traitor Mod v" .. Traitormod.VERSION .. " by Evil Factory")
print(">> Special thanks to Qunk, Femboy69 and JoneK for helping in the development of this mod.")

local path = table.pack(...)[1]

Traitormod.Path = path

dofile(Traitormod.Path .. "/Lua/traitormod.lua")