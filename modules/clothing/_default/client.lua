Clothing = Clothing or {}

ClothingBackup = {}

Clothing.SetAppearance = function(data)
    ClothingBackup = Clothing.GetAppearance()
    Utility.SetEntitySkinData(cache.ped, data)
    return true
end

Clothing.GetAppearance = function()
    return Utility.GetEntitySkinData(cache.ped)
end

Clothing.RestoreAppearance = function()
    Utility.SetEntitySkinData(cache.ped, ClothingBackup)
    return true
end

Clothing.ReloadSkin = function()
    Utility.SetEntitySkinData(cache.ped, ClothingBackup)
    return true
end



Clothing.UpdateAppearanceBackup = function(data)
    ClothingBackup = data
end

RegisterNetEvent('community_bridge:client:updateClothingBackup', function(skindata)
    ClothingBackup = skindata
end)

RegisterNetEvent('community_bridge:client:SetAppearance', function(data)
    Clothing.SetAppearance(data)
end)

RegisterNetEvent('community_bridge:client:GetAppearance', function()
    Clothing.GetAppearance()
end)

RegisterNetEvent('community_bridge:client:RestoreAppearance', function()
    Clothing.RestoreAppearance()
end)

RegisterNetEvent('community_bridge:client:ReloadSkin', function()
    Clothing.ReloadSkin()
end)