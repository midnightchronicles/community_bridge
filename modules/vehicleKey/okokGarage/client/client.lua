if GetResourceState('okokGarage') ~= 'started' or (BridgeSharedConfig.VehicleKey ~= "okokGarage" and BridgeSharedConfig.VehicleKey ~= "auto") then return end

VehicleKey = VehicleKey or {}

VehicleKey.GiveKeys = function(vehicle, plate)
    TriggerServerEvent('okokGarage:GiveKeys', plate)
end

VehicleKey.RemoveKeys = function(vehicle, plate)
    return true
end