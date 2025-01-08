if GetResourceState('ox_doorlock') ~= 'started' then return end

Doorlock = {}

Doorlock.GetClosestDoor = function()
    return exports.ox_doorlock:getClosestDoor()
end
