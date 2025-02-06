if GetResourceState('jg-textui') ~= 'started' then return end
if BridgeClientConfig.HelpTextSystem and (BridgeClientConfig.HelpTextSystem ~= 'auto' and BridgeClientConfig.HelpTextSystem ~= 'jg') then return end 
Notify = Notify or {}

Notify.ShowHelpText = function(message, _position)
    return exports['jg-textui']:DrawText(message)  
end

Notify.HideHelpText = function()   
    return exports['jg-textui']:HideText()
end
