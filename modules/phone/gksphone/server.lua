if GetResourceState('gksphone') ~= 'started' or (BridgeSharedConfig.Phone ~= "gksphone" and BridgeSharedConfig.VehicleKey ~= "auto") then return end

Phone = {}

---comment
---@param src number
---@return number||boolean
Phone.GetPlayerPhone = function(src)
    return exports["gksphone"]:GetPhoneBySource(src) or false
end

---comment
---@param src number
---@param email string
---@param title string
---@param message string
---@return boolean
Phone.SendEmail = function(src, email, title, message)
    local data = {}
    data.sender = email
    data.image = '/html/static/img/icons/mail.png'
    data.subject = title
    data.message = message
    exports["gksphone"]:SendNewMail(src, data)
    return true
end