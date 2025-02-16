
function CreateParticleFX(dict, ptfx, pos, rot, scale, color, looped, loopLength)
    CreateThread(function()
        local failed = 5
        while not HasNamedPtfxAssetLoaded(dict) and failed >= 0 do
            RequestNamedPtfxAsset(ptfx)
            failed = failed - 1
            Wait(0)
        end

        UseParticleFxAssetNextCall(dict)
        SetParticleFxNonLoopedColour(color.x, color.y, color.z)
        if looped then
            StartParticleFxLoopedAtCoord(ptfx, pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, scale, false, false, false, false)
            Wait(loopLength)
            RemoveParticleFxInRange(pos.x, pos.y, pos.z, 0.01)
        else
            StartParticleFxNonLoopedAtCoord(ptfx, pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, scale, false, false, false, false)
        end
        RemoveNamedPtfxAsset(ptfx)
    end)
end

function CreateParticleFXOnEntityBone(dict, ptfx, entity, bone,  offset, rot, scale, color, looped, loopLength)
    local failed = 5
    while not HasNamedPtfxAssetLoaded(dict) and failed >= 0 do
        RequestNamedPtfxAsset(ptfx)
        failed = failed - 1
        Wait(0)
    end

    UseParticleFxAssetNextCall(dict)
    SetParticleFxNonLoopedColour(color.x, color.y, color.z)
    local bleh = nil
    if looped then
        bleh = StartNetworkedParticleFxLoopedOnEntityBone(ptfx, entity, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, bone, scale, false, false, false)
        if loopLength then
            Wait(loopLength)
            RemoveParticleFxFromEntity(entity)
        end
    else
        bleh = StartNetworkedParticleFxNonLoopedOnEntityBone(ptfx, entity, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, bone, scale, false, false, false)
    end
    RemoveNamedPtfxAsset(ptfx)
    return bleh
end



function PlayParticleFX(dict, name, looped, x, y, z, rotX, rotY, rotZ, scale)
    RequestNamedPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
        Wait(0)
    end
    SetPtfxAssetNextCall(dict)
    UseParticleFxAssetNextCall(dict)
    local particle = nil
    if looped then
        particle = StartParticleFxLoopedAtCoord(name, x, y, z , rotX, rotY, rotZ, scale)
    else
        particle = StartParticleFxNonLoopedAtCoord(name, x, y, z, rotX, rotY, rotZ, scale, false, false, false)
    end
    return particle
end