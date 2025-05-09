---@diagnostic disable: duplicate-set-field
Inventory = Inventory or {}

---This will fallback to framework add item functions when an inventory does not have the specifiec function.
---@param item string
---@return table
Inventory.GetItemInfo = function(item)
    return Framework.GetItemInfo(item)
end

---This will fallback to framework add item functions when an inventory does not have the specifiec function.
---@param item string
---@return boolean
Inventory.HasItem = function(item)
    return Framework.HasItem(item)
end

---This will fallback to framework add item functions when an inventory does not have the specifiec function.
---@param item string
---@return number
Inventory.GetItemCount = function(item)
    return Framework.GetItemCount(item)
end

---This will provide a image of the community bridge logo if the inventory isnt bridged for the specific path.
---@param item string
---@return string
Inventory.GetImagePath = function(item)
    return "https://avatars.githubusercontent.com/u/47620135"
end

Inventory.StripPNG = function(item)
    if string.find(item, ".png") then
        item = string.gsub(item, ".png", "")
    end
    return item
end