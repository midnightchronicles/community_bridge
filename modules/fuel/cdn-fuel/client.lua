if GetResourceState('cdn-fuel') ~= 'started' or (BridgeClientConfig.Fuel ~= "cdn" and BridgeClientConfig.Fuel ~= "auto") then return end

--if GetResourceState('cdn-fuel') ~= 'started' then return end
Fuel = Fuel or {}

Fuel.GetFuel = function(vehicle)
    if not DoesEntityExist(vehicle) then return 0.0 end
    return exports['cdn-fuel']:GetFuel(vehicle)
end

Fuel.SetFuel = function(vehicle, fuel)
    if not DoesEntityExist(vehicle) then return end
    return exports['cdn-fuel']:SetFuel(vehicle, fuel)
end