if GetResourceState('t-notify') ~= 'started' then return end
if BridgeClientConfig.NotifySystem and (BridgeClientConfig.NotifySystem ~= 'auto' and BridgeClientConfig.NotifySystem ~= 't-notify') then return end 

Notify = Notify or {}
Notify.SendNotify = function(message, type, time)
    return exports['t-SendNotify']:Alert({ style = 'info', message = message, duration = time })
end
       
