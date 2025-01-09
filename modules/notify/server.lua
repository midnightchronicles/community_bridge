Notify = Notify or {}

Notify.SendNotify = function(src, message, _type, time)
    TriggerClientEvent('community_bridge:Client:Notify', src, message, _type, time)
end