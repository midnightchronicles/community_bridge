DefaultInventory = DefaultInventory or {}

DefaultInventory.AddItem = function(src, item, count, slot, metadata)
    return Framework.AddItem(src, item, count, slot, metadata)
end

DefaultInventory.RemoveItem = function(src, item, count, slot, metadata)
    return Framework.RemoveItem(src, item, count, slot, metadata)
end

DefaultInventory.GetItemInfo = function(item)
    return false, print("This Inventory Has Not Been Bridged For An Item Info Feature.")
end

DefaultInventory.GetItemCount = function(src, item, metadata)
    return Framework.GetItemCount(src, item, metadata)
end

DefaultInventory.GetInventoryItems = function(src)
    return Framework.GetPlayerInventory(src)
end

DefaultInventory.SetMetadata = function(src, item, slot, metadata)
    return Framework.SetMetadata(src, item, slot, metadata)
end

DefaultInventory.OpenStash = function(src, id, label, slots, weight, owner, groups, coords)
    return false, print("This Inventory Has Not Been Bridged For A Stash Feature.")
end

DefaultInventory.GetImagePath = function(item)
    return "https://avatars.githubusercontent.com/u/47620135"
end