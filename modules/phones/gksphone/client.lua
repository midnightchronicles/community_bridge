if GetResourceState('gksphone') ~= 'started' then return end
Phones = {}

Phones.SendEmail = function(email, title, message)
    return exports["gksphone"]:SendNewMail({ sender = email, image = '/html/static/img/icons/mail.png', subject = title, message = message })
end