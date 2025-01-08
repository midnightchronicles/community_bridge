if GetResourceState('mk_vehiclekeys') ~= 'started' then return end
VehicleKeys = {}

VehicleKeys.GiveKeys = function(vehicle, plate)
    if not DoesEntityExist(vehicle) then return false end
    return exports["mk_vehiclekeys"]:AddKey(vehicle)
end

VehicleKeys.RemoveKeys = function(vehicle, plate)
    if not DoesEntityExist(vehicle) then return false end
    return exports["mk_vehiclekeys"]:RemoveKey(vehicle)
end