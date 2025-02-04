Inventory = Inventory or {}

Inventory.AddItem = function(src, item, count, slot, metadata)
    return Framework.AddItem(src, item, count, slot, metadata)
end

Inventory.RemoveItem = function(src, item, count, slot, metadata)
    item = type(item) == "table" and item.name or item
    return Framework.RemoveItem(src, item, count, slot, metadata)
end

Inventory.GetItemInfo = function(item)
    return false, print("This Inventory Has Not Been Bridged For An Item Info Feature.")
end

Inventory.GetItemCount = function(src, item, metadata)
    return Framework.GetItemCount(src, item, metadata)
end

Inventory.GetPlayerInventory = function(src)
    return Framework.GetPlayerInventory(src)
end

Inventory.GetItemBySlot = function(src, slot)
    return Framework.GetItemBySlot(src, slot)
end

Inventory.SetMetadata = function(src, item, slot, metadata)
    return Framework.SetMetadata(src, item, slot, metadata)
end

Inventory.OpenStash = function(src, id, label, slots, weight, owner, groups, coords)
    return false, print("This Inventory Has Not Been Bridged For A Stash Feature.")
end

Inventory.GetImagePath = function(item)
    return "https://avatars.githubusercontent.com/u/47620135"
end