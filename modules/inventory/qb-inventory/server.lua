if GetResourceState('qb-inventory') ~= 'started' then return end

local qbInventory = exports['qb-inventory']

Inventory = Inventory or {}

local function getInventoryNewVersion()
    if tonumber(string.sub(GetResourceMetadata("qb-inventory", "version", 0), 1, 1)) >= 2 then
        return true
    else
        return false
    end
end

Inventory.RegisterStash = function(id, label, slots, weight, owner, groups, coords)
    return true
end

Inventory.OpenStash = function(src, id, label, slots, weight, owner, groups, coords)
    TriggerClientEvent('community_bridge:client:qb-inventory:openStash', src, id, { weight = weight, slots = slots })
end

Inventory.GetImagePath = function(item)
    local file = LoadResourceFile("qb-inventory", string.format("html/images/%s.png", item))
    local imagePath = file and string.format("nui://qb-inventory/html/images/%s.png", item)
    return imagePath or "https://avatars.githubusercontent.com/u/47620135"
end

Inventory.GetItemBySlot = function(src, slot)
    local slotData = qbInventory:GetItemBySlot(src, slot)
    if not slotData then return {} end
    return {
        name = slotData.name,
        label = slotData.name,
        weight = slotData.weight,
        slot = slotData.slot,
        count = slotData.amount,
        metadata = slotData.info,
        stack = slotData.unique,
        description = slotData.description
    }
end

Inventory.UpdatePlate = function(oldplate, newplate)
    local newVersion = getInventoryNewVersion()
    if newVersion then
        local gloveboxInv = exports['qb-inventory']:GetInventory('glovebox-'..oldplate) or {slots = 5, maxweight = 10000, items = {}}
        local storedGloveBox = Bridge.Tables.DeepClone(gloveboxInv, nil, nil)
        local trunkInv = exports['qb-inventory']:GetInventory('trunk-'..oldplate) or {slots = 5, maxweight = 10000, items = {}}
        local storedTrunk = Bridge.Tables.DeepClone(trunkInv, nil, nil)
        exports['qb-inventory']:ClearStash('glovebox-'..oldplate)
        exports['qb-inventory']:ClearStash('trunk-'..oldplate)
        exports['qb-inventory']:CreateInventory('glovebox-'..newplate, {label = 'glovebox-'..newplate, slots = storedGloveBox.slots, maxweight = storedGloveBox.maxweight})
        exports['qb-inventory']:SetInventory('glovebox-'..newplate, storedGloveBox.items, "Community Bridge Moving Items In GloveBox")
        exports['qb-inventory']:CreateInventory('trunk-'..newplate, {label = 'trunk-'..newplate, slots = storedTrunk.slots, maxweight = storedTrunk.maxweight})
        exports['qb-inventory']:SetInventory('trunk-'..newplate, storedTrunk.items, "Community Bridge Moving Items In Trunk")
        return true
    else
        local queries = {
            'UPDATE inventory_glovebox SET plate = @newplate WHERE plate = @oldplate',
            'UPDATE inventory_trunk SET plate = @newplate WHERE plate = @oldplate',
        }
        local values = { newplate = newplate, oldplate = oldplate }
        MySQL.transaction.await(queries, values)
    end
    if GetResourceState('jg-mechanic') ~= 'started' then return true end
    exports["jg-mechanic"]:vehiclePlateUpdated(oldplate, newplate)
    return true
end

Inventory.AddItem = function(src, item, amount, slot, metadata)
    TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add')
    TriggerClientEvent("community_bridge:client:inventory:updateInventory", src, {action = "add", item = item, count = amount, slot = slot, metadata = metadata})
    return exports['qb-inventory']:AddItem(src, item, amount, slot, metadata, 'community_bridge')
end

Inventory.RemoveItem = function(src, item, amount, slot, metadata)
    TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'remove')
    TriggerClientEvent("community_bridge:client:inventory:updateInventory", src, {action = "remove", item = item, count = amount, slot = slot, metadata = metadata})
    return exports['qb-inventory']:RemoveItem(src, item, amount, slot, 'community_bridge')
end
