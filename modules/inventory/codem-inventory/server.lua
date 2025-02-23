if GetResourceState('codem-inventory') ~= 'started' then return end

local codem = exports['codem-inventory']

Inventory = Inventory or {}

Inventory.GetImagePath = function(item)
    local file = LoadResourceFile("codem-inventory", string.format("html/images/%s.png", item))
    local imagePath = file and string.format("nui://codem-inventory/html/images/%s.png", item)
    return imagePath or "https://avatars.githubusercontent.com/u/47620135"
end