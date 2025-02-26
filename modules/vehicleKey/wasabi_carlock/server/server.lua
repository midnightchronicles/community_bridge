if GetResourceState('wasabi_carlock') ~= 'started' or (BridgeSharedConfig.VehicleKey ~= "wasabi_carlock" and BridgeSharedConfig.VehicleKey ~= "auto") then return end
VehicleKey = VehicleKey or {}

VehicleKey.GiveKeys = function(src, vehicle, plate)
    if not plate and vehicle then plate = GetVehicleNumberPlateText(vehicle) end
    exports.wasabi_carlock:GiveKey(src, plate)
end

VehicleKey.RemoveKeys = function(src, vehicle, plate)
    if not plate and vehicle then plate = GetVehicleNumberPlateText(vehicle) end
    exports.wasabi_carlock:RemoveKey(src, plate)
end