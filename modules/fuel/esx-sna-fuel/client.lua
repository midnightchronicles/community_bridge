if GetResourceState('esx-sna-fuel') ~= 'started' then return end
Fuel = {}

Fuel.GetFuel = function(vehicle)
    if not DoesEntityExist(vehicle) then return 0.0 end
    return exports['esx-sna-fuel']:GetFuel(vehicle)
end

Fuel.SetFuel = function(vehicle, fuel)
    if not DoesEntityExist(vehicle) then return end
    exports['esx-sna-fuel']:SetFuel(vehicle, fuel)
end
