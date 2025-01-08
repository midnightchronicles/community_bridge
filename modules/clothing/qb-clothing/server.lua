if GetResourceState('qb-clothing') ~= 'started' then return end

RegisterServerEvent('qb-clothing:saveSkin', function(model, skin)
    local src = source
    if model ~= nil and skin ~= nil then
        TriggerClientEvent('community_bridge:client:updateStoredClothing', src, skin)
    end
end)