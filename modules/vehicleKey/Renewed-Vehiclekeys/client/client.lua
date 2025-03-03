if GetResourceState('Renewed-Vehiclekeys') ~= 'started' or (BridgeClientConfig.VehicleKey ~= "Renewed-Vehiclekeys" and BridgeClientConfig.VehicleKey ~= "auto") then return end

VehicleKey = VehicleKey or {}

VehicleKey.GiveKeys = function(vehicle, plate)
    if not plate and not DoesEntityExist(vehicle) then return false end
    return exports['Renewed-Vehiclekeys']:addKey(plate)
end

VehicleKey.RemoveKeys = function(vehicle, plate)
    if not plate and not DoesEntityExist(vehicle) then return false end
    return exports['Renewed-Vehiclekeys']:removeKey(plate)
end