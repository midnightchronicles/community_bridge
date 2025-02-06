if GetResourceState('wasabi_notify') ~= 'started' then return end
if BridgeClientConfig.NotifySystem and (BridgeClientConfig.NotifySystem ~= 'auto' and BridgeClientConfig.NotifySystem ~= 'wasabi') then return end 

Notify = Notify or {}
Notify.SendNotify = function(message, type, time)
    return exports.wasabi_notify:notify(type, message, time, type)
end

    