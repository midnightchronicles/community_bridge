Phone = Phone or {}

Phone.SendEmail = function(email, title, message)
    return false, Print.Error('There Is No Phone Bridged.')
end