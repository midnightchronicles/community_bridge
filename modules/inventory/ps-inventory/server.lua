---@diagnostic disable: duplicate-set-field
if GetResourceState('ps-inventory') ~= 'started' then return end

local sloth = exports['ps-inventory']

Inventory = Inventory or {}


---comment
---@param id string||number
---@param label string
---@param slots number
---@param weight number
---@param owner string
---@param groups table
---@param coords table
---@return boolean
Inventory.RegisterStash = function(id, label, slots, weight, owner, groups, coords)
    return true
end

---comment
---@param src number
---@param id string||number
---@param label string
---@param slots number
---@param weight number
---@param owner string
---@param groups table
---@param coords table
---@return nil
Inventory.OpenStash = function(src, id, label, slots, weight, owner, groups, coords)
    TriggerClientEvent('community_bridge:client:ps-inventory:openStash', src, id, { label = label, maxweight = weight, slots = slots, })
end

---comment
---@param item string
---@return string
Inventory.GetImagePath = function(item)
    item = Inventory.StripPNG(item)
    local file = LoadResourceFile("ps-inventory", string.format("html/images/%s.png", item))
    local imagePath = file and string.format("nui://ps-inventory/html/images/%s.png", item)
    return imagePath or "https://avatars.githubusercontent.com/u/47620135"
end

---comment
---@param src number
---@param item string
---@return boolean
Inventory.HasItem = function(src, item)
    return sloth:HasItem(src, item, 1)
end

---comment
---@param src number
---@param slot number
---@return table
Inventory.GetItemBySlot = function(src, slot)
    local slotData = sloth:GetItemBySlot(src, slot)
    if not slotData then return {} end
    return {
        name = slotData.name,
        label = slotData.name,
        weight = slotData.weight,
        slot = slot,
        count = slotData.amount,
        metadata = slotData.info,
        stack = slotData.unique,
        description = slotData.description
    }
end

---comment
---@param src number
---@param item string
---@param amount number
---@param slot number
---@param metadata table
---@return boolean
Inventory.AddItem = function(src, item, amount, slot, metadata)
    TriggerClientEvent('ps-inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add', amount)
    TriggerClientEvent("community_bridge:client:inventory:updateInventory", src, {action = "add", item = item, count = amount, slot = slot, metadata = metadata})
    return sloth:AddItem(src, item, amount, slot, metadata, 'community_bridge')
end

---comment
---@param src number
---@param item string
---@param amount number
---@param slot number
---@param metadata table
---@return boolean
Inventory.RemoveItem = function(src, item, amount, slot, metadata)
    TriggerClientEvent('ps-inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'remove', amount)
    TriggerClientEvent("community_bridge:client:inventory:updateInventory", src, {action = "remove", item = item, count = amount, slot = slot, metadata = metadata})
    return sloth:RemoveItem(src, item, amount, slot, 'community_bridge')
end

---comment
---@param oldplate string
---@param newplate string
---@return boolean
Inventory.UpdatePlate = function(oldplate, newplate)
    local queries = {
        'UPDATE gloveboxitems SET plate = @newplate WHERE plate = @oldplate',
        'UPDATE trunkitems SET plate = @newplate WHERE plate = @oldplate',
    }
    local values = { newplate = newplate, oldplate = oldplate }
    MySQL.transaction.await(queries, values)
    if GetResourceState('jg-mechanic') ~= 'started' then return true end
    exports["jg-mechanic"]:vehiclePlateUpdated(oldplate, newplate)
    return true
end

local registeredShops = {}

Inventory.OpenShop = function(src, shopTitle)
    return sloth:OpenShop(src, shopTitle)
end

Inventory.CreateShop = function(src, shopTitle, shopInventory, shopCoords, shopGroups)
    if not shopTitle or not shopInventory or not shopCoords then return end
    if registeredShops[shopTitle] then return true end

    local repackItems = {}
    local repackedShopItems = {name = shopTitle, label = shopTitle, coords = shopCoords, items = repackItems, slots = #shopInventory, }
    for k, v in pairs(shopInventory) do
        table.insert(repackItems, { name = v.name, price = v.price or 1000, amount = v.count or 1, slot = k })
    end

    sloth:CreateShop(repackedShopItems)
    registeredShops[shopTitle] = true
    --Inventory.OpenShop(src, shopTitle)
    return true
end