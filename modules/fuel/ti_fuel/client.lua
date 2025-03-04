if GetResourceState('ti_fuel') ~= 'started' or (BridgeClientConfig.Fuel ~= "ti_fuel" and BridgeClientConfig.Fuel ~= "auto") then return end

--if GetResourceState('ti_fuel') ~= 'started' then return end
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