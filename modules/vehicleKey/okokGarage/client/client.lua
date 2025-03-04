if GetResourceState('okokGarage') ~= 'started' or (BridgeClientConfig.VehicleKey ~= "okokGarage" and BridgeClientConfig.VehicleKey ~= "auto") then return end

VehicleKey = VehicleKey or {}

VehicleKey.GiveKeys = function(vehicle, plate)
    if not plate then return false end
    TriggerServerEvent('okokGarage:GiveKeys', plate)
end

VehicleKey.RemoveKeys = function(vehicle, plate)
    return true
end