local resourceName = "ti_fuel"
local configValue = BridgeClientConfig.Fuel
if (configValue == "auto" and GetResourceState(resourceName) ~= "started") or (configValue ~= "auto" and configValue ~= resourceName) then return end
--print("Fuel: Loading ti_fuel")
Fuel = Fuel or {}

Fuel.GetFuel = function(vehicle)
    if not DoesEntityExist(vehicle) then return 0.0 end
    local level, _ = exports["ti_fuel"]:getFuel(vehicle)
    return level
end

Fuel.SetFuel = function(vehicle, fuel)
    if not DoesEntityExist(vehicle) then return end
    return exports['ti_fuel']:setFuel(vehicle, fuel, "RON91")
end