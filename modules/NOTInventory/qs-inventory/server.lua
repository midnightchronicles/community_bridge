if GetResourceState('qs-inventory') ~= 'started' then return end

Inventory = Inventory or {}

Inventory.AddItem = function(src, item, count, slot, metadata)
    if not exports['qs-inventory']:CanCarryItem(src, item, count) then return false end
    return exports['qs-inventory']:AddItem(src, item, count, slot, metadata)
end

Inventory.RemoveItem = function(src, item, count, slot, metadata)
    return exports['qs-inventory']:RemoveItem(src, item, count, slot, metadata)
end

Inventory.GetItemCount = function(src, item, metadata)
    return exports['qs-inventory']:GetItemTotalAmount(src, item)
end

Inventory.GetPlayerInventory = function(src)
    local playerItems = exports['qs-inventory']:GetInventory(src)
    local repackedTable = {}
    for _, v in pairs(playerItems) do
        table.insert(repackedTable, {
            name = v.name,
            count = v.amount,
            metadata = v.info,
            slot = v.slot,
        })
    end
    return repackedTable
end

Inventory.CanCarryItem = function(src, item, count)
    return exports['qs-inventory']:CanCarryItem(src, item, count)
end

Inventory.RegisterStash = function(id, label, slots, weight, owner, groups, coords)
    return true
end

Inventory.OpenStash = function(src, id, label, slots, weight, owner, groups, coords)
    TriggerEvent("inventory:server:OpenInventory", "stash", id, { maxweight = weight, slots = slots })
    TriggerClientEvent("inventory:client:SetCurrentStash",src, id)
end

Inventory.GetItemInfo = function(item)
    local itemData = exports['qs-inventory']:GetItemList()
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
    return exports['qs-inventory']:SetItemMetadata(src, slot, metadata)
end

Inventory.GetImagePath = function(item)
    local file = LoadResourceFile("qs-inventory", string.format("html/images/%s.png", item))
    local imagePath = file and string.format("nui://qs-inventory/html/images/%s.png", item)
    return imagePath or "https://avatars.githubusercontent.com/u/47620135"
end