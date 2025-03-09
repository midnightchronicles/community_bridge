Shops = Shops or {}

local registeredShops = {}

Shops.OpenShop = function(src, shopTitle)
    if not shopTitle and not registeredShops[shopTitle] then return false end
    TriggerClientEvent('community_bridge:openShop', src, 'shop', shopTitle, registeredShops[shopTitle])
end

Shops.CreateShop = function(shopTitle, shopInventory, shopCoords, shopGroups)
    if not shopTitle and not shopInventory and not shopCoords then return end
    if registeredShops[shopTitle] then return true end
    registeredShops[shopTitle] = {name = shopTitle, inventory = shopInventory, shopCoords = shopCoords, groups = shopGroups}
    return true
end

Shops.CompleteCheckout = function(src, shopName, item, amount, paymentType)

    if not src and not shopName and not item and not amount and not paymentType then return end
    local ilocale = Language.Locale
    local shopData = registeredShops[shopName]
    if not shopData then return end
    local itemData = nil
    for _, data in pairs(shopData.inventory) do
        if data.name == item then
            itemData = data
            break
        end
    end
    if not itemData then return print("Player ID "..src.." Is Possibly A Cheater And Has Attempted To Purchase A "..item) end
    if not itemData.price then return end
    local balance = Framework.GetAccountBalance(src, paymentType)
    local mathStuff = tonumber(itemData.price) * tonumber(amount)
    if balance < mathStuff then return Notify.SendNotify(src, ilocale('Shops.NotEnoughMoney'), "error", 5000) end
    if not Framework.RemoveAccountBalance(src, paymentType, mathStuff) then return end
    Inventory.AddItem(src, itemData.name, amount)
    local itemLabel = Inventory.GetItemInfo(itemData.name).label
    Notify.SendNotify(src, ilocale('Shops.PurchasedItem')..itemLabel, "success", 5000)
end

RegisterNetEvent("community_bridge:completeCheckout", function(shopName, item, amount, paymentType)
    local src = source
    if not shopName and not item and not paymentType then return end
    if not paymentType == "money" or not paymentType == "bank" then return end
    Shops.CompleteCheckout(src, shopName, item, amount, paymentType)
end)