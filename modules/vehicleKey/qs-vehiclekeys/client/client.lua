if GetResourceState('qs-vehiclekeys') ~= 'started' or (BridgeClientConfig.VehicleKey ~= "qs-vehiclekeys" and BridgeClientConfig.VehicleKey ~= "auto") then return end

VehicleKey = VehicleKey or {}

VehicleKey.GiveKeys = function(vehicle, plate)
    if not vehicle then return end
    local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
    local verifiedPlate = GetVehicleNumberPlateText(vehicle)
    return exports['qs-vehiclekeys']:GiveKeys(verifiedPlate, model, true)
end

VehicleKey.RemoveKeys = function(vehicle, plate)
    if not vehicle then return end
    local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
    local verifiedPlate = GetVehicleNumberPlateText(vehicle)
    return exports['qs-vehiclekeys']:RemoveKeys(verifiedPlate, model)
end

RegisterNetEvent("community_bridge:vehicleKey:removeKeys", function(netId, plate)
    if not NetworkDoesNetworkIdExist(netId) then return end
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    VehicleKey.RemoveKeys(vehicle, plate)
end)

RegisterNetEvent("community_bridge:vehicleKey:giveKeys", function(netId, plate)
    if not NetworkDoesNetworkIdExist(netId) then return end
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    VehicleKey.GiveKeys(vehicle, plate)
end)