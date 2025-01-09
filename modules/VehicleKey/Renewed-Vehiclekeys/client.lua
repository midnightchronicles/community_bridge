if GetResourceState('Renewed-Vehiclekeys') ~= 'started' then return end
VehicleKey = {}

VehicleKey.GiveKeys = function(vehicle, plate)
    if not DoesEntityExist(vehicle) then return false end
    return exports['Renewed-Vehiclekeys']:addKey(plate)
end

VehicleKey.RemoveKeys = function(vehicle, plate)
    if not DoesEntityExist(vehicle) then return false end
    return exports['Renewed-Vehiclekeys']:removeKey(plate)
end