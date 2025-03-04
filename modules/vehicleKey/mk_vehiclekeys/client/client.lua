if GetResourceState('mk_vehiclekeys') ~= 'started' or (BridgeClientConfig.VehicleKey ~= "mk_vehiclekeys" and BridgeClientConfig.VehicleKey ~= "auto") then return end

VehicleKey = VehicleKey or {}

VehicleKey.GiveKeys = function(vehicle, plate)
    if not vehicle and not DoesEntityExist(vehicle) then return false end
    return exports["mk_vehiclekeys"]:AddKey(vehicle)
end

VehicleKey.RemoveKeys = function(vehicle, plate)
    if not vehicle and not DoesEntityExist(vehicle) then return false end
    return exports["mk_vehiclekeys"]:RemoveKey(vehicle)
end