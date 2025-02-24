if GetResourceState('gksphone') ~= 'started' or (BridgeSharedConfig.Phone ~= "gksphone" and BridgeSharedConfig.VehicleKey ~= "auto") then return end

Phone = {}

Phone.SendEmail = function(email, title, message)
    return exports["gksphone"]:SendNewMail({ sender = email, image = '/html/static/img/icons/mail.png', subject = title, message = message })
end