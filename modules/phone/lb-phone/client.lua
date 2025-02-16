if GetResourceState('lb-phone') ~= 'started' then return end
Phone = {}

Phone.SendEmail = function(email, title, message)
    TriggerServerEvent('community_bridge:Server:genericEmail', {email = email, title = title, message = message})
end