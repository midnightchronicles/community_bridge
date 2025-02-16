Notify = Notify or {}

Notify.SendNotify = function(src, message, _type, time)
    TriggerClientEvent('community_bridge:Client:Notify', src, message, _type, time)
end

Notify.ShowHelpText = function(src, message, position)
    TriggerClientEvent('community_bridge:Client:ShowHelpText', src, message, position)
end

Notify.HideHelpText = function(src)
    TriggerClientEvent('community_bridge:Client:HideHelpText', src)
end