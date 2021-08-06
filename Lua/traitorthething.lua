local traitormod = Traitormod

local config = dofile("Mods/traitormod/Lua/traitorconfig.lua")
local util = dofile("Mods/traitormod/Lua/util.lua")

if not config.overrideDefaultTraitors then
    return
end 

traitormod.assignTheThing = function (amount)
    local assignedNowTraitors = traitormod.chooseTraitors(amount)

    for index, value in pairs(assignedNowTraitors) do
        traitormod.roundtraitors[value] = {}
        traitormod.roundtraitors[value].name = "The Thing"
        traitormod.roundtraitors[value].objectiveType = "thething"

        local mess =
            "You feel like killing everyone for some reason...\n You are The Thing!"

        mess = mess .. "\n\n(You can type in local chat !traitor, to check this information again.)"

        Game.Log(value.name .. " Was assigned to be The Thing", 6)

        local cl = util.clientChar(value)
        traitormod.sendTraitorMessage(mess, cl)

        Game.ExecuteCommand('giveaffliction "Thing infection" 75 "'.. value.name ..'"')
    end
end

local helloIHateMyLife = {}

Hook.Add("think", "the_thing_think", function ()
    if traitormod.gamemodes["The Thing"] == nil then return end

    for key, value in pairs(traitormod.roundtraitors) do
        if key.IsDead == true and helloIHateMyLife[key] ~= true then
            Game.ExecuteCommand('setclientcharacter "'.. key.name ..'" "'.. key.name ..'"')
            helloIHateMyLife[key] = true
        end
    end
end)

Hook.Add("roundEnd", "the_thing_end", function ()
    helloIHateMyLife = {}
end)