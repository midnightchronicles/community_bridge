if GetResourceState('linden_outlawalert') ~= 'started' then return end

Dispatch = {}

Dispatch.SendAlert = function(data)
    local formattedData = {
        displayCode = data.code or '10-80',
        description = data.message,
        isImportant = data.priority or 0,
        recipientList = data.job,
        length = '10000',
        infoM = data.icon or 'fas fa-question',
        info = data.message
    }
    local dispatchData = {
        dispatchData = formattedData,
        caller = 'Anonymous',
        coords = GetEntityCoords(cache.ped)
    }
    TriggerServerEvent('wf-alerts:svNotify', dispatchData)
end