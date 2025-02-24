if GetResourceState('qs-smartphone') ~= 'started' or (BridgeSharedConfig.Phone ~= "qs-smartphone" and BridgeSharedConfig.VehicleKey ~= "auto") then return end
Phone = {}

Phone.GetPlayerPhone = function(src)
    return exports['qs-base']:GetPlayerPhone(src) or false
end

Phone.SendEmail = function(src, email, title, message)
    TriggerClientEvent('community_bridge:Server:genericEmail', src, { sender = email, subject = title, message = message, button = {} })
    return true
end