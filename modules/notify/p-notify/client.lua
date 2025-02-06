if GetResourceState('pNotify') ~= 'started' then return end
if BridgeClientConfig.NotifySystem and (BridgeClientConfig.NotifySystem ~= 'auto' and BridgeClientConfig.NotifySystem ~= 'pNotify') then return end 

Notify = Notify or {}


Notify.SendNotify = function(message, type, time)
    return exports['pNotify']:SendNotification({ text = message, type = type, timeout = time, layout = 'centerRight' })
end
