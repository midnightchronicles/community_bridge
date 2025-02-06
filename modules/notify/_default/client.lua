Notify = Notify or {}
local notifyType = BridgeClientConfig.NotifySystem
local helptextType = BridgeClientConfig.ShowHelpText

Notify.SendNotify = function(message, _type, time)
    time = time or 3000
    if notifyType == 'qb' then
        return Framework.Notify(message, nil, time)
    elseif notifyType == 'mythic' then
        return exports['mythic_notify']:SendAlert('inform', message, time)
    elseif notifyType == 'pNotify' then
        return exports['pNotify']:SendNotification({ text = message, type = _type, timeout = time, layout = 'centerRight' })
    elseif notifyType == 'esx' then
        return Framework.Notify(message, _type, time)
    elseif notifyType == 'ox' then
        return exports.ox_lib:notify({ description = message, type = _type, position = 'center-left' })
    elseif notifyType == 'okok' then
        return exports['okokNotify']:Alert('Notification', message, time, _type, false)
    elseif notifyType == 't-notify' then
        return exports['t-notify']:Alert({ style = 'info', message = message, duration = time, })
    elseif notifyType == 'wasabi' then
        return exports.wasabi_notify:notify(_type, message, time, _type)
    elseif notifyType == 'custom' then
        return Prints.Error("You have not set up a custom notify in community_bridge")
    else
        return Prints.Error("You have not configured a notify in community_bridge")
    end
end

Notify.ShowHelpText = function(message, _position)
    if helptextType == 'ox' then
        if _position == nil then _position = 'left-center' end
        return exports.ox_lib:showTextUI(message, { position = _position })
    elseif helptextType == 'jg' then
        return exports['jg-textui']:DrawText(message)
    elseif helptextType == 'qb' then
        if _position == nil then _position = 'left' end
        return Framework.ShowHelpText(message, _position)
    elseif helptextType == 'okok' then
        if _position == nil then _position = 'left' end
        return exports['okokTextUI']:Open(message, 'darkblue', _position, false)
    elseif helptextType == 'cd' then
        return TriggerEvent('cd_drawtextui:ShowUI', 'show', message)
    elseif helptextType == 'lab' then
        return exports['lab-HintUI']:Show(message, "Hint Text")
    elseif helptextType == 'custom' then
        return Prints.Error("You have not set up a custom ShowHelpText in community_bridge")
    else
        return Prints.Error("You have not configured a ShowHelpText in community_bridge")
    end
end

Notify.HideHelpText = function()
    if helptextType == 'ox' then
        return exports.ox_lib:hideTextUI()
    elseif helptextType == 'jg' then
        return exports['jg-textui']:HideText()
    elseif helptextType == 'qb' then
        return Framework.HideHelpText()
    elseif helptextType == 'okok' then
        return exports['okokTextUI']:Close()
    elseif helptextType == 'cd' then
        return TriggerEvent('cd_drawtextui:HideUI')
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