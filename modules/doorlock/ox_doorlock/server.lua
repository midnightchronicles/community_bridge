if GetResourceState('ox_doorlock') ~= 'started' then return end

Doorlock = Doorlock or {}

Doorlock.ToggleDoorLock = function(doorID, toggle)
    local state = toggle
    if state then
        exports.ox_doorlock:setDoorState(doorID, 1)
    else
        exports.ox_doorlock:setDoorState(doorID, 0)
    end
    return true
end