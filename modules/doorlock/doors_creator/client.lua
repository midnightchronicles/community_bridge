if GetResourceState('doors_creator') ~= 'started' then return end

Doorlock = Doorlock or {}

Doorlock.GetClosestDoor = function()
    return exports["doors_creator"]:getClosestActiveDoor()
end