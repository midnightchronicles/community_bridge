if GetResourceState('ox_doorlock') ~= 'started' then return end

Doorlock = Doorlock or {}

---This will get the closest door to the ped
---@return string | nil
Doorlock.GetClosestDoor = function()
    return exports.ox_doorlock:getClosestDoor()
end
