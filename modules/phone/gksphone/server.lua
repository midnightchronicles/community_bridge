if GetResourceState('gksphone') ~= 'started' then return end
Phone = {}

Phone.GetPlayerPhone = function(src)
    return exports["gksphone"]:GetPhoneBySource(src) or false
end

Phone.SendEmail = function(src, email, title, message)
    local data = {}
    data.sender = email
    data.image = '/html/static/img/icons/mail.png'
    data.subject = title
    data.message = message
    exports["gksphone"]:SendNewMail(src, data)
    return true
end