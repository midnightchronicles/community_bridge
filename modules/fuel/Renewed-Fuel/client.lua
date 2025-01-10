if GetResourceState('Renewed-Fuel') ~= 'started' then return end
Fuel = {}

Fuel.GetFuel = function(vehicle)
    if not DoesEntityExist(vehicle) then return 0.0 end
    return exports['Renewed-Fuel']:GetFuel(vehicle)
end

Fuel.SetFuel = function(vehicle, fuel, type)
    if not DoesEntityExist(vehicle) then return end
    return exports['Renewed-Fuel']:SetFuel(vehicle, fuel)
end