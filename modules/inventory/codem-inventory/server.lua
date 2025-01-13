if GetResourceState('codem-inventory') ~= 'started' then return end

Inventory = Inventory or {}

Inventory.AddItem = function(src, item, count, slot, metadata)
    return exports['codem-inventory']:AddItem(src, item, count, slot, metadata)
end

Inventory.RemoveItem = function(src, item, count, slot, metadata)
    if metadata == nil then
        return exports['codem-inventory']:RemoveItem(src, item, count, slot)
    else
        local items = exports['codem-inventory']:GetInventory(nil, src)
        for _, itemInfo in pairs(items) do
            if itemInfo.name == item then
                if itemInfo.info == metadata then
                    return exports['codem-inventory']:RemoveItem(src, item, count, itemInfo.slot)
                end
            end
        end
    end
end

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

Inventory.GetItemCount = function(src, item, metadata)
    if metadata == nil then
        return exports['codem-inventory']:GetItemsTotalAmount(src, item)
    else
        local count = 0
        local items = exports['codem-inventory']:GetInventory(nil, src)
        for _, itemInfo in pairs(items) do
            if itemInfo.name == item and itemInfo.info == metadata then
                count = count + itemInfo.amount
            end
            return count
        end
    end
end

Inventory.GetInventoryItems = function(src)
    local items = exports['codem-inventory']:GetInventory(nil, src)
    local repackedTable = {}
    for _, v in pairs(items) do
        table.insert(repackedTable, {
            name = v.name,
            count = v.amount,
            metadata = v.info,
            slot = v.slot,
        })
    end
    return items
end

Inventory.SetMetadata = function(src, item, slot, metadata)
    exports['codem-inventory']:SetItemMetadata(src, slot, metadata)
end

Inventory.OpenStash = function(src, id, label, slots, weight, owner, groups, coords)
    TriggerEvent('codem-inventory:server:openstash', id, slots, weight, label)
end

Inventory.GetImagePath = function(item)
    local imagePath = string.format("nui://codem-inventory/html/images/%s.png", item)
    return imagePath or "https://avatars.githubusercontent.com/u/47620135"
end