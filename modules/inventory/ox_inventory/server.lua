if GetResourceState('ox_inventory') ~= 'started' then return end

local ox_inventory = exports.ox_inventory

Inventory = Inventory or {}

Inventory.AddItem = function(src, item, count, slot, metadata)
    return ox_inventory:AddItem(src, item, count, metadata)
end

Inventory.RemoveItem = function(src, item, count, slot, metadata)
    return ox_inventory:RemoveItem(src, item, count, metadata, slot)
end

Inventory.GetItem = function(src, item, metadata)
    return ox_inventory:GetItem(src, item, metadata, false)
end

Inventory.GetItemBySlot = function(src, slot)
    return ox_inventory:GetSlot(src, slot)
end

Inventory.GetItemCount = function(src, item, metadata)
    return ox_inventory:GetItemCount(src, item, metadata, false)
end

Inventory.GetInventoryItems = function(src)
    return ox_inventory:GetInventoryItems(src, false)
end

Inventory.CanCarryItem = function(src, item, count)
    return ox_inventory:CanCarryItem(src, item, count)
end

Inventory.RegisterStash = function(id, label, slots, weight, owner, groups, coords)
    return ox_inventory:RegisterStash(id, label, slots, weight, owner)
end

Inventory.OpenStash = function(src, id, label, slots, weight, owner, groups, coords)
    TriggerClientEvent('ox_inventory:openInventory', src, 'stash', 'stash_' .. id)
end

Inventory.GetItemInfo = function(item)
    local itemData = ox_inventory:Items(item)
    if not itemData then return {} end
    local repackedTable = {
        name = itemData.name or "Missing Name",
        label = itemData.label or "Missing Label",
        stack = itemData.stack or "true",
        weight = itemData.weight or "0",
        description = itemData.description or "none",
        image = itemData.client.image or Inventory.GetImagePath(item),
    }
    return repackedTable
end

Inventory.SetMetadata = function(src, item, slot, metadata)
    ox_inventory:SetMetadata(src, slot, metadata)
end

Inventory.UpdatePlate = function(oldplate, newplate)
    ox_inventory:UpdateVehicle(oldplate, newplate)
    if GetResourceState('jg-mechanic') ~= 'started' then return end
    exports["jg-mechanic"]:vehiclePlateUpdated(oldplate, newplate)
end

Inventory.GetImagePath = function(item)
    local file = LoadResourceFile("ox_inventory", string.format("web/images/%s.png", item))
    local imagePath = file and string.format("nui://ox_inventory/web/images/%s.png", item)
    return imagePath or "https://avatars.githubusercontent.com/u/47620135"
end