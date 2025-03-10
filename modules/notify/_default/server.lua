Notify = Notify or {}

---comment
---@param src number
---@param message string
---@param _type string
---@param time number
Notify.SendNotify = function(src, message, _type, time)
    TriggerClientEvent('community_bridge:Client:Notify', src, message, _type, time)
end

---comment
---@param src number
---@param message string
---@param position string
Notify.ShowHelpText = function(src, message, position)
    TriggerClientEvent('community_bridge:Client:ShowHelpText', src, message, position)
end

Notify.HideHelpText = function(src)
    TriggerClientEvent('community_bridge:Client:HideHelpText', src)
end