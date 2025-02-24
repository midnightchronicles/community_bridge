if GetResourceState('MrNewbVehicleKeys') ~= 'started' or (BridgeSharedConfig.VehicleKey ~= "MrNewbVehicleKeys" and BridgeSharedConfig.VehicleKey ~= "auto") then return end

VehicleKey = VehicleKey or {}

VehicleKey.GiveKeys = function(vehicle, plate)
    if not DoesEntityExist(vehicle) and not plate then return false end
    return exports.MrNewbVehicleKeys:GiveKeys(vehicle)
end

VehicleKey.RemoveKeys = function(vehicle, plate)
    if not vehicle and not plate then return false end
    if not DoesEntityExist(vehicle) then return exports.MrNewbVehicleKeys:RemoveKeysByPlate(plate) end
    return exports.MrNewbVehicleKeys:RemoveKeys(vehicle)
end