if GetResourceState('qb-clothing') ~= 'started' then return end

RegisterNetEvent('qb-clothing:saveSkin', function(model, skin)
    local src = source
    if model ~= nil and skin ~= nil then
        TriggerClientEvent('community_bridge:client:updateStoredClothing', src, skin)
    end
end)

Clothing = Clothing or {}

Clothing.SetAppearance = function(src, data)
    --wip
end

Clothing.GetAppearance = function(src)
    --wip
end

Clothing.RestoreAppearance = function(src)
    --wip
end

Clothing.ReloadSkin = function(src)
    --wip
end