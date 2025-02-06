if GetResourceState('esx') ~= 'started' then return end
if BridgeClientConfig.NotifySystem and (BridgeClientConfig.NotifySystem ~= 'auto' and BridgeClientConfig.NotifySystem ~= 'esx') then return end 

Notify = Notify or {}

Notify.SendNotify = function(message, type, time)
    return ESX.ShowNotification(message, type, time)
end
