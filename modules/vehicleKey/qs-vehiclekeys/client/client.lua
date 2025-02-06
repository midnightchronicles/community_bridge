if GetResourceState('qs-vehiclekeys') ~= 'started' then return end
VehicleKey = {}

VehicleKey.GiveKeys = function(vehicle, plate)
    local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
    local verifiedPlate = GetVehicleNumberPlateText(vehicle)
    exports['qs-vehiclekeys']:GiveKeys(verifiedPlate, model, true)
end

VehicleKey.RemoveKeys = function(vehicle, plate)
    return true
end