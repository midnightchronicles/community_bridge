if GetResourceState('cd_garage') ~= 'started' then return end
VehicleKey = VehicleKey or {}

VehicleKey.GiveKeys = function(vehicle, plate)
    TriggerEvent('cd_garage:AddKeys', plate)
end

VehicleKey.RemoveKeys = function(vehicle, plate)

end