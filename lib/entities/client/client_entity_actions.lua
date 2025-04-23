local LA = LA or Require("lib/utility/shared/la.lua")
local ActionThreads = {} -- Store running action threads { [entityId] = thread }

ClientEntityActions = {}

--- Makes a ped entity walk to specified coordinates.
-- @param entityData table The entity data containing the spawned ped handle.
-- @param coords vector3 The target coordinates.
-- @param speed number Movement speed.
-- @param timeout number Timeout in ms.
function ClientEntityActions.WalkTo(entityData, coords, speed, timeout)
    local entity = entityData.spawned
    if not entity or not DoesEntityExist(entity) or not IsEntityAPed(entity) then return end

    -- Clear any existing task for this entity
    if ActionThreads[entityData.id] then
        -- Potentially stop the old thread if needed, depending on desired behavior
        ClearPedTasks(entity)
    end

    local thread = CreateThread(function()
        TaskGoToCoordAnyMeans(entity, coords.x, coords.y, coords.z, speed or 1.0, 0, false, 786603, timeout or -1)
        -- Wait until task is completed or entity is despawned
        while GetScriptTaskStatus(entity, 288358301) ~= 7 and entityData.spawned == entity and DoesEntityExist(entity) do
            Wait(500)
        end
        ActionThreads[entityData.id] = nil -- Clear thread reference when done/stopped
    end)
    ActionThreads[entityData.id] = thread
end

--- Lerps an entity's position over time.
-- @param entityData table The entity data containing the spawned entity handle.
-- @param targetCoords vector3 The target coordinates.
-- @param duration number Duration of the lerp in milliseconds.
-- @param easingType string (Optional) Easing function name from LA library (e.g., "linear", "sine").
-- @param easingDirection string (Optional) "in", "out", or "inout".
function ClientEntityActions.LerpTo(entityData, targetCoords, duration, easingType, easingDirection)
    local entity = entityData.spawned
    if not entity or not DoesEntityExist(entity) then return end

    local startCoords = GetEntityCoords(entity)
    local startTime = GetGameTimer()
    easingType = easingType or "linear"
    easingDirection = easingDirection or "inout"

    -- Clear any existing lerp for this entity
    if ActionThreads[entityData.id] then
        -- Stop the old thread if needed
    end

    local thread = CreateThread(function()
        while GetGameTimer() < startTime + duration do
            -- Check if entity still exists and is the same one we started with
            if not entityData.spawned or entityData.spawned ~= entity or not DoesEntityExist(entity) then
                break -- Stop if entity despawned or changed
            end

            local elapsed = GetGameTimer() - startTime
            local t = LA.Clamp(elapsed / duration, 0.0, 1.0)
            local easedT = LA.EaseInOut(t, easingType) -- Default to EaseInOut if direction not specified or invalid

            if easingDirection == "in" then
                easedT = LA.EaseIn(t, easingType)
            elseif easingDirection == "out" then
                easedT = LA.EaseOut(t, easingType)
            end

            local currentPos = LA.LerpVector(startCoords, targetCoords, easedT)
            SetEntityCoordsNoOffset(entity, currentPos.x, currentPos.y, currentPos.z, false, false, false)
            Wait(0)
        end

        -- Ensure final position if completed fully
        if entityData.spawned == entity and DoesEntityExist(entity) then
             SetEntityCoordsNoOffset(entity, targetCoords.x, targetCoords.y, targetCoords.z, false, false, false)
        end
        ActionThreads[entityData.id] = nil -- Clear thread reference
    end)
    ActionThreads[entityData.id] = thread
end

--- Stops any ongoing action for a specific entity.
-- @param entityId string|number The ID of the entity.
function ClientEntityActions.StopAction(entityId)
    if ActionThreads[entityId] then
        -- Stopping Lua threads directly isn't safe/possible.
        -- Instead, rely on checks within the thread loops (e.g., entityData.spawned check)
        -- For peds, we can clear tasks.
        local entityData = ClientEntity.Get(entityId) -- Assumes ClientEntity is accessible or passed in
        if entityData and entityData.spawned and DoesEntityExist(entityData.spawned) then
            if IsEntityAPed(entityData.spawned) then
                ClearPedTasks(entityData.spawned)
            end
            -- Other entity types might need different stop logic if applicable
        end
        ActionThreads[entityId] = nil -- Clear reference to let the thread terminate naturally
    end
end

return ClientEntityActions
