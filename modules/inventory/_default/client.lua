Inventory = Inventory or {}

---comment
---@param item string
---@return table
Inventory.GetItemInfo = function(item)
    return Framework.GetItemInfo(item)
end

---comment
---@param item string
---@return boolean
Inventory.HasItem = function(item)
    return Framework.HasItem(item)
end

---comment
---@param item string
---@return string
Inventory.GetImagePath = function(item)
    return "https://avatars.githubusercontent.com/u/47620135"
end
