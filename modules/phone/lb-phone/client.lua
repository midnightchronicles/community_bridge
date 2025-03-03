if GetResourceState('lb-phone') ~= 'started' or (BridgeSharedConfig.Phone ~= "lb-phone" and BridgeSharedConfig.VehicleKey ~= "auto") then return end

Phone = {}

---comment
---@param email string
---@param title string
---@param message string
---@return nil
Phone.SendEmail = function(email, title, message)
    TriggerServerEvent('community_bridge:Server:genericEmail', {email = email, title = title, message = message})
end