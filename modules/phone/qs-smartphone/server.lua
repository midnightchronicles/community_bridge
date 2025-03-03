if GetResourceState('qs-smartphone') ~= 'started' or (BridgeSharedConfig.Phone ~= "qs-smartphone" and BridgeSharedConfig.VehicleKey ~= "auto") then return end
Phone = {}

---comment
---@param src number
---@return number||boolean
Phone.GetPlayerPhone = function(src)
    return exports['qs-base']:GetPlayerPhone(src) or false
end

---comment
---@param src number
---@param email string
---@param title string
---@param message string
---@return boolean
Phone.SendEmail = function(src, email, title, message)
    TriggerClientEvent('community_bridge:Server:genericEmail', src, { sender = email, subject = title, message = message, button = {} })
    return true
end