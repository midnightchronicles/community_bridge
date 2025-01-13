if GetResourceState('qs-smartphone') ~= 'started' then return end
Phone = {}

Phone.SendEmail = function(email, title, message)
    return TriggerServerEvent('qs-smartphone:server:sendNewMail', { sender = email, subject = title, message = message, button = {} })
end

RegisterNetEvent('community_bridge:Server:genericEmail', function(data)
    TriggerServerEvent('qs-smartphone:server:sendNewMail', { sender = data.email, subject = data.title, message = data.message, button = {} })
    return true
end)