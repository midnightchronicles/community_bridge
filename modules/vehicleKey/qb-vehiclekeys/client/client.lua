if GetResourceState('qb-vehiclekeys') ~= 'started' and not GetResourceState("qbx_vehiclekeys") == "started" or (BridgeClientConfig.VehicleKey ~= "qb-vehiclekeys" and BridgeClientConfig.VehicleKey ~= "auto") then return end
VehicleKey = VehicleKey or {}

VehicleKey.GiveKeys = function(vehicle, plate)
    if not plate and vehicle then plate = GetVehicleNumberPlateText(vehicle) end
    TriggerServerEvent("qb-vehiclekeys:server:AcquireVehicleKeys", plate)
end

VehicleKey.RemoveKeys = function(vehicle, plate)
    if not plate and vehicle then plate = GetVehicleNumberPlateText(vehicle) end
    TriggerEvent("qb-vehiclekeys:client:RemoveKeys", plate)
end