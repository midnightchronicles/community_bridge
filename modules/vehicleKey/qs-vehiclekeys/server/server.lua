if GetResourceState('qs-vehiclekeys') ~= 'started' or (BridgeSharedConfig.VehicleKey ~= "qs-vehiclekeys" and BridgeSharedConfig.VehicleKey ~= "auto") then return end

VehicleKey = VehicleKey or {}

VehicleKey.GiveKeys = function(src, vehicle, plate)
    if not vehicle and not plate then return end
    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    TriggerClientEvent("community_bridge:vehicleKey:giveKeys", src, netId, plate)
end

VehicleKey.RemoveKeys = function(src, vehicle, plate)
    if not vehicle and not plate then return end
    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    TriggerClientEvent("community_bridge:vehicleKey:removeKeys", src, netId, plate)
end