local resourceName = "x-fuel"
local configValue = BridgeClientConfig.Fuel
if (configValue == "auto" and GetResourceState(resourceName) ~= "started") or (configValue ~= "auto" and configValue ~= resourceName) then return end
--print("Fuel: Loading x-fuel")
Fuel = Fuel or {}

Fuel.GetFuel = function(vehicle)
    if not DoesEntityExist(vehicle) then return 0.0 end
    local level, _ = exports["x-fuel"]:getFuel(vehicle)
    return level
end

Fuel.SetFuel = function(vehicle, fuel)
    if not DoesEntityExist(vehicle) then return end
    return exports['x-fuel']:SetFuel(vehicle, fuel)
end