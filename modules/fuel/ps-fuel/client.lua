if GetResourceState('ps-fuel') ~= 'started' then return end
Fuel = {}

Fuel.GetFuel = function(vehicle)
    if not DoesEntityExist(vehicle) then return 0.0 end
    return exports['ps-fuel']:GetFuel(vehicle)
end

Fuel.SetFuel = function(vehicle, fuel, type)
    if not DoesEntityExist(vehicle) then return end
    return exports['ps-fuel']:SetFuel(vehicle, fuel)
end