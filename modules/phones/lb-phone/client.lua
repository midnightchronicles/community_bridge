if GetResourceState('lb-phone') ~= 'started' then return end
Phones = {}

Phones.SendEmail = function(email, title, message)
    TriggerServerEvent('community_bridge:Server:genericEmail', {email = email, title = title, message = message})
end