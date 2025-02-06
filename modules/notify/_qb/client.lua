if GetResourceState('qb-core') ~= 'started' then return end
if BridgeClientConfig.NotifySystem and (BridgeClientConfig.NotifySystem ~= 'auto' and BridgeClientConfig.NotifySystem ~= 'qb') then return end 
Notify = Notify or {}


Notify.SendNotify = function(message, type, time)
    return TriggerEvent('QBCore:Notify', message, 'primary', time)
end