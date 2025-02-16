if GetResourceState('tgiann-inventory') ~= 'started' then return end

local tgiann = exports["tgiann-inventory"]

Inventory = Inventory or {}

Inventory.AddItem = function(src, item, count, slot, metadata)
    if not tgiann:CanCarryItem(src, item, count) then return false end
    TriggerClientEvent("community_bridge:client:inventory:updateInventory", src, {action = "add", item = item, count = count, slot = slot, metadata = metadata})
    return tgiann:AddItem(src, item, count, slot, metadata, false)
end

Inventory.RemoveItem = function(src, item, count, slot, metadata)
    TriggerClientEvent("community_bridge:client:inventory:updateInventory", src, {action = "remove", item = item, count = count, slot = slot, metadata = metadata})
    return tgiann:RemoveItem(src, item, count, slot, metadata)
end

Inventory.GetItem = function(src, item, metadata)
    local item = tgiann:GetItemByName(src, item, metadata)
    item.count = item.amount
    item.metadata = item.info
    return item
end

Inventory.GetItemCount = function(src, item, metadata)
    local _item = tgiann:GetItemByName(src, item, metadata)
    return _item.amount or 0
end

Inventory.GetPlayerInventory = function(src)
    local inventory = tgiann:GetPlayerItems(src)
    local items = {}
    for _, v in pairs(inventory) do
        if tonumber(_) then
            table.insert(items, {name = v.name, label = v.name, weight = 0, description = v.description, slot = v.slot, count = v.amount, metadata = v.info})
        end
    end
    return items
end

Inventory.CanCarryItem = function(src, item, count)
    return tgiann:CanCarryItem(src, item, count)
end

Inventory.RegisterStash = function(id, label, slots, weight, owner)
    return tgiann:CreateCustomStashWithItem(id, {})
end

Inventory.GetItemBySlot = function(src, slot)
    local item = tgiann:GetItemBySlot(src, slot)
    if not item then return {} end
    return {name = item.name, label = item.label, weight = item.weight, slot = slot, count = item.amount, metadata = item.info, stack = item.unique or false, description = item.description}
end

Inventory.GetItemInfo = function(item)
    local itemData = tgiann:GetItemList()
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

Inventory.SetMetadata = function(src, item, slot, metadata)
    tgiann:UpdateItemMetadata(src, item, slot, metadata)
end

Inventory.GetImagePath = function(item)
    local pngPath = LoadResourceFile("inventory_images", string.format("html/images/%s.png", item))
    local webpPath = LoadResourceFile("inventory_images", string.format("html/images/%s.webp", item))
    local imagePath = pngPath and string.format("nui://inventory_images/html/images/%s.png", item) or webpPath and string.format("nui://inventory_images/html/images/%s.webp", item)
    return imagePath or "https://avatars.githubusercontent.com/u/47620135"
end

Inventory.UpdatePlate = function(oldplate, newplate)
    local queries = {
        'UPDATE tgiann_inventory_trunkitems SET plate = @newplate WHERE plate = @oldplate',
        'UPDATE tgiann_inventory_gloveboxitems SET plate = @newplate WHERE plate = @oldplate',
    }
    local values = { newplate = newplate, oldplate = oldplate }
    MySQL.transaction.await(queries, values)
    if GetResourceState('jg-mechanic') ~= 'started' then return true end
    exports["jg-mechanic"]:vehiclePlateUpdated(oldplate, newplate)
    return true
end