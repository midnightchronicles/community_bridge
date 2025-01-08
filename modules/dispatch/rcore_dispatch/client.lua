if GetResourceState('rcore_dispatch') ~= 'started' then return end

Dispatch = {}

Dispatch.SendAlert = function(data)
    local playerData = exports['rcore_dispatch']:GetPlayerData()
    TriggerEvent('rcore_dispatch:server:sendAlert', {
        code = data.code or '10-80',
        default_priority = 'low',
        coords = data.coords or playerData.coords,
        job = data.job,
        text = data.message or 'No message provided',
        type = 'alerts',
        blip = { sprite = 54, colour = 3, scale = 0.7, text = data.message or "No Message", flashes = false, radius = 0 }
    })
end