if GetResourceState('t1ger_keys') ~= 'started' then return end
VehicleKey = VehicleKey or {}

VehicleKey.GiveKeys = function(vehicle, plate)
    if not DoesEntityExist(vehicle) then return false end
    local vehicle_display_name = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
    return exports['t1ger_keys']:GiveTemporaryKeys(plate, vehicle_display_name, 'some_keys')
end

VehicleKey.RemoveKeys = function(vehicle, plate)

end