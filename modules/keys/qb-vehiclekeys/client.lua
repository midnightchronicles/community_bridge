if GetResourceState('qb-vehiclekeys') ~= 'started' then return end
if GetResourceState('qbx_vehiclekeys') == 'started' then return end
VehicleKeys = {}

VehicleKeys.GiveKeys = function(vehicle, plate)
    TriggerServerEvent('qb-vehiclekeys:server:AcquireVehicleKeys', plate)
end

VehicleKeys.RemoveKeys = function(vehicle, plate)

end