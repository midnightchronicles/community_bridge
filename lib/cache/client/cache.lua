Cache = Require("lib/cache/shared/cache.lua")
local PlayerPedId = PlayerPedId
local GetVehiclePedIsIn = GetVehiclePedIsIn
local GetVehicleMaxNumberOfPassengers = GetVehicleMaxNumberOfPassengers
local GetPedInVehicleSeat = GetPedInVehicleSeat
local GetSelectedPedWeapon = GetSelectedPedWeapon

--- Get the vehicle the player is in, if any
---@return integer | nil
function GetVehicle()
    local ped = PlayerPedId()
    if not ped then return end 
    return GetVehiclePedIsIn(ped, false)
end

--- Get the seat of the player in the vehicle if the vehicle is occupied
---@return integer | nil
function GetVehicleSeat()
    local vehicle = GetVehicle()
    if not vehicle then return end
    local ped = PlayerPedId()
    if not ped then return end
    for i = -1, GetVehicleMaxNumberOfPassengers(vehicle) - 1 do
        if ped == GetPedInVehicleSeat(vehicle, i) then
            return i
        end
    end
end

--- Get the current weapon of the player
--- @return integer | nil
function GetWeapon()
    local ped = PlayerPedId()
    if not ped then return end -- Return unarmed hash if no ped
    return GetSelectedPedWeapon(ped)
end

Cache.Create("Ped", PlayerPedId, 1000)           -- Check ped every second (adjust as needed)
Cache.Create("Vehicle", GetVehicle, 500)    -- Check vehicle every 500ms
Cache.Create("Seat", GetVehicleSeat, 500)   -- Check if in vehicle every 500ms
Cache.Create("Weapon", GetWeapon , 250)      -- Check weapon every 250ms

return Cache
