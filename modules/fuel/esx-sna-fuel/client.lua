local resourceName = "esx-sna-fuel"
local configValue = BridgeClientConfig.Fuel
if (configValue == "auto" and GetResourceState(resourceName) ~= "started") or (configValue ~= "auto" and configValue ~= resourceName) then return end
--print("Fuel: Loading esx-sna-fuel")
--if GetResourceState('esx-sna-fuel') ~= 'started' then return end
Fuel = Fuel or {}

Fuel.GetFuel = function(vehicle)
    if not DoesEntityExist(vehicle) then return 0.0 end
    return exports['esx-sna-fuel']:GetFuel(vehicle)
end

Fuel.SetFuel = function(vehicle, fuel)
    if not DoesEntityExist(vehicle) then return end
    exports['esx-sna-fuel']:SetFuel(vehicle, fuel)
end
