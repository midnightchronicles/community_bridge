Particle = {}

---Loads a ptfx asset into memory.
---@param dict string
---@return boolean
function LoadPtfxAsset(dict)
    local failed = 100
    while not HasNamedPtfxAssetLoaded(dict) and failed >= 0 do
        RequestNamedPtfxAsset(dict)
        failed = failed - 1
        Wait(100)
    end
    assert(failed > 0, "Failed to load dict asset: " .. dict)
    return HasNamedPtfxAssetLoaded(dict)
end


--- Create a particle effect at the specified position and rotation.
--- @param dict string
--- @param ptfx string
--- @param pos vector3
--- @param rot vector3
--- @param scale number
--- @param color vector3
--- @param looped boolean
--- @param loopLength number|nil
--- @return number|nil ptfxHandle -- The handle of the particle effect, or nil if it failed to create.
function Particle.Create(dict, ptfx, pos, rot, scale, color, looped, loopLength)
    LoadPtfxAsset(dict)
    UseParticleFxAssetNextCall(dict)
    SetParticleFxNonLoopedColour(color.x, color.y, color.z)
    local particle = nil
    if looped then
        particle = StartParticleFxLoopedAtCoord(ptfx, pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, scale, false, false, false, false)
        CreateThread(function()
            if loopLength then 
                Wait(loopLength)
                Particle.Remove(particle)
            end
        end)
    else
        particle = StartParticleFxNonLoopedAtCoord(ptfx, pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, scale, false, false, false, false)
    end

    return particle
end

function Particle.Remove(particle)
    if not particle then return end
    StopParticleFxLooped(particle, false)
    RemoveParticleFx(particle, false)
    RemoveNamedPtfxAsset(particle)

end

function Particle.CreateOnEntity(dict, ptfx, entity, offset, rot, scale, color, looped, loopLength)
    LoadPtfxAsset(dict)
    UseParticleFxAssetNextCall(dict)
    SetParticleFxNonLoopedColour(color.x, color.y, color.z)
    local particle = nil
    if looped then
        particle = StartNetworkedParticleFxLoopedOnEntity(ptfx, entity, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, scale, false, false, false)
        if loopLength then
            Wait(loopLength)
            RemoveParticleFxFromEntity(entity)
        end
    else
        particle = StartNetworkedParticleFxLoopedOnEntity(ptfx, entity, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, scale, false, false, false)
    end
    RemoveNamedPtfxAsset(ptfx)
    return particle
end

function Particle.CreateOnEntityBone(dict, ptfx, entity, bone,  offset, rot, scale, color, looped, loopLength)
    LoadPtfxAsset(dict)
    UseParticleFxAssetNextCall(dict)
    SetParticleFxNonLoopedColour(color.x, color.y, color.z)
    local particle = nil
    if looped then
        particle = StartNetworkedParticleFxLoopedOnEntityBone(ptfx, entity, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, bone, scale, false, false, false)
        if loopLength then
            Wait(loopLength)
            RemoveParticleFxFromEntity(entity)
        end
    else
        particle = StartNetworkedParticleFxNonLoopedOnEntityBone(ptfx, entity, offset.x, offset.y, offset.z, rot.x, rot.y, rot.z, bone, scale, false, false, false)
    end
    RemoveNamedPtfxAsset(ptfx)
    return particle
end

return Particle