local resourceName = "qs-smartphone"
local configValue = BridgeSharedConfig.Phone
if (configValue == "auto" and GetResourceState(resourceName) ~= "started") or (configValue ~= "auto" and configValue ~= resourceName) then return end
Phone = Phone or {}

---comment
---@param email string
---@param title string
---@param message string
---@return nil
Phone.SendEmail = function(email, title, message)
    return TriggerServerEvent('qs-smartphone:server:sendNewMail', { sender = email, subject = title, message = message, button = {} })
end

RegisterNetEvent('community_bridge:Server:genericEmail', function(data)
    TriggerServerEvent('qs-smartphone:server:sendNewMail', { sender = data.email, subject = data.title, message = data.message, button = {} })
    return true
end)