if GetResourceState('qb-vehiclekeys') ~= 'started' and not GetResourceState("qbx_vehiclekeys") == "started" or (BridgeSharedConfig.VehicleKey ~= "qb-vehiclekeys" and BridgeSharedConfig.VehicleKey ~= "auto") then return end
VehicleKey = VehicleKey or {}

VehicleKey.GiveKeys = function(vehicle, plate)
    if not plate and vehicle then plate = GetVehicleNumberPlateText(vehicle) end
    TriggerServerEvent("qb-vehiclekeys:server:AcquireVehicleKeys", plate)
end

VehicleKey.RemoveKeys = function(vehicle, plate)
    if not plate and vehicle then plate = GetVehicleNumberPlateText(vehicle) end
    TriggerEvent("qb-vehiclekeys:client:RemoveKeys", plate)
end