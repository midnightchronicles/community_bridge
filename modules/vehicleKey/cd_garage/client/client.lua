if GetResourceState('cd_garage') ~= 'started' or (BridgeClientConfig.VehicleKey ~= "cd_garage" and BridgeClientConfig.VehicleKey ~= "auto") then return end

VehicleKey = VehicleKey or {}

VehicleKey.GiveKeys = function(vehicle, plate)
    if not plate then return false end
    TriggerEvent('cd_garage:AddKeys', plate)
end

VehicleKey.RemoveKeys = function(vehicle, plate)
    return true
end