if GetResourceState('core_inventory') ~= 'started' then return end

Inventory = Inventory or {}

local core = exports.core_inventory

Inventory = Inventory or {}

---comment
---@param item string
---@return string
Inventory.GetImagePath = function(item)
    local file = LoadResourceFile("core_inventory", string.format("html/img/%s.png", item))
    local imagePath = file and string.format("nui://core_inventory/html/img/%s.png", item)
    return imagePath or "https://avatars.githubusercontent.com/u/47620135"
end