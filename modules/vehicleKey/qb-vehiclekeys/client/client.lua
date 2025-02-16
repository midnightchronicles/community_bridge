if GetResourceState('qb-vehiclekeys') ~= 'started' then return end
if GetResourceState('qbx_vehiclekeys') == 'started' then return end
VehicleKey = VehicleKey or {}

VehicleKey.GiveKeys = function(vehicle, plate)
    if plate == nil and vehicle and DoesEntityExist(vehicle) then
        plate = GetVehicleNumberPlateText(vehicle)
    end
    TriggerServerEvent('qb-vehiclekeys:server:AcquireVehicleKeys', plate)
end

VehicleKey.RemoveKeys = function(vehicle, plate)
    TriggerEvent('qb-vehiclekeys:client:RemoveKeys', plate)
end