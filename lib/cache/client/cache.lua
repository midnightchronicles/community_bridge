Cache = Require("lib/cache/shared/cache.lua")
-- Comparison functions for client-side state
local function GetPed()
    return PlayerPedId()
end

local function GetVehicle()
    local ped = Cache.Get("Ped") -- Use cached ped for efficiency
    if not ped then return end -- Or handle error/default case
    return GetVehiclePedIsIn(ped, false)
end

local function GetVehicleSeat()
    local vehicle = Cache.Get("Vehicle")
    if not vehicle then return end
    local ped = Cache.Get("Ped")
    if not ped then return end
    for i = -1, GetVehicleMaxNumberOfPassengers(vehicle) - 1 do
        if ped == GetPedInVehicleSeat(vehicle, i) then
            return i
        end
    end
end

local function GetWeapon()
    local ped = Cache.Get("Ped")
    if not ped then return end -- Return unarmed hash if no ped
    return GetSelectedPedWeapon(ped)
end

Cache.Create("Ped", GetPed, 1000) -- Check ped every second (adjust as needed)
Cache.Create("Vehicle", GetVehicle, 500) -- Check vehicle every 500ms
Cache.Create("Seat", GetVehicleSeat, 500) -- Check if in vehicle every 500ms
Cache.Create("Weapon", GetWeapon, 250) -- Check weapon every 250ms

return Cache