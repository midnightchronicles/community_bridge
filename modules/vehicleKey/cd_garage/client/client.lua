if GetResourceState('cd_garage') ~= 'started' or (BridgeSharedConfig.VehicleKey ~= "cd_garage" and BridgeSharedConfig.VehicleKey ~= "auto") then return end
VehicleKey = VehicleKey or {}

VehicleKey.GiveKeys = function(vehicle, plate)
    TriggerEvent('cd_garage:AddKeys', plate)
end

VehicleKey.RemoveKeys = function(vehicle, plate)

end