Shops = Shops or {}

RegisterNetEvent('community_bridge:openShop', function(_type, _title, shopData)
    if source ~= 65535 then return end
    if not _title and not _title and not shopData then return end
    if _type ~= 'shop' then return end
    Shops.OpenShop(_title, shopData.inventory)
end)

Shops.FinalizeCheckOut = function(shopName, item, itemLabel, price)
    if not shopName and not item and not itemLabel and not price then return end
    local generatedID = Ids.CreateUniqueId()
    local buildMenu = {
        {
            title = locale('Shops.PayByCash')..tostring(price),
            description = locale('Shops.AreYouSure') .. itemLabel,
            icon = "fa-solid fa-money-bill-wave",
            onSelect = function(_, __, ___)
                TriggerServerEvent('community_bridge:completeCheckout', shopName, item, "cash")
            end
        },
        {
            title = locale('Shops.PayByCard')..tostring(price),
            description = locale('Shops.AreYouSure') .. itemLabel,
            icon = "fa-solid fa-building-column",
            onSelect = function(_, __, ___)
                TriggerServerEvent('community_bridge:completeCheckout', shopName, item, "bank")
            end
        }
    }
    Bridge.Menu.Open({ id = generatedID, title = locale("Shops.Confirm"), options = buildMenu }, false)
end

Shops.FinalizeCheckOut = function(shopName, item, itemLabel, price, amount)
    if not shopName and not item and not itemLabel and not price then return end
    local mathStuff = tonumber(price) * tonumber(amount)
    local generatedID = Ids.CreateUniqueId()
    local buildMenu = {
        {
            title = locale('Shops.PayByCash').." "..tostring(mathStuff),
            description = locale('Shops.AreYouSure') .. itemLabel,
            icon = "fa-solid fa-money-bill-wave",
            onSelect = function(_, __, ___)
                TriggerServerEvent('community_bridge:completeCheckout', shopName, item, amount, "money")
            end
        },
        {
            title = locale('Shops.PayByCard').." "..tostring(mathStuff),
            description = locale('Shops.AreYouSure') .. itemLabel,
            icon = "fa-solid fa-building-column",
            onSelect = function(_, __, ___)
                TriggerServerEvent('community_bridge:completeCheckout', shopName, item, amount, "bank")
            end
        }
    }
    Menu.Open({ id = generatedID, title = locale("Shops.Input"), options = buildMenu }, false)
end

Shops.AmountSelect = function(shopName, item, itemLabel, price)
    if not shopName and not item and not itemLabel and not price then return end
    local numberOptions = {}
    for i = 1, 100 do
        table.insert(numberOptions, {label = tostring(i), value = i})
    end
    local _input = Input.Open(shopName, {
        {type = 'select', label = locale("Shops.PurchaseAmount"), options = numberOptions},
    })

    if _input and _input[1] then
        Shops.FinalizeCheckOut(shopName, item, itemLabel, price, tostring(_input[1]))
    end
end

Shops.OpenShop = function(title, shopData)
    if not title and not shopData and not title then return print("No Title Passed") end
    local generatedID = Ids.CreateUniqueId()
    local buildMenu = {}
    for _, v in pairs(shopData) do
        local getItemName = Inventory.GetItemInfo(v.name).label
        table.insert(buildMenu, {
            title = getItemName,
            description = locale('Shops.CurrencySymbol')..tostring(v.price),
            icon = "fa-solid fa-basket-shopping",
            onSelect = function(selected, secondary, args)
                Shops.AmountSelect(title, v.name, getItemName, v.price)
                --Shops.FinalizeCheckOut(title, v.name, getItemName, v.price)
            end
        })
    end
    Menu.Open({ id = generatedID,  title = title, options = buildMenu }, false)
end