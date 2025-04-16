if GetResourceState('codem-inventory') ~= 'started' then return end
Inventory = Inventory or {}

local codem = exports['codem-inventory']

---comment
---@param item string
---@return table
Inventory.GetItemInfo = function(item)
    local itemData = codem:GetItemList(item)
    local image = itemData.image and Inventory.GetImagePath(itemData.image) or Inventory.GetImagePath(item)
    local repackedTable = {
        name = itemData.name or "Missing Name",
        label = itemData.label or "Missing Label",
        stack = itemData.unique or "false",
        weight = itemData.weight or "0",
        description = itemData.description or "none",
        image = image,
    }
    return repackedTable or {}
end

---comment
---@return table
Inventory.GetPlayerInventory = function()
    local items = {}
    local inventory = codem:getUserInventory()
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

---comment
---@param item string
---@return string
Inventory.GetImagePath = function(item)
    item = Inventory.StripPNG(item)
    local file = LoadResourceFile("codem-inventory", string.format("html/images/%s.png", item))
    local imagePath = file and string.format("nui://codem-inventory/html/images/%s.png", item)
    return imagePath or "https://avatars.githubusercontent.com/u/47620135"
end