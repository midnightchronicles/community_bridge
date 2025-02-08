if GetResourceState('fivem-appearance') ~= 'started' then return end
Clothing = Clothing or {}

Clothing.SetAppearance = function(data)
    local clothing = {}
    if GetEntityModel(cache.ped) == `mp_m_freemode_01` then
        clothing = data.male
    else
        clothing = data.female
    end
    ClothingBackup = exports['fivem-appearance']:getPedAppearance(cache.ped)
    exports['fivem-appearance']:setPedAppearance(cache.ped, clothing)
    return true
end

Clothing.GetAppearance = function()
    return exports['fivem-appearance']:getPedAppearance(cache.ped)
end

Clothing.RestoreAppearance = function()
    if not next(ClothingBackup) then
        return false
    end
    exports['fivem-appearance']:setPedAppearance(cache.ped, ClothingBackup)
    return true
end

Clothing.ReloadSkin = function()
    TriggerEvent("fivem-appearance:client:reloadSkin", true)
    return true
end