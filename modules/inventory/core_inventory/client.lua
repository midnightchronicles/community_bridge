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

Inventory.GetItemInfo = function(item)
    local frameworkName = Framework.GetFrameworkName()
    if not frameworkName then return {} end
    local dataRepack = {}
    if frameworkName == 'es_extended' then
        local callbackData = lib.callback.await('community_bridge:Callback:core_inventory', false)
        -- really really wish this inventory allowed me to pull the item list client side....
        dataRepack = callbackData[item]
        if not dataRepack then return {} end
    elseif frameworkName == 'qb-core' then
        dataRepack = Framework.Shared.Items[item]
        if not dataRepack then return {} end
    end
    return {name = dataRepack.name, label = dataRepack.label, stack = dataRepack.stack, weight = dataRepack.weight, description = dataRepack.description, image = Inventory.GetImagePath(dataRepack.name) }
end