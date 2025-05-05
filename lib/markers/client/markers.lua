Marker = {

}
local Created = setmetatable({}, { __mode = "k" })
local id = Require("lib/utility/shared/ids")

--- This will validate the marker data.
--- @param data table{position: vector3, offset: vector3, rotation: vector3, size: vector3, color: vector3, alpha: number, bobUpAndDown: boolean, marker: number, interaction: function}
--- @return boolean
local function validateMarkerData(data)
    if not data.position or not data.position.x or not data.position.y or not data.position.z then
        print("Invalid marker position. Must be a vector3 with x, y, and z coordinates.")
        return false
    end
    if data.offset and (not data.offset.x or not data.offset.y or not data.offset.z) then
        print("Invalid marker offset. Must be a vector3 with x, y, and z coordinates.")
        return false
    end
    if data.rotation and (not data.rotation.x or not data.rotation.y or not data.rotation.z) then
        print("Invalid marker rotation. Must be a vector3 with x, y, and z coordinates.")
        return false
    end
    return true
end

AddEventHandler("community_bridge:client:marker", function(data)
    if not validateMarkerData(data) then return end
    if source == "" then return end
    Marker.DrawMarker(data)
end)

--- This will create a marker.
--- @param data table{position: vector3, offset: vector3, rotation: vector3, size: vector3, color: vector3, alpha: number, bobUpAndDown: boolean, marker: number, interaction: function}
---@return number
function Marker.DrawMarker(data)
    local _id = data.id or id.Random()
    local position = data.position or vector3(0.0, 0.0, 0.0)
    local offset = data.offset or vector3(0.0, 0.0, 0.0)
    local marker = data.marker or 1
    local pos = vector3(position.x + offset.x, position.y + offset.y, position.z + offset.z)
    local rotation = data.rotation or vector3(0, 0, 0)
    local size = data.size or vector3(1.0, 1.0, 1.0)
    local color = data.color or vector3(0, 255, 0)
    local alpha = data.alpha or 255
    local bobUpAndDown = data.bobUpAndDown
    local interaction = data.interaction or false
    Created[_id] = {
        position = pos,
        rotation = rotation,
        size = size,
        color = color,
        alpha = alpha,
        bobUpAndDown =
            bobUpAndDown,
        marker = marker,
        offset = offset,
        interaction = interaction,
        id = _id,
    }
    return _id
end

function Marker.RemoveMarker(id)
    if Created[id] then
        Created[id] = nil
        return true
    end
    return false
end

function Marker.Draw()
    while true do
        Wait(0)
        if not next(Created) then
            Wait(1000) -- Reduce CPU usage when no markers are present
            goto continue
        end

        for id, _ in pairs(Created) do
            if Created[id] then
                local data = Created[id]
                if #(data.position - GetEntityCoords(PlayerPedId())) > 100.0 then
                    goto continue
                else
                    DrawMarker(
                        data.marker,
                        data.position.x, data.position.y, data.position.z,
                        0.0, 0.0, 0.0,
                        data.rotation.x, data.rotation.y, data.rotation.z,
                        data.size.x, data.size.y, data.size.z,
                        data.color.x, data.color.y, data.color.z, data.alpha,
                        data.bobUpAndDown, false, false
                    )
                    if data.interaction then
                        local playerCoords = GetEntityCoords(PlayerPedId())
                        local distance = #(data.position - playerCoords)
                        if distance < 2.0 then
                            if IsControlJustReleased(0, 38) then -- E key
                                data.interaction(data.id)
                            end
                        end
                    end
                end
            end
        end
        ::continue::
    end
end

Marker.Draw() -- Start the marker drawing loop
exports("Marker", Marker)


return Marker
