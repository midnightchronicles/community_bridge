if GetResourceState('qb-inventory') ~= 'started' then return end

local qb = exports['qb-inventory']

Inventory = Inventory or {}

RegisterNetEvent('community_bridge:client:qb-inventory:openStash', function(id, data)
    if source ~= 65535 then return end
    TriggerEvent("inventory:client:SetCurrentStash", id)
    TriggerServerEvent('inventory:server:OpenInventory', 'stash', id, { maxweight = data.weight, slots = data.slots })
end)

Inventory.HasItem = function(item)
    return qb:HasItem(item)
end

Inventory.GetImagePath = function(item)
    local file = LoadResourceFile("qb-inventory", string.format("html/images/%s.png", item))
    local imagePath = file and string.format("nui://qb-inventory/html/images/%s.png", item)
    return imagePath or "https://avatars.githubusercontent.com/u/47620135"
end
