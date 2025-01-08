if GetResourceState('gksphone') ~= 'started' then return end
Phones = {}

Phones.GetPlayerPhone = function(src)
    return exports["gksphone"]:GetPhoneBySource(src) or false
end

Phones.SendEmail = function(src, email, title, message)
    local data = {}
    data.sender = email
    data.image = '/html/static/img/icons/mail.png'
    data.subject = title
    data.message = message
    exports["gksphone"]:SendNewMail(src, data)
    return true
end