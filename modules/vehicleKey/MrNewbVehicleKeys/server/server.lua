if GetResourceState('MrNewbVehicleKeys') ~= 'started' then return end
VehicleKey = VehicleKey or {}

VehicleKey.GiveKeys = function(src, vehicle, plate)
    if vehicle then
        local netId = NetworkGetNetworkIdFromEntity(vehicle)
        return exports.MrNewbVehicleKeys:GiveKeys(src, netId)
    elseif plate then
        return exports.MrNewbVehicleKeys:GiveKeysByPlate(src, plate)
    end
end

VehicleKey.RemoveKeys = function(src, vehicle, plate)
    if vehicle then
        local netId = NetworkGetNetworkIdFromEntity(vehicle)
        return exports.MrNewbVehicleKeys:RemoveKeys(src, netId)
    elseif plate then
        return exports.MrNewbVehicleKeys:RemoveKeysByPlate(src, plate)
    end
end