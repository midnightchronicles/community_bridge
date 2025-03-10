local resourceName = "ox_fuel"
local configValue = BridgeClientConfig.Fuel
if (configValue == "auto" and GetResourceState(resourceName) ~= "started") or (configValue ~= "auto" and configValue ~= resourceName) then return end
--print("Fuel: Loading ox_fuel")
Fuel = Fuel or {}

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