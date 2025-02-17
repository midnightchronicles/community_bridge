if GetResourceState('codem-inventory') ~= 'started' then return end
Inventory = Inventory or {}

local codem = exports['codem-inventory']

Inventory.GetItemInfo = function(item)
    local itemData = codem:GetItemList()
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

Inventory.HasItem = function(item)
    local itemList = codem:GetItemList()
    local itemCheck = itemList and itemList[item] ~= nil
    return itemCheck
end

Inventory.GetImagePath = function(item)
    local imagePath = string.format("nui://codem-inventory/html/images/%s.png", item)
    return imagePath or "https://avatars.githubusercontent.com/u/47620135"
end

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
