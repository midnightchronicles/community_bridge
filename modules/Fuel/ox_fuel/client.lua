if GetResourceState('cdn-fuel') ~= 'started' then return end
Fuel = {}

Fuel.GetFuel = function(vehicle)
    if not DoesEntityExist(vehicle) then return 0.0 end
    return Entity(vehicle).state.fuel
end

Fuel.SetFuel = function(vehicle, fuel, type)
    if not DoesEntityExist(vehicle) then return end
    local currentFuel = Entity(vehicle).state.fuel
    Entity(vehicle).state.fuel = currentFuel + fuel
    return Entity(vehicle).state.fuel
end