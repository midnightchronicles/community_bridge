if GetResourceState('doors_creator') ~= 'started' then return end

Doorlock = {}

Doorlock.ToggleDoorLock = function(doorID, toggle)
    local state = toggle
    if state then
        exports["doors_creator"]:setDoorState(doorID, 1)
    else
        exports["doors_creator"]:setDoorState(doorID, 0)
    end
    return true
end