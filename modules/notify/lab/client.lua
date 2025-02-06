if GetResourceState('lab-HintUI') ~= 'started' then return end
if BridgeClientConfig.HelpTextSystem and (BridgeClientConfig.HelpTextSystem ~= 'auto' and BridgeClientConfig.HelpTextSystem ~= 'lab') then return end 

Notify = Notify or {}

Notify.ShowHelpText = function(message, _position)
    return exports['lab-HintUI']:Show(message, "Hint Text")
end

Notify.HideHelpText = function()
    return exports['lab-HintUI']:Hide()    
end
