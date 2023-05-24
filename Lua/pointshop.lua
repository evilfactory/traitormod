local ps = {}

local config = Traitormod.Config
local textPromptUtils = require("textpromptutils")

local defaultLimit = 999

ps.ProductBuyFailureReason = {
    NoPoints = 1,
    NoStock = 2,
}

ps.GlobalProductLimits = {}
ps.LocalProductLimits = {}
ps.Timeouts = {}

ps.ValidateConfig = function ()
    for i, category in pairs(config.PointShopConfig.ItemCategories) do
        for k, product in pairs(category.Products) do
            if product.Items then
                for z, item in pairs(product.Items) do
                    if type(item) == "string" then
                        item = {Identifier = item}
                    end

                    if type(item) ~= "table" then
                        Traitormod.Error(string.format("PointShop Error: Inside the Category \"%s\" theres a Product with Name \"%s\", that is invalid", category.Name, product.Name))
                    elseif item.Identifier == nil then
                        Traitormod.Error(string.format("PointShop Error: Inside the Category \"%s\" theres a Product with Name \"%s\", that has items without an Identifier", category.Name, product.Name))
                    elseif ItemPrefab.GetItemPrefab(item.Identifier) == nil then
                        Traitormod.Error(string.format("PointShop Error: Inside the Category \"%s\" theres a Product with Name \"%s\", that has an invalid item identifier \"%s\"", category.Name, product.Name, item.Identifier))
                    end
                end
            end
        end
    end
end

ps.ResetProductLimits = function()
    ps.GlobalProductLimits = {}
    ps.LocalProductLimits = {}
end

ps.GetProductHasInstallation = function(product)
    if product.Items ~= nil then
        for key, value in pairs(product.Items) do
            if type(value) == "table" and value.IsInstallation then
                return true
            end
        end
    end

    return false
end

ps.GetProductLimit = function (client, product)
    if product.IsLimitGlobal then
        if ps.GlobalProductLimits[product.Name] == nil then
            ps.GlobalProductLimits[product.Name] = product.Limit or defaultLimit
        end

        return ps.GlobalProductLimits[product.Name]
    else
        if ps.LocalProductLimits[client.SteamID] == nil then
            ps.LocalProductLimits[client.SteamID] = {}
        end

        local localProductLimit = ps.LocalProductLimits[client.SteamID]

        if localProductLimit[product.Name] == nil then
            localProductLimit[product.Name] = product.Limit or defaultLimit
        end

        return localProductLimit[product.Name]
    end
end

ps.UseProductLimit = function (client, product)
    if product.IsLimitGlobal then
        if ps.GlobalProductLimits[product.Name] == nil then
            ps.GlobalProductLimits[product.Name] = product.Limit or defaultLimit
        end

        if ps.GlobalProductLimits[product.Name] > 0 then
            ps.GlobalProductLimits[product.Name] = ps.GlobalProductLimits[product.Name] - 1
            return true
        else
            return false
        end
    else
        if ps.LocalProductLimits[client.SteamID] == nil then
            ps.LocalProductLimits[client.SteamID] = {}
        end

        local localProductLimit = ps.LocalProductLimits[client.SteamID]

        if localProductLimit[product.Name] == nil then
            localProductLimit[product.Name] = product.Limit or defaultLimit
        end

        if localProductLimit[product.Name] > 0 then
            localProductLimit[product.Name] = localProductLimit[product.Name] - 1
            return true
        else
            return false
        end
    end
end

ps.FindProductByName = function (client, name)
    for i, category in pairs(config.PointShopConfig.ItemCategories) do
        if ps.CanClientAccessCategory(client, category) then
            for k, product in pairs(category.Products) do
                if product.Name == name then
                    return product
                end
            end
        end
    end 
end

ps.CanClientAccessCategory = function(client, category)
    if category.CanAccess ~= nil then
        return category.CanAccess(client)
    elseif client.Character == nil or client.Character.IsDead or not client.Character.IsHuman then
        return false
    end

    return true
end

ps.ValidateClient = function(client)
    if not config.PointShopConfig.Enabled then
        Traitormod.SendMessage(client, Traitormod.Language.CommandNotActive)
        return false
    end

    if not client.InGame then
        Traitormod.SendMessage(client, "You must be in game to use the Pointshop.")
        return false
    end

    return true
end

ps.SpawnItem = function(client, item, onSpawned)
    local prefab = ItemPrefab.GetItemPrefab(item.Identifier)
    local condition = item.Condition or item.MaxCondition

    if prefab == nil then
        Traitormod.SendMessage(client, "PointShop Error: Could not find item with identifier " .. item.Identifier .. " please report this error.")
        Traitormod.Error("PointShop Error: Could not find item with identifier " .. item.Identifier)
        return
    end

    local function OnSpawn(item)
        local powerContainer = item.GetComponentString("PowerContainer")
        if powerContainer then
            powerContainer.Capacity = powerContainer.Capacity * 10
            powerContainer.Charge = powerContainer.Capacity
        end

        if onSpawned then onSpawned(item) end
    end

    if item.IsInstallation then
        local position = client.Character.AnimController.GetLimb(LimbType.Torso).WorldPosition
        if client.Character.Submarine == nil then
            Entity.Spawner.AddItemToSpawnQueue(prefab, position, condition, nil, OnSpawn)
        else
            Entity.Spawner.AddItemToSpawnQueue(prefab, position - client.Character.Submarine.Position, client.Character.Submarine, condition, nil, OnSpawn)
        end
    else
        Entity.Spawner.AddItemToSpawnQueue(prefab, client.Character.Inventory, condition, nil, OnSpawn)
    end
end

ps.ActivateProduct = function (client, product)
    local spawnedItems = {}
    local spawnedItemCount = 0

    local function OnSpawned(item)
        table.insert(spawnedItems, item)

        spawnedItemCount = spawnedItemCount + 1

        if spawnedItemCount == #product.Items and product.Action then
            product.Action(client, product, spawnedItems)
        end
    end

    if product.Items then
        if product.ItemRandom then
            local randomIndex = math.random(1, #product.Items)
            local item = product.Items[randomIndex]

            if type(product.Items[randomIndex]) == "string" then
                item = {Identifier = product.Items[randomIndex]}
            end

            ps.SpawnItem(client, item, OnSpawned)
        else
            for key, value in pairs(product.Items) do
                if type(value) == "string" then
                    value = {Identifier = value}
                end

                ps.SpawnItem(client, value, OnSpawned)
            end
        end
    end

    if (product.Items == nil or #product.Items == 0) and product.Action then
        product.Action(client, product)
    end
end

ps.GetProductPrice = function (client, product)
    return product.Price + (product.Limit - ps.GetProductLimit(client, product)) * (product.PricePerLimit or 0)
end

ps.BuyProduct = function(client, product)
    if not Traitormod.Config.TestMode then
        local points = Traitormod.GetData(client, "Points") or 0
        local price = ps.GetProductPrice(client, product)

        if product.CanBuy then
            local success, result = product.CanBuy(client, product)
            if not success then
                return result or "This product cannot be used at the moment."
            end
        end

        if price > points then
            return ps.ProductBuyFailureReason.NoPoints
        end

        if product.Timeout ~= nil then
            if ps.Timeouts[client.SteamID] ~= nil and Timer.GetTime() < ps.Timeouts[client.SteamID] then
                local time = math.ceil(ps.Timeouts[client.SteamID] - Timer.GetTime())
                return "You have to wait " .. time .. " seconds before you can use this product."
            end

            ps.Timeouts[client.SteamID] = Timer.GetTime() + product.Timeout
        end

        if not ps.UseProductLimit(client, product) then
            return ps.ProductBuyFailureReason.NoStock
        end

        Traitormod.Log(string.format("PointShop: %s bought \"%s\".", Traitormod.ClientLogName(client), product.Name))
        Traitormod.SetData(client, "Points", points - price)

        Traitormod.Stats.AddClientStat("CrewBoughtItem", client, 1)
        Traitormod.Stats.AddListStat("ItemsBought", product.Name, 1)
    end

    -- Activate the product
    ps.ActivateProduct(client, product)
end

ps.HandleProductBuy = function (client, product, result, quantity)
    quantity = quantity or 1 -- To handle "buy again" for multiple items
    if result == ps.ProductBuyFailureReason.NoPoints then
        textPromptUtils.Prompt("You do not have enough points to buy this item.", {}, client, function (id, client) end, "gambler")
    elseif result == ps.ProductBuyFailureReason.NoStock then
        textPromptUtils.Prompt("This product is out of stock.", {}, client, function (id, client) end, "gambler")
    elseif result == nil then
        -- Not let the player rebuy products that need installation or have timelimit
        if ps.GetProductHasInstallation(product) or product.Timeout ~= nil then
            textPromptUtils.Prompt(string.format("Purchased \"%s\" for %s points\n\nNew point balance is: %s points.", product.Name, ps.GetProductPrice(client, product), math.floor(Traitormod.GetData(client, "Points") or 0)), {}, client, function (id, client) end, "gambler")
            return
        end
        -- Buyagain menu
        local options = {}
        table.insert(options, ">> Cancel <<")
        for i = 1, 9, 1 do
            table.insert(options, " - " .. tostring(i))
        end
        -- Handles rebuying multiple times
        textPromptUtils.Prompt(string.format("Purchased %sx \"%s\" for %s points\n\nNew point balance is: %s points.\nIf you want to buy again enter the amount:", quantity, product.Name, ps.GetProductPrice(client, product)*quantity, math.floor(Traitormod.GetData(client, "Points") or 0)), options, client, function (id, client)
            -- id-1 is the quantity that player chose
            if id > 1 then
                _success_count = 0 -- If you select more than product has in stock it will handle it

                for i = 1, id-1, 1 do
                    _result = ps.BuyProduct(client, product)
                    -- It can exit the loop if the product isnt avaiable when rebuying
                    if _result ~= nil then
                        break
                    end
                    _success_count = _success_count + 1
                end
                if _success_count > 0 then
                    ps.HandleProductBuy(client, product, nil, _success_count)
                else
                    ps.HandleProductBuy(client, product, _result)
                end
                -- Couldn't have "local" for "result" and "_success_count" so instead made it nil so garbage collection can do its job
                _result = nil
                _success_count = nil
            end
        end, "gambler")
    -- It will handel other errors or other messages ( mostly errors )
    else
        textPromptUtils.Prompt(result, {}, client, function (id, client) end, "gambler")
    end
end

ps.ShowCategoryItems = function(client, category)
    local options = {}
    local productsLookup = {}

    table.insert(options, ">> Go Back <<")
    table.insert(options, ">> Cancel <<")

    for key, product in pairs(category.Products) do
        if product.Enabled ~= false then
            local text = string.format("%s - %spt (%s/%s)",
                product.Name, ps.GetProductPrice(client, product), ps.GetProductLimit(client, product), product.Limit or defaultLimit)

            table.insert(options, text)
            productsLookup[#options] = product
        end
    end

    local emptyLines = math.floor(#options / 4)
    for i = 1, emptyLines, 1 do
        table.insert(options, "") -- FIXME: some hud scaling settings will hide list items
    end

    local points = Traitormod.GetData(client, "Points") or 0

    textPromptUtils.Prompt(
        "Your current balance: " .. math.floor(points) .." points\nWhat do you wish to buy?", 
        options, client, function (id, client2)
        if id == 1 then
            ps.ShowCategory(client2)
        end

        local product = productsLookup[id]
        if product == nil then return end

        -- Check if product needs to be installed
        if ps.GetProductHasInstallation(product) then
            textPromptUtils.Prompt(
            "The product that you are about to buy will spawn an installation in your exact location, you won't be able to move it else where, do you wish to continue?\n",
            {"Yes", "No"}, client2, function (id, client3)
                if id == 1 then
                    if not ps.ValidateClient(client3) or not ps.CanClientAccessCategory(client2, category) then
                        return
                    end

                    local result = ps.BuyProduct(client3, product)
                    ps.HandleProductBuy(client3, product, result)
                end
            end, category.Decoration or "gambler", category.FadeToBlack)
        else
            if not ps.ValidateClient(client2) or not ps.CanClientAccessCategory(client2, category) then
                return
            end

            local result = ps.BuyProduct(client2, product)
            ps.HandleProductBuy(client2, product, result)
        end
    end, category.Decoration or "gambler", category.FadeToBlack)
end

ps.ShowCategory = function(client)
    local options = {}
    local categoryLookup = {}

    table.insert(options, ">> Cancel <<")

    for key, value in pairs(config.PointShopConfig.ItemCategories) do
        if ps.CanClientAccessCategory(client, value) then
            table.insert(options, value.Name)
            categoryLookup[#options] = value
        end
    end

    if #options == 1 then
        textPromptUtils.Prompt("Point Shop not available.", {}, client, function (id, client) end, "gambler")
        return
    end

    table.insert(options, "") -- FIXME: for some reason when the bar is full, the last item is never shown?

    local points = Traitormod.GetData(client, "Points") or 0

    -- note: we have two different client variables here to prevent cheating
    textPromptUtils.Prompt("Your current balance: " .. math.floor(points) .." points\nChoose a category.", options, client, function (id, client2)
        if categoryLookup[id] == nil then return end

        ps.ShowCategoryItems(client2, categoryLookup[id])
    end, "officeinside")
end

Traitormod.AddCommand({"!pointshop", "!pointsshop", "!ps"}, function (client, args)
    if not ps.ValidateClient(client) then
        return true
    end

    if #args > 0 then
        local product = ps.FindProductByName(client, args[1])

        if product ~= nil then
            local amount = 1

            if args[2] ~= nil then
                amount = tonumber(args[2]) or amount
            end

            amount = math.min(amount, 8)

            for i=1, amount, 1 do
                local result = ps.BuyProduct(client, product)

                if result == ps.ProductBuyFailureReason.NoPoints then
                    Traitormod.SendMessage(client, "You do not have enough points to buy this item.")
                end

                if result == ps.ProductBuyFailureReason.NoStock then
                    Traitormod.SendMessage(client, "This product is out of stock.")
                end
            end

            return true
        end
    end

    ps.ShowCategory(client)

    return true
end)

Hook.Add("roundEnd", "TraitorMod.PointShop.RoundEnd", function ()
    ps.ResetProductLimits()
end)

Hook.Add("characterDeath", "Traitormod.Pointshop.Death", function (character)
    if character.IsPet then return end
    local client = Traitormod.FindClientCharacter(character)
    if client == nil then return end

    ps.Timeouts[client.SteamID] = Timer.GetTime() + config.PointShopConfig.DeathTimeoutTime
end)

ps.ValidateConfig()

for i, category in pairs(config.PointShopConfig.ItemCategories) do
    if category.Init then category.Init() end
end

return ps