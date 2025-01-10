if GetResourceState('codem-inventory') ~= 'started' then return end
Inventory = Inventory or {}

Inventory.GetItemInfo = function(item)
    local itemData = exports['codem-inventory']:GetItemList()
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

Inventory.GetImagePath = function(item)
    local imagePath = string.format("nui://codem-inventory/html/images/%s.png", item)
    return imagePath or "https://avatars.githubusercontent.com/u/47620135"
end
