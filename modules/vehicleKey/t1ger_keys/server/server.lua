if GetResourceState('t1ger_keys') ~= 'started' or (BridgeSharedConfig.VehicleKey ~= "t1ger_keys" and BridgeSharedConfig.VehicleKey ~= "auto") then return end

VehicleKey = VehicleKey or {}

VehicleKey.GiveKeys = function(src, vehicle, plate)
    TriggerClientEvent("community_bridge:vehicleKey:giveKeys", src, plate)
end

VehicleKey.RemoveKeys = function(src, vehicle, plate)

end