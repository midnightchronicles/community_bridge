if GetResourceState('qs-inventory') ~= 'started' then return end

local quasar = exports['qs-inventory']

Inventory = Inventory or {}

Inventory.AddItem = function(src, item, count, slot, metadata)
    if not quasar:CanCarryItem(src, item, count) then return false end
    return quasar:AddItem(src, item, count, slot, metadata)
end

Inventory.RemoveItem = function(src, item, count, slot, metadata)
    return quasar:RemoveItem(src, item, count, slot, metadata)
end

Inventory.GetItemCount = function(src, item, metadata)
    return quasar:GetItemTotalAmount(src, item)
end

Inventory.GetInventoryItems = function(src)
    local playerItems = quasar:GetInventory(src)
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

Inventory.GetItemBySlot = function(src, slot)
    local playerItems = quasar:GetInventory(src)
    for _, item in pairs(playerItems) do
        if item.slot == slot then
            return {
                name = item.name,
                label = item.label,
                weight = item.weight,
                slot = slot,
                count = item.amount,
                metadata = item.info,
                stack = item.unique or false,
                description = item.description
            }
        end
    end
    return nil
end

Inventory.CanCarryItem = function(src, item, count)
    return quasar:CanCarryItem(src, item, count)
end

Inventory.RegisterStash = function(id, label, slots, weight, owner, groups, coords)
    return true
end

Inventory.OpenStash = function(src, id, label, slots, weight, owner, groups, coords)
    TriggerEvent("inventory:server:OpenInventory", "stash", id, { maxweight = weight, slots = slots })
    TriggerClientEvent("inventory:client:SetCurrentStash",src, id)
end

Inventory.GetItemInfo = function(item)
    local itemData = quasar:GetItemList()
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
    return quasar:SetItemMetadata(src, slot, metadata)
end

Inventory.GetImagePath = function(item)
    local file = LoadResourceFile("qs-inventory", string.format("html/images/%s.png", item))
    local imagePath = file and string.format("nui://qs-inventory/html/images/%s.png", item)
    return imagePath or "https://avatars.githubusercontent.com/u/47620135"
end