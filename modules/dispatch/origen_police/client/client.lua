---@diagnostic disable: duplicate-set-field
if GetResourceState('origen_police') == 'missing' then return end
Dispatch = Dispatch or {}

Dispatch.SendAlert = function(data)
    local customData = {
        coords = data.coords or vector3(0.0, 0.0, 0.0),
        title = 'Alert '..(data.code or '10-80'),
        message = data.message,
        job = data.jobs or 'police',
        metadata = {
            model = data.vehicle and (GetDisplayNameFromVehicleModel(GetEntityModel(data.vehicle))) or nil,
            color = {255, 255, 255},
            plate = data.vehicle and GetVehicleNumberPlateText(data.vehicle) or nil,
            speed = data.vehicle and (GetEntitySpeed(veh) * 3.6)..' kmh' or nil
        }
    }

    TriggerServerEvent("SendAlert:police", customData)
end

return Dispatch