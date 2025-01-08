if GetResourceState('MrNewbVehicleKeys') ~= 'started' then return end
VehicleKeys = {}

VehicleKeys.GiveKeys = function(vehicle, plate)
    if not DoesEntityExist(vehicle) then return false end
    return exports.MrNewbVehicleKeys:GiveKeys(vehicle)
end

VehicleKeys.RemoveKeys = function(vehicle, plate)
    if not vehicle and not plate then return false end
    if not DoesEntityExist(vehicle) then
        return exports.MrNewbVehicleKeys:RemoveKeysByPlate(plate)
    end
    return exports.MrNewbVehicleKeys:RemoveKeys(vehicle)
end