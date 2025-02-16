if GetResourceState('illenium-appearance') ~= 'started' then return end
Clothing = Clothing or {}

Clothing.SetAppearance = function(clothingData)
    local clothing = {}
    if GetEntityModel(cache.ped) == `mp_m_freemode_01` then
        clothingData = clothingData.male
    else
        clothingData = clothingData.female
    end
    clothing.components = exports['illenium-appearance']:getPedComponents(cache.ped)
    clothing.props = exports['illenium-appearance']:getPedProps(cache.ped)

    Prints.Debug(json.encode(clothingData, {indent = true}))
    ClothingBackup = clothing
    exports['illenium-appearance']:setPedComponents(cache.ped, clothingData.components)
    exports['illenium-appearance']:setPedProp(cache.ped, clothingData.props)
    return true
end

Clothing.GetAppearance = function()
    local clothing = {}
    if GetEntityModel(cache.ped) == `mp_m_freemode_01` then
        clothing = clothing.male
    else
        clothing = clothing.female
    end
    clothing.components = exports['illenium-appearance']:getPedComponents(cache.ped)
    clothing.props = exports['illenium-appearance']:getPedProps(cache.ped)

    return clothing
end

Clothing.RestoreAppearance = function()
    exports['illenium-appearance']:setPedComponents(cache.ped, ClothingBackup.components)
    exports['illenium-appearance']:setPedProp(cache.ped, ClothingBackup.props)
    return true
end

Clothing.ReloadSkin = function()
    TriggerEvent("illenium-appearance:client:reloadSkin", true)
end
