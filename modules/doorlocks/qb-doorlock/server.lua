if GetResourceState('qb-doorlock') ~= 'started' then return end

Doorlock = {}

Doorlock.ToggleDoorLock = function(doorID, toggle)
    TriggerClientEvent('qb-doorlock:client:setState', -1, 0, doorID, toggle, false, false, false)
    return true
end