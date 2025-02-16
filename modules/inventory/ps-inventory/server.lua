if GetResourceState('ps-inventory') ~= 'started' then return end

local sloth = exports['ps-inventory']

Inventory = Inventory or {}

Inventory.RegisterStash = function(id, label, slots, weight, owner, groups, coords)
    return true
end

Inventory.OpenStash = function(src, id, label, slots, weight, owner, groups, coords)
    TriggerClientEvent('community_bridge:client:ps-inventory:openStash', src, id, { label = label, maxweight = weight, slots = slots, })
end

Inventory.GetImagePath = function(item)
    local file = LoadResourceFile("ps-inventory", string.format("html/images/%s.png", item))
    local imagePath = file and string.format("nui://ps-inventory/html/images/%s.png", item)
    return imagePath or "https://avatars.githubusercontent.com/u/47620135"
end

Inventory.GetItemBySlot = function(src, slot)
    local slotData = sloth:GetItemBySlot(src, slot)
    if not slotData then return {} end
    return {name = slotData.name, label = slotData.name, weight = slotData.weight, slot = slot, count = slotData.amount, metadata = slotData.info, stack = slotData.unique, description = slotData.description}
end

Inventory.AddItem = function(src, item, amount, slot, metadata)
    TriggerClientEvent('ps-inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add')
    TriggerClientEvent("community_bridge:client:inventory:updateInventory", src, {action = "add", item = item, count = amount, slot = slot, metadata = metadata})
    return exports['ps-inventory']:AddItem(src, item, amount, slot, metadata, 'community_bridge')
end

Inventory.RemoveItem = function(src, item, amount, slot, metadata)
    TriggerClientEvent('ps-inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'remove')
    TriggerClientEvent("community_bridge:client:inventory:updateInventory", src, {action = "remove", item = item, count = amount, slot = slot, metadata = metadata})
    return exports['ps-inventory']:RemoveItem(src, item, amount, slot, 'community_bridge')
end
