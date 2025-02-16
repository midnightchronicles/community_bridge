if GetResourceState('ox_inventory') ~= 'started' then return end
local ox_inventory = exports.ox_inventory

Inventory = Inventory or {}

Inventory.GetItemInfo = function(item)
    local itemData = ox_inventory:Items(item)
    if not itemData then return {} end
    local repackedTable = {
        name = itemData.name or "Missing Name",
        label = itemData.label or "Missing Label",
        stack = itemData.stack or "true",
        weight = itemData.weight or "0",
        description = itemData.description or "none",
        image = (itemData.client and itemData.client.image) or Inventory.GetImagePath(item),
    }
    return repackedTable
end

Inventory.GetImagePath = function(item)
    local file = LoadResourceFile("ox_inventory", string.format("web/images/%s.png", item))
    local imagePath = file and string.format("nui://ox_inventory/web/images/%s.png", item)
    return imagePath or "https://avatars.githubusercontent.com/u/47620135"
end

Inventory.GetPlayerInventory = function()
    return exports.ox_inventory:GetPlayerItems()
end

--Bridge.RegisterModule("Inventory", Inventory)