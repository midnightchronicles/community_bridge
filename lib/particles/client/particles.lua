Particle = {}
Particles = {}


--- Load a particle dictionary. This function will block until the dictionary is loaded.
--- @param dict string -- The name of the particle dictionary to load.
--- @return boolean -- Returns true if the dictionary was loaded successfully, false otherwise.
--- @throws string -- Throws an error if the dictionary fails to load after 100 attempts.
function Particle.LoadDict(dict)
    RequestNamedPtfxAsset(dict)
    local failed = 100
    while not HasNamedPtfxAssetLoaded(dict) and failed >= 0 do
        failed = failed - 1
        Wait(50)
    end
    assert(failed >= 0, "Failed to load particle dictionary: " .. dict)
    return true
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
    if not Particle.LoadDict(dict) then return end
    UseParticleFxAssetNextCall(dict)
    local handle = nil
    if looped then
        handle = StartParticleFxLoopedAtCoord(ptfx, pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, scale, false, false, false, false)
        SetParticleFxLoopedColour(handle, color.x, color.y, color.z, false)
        if loopLength then
            Wait(loopLength)
            StopParticleFxLooped(handle, 0)
            RemoveParticleFx(handle, false)
        end
    else
        SetParticleFxNonLoopedColour(color.x, color.y, color.z)
        handle = StartParticleFxNonLoopedAtCoord(ptfx, pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, scale, false, false, false)
        RemoveParticleFx(handle, false)
    end
    return handle
end

-- need to add looping effects (regarless of if its a looped particle or not)


return Particle