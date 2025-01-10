if GetResourceState('qb-vehiclekeys') ~= 'started' then return end
if GetResourceState('qbx_vehiclekeys') == 'started' then return end
VehicleKey = {}

VehicleKey.GiveKeys = function(vehicle, plate)
    TriggerServerEvent('qb-vehiclekeys:server:AcquireVehicleKeys', plate)
end

VehicleKey.RemoveKeys = function(vehicle, plate)
    return true
end