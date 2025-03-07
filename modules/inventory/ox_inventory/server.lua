if GetResourceState('ox_inventory') ~= 'started' then return end

local ox_inventory = exports.ox_inventory

Inventory = Inventory or {}

---comment
---@param src number
---@param item string
---@param count number
---@param slot number
---@param metadata table
---@return boolean
Inventory.AddItem = function(src, item, count, slot, metadata)
    TriggerClientEvent("community_bridge:client:inventory:updateInventory", src, {action = "add", item = item, count = count, slot = slot, metadata = metadata})
    return ox_inventory:AddItem(src, item, count, metadata)
end

---comment
---@param src number
---@param item string
---@param count number
---@param slot number
---@param metadata table
---@return boolean
Inventory.RemoveItem = function(src, item, count, slot, metadata)
    TriggerClientEvent("community_bridge:client:inventory:updateInventory", src, {action = "remove", item = item, count = count, slot = slot, metadata = metadata})
    return ox_inventory:RemoveItem(src, item, count, metadata, slot)
end

---comment
---@param src number
---@param item string
---@param metadata table
---@return table
Inventory.GetItem = function(src, item, metadata)
    return ox_inventory:GetItem(src, item, metadata, false)
end

---comment
---@param src number
---@param slot number
---@return table
Inventory.GetItemBySlot = function(src, slot)
    return ox_inventory:GetSlot(src, slot)
end

---comment
---@param src number
---@param item string
---@param metadata table
---@return number
Inventory.GetItemCount = function(src, item, metadata)
    return ox_inventory:GetItemCount(src, item, metadata, false)
end

---comment
---@param src number
---@param item string
---@return boolean
Inventory.HasItem = function(src, item)
    local count = ox_inventory:GetItemCount(src, item, nil, false)
    return count > 0
end

---comment
---@param src number
---@return table
Inventory.GetPlayerInventory = function(src)
    return ox_inventory:GetInventoryItems(src, false)
end

---comment
---@param src number
---@param item string
---@param count number
---@return boolean
Inventory.CanCarryItem = function(src, item, count)
    return ox_inventory:CanCarryItem(src, item, count)
end

---comment
---@param id number||string
---@param label string
---@param slots number
---@param weight number
---@param owner string
---@param groups table
---@param coords table
---@return boolean
Inventory.RegisterStash = function(id, label, slots, weight, owner, groups, coords)
    return ox_inventory:RegisterStash(id, label, slots, weight, owner)
end

---comment
---@param src number
---@param id number||string
---@param label string
---@param slots number
---@param weight number
---@param owner string
---@param groups table
---@param coords table
---@return nil
Inventory.OpenStash = function(src, id, label, slots, weight, owner, groups, coords)
    TriggerClientEvent('ox_inventory:openInventory', src, 'stash', 'stash_' .. id)
end

---comment
---@param item string
---@return table
Inventory.GetItemInfo = function(item)
    local itemData = ox_inventory:Items(item)
    if not itemData then return {} end
    local repackedTable = {
        name = itemData.name or "Missing Name",
        label = itemData.label or "Missing Label",
        stack = itemData.stack or "true",
        weight = itemData.weight or "0",
        description = itemData.description or "none",
        image = itemData.client.image or Inventory.GetImagePath(item),
    }
    return repackedTable
end

---comment
---@param src number
---@param item string
---@param slot number
---@param metadata table
---@return nil
Inventory.SetMetadata = function(src, item, slot, metadata)
    ox_inventory:SetMetadata(src, slot, metadata)
end

---comment
---@param oldplate string
---@param newplate string
---@return boolean
Inventory.UpdatePlate = function(oldplate, newplate)
    ox_inventory:UpdateVehicle(oldplate, newplate)
    if GetResourceState('jg-mechanic') ~= 'started' then return true end
    exports["jg-mechanic"]:vehiclePlateUpdated(oldplate, newplate)
    return true
end

---comment
---@param item string
---@return string
Inventory.GetImagePath = function(item)
    local file = LoadResourceFile("ox_inventory", string.format("web/images/%s.png", item))
    local imagePath = file and string.format("nui://ox_inventory/web/images/%s.png", item)
    return imagePath or "https://avatars.githubusercontent.com/u/47620135"
end

local registeredShops = {}

Inventory.OpenShop = function(src, shopTitle)
    TriggerClientEvent('ox_inventory:openInventory', src, 'shop', {type = shopTitle})
end

Inventory.CreateShop = function(shopTitle, shopInventory, shopCoords, shopGroups)
    if registeredShops[shopTitle] then return true end
    registeredShops[shopTitle] = true
    ox_inventory:RegisterShop(shopTitle, { name = shopTitle, inventory = shopInventory, groups = shopGroups, })
    --return Inventory.OpenShop(src, shopTitle)
    return true
end