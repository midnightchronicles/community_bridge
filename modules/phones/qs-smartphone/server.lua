if GetResourceState('qs-smartphone') ~= 'started' then return end
Phones = {}

Phones.GetPlayerPhone = function(src)
    return exports['qs-base']:GetPlayerPhone(src) or false
end

Phones.SendEmail = function(src, email, title, message)
    TriggerClientEvent('community_bridge:Server:genericEmail', src, { sender = email, subject = title, message = message, button = {} })
    return true
end