Notify = Notify or {}

Notify.SendNotify = function(message, type, time)
    if BridgeClientConfig == nil or BridgeClientConfig.NotifySystem == nil then return Prints.error("You have not configured a compatable notify in community_bridge") end
    local notifyType = BridgeClientConfig.NotifySystem
    time = time or 3000
    if notifyType == 'qb' then
        return TriggerEvent('QBCore:Notify', message, 'primary', time)
    elseif notifyType == 'mythic_notify' then
        return exports['mythic_notify']:SendAlert('inform', message, time)
    elseif notifyType == 'pNotify' then
        return exports['pNotify']:SendNotification({ text = message, type = type, timeout = time, layout = 'centerRight' })
    elseif notifyType == 'esx_notify' then
        return ESX.ShowNotification(message, type, time)
    elseif notifyType == 'ox' then
        return exports.ox_lib:notify({ description = message, type = type, position = 'center-left' })
    elseif notifyType == 't-notify' then
        return exports['t-notify']:Alert({ style = 'info', message = message, duration = time, })
    elseif notifyType == 'wasabi_notify' then
        return exports.wasabi_notify:notify(type, message, time, type)
    elseif notifyType == 'lab' then
        return exports['swe-notify']:SendNotification(message, time, type)
    elseif notifyType == 'custom' then
        return Prints.Error("You have not set up a custom notify in community_bridge")
    else
        return Prints.Error("You have not configured a notify in community_bridge")
    end
end

Notify.ShowHelpText = function(message, _position)
    if BridgeClientConfig == nil or BridgeClientConfig.ShowHelpText == nil then return Prints.error("You have not configured a compatable helptext in community_bridge") end
    local helptextType = BridgeClientConfig.ShowHelpText
    if helptextType == 'ox' then
        if _position == nil then _position = 'left-center' end
        return exports.ox_lib:showTextUI(message, { position = _position })
    elseif helptextType == 'jg' then
        return exports['jg-textui']:DrawText(message)
    elseif helptextType == 'qb' then
        if _position == nil then _position = 'left' end
        return exports['qb-core']:DrawText(message, 'left')
    elseif helptextType == 'lab' then
        return exports['lab-HintUI']:Show(message, "Hint Text")
    elseif helptextType == 'custom' then
        return Prints.Error("You have not set up a custom ShowHelpText in community_bridge")
    else
        return Prints.Error("You have not configured a ShowHelpText in community_bridge")
    end
end

Notify.HideHelpText = function()
    if BridgeClientConfig == nil or BridgeClientConfig.ShowHelpText == nil then return Prints.error("You have not configured a compatable helptext in community_bridge") end
    local helptextType = BridgeClientConfig.ShowHelpText
    if helptextType == 'ox' then
        return exports.ox_lib:hideTextUI()
    elseif helptextType == 'jg' then
        return exports['jg-textui']:HideText()
    elseif helptextType == 'qb' then
        return exports['qb-core']:HideText()
    elseif helptextType == 'lab' then
        return exports['lab-HintUI']:Hide()
    elseif helptextType == 'custom' then
        return Prints.Error("You have not set up a custom HideHelpText in community_bridge")
    else
        return Prints.Error("You have not configured a HideHelpText in community_bridge")
    end
end

RegisterNetEvent('community_bridge:Client:Notify', function(message, _type, time)
    Notify.SendNotify(message, _type, time)
end)

RegisterNetEvent('community_bridge:Client:ShowHelpText', function(message, position)
    Notify.ShowHelpText(message, position)
end)

RegisterNetEvent('community_bridge:Client:HideHelpText', function()
    Notify.HideHelpText()
end)