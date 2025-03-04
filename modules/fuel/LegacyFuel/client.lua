if GetResourceState('LegacyFuel') ~= 'started' or (BridgeClientConfig.Fuel ~= "LegacyFuel" and BridgeClientConfig.Fuel ~= "auto") then return end

--if GetResourceState('LegacyFuel') ~= 'started' then return end
Fuel = Fuel or {}

Fuel.GetFuel = function(vehicle)
    if not DoesEntityExist(vehicle) then return 0.0 end
    return exports['LegacyFuel']:GetFuel(vehicle)
end

Fuel.SetFuel = function(vehicle, fuel, type)
    if not DoesEntityExist(vehicle) then return end
    return exports['LegacyFuel']:SetFuel(vehicle, fuel)
end