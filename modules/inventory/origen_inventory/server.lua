if GetResourceState('origen_inventory') ~= 'started' then return end

Inventory = Inventory or {}

local origen_inventory = exports.origen_inventory

Inventory.AddItem = function(src, item, count, slot, metadata)
    if not origen_inventory:CanCarryItem(src, item, count) then
        return Bridge.Notify.SendNotify(src, "Inventory Full", "error", 5000)
    end
    return origen_inventory:AddItem(src, item, count, nil, nil, metadata)
end

Inventory.RemoveItem = function(src, item, count, slot, metadata)
    return origen_inventory:RemoveItem(src, item, count, metadata)
end

Inventory.GetItemInfo = function(item)
    local itemData = origen_inventory:Items(item)
    local repackedTable = {
        name = itemData.name or "Missing Name",
        label = itemData.label or "Missing Label",
        stack = itemData.unique or "false",
        weight = itemData.weight or "0",
        description = itemData.description or "none",
        image = itemData.image or Inventory.GetImagePath(item),
    }
    return repackedTable or {}
end

Inventory.GetItemCount = function(src, item, metadata)
    if not metadata then
        return origen_inventory:GetItemTotalAmount(src, item)
    else
        local items = origen_inventory:GetInventory(src)
        local count = 0
        for _, itemInfo in pairs(items) do
            if itemInfo.name == item and itemInfo.info == metadata then
                count = count + itemInfo.amount
            end
        end
        return count
    end
end

Inventory.GetPlayerInventory = function(src)
    local playerItems = origen_inventory:GetInventory(src)
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
    return origen_inventory:CanCarryItems(src, item, count)
end

Inventory.RegisterStash = function(id, label, slots, weight, owner, groups, coords)
    return origen_inventory:RegisterStash(id, { label = label, slots = slots, weight = weight })
end

Inventory.OpenStash = function(src, id, label, slots, weight, owner, groups, coords)
    return origen_inventory:OpenInventory(src, 'stash', id)
end

Inventory.SetMetadata = function(src, item, slot, metadata)
    origen_inventory:SetItemMetadata(src, item, slot, metadata)
end

Inventory.GetImagePath = function(item)
    local file = LoadResourceFile("origen_inventory", string.format("html/images/%s.png", item))
    local imagePath = file and string.format("nui://origen_inventory/html/images/%s.png", item)
    return imagePath or "https://avatars.githubusercontent.com/u/47620135"
end