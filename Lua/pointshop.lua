local ps = {}

local config = Traitormod.Config
local textPromptUtils = require("textpromptutils")

local defaultLimit = 999

ps.GlobalProductLimits = {}
ps.LocalProductLimits = {}

ps.ResetProductLimits = function()
    ps.GlobalProductLimits = {}
    ps.LocalProductLimits = {}
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

ps.CanClientAccessCategory = function(client, category)
    -- FIXME: Is this correct?
    if category.IsTraitorOnly and not client.Character.IsTraitor then
        return false
    end

    return true
end

ps.ValidateClient = function(client)
    if not config.PointShopConfig.Enabled then
        Traitormod.SendMessage(client, "Pointshop is not enabled.")
        return false
    end

    if client.Character == nil or client.Character.IsDead or not client.InGame then
        Traitormod.SendMessage(client, "You must be in game to use the Pointshop.")
        return false
    end

    return true
end

ps.SpawnItem = function(client, identifier)
    local prefab = ItemPrefab.GetItemPrefab(identifier)

    Entity.Spawner.AddItemToSpawnQueue(prefab, client.Character.Inventory, nil, nil, function (item)
        
    end)
end

ps.BuyProduct = function(client, product)
    local points = Traitormod.GetData(client, "Points") or 0

    if product.Price > points then
        textPromptUtils.Prompt("You do not have enough points to buy this item.", {}, client, function (id, client) end)
        return
    end

    -- the person could have died between the time they accessed the pointshop and the time they bought the item.
    if not ps.ValidateClient(client) then
        return
    end

    if not ps.UseProductLimit(client, product) then
        textPromptUtils.Prompt("This product is out of stock.", {}, client, function (id, client) end)
        return
    end

    Traitormod.SetData(client, "Points", points - product.Price)

    textPromptUtils.Prompt(string.format("%s Points have been used to buy \"%s\"", product.Price, product.Name), {}, client, function (id, client) end)

    -- Activate the product

    if product.Items then
        for key, value in pairs(product.Items) do
            ps.SpawnItem(client, value)
        end
    end
end

ps.ShowCategoryItems = function(client, category)
    local options = {}
    local productsLookup = {}

    table.insert(options, ">> Go Back <<")
    table.insert(options, ">> Cancel <<")

    for key, product in pairs(category.Products) do
        local text = string.format("%s - $%s (%s/%s)",
            product.Name, product.Price, ps.GetProductLimit(client, product), product.Limit or defaultLimit)

        table.insert(options, text)
        productsLookup[#options] = product
    end

    textPromptUtils.Prompt("Choose what you want to buy.", options, client, function (id, client2)
        if id == 1 then
            ps.ShowCategory(client2)
        end
        
        if productsLookup[id] == nil then return end

        ps.BuyProduct(client2, productsLookup[id])
    end)
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

    -- note: we have two different client variables here to prevent cheating
    textPromptUtils.Prompt("Choose a category.", options, client, function (id, client2)
        if categoryLookup[id] == nil then return end

        ps.ShowCategoryItems(client2, categoryLookup[id])
    end)
end

Traitormod.AddCommand("!pointshop", function (client, args)
    if not ps.ValidateClient(client) then
        return true
    end

    ps.ShowCategory(client)

    return true
end)

Hook.Add("roundEnd", "TraitorMod.PointShop.RoundEnd", function ()
    ps.ResetProductLimits()
end)