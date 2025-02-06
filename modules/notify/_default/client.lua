Notify = Notify or {}

Notify.SendNotify = function(message, type, time)
    Utility.NotifyText(message)
end
      

Notify.ShowHelpText = function(message, _position)
    Utility.HelpText(message, 7000)
end

Notify.HideHelpText = function()   
   
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