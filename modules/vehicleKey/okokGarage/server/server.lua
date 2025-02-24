if GetResourceState('okokGarage') ~= 'started' or (BridgeSharedConfig.VehicleKey ~= "okokGarage" and BridgeSharedConfig.VehicleKey ~= "auto") then return end

VehicleKey = VehicleKey or {}

VehicleKey.GiveKeys = function(src, vehicle, plate)
    --wip
end

VehicleKey.RemoveKeys = function(src, vehicle, plate)
    -- wip
end