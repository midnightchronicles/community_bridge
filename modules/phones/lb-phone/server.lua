if GetResourceState('lb-phone') ~= 'started' then return end
Phones = {}

Phones.GetPlayerPhone = function(src)
    return exports["lb-phone"]:GetEquippedPhoneNumber(src) or false
end

Phones.SendEmail = function(src, email, title, message)
    local numberNumber = exports["lb-phone"]:GetEquippedPhoneNumber(src)
    if not numberNumber then return false, print("Could not Find Phone number") end
    local playerEmail = exports["lb-phone"]:GetEmailAddress(numberNumber)
    if not playerEmail then return false, print("Could not Find email")  end
    local success, id = exports["lb-phone"]:SendMail({
        to = playerEmail,
        sender = email,
        subject = title,
        message = message,
    })
    return success
end

RegisterNetEvent('community_bridge:Server:genericEmail', function(data)
    local src = source
    print('community_bridge:Server:genericEmail Hit')
    return Phones.SendEmail(src, data.email, data.title, data.message)
end)