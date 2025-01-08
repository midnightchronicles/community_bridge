if GetResourceState('rcore_doorlock') ~= 'started' then return end

Doorlock = {}

Doorlock.ToggleDoorLock = function(doorID, toggle)
    local state = toggle
    if state then
        exports.rcore_doorlock:changeDoorState(doorID, 0)
    else
        exports.rcore_doorlock:changeDoorState(doorID, 1)
    end
    return true
end