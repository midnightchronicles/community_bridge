if GetResourceState('MrNewbVehicleKeys') ~= 'started' or (BridgeClientConfig.VehicleKey ~= "MrNewbVehicleKeys" and BridgeClientConfig.VehicleKey ~= "auto") then return end

VehicleKey = VehicleKey or {}

VehicleKey.GiveKeys = function(vehicle, plate)
    if not plate then return false end
    return exports.MrNewbVehicleKeys:GiveKeysByPlate(plate)
end

VehicleKey.RemoveKeys = function(vehicle, plate)
    if not plate then return false end
    return exports.MrNewbVehicleKeys:RemoveKeysByPlate(plate)
end