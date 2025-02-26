if GetResourceState('Renewed-Vehiclekeys') ~= 'started' or (BridgeSharedConfig.VehicleKey ~= "Renewed-Vehiclekeys" and BridgeSharedConfig.VehicleKey ~= "auto") then return end

VehicleKey = VehicleKey or {}

VehicleKey.GiveKeys = function(src, vehicle, plate)
    if not plate then plate = GetVehicleNumberPlateText(vehicle) end
    exports['Renewed-Vehiclekeys']:addKey(src, plate)
end

VehicleKey.RemoveKeys = function(src, vehicle, plate)
    if not plate then plate = GetVehicleNumberPlateText(vehicle) end
    exports['Renewed-Vehiclekeys']:removeKey(src, plate)
end