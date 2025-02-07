if GetResourceState('qb-clothing') ~= 'started' then return end

Clothing = Clothing or {}

Clothing.SetAppearance = function(data)
    local clothingData = {}
    local repackedTable = {}
    if GetEntityModel(cache.ped) == `mp_m_freemode_01` then
        clothingData = data.male
    else
        clothingData = data.female
    end
    ClothingBackup = Clothing.GetAppearance
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

    for _, v in pairs(clothingData) do
        if componentMap[v.component_id] then
            repackedTable[componentMap[v.component_id]] = {drawable = v.drawable, texture = v.texture}
        elseif propMap[v.prop_id] then
            repackedTable[propMap[v.prop_id]] = {drawable = v.drawable, texture = v.texture}
        elseif specialMap[v.eye_color_id] then
            repackedTable[specialMap[v.eye_color_id]] = {drawable = v.drawable, texture = v.texture}
        elseif specialMap[v.moles_id] then
            repackedTable[specialMap[v.moles_id]] = {drawable = v.drawable, texture = v.texture}
        elseif specialMap[v.ageing_id] then
            repackedTable[specialMap[v.ageing_id]] = {drawable = v.drawable, texture = v.texture}
        elseif specialMap[v.hair_id] then
            repackedTable[specialMap[v.hair_id]] = {drawable = v.drawable, texture = v.texture}
        elseif specialMap[v.face_id] then
            repackedTable[specialMap[v.face_id]] = {drawable = v.drawable, texture = v.texture}
        end
    end
    TriggerEvent('qb-clothing:client:loadOutfit', repackedTable)
    return true
end

Clothing.GetAppearance = function()
    ClothingBackup = Utility.GetEntitySkinData(cache.ped)
    return Utility.GetEntitySkinData(cache.ped)
end

Clothing.RestoreAppearance = function()
    return Utility.SetEntitySkinData(cache.ped, ClothingBackup)
end

Clothing.ReloadSkin = function()
    return exports['qb-clothing']:reloadSkin(GetEntityHealth(cache.ped))
end