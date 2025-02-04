if GetResourceState('qb-inventory') ~= 'started' then return end

local qbInventory = exports['qb-inventory']

Inventory = Inventory or {}

Inventory.RegisterStash = function(id, label, slots, weight, owner, groups, coords)
    return true
end

Inventory.OpenStash = function(src, id, label, slots, weight, owner, groups, coords)
    TriggerClientEvent('community_bridge:client:qb-inventory:openStash', src, id, { weight = weight, slots = slots })
end

Inventory.GetImagePath = function(item)
    local file = LoadResourceFile("qb-inventory", string.format("html/images/%s.png", item))
    local imagePath = file and string.format("nui://qb-inventory/html/images/%s.png", item)
    return imagePath or "https://avatars.githubusercontent.com/u/47620135"
end

function Inventory.GetItemBySlot(src, slot)
    local slotData = qbInventory:GetItemBySlot(src, slot)
    if not slotData then return {} end
    return {
        name = slotData.name,
        label = slotData.name,
        weight = slotData.weight,
        slot = slotData.slot,
        count = slotData.amount,
        metadata = slotData.info,
        stack = slotData.unique,
        description = slotData.description
    }
end