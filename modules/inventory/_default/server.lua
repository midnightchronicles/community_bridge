Inventory = Inventory or {}

---comment
---@param src number
---@param item string
---@param count number
---@param slot number
---@param metadata table
---@return boolean
Inventory.AddItem = function(src, item, count, slot, metadata)
    return Framework.AddItem(src, item, count, slot, metadata)
end

---comment
---@param src number
---@param item string
---@param count number
---@param slot number
---@param metadata table
---@return boolean
Inventory.RemoveItem = function(src, item, count, slot, metadata)
    item = type(item) == "table" and item.name or item
    return Framework.RemoveItem(src, item, count, slot, metadata)
end

---comment
---@param item string
---@return boolean
Inventory.GetItemInfo = function(item)
    return false, print("This Inventory Has Not Been Bridged For An Item Info Feature.")
end

---comment
---@param src number
---@param item string
---@param metadata table
---@return number
Inventory.GetItemCount = function(src, item, metadata)
    return Framework.GetItemCount(src, item, metadata)
end

---comment
---@param src number
---@return table
Inventory.GetPlayerInventory = function(src)
    return Framework.GetPlayerInventory(src)
end

---comment
---@param src number
---@param slot number
---@return table
Inventory.GetItemBySlot = function(src, slot)
    return Framework.GetItemBySlot(src, slot)
end

---comment
---@param src number
---@param item string
---@param slot number
---@param metadata table
---@return boolean
Inventory.SetMetadata = function(src, item, slot, metadata)
    return Framework.SetMetadata(src, item, slot, metadata)
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
---@return boolean
Inventory.OpenStash = function(src, id, label, slots, weight, owner, groups, coords)
    return false, print("This Inventory Has Not Been Bridged For A Stash Feature.")
end

---comment
---@param item string
---@return string
Inventory.GetImagePath = function(item)
    return "https://avatars.githubusercontent.com/u/47620135"
end