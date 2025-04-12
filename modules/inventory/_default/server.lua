Inventory = Inventory or {}

---This will fallback to framework add item functions when an inventory does not have the specifiec function.
---@param src number
---@param item string
---@param count number
---@param slot number
---@param metadata table
---@return boolean|nil
Inventory.AddItem = function(src, item, count, slot, metadata)
    return Framework.AddItem(src, item, count, slot, metadata)
end

---This will fallback to framework add item functions when an inventory does not have the specifiec function.
---@param src number
---@param item string
---@param count number
---@param slot number
---@param metadata table
---@return boolean|nil
Inventory.RemoveItem = function(src, item, count, slot, metadata)
    item = type(item) == "table" and item.name or item
    return Framework.RemoveItem(src, item, count, slot, metadata)
end

---This will fallback to framework add item functions when an inventory does not have the specifiec function.
---@param item string
---@return table
Inventory.GetItemInfo = function(item)
    return Framework.GetItemInfo(item)
end

---This will fallback to framework add item functions when an inventory does not have the specifiec function.
---@param src number
---@param item string
---@param metadata table
---@return number
Inventory.GetItemCount = function(src, item, metadata)
    return Framework.GetItemCount(src, item, metadata)
end

---This will fallback to framework add item functions when an inventory does not have the specifiec function.
---@param src number
---@return table
Inventory.GetPlayerInventory = function(src)
    return Framework.GetPlayerInventory(src)
end

---This will fallback to framework add item functions when an inventory does not have the specifiec function.
---@param src number
---@param slot number
---@return table
Inventory.GetItemBySlot = function(src, slot)
    return Framework.GetItemBySlot(src, slot)
end

---This will fallback to framework add item functions when an inventory does not have the specifiec function.
---@param src number
---@param item string
---@param slot number
---@param metadata table
---@return boolean
Inventory.SetMetadata = function(src, item, slot, metadata)
    return Framework.SetMetadata(src, item, slot, metadata)
end

---This will fallback to framework add item functions when an inventory does not have the specifiec function.
---@param src number
---@param id string||number
---@param label string
---@param slots number
---@param weight number
---@param owner string
---@param groups table
---@param coords table
---@return boolean
Inventory.OpenStash = function(src, id, label, slots, weight, owner, groups, coords)
    return false, Prints.Error("This Inventory Has Not Been Bridged For A Stash Feature.")
end

---This will provide a image of the community bridge logo if the inventory isnt bridged for the specific path.
---@param item string
---@return string
Inventory.GetImagePath = function(item)
    return "https://avatars.githubusercontent.com/u/47620135"
end