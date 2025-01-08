if GetResourceState('okokGarage') ~= 'started' then return end
VehicleKeys = {}

VehicleKeys.GiveKeys = function(vehicle, plate)
    TriggerServerEvent('okokGarage:GiveKeys', plate)
end

VehicleKeys.RemoveKeys = function(vehicle, plate)

end