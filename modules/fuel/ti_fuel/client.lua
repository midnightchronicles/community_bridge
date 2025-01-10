if GetResourceState('ti_fuel') ~= 'started' then return end
Fuel = {}

Fuel.GetFuel = function(vehicle)
    if not DoesEntityExist(vehicle) then return 0.0, type end
    local level, type = exports["ti_fuel"]:getFuel(vehicle)
    return level, type
end

Fuel.SetFuel = function(vehicle, fuel, type)
    if not DoesEntityExist(vehicle) then return end
    return exports['ti_fuel']:setFuel(vehicle, fuel, type or "RON91")
end