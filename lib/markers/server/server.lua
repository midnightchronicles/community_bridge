---@diagnostic disable: duplicate-set-field
local id = Ids or Require("lib/utility/shared/ids.lua")
Marker = {}
local Created = {}

function Marker.Create(data)
    if not data.position or not data.position.x or not data.position.y or not data.position.z then
        print("Invalid marker position. Must be a vector3 with x, y, and z coordinates.")
        return
    end
    if data.offset and (not data.offset.x or not data.offset.y or not data.offset.z) then
        print("Invalid marker offset. Must be a vector3 with x, y, and z coordinates.")
        return
    end
    if data.rotation and (not data.rotation.x or not data.rotation.y or not data.rotation.z) then
        print("Invalid marker rotation. Must be a vector3 with x, y, and z coordinates.")
        return
    end

    if not data.size or not data.size.x or not data.size.y or not data.size.z then
        print("Invalid marker size. Must be a vector3 with x, y, and z dimensions.")
        return
    end

    local _id = data.id or id.CreateUniqueId(Created)
    local data = {
        id = _id,
        position = data.position,
        offset = data.offset or vector3(0.0, 0.0, 0.0),
        marker = data.marker or 1,
        rotation = data.rotation or vector3(0, 0, 0),
        size = data.size or vector3(1.0, 1.0, 1.0),
        color = data.color or vector3(0, 255, 0),
        alpha = data.alpha or 255,
        bobUpAndDown = data.bobUpAndDown,
        -- interaction = data.interaction or false, -- Uncomment if you re-implement interaction logic
        rotate = data.rotate,
        textureDict = data.textureDict,
        textureName = data.textureName,
        drawOnEnts = data.drawOnEnts,
    }
    Created[_id] = data
    TriggerClientEvent("community_bridge:Client:Marker", -1, data)
    return _id
end

function Marker.Remove(id)
    if not Created[id] then return end
    TriggerClientEvent("community_bridge:Client:MarkerRemove", -1, id)
    Created[id] = nil
end

RegisterNetEvent("community_bridge:Server:MarkerRemove", function(id)
    Marker.Remove(id)
end)

exports("Marker", Marker)
return Marker
