if GetResourceState('core_inventory') ~= 'started' then return end

Inventory = Inventory or {}

local core = exports.core_inventory

Inventory.GetPlayerInventory = function(src)
    local playerItems = core:getInventory(src)
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

Inventory.GetImagePath = function(item)
    local file = LoadResourceFile("core_inventory", string.format("html/img/%s.png", item))
    local imagePath = file and string.format("nui://core_inventory/html/img/%s.png", item)
    return imagePath or "https://avatars.githubusercontent.com/u/47620135"
end

Inventory.SetMetadata = function(src, item, slot, metadata)
    core:SetMetadata(src, slot, metadata)
end

Inventory.AddItem = function(src, item, count, slot, metadata)
    local success = core:addItem(src, item, count, metadata, 'content')
    if success then
        TriggerClientEvent('core_inventory:client:notification', src, item, 'add', count)
        TriggerClientEvent("community_bridge:client:inventory:updateInventory", src, {action = "add", item = item, count = count, slot = slot, metadata = metadata})
    end
    return success
end

Inventory.GetItemBySlot = function(src, slot)
    return core:getItemBySlot(src, slot)
end

Inventory.RemoveItem = function(src, item, count, slot, metadata)
    local success = false
    if slot then
        local itemData = Inventory.GetItemBySlot(src, slot)
        if itemData then success = core:removeItemExact(src, itemData.id, count) end
    else
        success = core:removeItem(src, item, count, metadata)
    end
    if not success then return false end
    TriggerClientEvent('core_inventory:client:notification', src, item, 'remove', count)
    TriggerClientEvent("community_bridge:client:inventory:updateInventory", src, {action = "remove", item = item, count = count, slot = slot, metadata = metadata})
    return success
end

Inventory.GetItemCount = function(src, item, metadata)
    return core:getItemCount(src, item)
end

Inventory.CanCarryItem = function(src, item, count)
    return core:canCarry(src, item, count)
end

Inventory.UpdatePlate = function(oldplate, newplate)
    -- have no clue if this will work but fingers crossed
    local queries = {
        'UPDATE coreinventories SET name = @newplate WHERE name = @oldplate',
        'UPDATE coreinventories SET name = @newplate WHERE name = @glovebox_oldplate',
        'UPDATE coreinventories SET name = @newplate WHERE name = @trunk_oldplate',
    }
    local values = {
        newplate = newplate,
        oldplate = oldplate,
        glovebox_oldplate = 'glovebox-' .. oldplate,
        trunk_oldplate = 'trunk-' .. oldplate
    }
    MySQL.transaction.await(queries, values)
    if GetResourceState('jg-mechanic') ~= 'started' then return true end
    exports["jg-mechanic"]:vehiclePlateUpdated(oldplate, newplate)
    return true
end