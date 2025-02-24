if GetResourceState('mk_vehiclekeys') ~= 'started' or (BridgeSharedConfig.VehicleKey ~= "mk_vehiclekeys" and BridgeSharedConfig.VehicleKey ~= "auto") then return end

VehicleKey = VehicleKey or {}

VehicleKey.GiveKeys = function(src, vehicle, plate)
    -- wip
end

VehicleKey.RemoveKeys = function(src, vehicle, plate)
    --wip
end