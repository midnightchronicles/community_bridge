Notify = {}

Notify.SendNotify = function(src, message, type, time)
    TriggerClientEvent('community_bridge:Client:Notify', src, message, type, time)
end