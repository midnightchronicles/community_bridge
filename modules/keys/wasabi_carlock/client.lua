if GetResourceState('wasabi_carlock') ~= 'started' then return end
VehicleKeys = {}

VehicleKeys.GiveKeys = function(vehicle, plate)
    exports.wasabi_carlock:GiveKey(plate)
end

VehicleKeys.RemoveKeys = function(vehicle, plate)
    exports.wasabi_carlock:RemoveKey(plate)
end