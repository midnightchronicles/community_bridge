if GetResourceState('jpr-inventory') ~= 'started' then return end

local jpr = exports['jpr-inventory']

Inventory = Inventory or {}

Inventory.RegisterStash = function(id, label, slots, weight, owner, groups, coords)
    return true
end

Inventory.OpenStash = function(src, id, label, slots, weight, owner, groups, coords)
    TriggerClientEvent('community_bridge:client:qb-inventory:openStash', src, id, { weight = weight, slots = slots })
end

Inventory.GetImagePath = function(item)
    local file = LoadResourceFile("jpr-inventory", string.format("html/images/%s.png", item))
    local imagePath = file and string.format("nui://jpr-inventory/html/images/%s.png", item)
    return imagePath or "https://avatars.githubusercontent.com/u/47620135"
end

Inventory.GetItemBySlot = function(src, slot)
    local slotData = jpr:GetItemBySlot(src, slot)
    if not slotData then return {} end
    return { name = slotData.name, label = slotData.label, weight = slotData.weight, slot = slot, count = slotData.amount, metadata = slotData.info, stack = slotData.unique, description = slotData.description }
end