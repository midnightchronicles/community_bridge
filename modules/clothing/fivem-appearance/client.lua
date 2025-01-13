if GetResourceState('fivem-appearance') ~= 'started' then return end

Clothing = {}

StoredOldClothing = {}

Clothing.SetAppearance = function(clothingData)
    if GetEntityModel(cache.ped) == `mp_m_freemode_01` then
        clothingData = clothingData.male
    else
        clothingData = clothingData.female
    end
    StoredOldClothing = exports['fivem-appearance']:getPedAppearance(cache.ped)
    exports['fivem-appearance']:setPedAppearance(cache.ped, clothingData)
    return true
end

Clothing.GetAppearance = function()
    return exports['fivem-appearance']:getPedAppearance(cache.ped)
end

Clothing.RestoreAppearance = function()
    return exports['fivem-appearance']:setPedAppearance(cache.ped, StoredOldClothing)
end

Clothing.ReloadSkin = function()
    TriggerEvent("fivem-appearance:client:reloadSkin", true)
end