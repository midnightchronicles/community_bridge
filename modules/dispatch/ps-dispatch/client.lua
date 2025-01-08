if GetResourceState('ps-dispatch') ~= 'started' then return end

Dispatch = {}

Dispatch.SendAlert = function(data)
    local customData = {
        message = data.message,
        code = data.code or '10-80',
        icon = data.icon or 'fas fa-question',
        priority = data.priority or 2,
        coords = data.coords or vec3(0.0, 0.0, 0.0),
        gender = data.gender or nil,
        camId = data.camId or nil,
        color = data.firstColor or nil,
        callsign = data.callsign or nil,
        name = data.name or nil,
        vehicle = data.model or nil,
        plate = data.plate or nil,
        alertTime = data.alertTime or nil,
        doorCount = data.doorCount or nil,
        automaticGunfire = data.automaticGunfire or false,
        alert = {
            radius = data.radius or 0,
            recipientList = data.job or { 'leo' },
            sprite = data.sprite or 1,
            color = data.color or 1,
            scale = data.scale or 0.5,
            length = data.length or 2,
            sound = data.sound or "Lose_1st",
            sound2 = data.sound2 or "GTAO_FM_Events_Soundset",
            offset = data.offset or false,
            flash = data.flash or false
        },
        jobs = { data.job or 'leo' }
    }
    exports["ps-dispatch"]:CustomAlert(customData)
end

--[[
-- tested, it worked
CreateThread(function()
    local data = {
        message = "Fart",
        code = '10-80',
        icon = 'fas fa-question',
        priority = 2,
        coords = vec3(0.0, 0.0, 0.0),
        gender = nil,
        camId = nil,
        color = nil,
        callsign = nil,
        name = "Test Name",
        vehicle = nil,
        plate = nil,
        alertTime = 30000,
        doorCount = nil,
        automaticGunfire = false,
        alert = {
            radius = 0,
            recipientList = { 'leo' },
            sprite = 1,
            color = 1,
            scale = 0.5,
            length = 2,
            sound = "Lose_1st",
            sound2 = "GTAO_FM_Events_Soundset",
            offset = false,
            flash = false
        },
        jobs = { 'leo' }
    }
    Dispatch.SendAlert(data)
    print("Dispatched")
end)
--]]