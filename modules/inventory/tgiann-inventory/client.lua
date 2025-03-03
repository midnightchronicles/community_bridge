if GetResourceState('tgiann-inventory') ~= 'started' then return end
local tgiann = exports["tgiann-inventory"]

Inventory = Inventory or {}

---@param id any
---@return nil
Inventory.OpenStash = function(id)
    -- open stash export... not sure what it is yet. 
end

---@param item string
---@return table
Inventory.GetItemInfo = function(item)
    local itemData = tgiann:GetItemList()
    if not itemData[item] then return {} end
    local repackedTable = {
        name = itemData.name or "Missing Name",
        label = itemData.label or "Missing Label",
        stack = itemData.unique or "false",
        weight = itemData.weight or "0",
        description = itemData.description or "none",
        image = itemData.image or Inventory.GetImagePath(item),
    }
    return repackedTable
end

---@param item string
---@return boolean
Inventory.HasItem = function(item)
    return tgiann:HasItem(item)
end

---@param item string
---@return string
Inventory.GetImagePath = function(item)
    local pngPath = LoadResourceFile("inventory_images", string.format("html/images/%s.png", item))
    local webpPath = LoadResourceFile("inventory_images", string.format("html/images/%s.webp", item))
    local imagePath = pngPath and string.format("nui://inventory_images/html/images/%s.png", item) or webpPath and string.format("nui://inventory_images/html/images/%s.webp", item)
    return imagePath or "https://avatars.githubusercontent.com/u/47620135"
end

---@return table
Inventory.GetPlayerInventory = function()
    local items = {}
    local inventory = tgiann:GetPlayerItems()
    for _, v in pairs(inventory) do
        table.insert(items, {
            name = v.name,
            label = v.label,
            count = v.amount,
            slot = v.slot,
            metadata = v.info,
            stack = v.unique,
            close = v.useable,
            weight = v.weight
        })
    end
    return items
end
