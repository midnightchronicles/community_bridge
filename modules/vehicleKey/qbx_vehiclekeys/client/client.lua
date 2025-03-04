if GetResourceState('qbx_vehiclekeys') ~= 'started' or (BridgeClientConfig.VehicleKey ~= "qbx" and BridgeClientConfig.VehicleKey ~= "auto") then return end

VehicleKey = VehicleKey or {}

VehicleKey.GiveKeys = function(vehicle, plate)
    if not plate then return false end
    TriggerServerEvent('qb-vehiclekeys:server:AcquireVehicleKeys', plate)
end

VehicleKey.RemoveKeys = function(vehicle, plate)
    return true
end