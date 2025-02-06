if GetResourceState('qb-clothing') ~= 'started' then return end

Clothing = Clothing or {}

StoredOldClothing = {}

RegisterNetEvent('community_bridge:client:updateStoredClothing', function(skindata)
    StoredOldClothing = skindata
end)

Clothing.SetAppearance = function(clothingData)
    if GetEntityModel(cache.ped) == `mp_m_freemode_01` then
        clothingData = clothingData.male
    else
        clothingData = clothingData.female
    end
    local repackedTable = {}
    StoredOldClothing = Clothing.GetAppearance
    local componentMap = {
        [1] = 'mask',
        [3] = 'arms',
        [4] = 'pants',
        [5] = 'bag',
        [6] = 'shoes',
        [7] = 'accessory',
        [8] = 't-shirt',
        [9] = 'vest',
        [10] = 'decals',
        [11] = 'torso2'
    }

    local propMap = {
        [0] = 'hat',
        [1] = 'glass',
        [2] = 'ear',
        [6] = 'watch',
        [7] = 'bracelet'
    }

    local specialMap = {
        eye_color_id = 'eye_color',
        moles_id = 'moles',
        ageing_id = 'ageing',
        hair_id = 'hair',
        face_id = 'face'
    }

    for _, data in pairs(clothingData) do
        if componentMap[data.component_id] then
            repackedTable[componentMap[data.component_id]] = {drawable = data.drawable, texture = data.texture}
        elseif propMap[data.prop_id] then
            repackedTable[propMap[data.prop_id]] = {drawable = data.drawable, texture = data.texture}
        elseif specialMap[data.eye_color_id] then
            repackedTable[specialMap[data.eye_color_id]] = {drawable = data.drawable, texture = data.texture}
        elseif specialMap[data.moles_id] then
            repackedTable[specialMap[data.moles_id]] = {drawable = data.drawable, texture = data.texture}
        elseif specialMap[data.ageing_id] then
            repackedTable[specialMap[data.ageing_id]] = {drawable = data.drawable, texture = data.texture}
        elseif specialMap[data.hair_id] then
            repackedTable[specialMap[data.hair_id]] = {drawable = data.drawable, texture = data.texture}
        elseif specialMap[data.face_id] then
            repackedTable[specialMap[data.face_id]] = {drawable = data.drawable, texture = data.texture}
        end
    end
    TriggerEvent('qb-clothing:client:loadOutfit', repackedTable)
    return true
end

Clothing.GetAppearance = function()
    StoredOldClothing = Utility.GetEntitySkinData(cache.ped)
    return Utility.GetEntitySkinData(cache.ped)
end

Clothing.RestoreAppearance = function()
    return Utility.SetEntitySkinData(cache.ped, StoredOldClothing)
end

Clothing.ReloadSkin = function()
    return exports['qb-clothing']:reloadSkin(GetEntityHealth(cache.ped))
end