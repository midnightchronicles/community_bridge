if GetResourceState('core_inventory') ~= 'started' then return end

Inventory = Inventory or {}

local core = exports.core_inventory

Inventory = Inventory or {}

Inventory.HasItem = function(item)
    return core:hasItem(item, 1)
end

Inventory.GetImagePath = function(item)
    local file = LoadResourceFile("core_inventory", string.format("html/img/%s.png", item))
    local imagePath = file and string.format("nui://core_inventory/html/img/%s.png", item)
    return imagePath or "https://avatars.githubusercontent.com/u/47620135"
end

Inventory.GetPlayerInventory = function()
    local playerItems = core:getInventory()
    local repackedTable = {}
    for _, v in pairs(playerItems) do
        table.insert(repackedTable, {
            name = v.name,
            count = v.count,
            metadata = v.metadata,
            slot = v.slot,
        })
    end
    return repackedTable
end