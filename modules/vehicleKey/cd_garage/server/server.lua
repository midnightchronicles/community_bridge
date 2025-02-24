if GetResourceState('cd_garage') ~= 'started' or (BridgeSharedConfig.VehicleKey ~= "cd_garage" and BridgeSharedConfig.VehicleKey ~= "auto") then return end
VehicleKey = VehicleKey or {}

VehicleKey.GiveKeys = function(src, vehicle, plate)
    --wip
end

VehicleKey.RemoveKeys = function(src, vehicle, plate)
    -- wip
end