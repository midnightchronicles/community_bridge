if GetResourceState('mythic_notify') ~= 'started' then return end
if BridgeClientConfig.NotifySystem and (BridgeClientConfig.NotifySystem ~= 'auto' and BridgeClientConfig.NotifySystem ~= 'mythic') then return end 

Notify = Notify or {}

Notify.SendNotify = function(message, type, time)
    return exports['mythic_notify']:SendAlert('inform', message, time)
end
