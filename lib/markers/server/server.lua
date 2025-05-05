local function RegisterNewMarker(data)
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

    TriggerClientEvent("community_bridge:client:marker", source, data)
end

RegisterNetEvent("community_bridge:server:createMarker", RegisterNewMarker)
exports("RegisterNewMarker", RegisterNewMarker)
