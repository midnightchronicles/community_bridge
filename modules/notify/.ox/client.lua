if GetResourceState('ox_lib') ~= 'started' then return end

Notify = Notify or {}

local isNotifySystem = (not BridgeClientConfig.NotifySystem) or BridgeClientConfig.NotifySystem == 'auto' or BridgeClientConfig.NotifySystem == 'ox'
local isHelpTextSystem = (not BridgeClientConfig.HelpTextSystem) or BridgeClientConfig.HelpTextSystem == 'auto' or BridgeClientConfig.HelpTextSystem == 'ox'



-- █▄ █ ▄▀▄ ▀█▀ █ █▀ ▀▄▀    ▄▀▀ ▀▄▀ ▄▀▀ ▀█▀ ██▀ █▄ ▄█ 
-- █ ▀█ ▀▄▀  █  █ █▀  █     ▄█▀  █  ▄█▀  █  █▄▄ █ ▀ █ 
if isHelpTextSystem and not isNotifySystem then goto HELP_TEXT_SYSTEM end
Notify.SendNotify = function(message, type, time)
    return exports.ox_lib:notify({ description = message, type = type, position = 'center-left' })
end


-- █▄█ ██▀ █   █▀▄    ▀█▀ ██▀ ▀▄▀ ▀█▀    ▄▀▀ ▀▄▀ ▄▀▀ ▀█▀ ██▀ █▄ ▄█ 
-- █ █ █▄▄ █▄▄ █▀      █  █▄▄ █ █  █     ▄█▀  █  ▄█▀  █  █▄▄ █ ▀ █ 
if not isHelpTextSystem then return end
    ::HELP_TEXT_SYSTEM::
Notify.ShowHelpText = function(message, _position)
    if _position == nil then _position = 'left-center' end
    return exports.ox_lib:showTextUI(message, { position = _position })
end

Notify.HideHelpText = function()
    return exports.ox_lib:hideTextUI()
end

--   .--------.
--   | taktak | 
--   |/-------' 
--   .-.  ,-.
--   ;oo  oo;
--  / \|  |/ \
-- |. `.  .' .|
-- `;.;'  `;.;'
-- .-^-.  .-^-. 
-- | | |  | | |



