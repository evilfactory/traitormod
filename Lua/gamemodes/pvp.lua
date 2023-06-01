local weightedRandom = dofile(Traitormod.Path .. "/Lua/weightedrandom.lua")
local gm = Traitormod.Gamemodes.Gamemode:new()

gm.Name = "PvP"

function gm:Start()
    if self.EnableRandomEvents then
        Traitormod.RoundEvents.Initialize()
    end

    if self.ShowSonar then
        for key, submarine in pairs(Submarine.MainSubs) do
            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.Prefabs["sonarbeacon"], submarine.WorldPosition, nil, nil, function(item)
                item.NonInteractable = true

                Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.Prefabs["batterycell"], item.OwnInventory, nil, nil, function(bat)
                    bat.Indestructible = true

                    local interface = item.GetComponentString("CustomInterface")

                    interface.customInterfaceElementList[1].State = true

                    if key == 1 then
                        interface.customInterfaceElementList[2].Signal = "Left Submarine"
                    else
                        interface.customInterfaceElementList[2].Signal = "Right Submarine"
                    end

                    item.CreateServerEvent(interface, interface)
                end)
            end) 
        end
    end

    self.CharacterToClient = {}

    for key, value in pairs(Client.ClientList) do
        local character = value.Character
        if value.Character then
            self.CharacterToClient[character] = value
        end
    end

    for key, value in pairs(Character.CharacterList) do
        if value.IsHuman then
            if self.IdCardAllAccess then
                local idCard = value.Inventory.GetItemInLimbSlot(InvSlotType.Card)

                if idCard then
                    idCard.AddTag("id_captain")
                end
            end

            if self.CrossTeamCommunication then
                local radio = value.Inventory.GetItemInLimbSlot(InvSlotType.Headset)
                if radio then
                    local wifi = radio.GetComponentString("WifiComponent")
                    wifi.AllowCrossTeamCommunication = true
                end
            end
        end
    end

    for key, value in pairs(Item.ItemList) do
        for _, bannedItem in pairs(self.BannedItems) do
            if value.Prefab.Identifier.Value == bannedItem then
                Entity.Spawner.AddEntityToRemoveQueue(value)
            end
        end
    end

    Hook.Add("item.created", "Traitormod.PvP.BannedItems", function (item)
        for _, bannedItem in pairs(self.BannedItems) do
            if item.Prefab.Identifier.Value == bannedItem then
                Entity.Spawner.AddEntityToRemoveQueue(item)
            end
        end
    end)
end

function gm:AwardPoints()
    for key, value in pairs(Character.CharacterList) do
        local client = self.CharacterToClient[value]
        if client == nil then
            for key, value2 in pairs(Client.ClientList) do
                if value2.Character == value then
                    client = value2
                end
            end
        end

        if client and client.Character and client.Character.TeamID == Game.GameSession.WinningTeam then
            local amount = self.WinningPoints
            if client.Character.IsDead then
                amount = self.WinningDeadPoints
            end

            local points = Traitormod.AwardPoints(client, amount)
            Traitormod.SendMessage(client, string.format(Traitormod.Language.ReceivedPoints, points), "InfoFrameTabButton.Mission")
        end
    end
end

function gm:End()
    if #Client.ClientList >= self.MinimumPlayersForPoints then
        self:AwardPoints()
    end

    Hook.Remove("item.created", "Traitormod.PvP.BannedItems")

    -- first arg = mission id, second = message, third = completed, forth = list of characters
    return nil
end

function gm:Think()

end

return gm
