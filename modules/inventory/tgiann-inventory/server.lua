if GetResourceState('tgiann-inventory') ~= 'started' then return end
local tgiann = exports["tgiann-inventory"]

Inventory = Inventory or {}

Inventory.AddItem = function(src, item, count, slot, metadata)
    if not tgiann:CanCarryItem(src, item, count) then return false end
    local action = tgiann:AddItem(src, item, count, metadata)
    return (action.itemAddRemoveLog == 'added')
end

Inventory.RemoveItem = function(src, item, count, slot, metadata)
    return tgiann:RemoveItem(src, item, count, nil, metadata)
end

Inventory.GetItem = function(src, item, metadata)
    local item = tgiann:GetItemByName(src, item, metadata)
    item.count = item.amount
    item.metadata = item.info
    return item
end

Inventory.GetItemCount = function(src, item, metadata)
    local _item = tgiann:GetItemByName(src, item, metadata)
    return _item.amount or 0
end

Inventory.GetInventoryItems = function(src)
    return tgiann:GetPlayerItems(src)
end

Inventory.CanCarryItem = function(src, item, count)
    return tgiann:CanCarryItem(src, item, count)
end

Inventory.RegisterStash = function(id, label, slots, weight, owner)
    return tgiann:CreateCustomStashWithItem(id, {})
end

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

Inventory.SetMetadata = function(src, item, slot, metadata)
    tgiann:UpdateItemMetadata(src, item, slot, metadata)
end

Inventory.GetImagePath = function(item)
    local pngPath = LoadResourceFile("inventory_images", string.format("html/images/%s.png", item))
    local webpPath = LoadResourceFile("inventory_images", string.format("html/images/%s.webp", item))
    local imagePath = pngPath and string.format("nui://inventory_images/html/images/%s.png", item) or webpPath and string.format("nui://inventory_images/html/images/%s.webp", item)
    return imagePath or "https://avatars.githubusercontent.com/u/47620135"
end