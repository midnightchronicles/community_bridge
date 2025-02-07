if GetResourceState('F_RealCarKeysSystem') ~= 'started' then return end
VehicleKey = {}

VehicleKey.GiveKeys = function(vehicle, plate)
    TriggerServerEvent('F_RealCarKeysSystem:generateVehicleKeys', plate)
end

VehicleKey.RemoveKeys = function(vehicle, plate)
    return
end
