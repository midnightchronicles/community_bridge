if GetResourceState('qs-dispatch') ~= 'started' then return end

Dispatch = {}

Dispatch.SendAlert = function(data)
    local playerData = exports['qs-dispatch']:GetPlayerInfo()
    if not playerData then
        print("Error getting player data")
        return
    end

    local customData = {
        job = data.job or { 'police', 'sheriff', 'traffic', 'patrol' }, -- Job Names
        callLocation = data.coords or vec3(0.0, 0.0, 0.0),
        callCode = { 
            code = data.code or '10-80',    
            snippet = data.snippet or 'General Alert' 
        },
        message = data.message or "No message provided.",
        flashes = data.flash or false,
        image = data.image or nil,
        blip = {
            sprite = data.sprite or 1,
            scale = data.scale or 1.0,
            colour = data.color or 1,
            flashes = data.flash or false,
            text = data.blipText or "Alert",
            time = data.length and (data.length * 1000) or 20000 -- Default to 20 seconds
        },
        otherData = {
            {
                text = data.name or 'N/A',
                icon = data.icon or 'fas fa-question'
            }
        }
    }

    exports['qs-dispatch']:getSSURL(function(image)
        customData.image = image or customData.image
        TriggerServerEvent('qs-dispatch:server:CreateDispatchCall', customData)
    end)
end