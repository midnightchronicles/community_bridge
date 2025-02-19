if GetResourceState('x-fuel') ~= 'started' then return end
Fuel = Fuel or {}

Fuel.GetFuel = function(vehicle)
    if not DoesEntityExist(vehicle) then return 0.0, type end
    local level, type = exports["x-fuel"]:getFuel(vehicle)
    return level, type
end

Fuel.SetFuel = function(vehicle, fuel, type)
    if not DoesEntityExist(vehicle) then return end
    return exports['x-fuel']:SetFuel(vehicle, fuel)
end