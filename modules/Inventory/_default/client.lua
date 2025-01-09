DefaultInventory = DefaultInventory or {}

DefaultInventory.GetItemInfo = function(item)
    print('client funct')
    return Framework.GetItemInfo(item)
end

DefaultInventory.GetImagePath = function(item)
    return "https://avatars.githubusercontent.com/u/47620135"
end