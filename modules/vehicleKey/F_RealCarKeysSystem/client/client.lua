if GetResourceState('F_RealCarKeysSystem') ~= 'started' or (BridgeClientConfig.VehicleKey ~= "F_RealCarKeysSystem" and BridgeClientConfig.VehicleKey ~= "auto") then return end

VehicleKey = VehicleKey or {}

VehicleKey.GiveKeys = function(vehicle, plate)
    if not plate then return false end
    TriggerServerEvent('F_RealCarKeysSystem:generateVehicleKeys', plate)
end

VehicleKey.RemoveKeys = function(vehicle, plate)
    return true
end
