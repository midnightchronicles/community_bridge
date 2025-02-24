if GetResourceState('F_RealCarKeysSystem') ~= 'started' or (BridgeSharedConfig.VehicleKey ~= "F_RealCarKeysSystem" and BridgeSharedConfig.VehicleKey ~= "auto") then return end
VehicleKey = VehicleKey or {}

VehicleKey.GiveKeys = function(vehicle, plate)
    TriggerServerEvent('F_RealCarKeysSystem:generateVehicleKeys', plate)
end

VehicleKey.RemoveKeys = function(vehicle, plate)
    return
end
