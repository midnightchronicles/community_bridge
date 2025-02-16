if GetResourceState('wasabi_carlock') ~= 'started' then return end
VehicleKey = VehicleKey or {}

VehicleKey.GiveKeys = function(vehicle, plate)
    exports.wasabi_carlock:GiveKey(plate)
end

VehicleKey.RemoveKeys = function(vehicle, plate)
    exports.wasabi_carlock:RemoveKey(plate)
end