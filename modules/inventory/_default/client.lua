Inventory = Inventory or {}

Inventory.GetItemInfo = function(item)
    print('client funct')
    return Framework.GetItemInfo(item)
end

Inventory.HasItem = function(item)
    return Framework.HasItem(item)
end

Inventory.GetImagePath = function(item)
    return "https://avatars.githubusercontent.com/u/47620135"
end
