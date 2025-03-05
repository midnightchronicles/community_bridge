local resourceName = "BigDaddy-Fuel"
local configValue = BridgeClientConfig.Fuel
if (configValue == "auto" and GetResourceState(resourceName) ~= "started") or (configValue ~= "auto" and configValue ~= resourceName) then return end

--print("Fuel: Loading BigDaddy-Fuel")
--if GetResourceState('BigDaddy-Fuel') ~= 'started' then return end
Fuel = Fuel or {}

Fuel.GetFuel = function(vehicle)
    if not DoesEntityExist(vehicle) then return 0.0 end
    return exports['BigDaddy-Fuel']:GetFuel(vehicle)
end

Fuel.SetFuel = function(vehicle, fuel)
    if not DoesEntityExist(vehicle) then return end
    exports['BigDaddy-Fuel']:SetFuel(vehicle, fuel)
end
