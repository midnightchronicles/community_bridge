Fuel = Fuel or {}
----print("Fuel: Loading Defualt")
Fuel.GetFuel = function(vehicle)
    if not DoesEntityExist(vehicle) then return 0.0 end
    return GetVehicleFuelLevel(vehicle)
end

Fuel.SetFuel = function(vehicle, fuel, type)
    if not DoesEntityExist(vehicle) then return end
    return SetVehicleFuelLevel(vehicle, fuel)
end