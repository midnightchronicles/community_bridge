if GetResourceState('cd_garage') ~= 'started' then return end
VehicleKeys = {}

VehicleKeys.GiveKeys = function(vehicle, plate)
    TriggerEvent('cd_garage:AddKeys', plate)
end

VehicleKeys.RemoveKeys = function(vehicle, plate)

end