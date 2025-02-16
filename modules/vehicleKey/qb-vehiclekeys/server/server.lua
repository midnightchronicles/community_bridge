if GetResourceState('qb-vehiclekeys') ~= 'started' then return end
if GetResourceState('qbx_vehiclekeys') == 'started' then return end
VehicleKey = VehicleKey or {}

VehicleKey.GiveKeys = function(src, vehicle, plate)
    if plate then
        return exports["qb-vehiclekeys"]:GiveKeys(src, plate)
    end
end

VehicleKey.RemoveKeys = function(src, vehicle, plate)
    if plate then
        return exports["qb-vehiclekeys"]:RemoveKeys(src, plate)
    end
end