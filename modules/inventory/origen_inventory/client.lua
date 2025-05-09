---@diagnostic disable: duplicate-set-field
if GetResourceState('origen_inventory') ~= 'started' then return end

Inventory = Inventory or {}

local origin = exports.origen_inventory

---comment
---@param item string
---@return table
Inventory.GetItemInfo = function(item)
    local itemData = origin:Items(item)
    if not itemData then return {} end
    return {
        name = itemData.name or "Missing Name",
        label = itemData.label or "Missing Label",
        stack = itemData.unique or "false",
        weight = itemData.weight or "0",
        description = itemData.description or "none",
        image = itemData.image or Inventory.GetImagePath(item),
    }
end

---comment
---@param item string
---@return boolean
Inventory.HasItem = function(item)
    return origin:HasItem(item)
end

---comment
---@param item string
---@return number
Inventory.GetItemCount = function(item)
    local searchItem = origin:Search('slots', item)
    local count = 0
    for _, v in pairs(searchItem) do
        count = count + v.count
    end
    return count
end

---comment
---@param item string
---@return string
Inventory.GetImagePath = function(item)
    item = Inventory.StripPNG(item)
    local file = LoadResourceFile("origen_inventory", string.format("html/images/%s.png", item))
    local imagePath = file and string.format("nui://origen_inventory/html/images/%s.png", item)
    return imagePath or "https://avatars.githubusercontent.com/u/47620135"
end

---comment
---@return table
Inventory.GetPlayerInventory = function()
    local items = {}
    local inventory = origin:GetInventory()
    for _, v in pairs(inventory) do
        table.insert(items, {
            name = v.name,
            label = v.label,
            count = v.count,
            slot = v.slot,
            metadata = v.metadata,
            stack = v.unique,
            close = v.useable,
            weight = v.weight
        })
    end
    return items
end
