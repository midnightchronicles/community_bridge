---@diagnostic disable: duplicate-set-field
if GetResourceState('kartik-mdt') == 'missing' then return end
Dispatch = Dispatch or {}

Dispatch.SendAlert = function(data)
    local alertOptions = {
        title = data.message or "Alert",
        code = data.code or '10-80',
        description = data.message,
        type = "Alert",
        -- sound = "gunshots",
        coords = data.coords,
        blip = {
            radius = 100.0,
            sprite = data.blipData.sprite or 161,
            color = data.blipData.color or 1,
            scale = data.blipData.scale or 0.8,
            length = 2
        },
        jobs = data.jobs or {"police"},
    }
    exports['kartik-mdt']:CustomAlert(alertOptions)
end

return Dispatch