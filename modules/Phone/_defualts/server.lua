Phone = Phone or {}

Phone.GetPlayerPhone = function(src)
    return false, Print.Error('There Is No Phone Bridged.')
end

Phone.SendEmail = function(src, email, title, message)
    return false, Print.Error('There Is No Phone Bridged.')
end