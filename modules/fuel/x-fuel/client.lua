if GetResourceState('x-fuel') ~= 'started' or (BridgeClientConfig.Fuel ~= "x-fuel" and BridgeClientConfig.Fuel ~= "auto") then return end

--if GetResourceState('x-fuel') ~= 'started' then return end
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