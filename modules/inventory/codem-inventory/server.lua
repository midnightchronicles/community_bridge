if GetResourceState('codem-inventory') ~= 'started' then return end

Inventory = Inventory or {}

local codem = exports['codem-inventory']

Inventory.GetItemInfo = function(item)
    local itemData = codem:GetItemList(item)
    local repackedTable = {
        name = itemData.name or "Missing Name",
        label = itemData.label or "Missing Label",
        stack = itemData.unique or "false",
        weight = itemData.weight or "0",
        description = itemData.description or "none",
        image = itemData.image or Inventory.GetImagePath(item),
    }
    return repackedTable or {}
end

Inventory.AddItem = function(src, item, count, slot, metadata)
    TriggerClientEvent("community_bridge:client:inventory:updateInventory", src, {action = "add", item = item, count = count, slot = slot, metadata = metadata})
    return codem:AddItem(src, item, count, slot, metadata)
end

Inventory.GetItemBySlot = function(src, slot)
    return codem:GetItemBySlot(src, slot)
end

Inventory.GetPlayerInventory = function(src)
    local identifier = Framework.GetPlayerIdentifier(src)
    local playerItems = codem:GetInventory(identifier, src)
    local repackedTable = {}
    for _, v in pairs(playerItems) do
        table.insert(repackedTable, {
            name = v.name,
            count = v.amount,
            metadata = v.info,
            slot = v.slot,
        })
    end
    return repackedTable
end

Inventory.RemoveItem = function(src, item, count, slot, metadata)
    if not slot and metadata then
        local inv = Inventory.GetPlayerInventory(src)
        if not inv then return false end
        for _, v in pairs(inv) do
            if v.name == item and v.metadata == metadata then
                slot = v.slot
                break
            end
        end
    end
    TriggerClientEvent("community_bridge:client:inventory:updateInventory", src, {action = "remove", item = item, count = count, slot = slot, metadata = metadata})
    return codem:RemoveItem(src, item, count, slot)
end

Inventory.SetMetadata = function(src, item, slot, metadata)
    return codem:SetItemMetadata(src, slot, metadata)
end

---comment
---@param src number
---@param item string
---@return boolean
Inventory.HasItem = function(src, item)
    return codem:HasItem(src, item, 1)
end

Inventory.GetItemBySlot = function(src, slot)
    local slotData = codem:GetItemBySlot(src, slot)
    if not slotData then return {} end
    for _, v in pairs(slotData) do
        return {
            name = v.name,
            label = v.name,
            weight = v.weight,
            slot = v.slot,
            count = v.amount,
            metadata = v.info,
            stack = v.unique,
            description = v.description
        }
    end
end

Inventory.GetImagePath = function(item)
    local file = LoadResourceFile("codem-inventory", string.format("html/images/%s.png", item))
    local imagePath = file and string.format("nui://codem-inventory/html/images/%s.png", item)
    return imagePath or "https://avatars.githubusercontent.com/u/47620135"
end

