if GetResourceState('qb-vehiclekeys') ~= 'started' and not GetResourceState("qbx_vehiclekeys") == "started" or (BridgeSharedConfig.VehicleKey ~= "qb-vehiclekeys" and BridgeSharedConfig.VehicleKey ~= "auto") then return end

VehicleKey = VehicleKey or {}

VehicleKey.GiveKeys = function(src, vehicle, plate)
    if not plate and vehicle then
        plate = GetVehicleNumberPlateText(vehicle)
    end
    return exports["qb-vehiclekeys"]:GiveKeys(src, plate)
end

VehicleKey.RemoveKeys = function(src, vehicle, plate)
    if not plate and vehicle then
        plate = GetVehicleNumberPlateText(vehicle)
    end
    return exports["qb-vehiclekeys"]:RemoveKeys(src, plate)
end