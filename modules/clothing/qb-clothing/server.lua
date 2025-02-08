if GetResourceState('qb-clothing') ~= 'started' then return end

RegisterNetEvent('qb-clothing:saveSkin', function(model, skin)
    local src = source
    if model and skin then
        TriggerClientEvent('community_bridge:client:updateClothingBackup', src, skin)
    end
end)