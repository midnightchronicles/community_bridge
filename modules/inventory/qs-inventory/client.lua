if GetResourceState('qs-inventory') ~= 'started' then return end
local quasar = exports["qs-inventory"]

Inventory = Inventory or {}

Inventory.OpenStash = function(id)
    quasar:RegisterStash(id, 50, 50000)
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

Inventory.GetImagePath = function(item)
    local file = LoadResourceFile("qs-inventory", string.format("html/images/%s.png", item))
    local imagePath = file and string.format("nui://qs-inventory/html/images/%s.png", item)
    return imagePath or "https://avatars.githubusercontent.com/u/47620135"
end