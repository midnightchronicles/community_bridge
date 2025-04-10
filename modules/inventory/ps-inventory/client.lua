if GetResourceState('ps-inventory') ~= 'started' then return end

local ps = exports['ps-inventory']

Inventory = Inventory or {}

RegisterNetEvent('community_bridge:client:ps-inventory:openStash', function(id, data)
    if source ~= 65535 then return end
    TriggerEvent('ps-inventory:client:SetCurrentStash', id)
    TriggerServerEvent('ps-inventory:server:OpenInventory', 'stash', id, { maxweight = data.weight, slots = data.slots })
end)


---comment
---@param item string
---@return boolean
Inventory.HasItem = function(item)
    return ps:HasItem(item)
end

---comment
---@param item string
---@return string
Inventory.GetImagePath = function(item)
    local file = LoadResourceFile("ps-inventory", string.format("html/images/%s.png", item))
    local imagePath = file and string.format("nui://ps-inventory/html/images/%s.png", item)
    return imagePath or "https://avatars.githubusercontent.com/u/47620135"
end

Inventory.GetItemInfo = function(item)
    local itemData = Framework.Shared.Items[item]
    if not itemData then return {} end
    local repackedTable = {
        name = itemData.name,
        label = itemData.label,
        stack = itemData.unique,
        weight = itemData.weight,
        description = itemData.description,
        image = Inventory.GetImagePath(itemData.name)
    }
    return repackedTable
end