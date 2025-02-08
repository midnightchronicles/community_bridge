Dispatch = Dispatch or {}

Dispatch.SendAlert = function(data)
    TriggerServerEvent('community_bridge:Server:DispatchAlert', {
        sprite = data.blipData.sprite or 161,
        color = data.blipData.color or 1,
        scale = data.blipData.scale or 0.8,
        vehicle = data.vehicle or nil,
        plate = data.vehicle and GetVehicleNumberPlateText(data.vehicle) or nil,
        ped = data.ped or cache.ped,
        pedCoords = data.pedCoords or GetEntityCoords(cache.ped),
        coords = data.coords or GetEntityCoords(cache.ped),
        message = data.message or "An Alert Has Been Made",
        code = data.code or '10-80',
        icon = data.icon or 'fas fa-question',
        jobs = data.jobs or {'police'},
        time = data.time or 100000
    })
end

RegisterNetEvent('community_bridge:Client:DispatchAlert', function(alert)
    Notify.SendNotify(alert.message, "success", 15000)
    local blip = Bridge.Utility.CreateBlip(alert.coords, alert.blipData.sprite, alert.blipData.color, alert.blipData.scale, alert.code, true)
	Wait(alert.time)
    Bridge.Utility.RemoveBlip(blip)
end)

--[[
RegisterCommand('testalert', function(source, args)
    print('sending alert')
    local ped = cache.ped
    local vehicle = cache.vehicle
    Dispatch.SendAlert({
        vehicle = vehicle or nil,
        plate = vehicle and GetVehicleNumberPlateText(vehicle) or nil,
        ped = ped,
        pedCoords = ped and GetEntityCoords(ped),
        coords = GetEntityCoords(ped),
        blipData = {
            sprite = 161,
            color = 1,
            scale = 0.8,
        },
        message = "Vehicle is being stolen",
        code = '10-80',
        icon = 'fas fa-question',
        jobs = {'police'},
        alertTime = 10
    })
end, false)
--]]