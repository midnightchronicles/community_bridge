if GetResourceState('qs-vehiclekeys') ~= 'started' then return end
VehicleKeys = {}

VehicleKeys.GiveKeys = function(vehicle, plate)
    local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
    local verifiedPlate = GetVehicleNumberPlateText(vehicle)
    exports['qs-vehiclekeys']:GiveKeys(verifiedPlate, model, true)
end

VehicleKeys.RemoveKeys = function(vehicle, plate)

end