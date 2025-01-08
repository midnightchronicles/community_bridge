if GetResourceState('Renewed-Vehiclekeys') ~= 'started' then return end
VehicleKeys = {}

VehicleKeys.GiveKeys = function(vehicle, plate)
    if not DoesEntityExist(vehicle) then return false end
    return exports['Renewed-Vehiclekeys']:addKey(plate)
end

VehicleKeys.RemoveKeys = function(vehicle, plate)
    if not DoesEntityExist(vehicle) then return false end
    return exports['Renewed-Vehiclekeys']:removeKey(plate)
end