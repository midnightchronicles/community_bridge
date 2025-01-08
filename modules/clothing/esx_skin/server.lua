if GetResourceState('esx_skin') ~= 'started' then return end

RegisterNetEvent("esx_skin:save", function(skin)
    local src = source
    TriggerClientEvent('community_bridge:client:updateStoredClothing', src, skin)
end)