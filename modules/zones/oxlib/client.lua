---@diagnostic disable: duplicate-set-field
local resourceName = "ox_lib"
if GetResourceState(resourceName) == 'missing' then return end
lib = lib or Require("init.lua", "ox_lib")
Ids = Ids or Require('lib/utility/shared/ids.lua')

cZones = {} --conflict with ox
cZones.All = {}
function cZones.Create(type, data)
    assert(type, "Requires zone type ('box', 'sphere', or 'poly')")
    assert(data, "Requires data table")
    data.id = Ids.CreateUniqueId(cZones.All)
    data.invoking = GetInvokingResource() or "unknown"

    local onEnter = data.onEnter or data.OnEnter
    local onExit = data.onExit or data.OnExit
    local zone = nil
    if type == "box" then
        assert(data.coords, "Requires .coords as vector3 in data")
        local width = data.size?.x or data.length or 1.0
        local height = data.size?.y or data.width or 1.0
        local z = data.size?.z or data.height or 1.0
        zone = lib.zones.box({
            coords = data.coords,
            size = vec3(width, height, z),
            rotation = data.heading or data.rotation or 0.0,
            debug = data.debug or false,
            onEnter = function(point)
                if onEnter then
                    onEnter(data)
                end
            end,
            onExit = function(point)
                if onExit then
                    onExit(data)
                end
            end,
        })
        data.zone = zone
        print("Created Zone: " .. data.id, json.encode(cZones.All))
        cZones.All[data.id] = data
        return data.id
    elseif type == "sphere" then
        assert(data.coords, "Requires .coords as vector3 in data")
        data.radius = data.radius or data.size?.x or 1
        lib.zones.sphere(data)
        local zone = lib.zones.sphere({
            coords = data.coords,
            radius = data.radius,
            debug = data.debug or false,
            onEnter = function(point)
                data.zone = data.zone or point
                if onEnter then
                    onEnter(data)
                end
            end,
            onExit = function(point)
                data.zone = data.zone or point
                if onExit then
                    onExit(data)
                end
            end,
        })
        data.zone = zone
        cZones.All[data.id] = data
        return data.id
    elseif type == "poly" then
        assert(data.points, "Requires an array of vector2 in .points")
        assert(#data.points > 2, "Requires at least three points in .points")
        local zSize = data.minZ or data.size?.z or data.height or data.thickness or 2

        local polyZone = lib.zones.poly({
            points = data.points,
            thickness = zSize,
            debug = data.debug or false,
            onEnter = function(point)
                data.zone = data.zone or point
                if onEnter then
                    onEnter(data)
                end
            end,
            onExit = function(point)
                data.zone = data.zone or point
                if onExit then
                    onExit(data)
                end
            end,
        })
        data.zone = polyZone
        cZones.All[data.id] = data
        return data.id
    end
    return nil
end

function cZones.Destroy(id)
    if not id then return false end
    local zone = cZones.All[id].zone
    if not zone then return false end
    zone:remove()
    cZones.All[id] = nil
    return true
end

function cZones.DestroyByResource(resource)
    if not resource then return false end
    for id, zone in pairs(cZones.All or {}) do
        if zone.invoking == resource then
            zone.zone:remove()
        end
    end
    return true
end

function cZones.Get(id)
    if not id then return nil end
    return cZones.All[id]
end

RegisterNetEvent("onResourceStop", function(resource)
    cZones.DestroyByResource(resource)
end)
