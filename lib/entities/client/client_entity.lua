Utility = Utility or Require("lib/utility/client/utility.lua")
Ids = Ids or Require("lib/utility/shared/ids.lua")
Point = Point or Require("lib/points/client/points.lua")
ClientEntityActions = ClientEntityActions or Require("lib/entities/client/client_entity_actions.lua") -- Added

local Entities = {} -- Stores entity data received from server
ClientEntity = {} -- Renamed from BaseEntity

local function SpawnEntity(entityData)
    entityData = entityData and entityData.args
    if entityData.spawned and DoesEntityExist(entityData.spawned) then return end -- Already spawned
    -- for k, v in pairs(entityData.args) do
    --     print(string.format("SpawnEntity %s: %s", k, v))
    -- end
    local model = entityData.model and type(entityData.model) == 'string' and GetHashKey(entityData.model) or entityData.model
    if not Utility.LoadModel(model) then
        print(string.format("[ClientEntity] Failed to load model %s for entity %s", entityData.model, entityData.id))
        return
    end

    local entity = nil
    local coords = entityData.coords
    local rotation = entityData.rotation

    if entityData.entityType == 'object' then
        entity = CreateObject(model, coords.x, coords.y, coords.z, false, false, false)
        SetEntityRotation(entity, rotation.x, rotation.y, rotation.z, 2, true)
    elseif entityData.entityType == 'ped' then
        entity = CreatePed(4, model, coords.x, coords.y, coords.z, type(rotation) == 'number' and rotation or rotation.z, false, false)
        -- Apply ped specific settings from entityData.meta if needed
    elseif entityData.entityType == 'vehicle' then
        entity = CreateVehicle(model, coords.x, coords.y, coords.z, type(rotation) == 'number' and rotation or rotation.z, false, false)
        -- Apply vehicle specific settings from entityData.meta if needed
    else
        print(string.format("[ClientEntity] Unknown entity type '%s' for entity %s", entityData.entityType, entityData.id))
    end
    if entity then
        entityData.spawned = entity
        SetModelAsNoLongerNeeded(model)
        SetEntityAsMissionEntity(entity, true, true) -- Keep entity from being deleted by game engine
        FreezeEntityPosition(entity, entityData.freeze or false) -- Optional freeze based on meta
        if entityData.OnSpawn and type(entityData.OnSpawn) == 'function' then
            entityData.OnSpawn(entityData)
        end
        -- print(string.format("[ClientEntity] Spawned %s entity %s (GameID: %s)", entityData.entityType, entityData.id, entity))
    else
        SetModelAsNoLongerNeeded(model)
    end
end

local function RemoveEntity(entityData)
    entityData = entityData and entityData.args
    if not entityData then return end -- Added safety check

    ClientEntityActions.StopAction(entityData.id) -- Stop any ongoing action before despawning

    if entityData.spawned and DoesEntityExist(entityData.spawned) then
        local entityHandle = entityData.spawned
        entityData.spawned = nil -- Clear handle first
        SetEntityAsMissionEntity(entityHandle, false, false) -- Allow game engine to delete if needed, though we delete manually
        DeleteEntity(entityHandle)
        -- print(string.format("[ClientEntity] Removed %s entity %s (GameID: %s)", entityData.entityType, entityData.id, entityHandle))
    end
    if entityData.OnRemove and type(entityData.OnRemove) == 'function' then
        entityData.OnRemove(entityData)
    end
end

--- Registers an entity received from the server and sets up proximity spawning.
-- @param entityData table Data received from the server via 'community_bridge:client:CreateEntity'
function ClientEntity.Register(entityData)
    if Entities[entityData.id] then return end -- Already registered

    Entities[entityData.id] = entityData
    -- print(string.format("[ClientEntity] Registering %s entity %s", entityData.entityType, entityData.id))

    -- Use Point system for proximity checks
    Point.Register(entityData.id, entityData.coords, entityData.spawnDistance or 50.0, entityData, SpawnEntity, RemoveEntity, function() end)
end

--- Unregisters an entity and removes it from the world if spawned.
-- @param id string|number The ID of the entity to unregister.
function ClientEntity.Unregister(id)
    local entityData = Entities[id]
    if not entityData then return end

    -- print(string.format("[ClientEntity] Unregistering entity %s", id))
    Point.Remove(id) -- Remove from proximity checks (this will call RemoveEntity if currently in range)
    RemoveEntity(entityData) -- Ensure it's removed even if Point.Remove didn't trigger it
    Entities[id] = nil
end

--- Updates the data for a registered entity.
-- @param id string|number The ID of the entity to update.
-- @param data table The data fields to update.
function ClientEntity.Update(id, data)
    local entityData = Entities[id]
    print(string.format("[ClientEntity] Updating entity %s", id))
    if not entityData then return end

    local needsPointUpdate = false
    for key, value in pairs(data) do
        if key == 'coords' and #(entityData.coords - value) > 0.1 then
            print(string.format("[ClientEntity] Updating coords for entity %s", id))
             needsPointUpdate = true
        end
        if key == 'spawnDistance' and entityData.spawnDistance ~= value then
             needsPointUpdate = true
        end
        entityData[key] = value
    end

    -- If entity is currently spawned, apply updates
    if entityData.spawned and DoesEntityExist(entityData.spawned) then
        if data.coords then
            SetEntityCoords(entityData.spawned, entityData.coords.x, entityData.coords.y, entityData.coords.z, false, false, false, true)
        end
        if data.rotation then
             if entityData.entityType == 'object' then
                 SetEntityRotation(entityData.spawned, entityData.rotation.x, entityData.rotation.y, entityData.rotation.z, 2, true)
             else -- Ped/Vehicle heading
                 SetEntityHeading(entityData.spawned, type(entityData.rotation) == 'number' and entityData.rotation or entityData.rotation.z)
             end
        end
        if data.freeze ~= nil then
            FreezeEntityPosition(entityData.spawned, data.freeze)
        end
        -- Add other updatable properties as needed
    end

    -- Update Point registration if coords or distance changed
    if needsPointUpdate then
        Point.Remove(id)
        Point.Register(
            entityData.id,
            entityData.coords,
            entityData.spawnDistance or 50.0,
            SpawnEntity,
            RemoveEntity,
            nil,
            entityData
        )
    end

    if entityData.OnUpdate and type(entityData.OnUpdate) == 'function' then
        entityData.OnUpdate(entityData, data)
    end
end

function ClientEntity.Get(id)
    return Entities[id]
end

function ClientEntity.GetAll()
    return Entities
end

-- Network Event Handlers
RegisterNetEvent("community_bridge:client:CreateEntity", function(entityData)
    ClientEntity.Register(entityData)
end)

RegisterNetEvent("community_bridge:client:DeleteEntity", function(id)
    ClientEntity.Unregister(id)
end)

RegisterNetEvent("community_bridge:client:UpdateEntity", function(id, data)
    ClientEntity.Update(id, data)
end)

-- New handler for entity actions
RegisterNetEvent("community_bridge:client:TriggerEntityAction", function(entityId, actionName, ...)
    local entityData = Entities[entityId]
    -- Check if entity exists locally AND is currently spawned
    if entityData and entityData.spawned and DoesEntityExist(entityData.spawned) then
        local actionFunc = ClientEntityActions[actionName]
        if actionFunc and type(actionFunc) == 'function' then
            -- print(string.format("[ClientEntity] Executing action '%s' for entity %s", actionName, entityId))
            actionFunc(entityData, ...) -- Pass entityData and any additional arguments
        else
            print(string.format("[ClientEntity] Received unknown action '%s' for entity %s", actionName, entityId))
        end
    -- else
        -- Optional: Log if action received but entity not spawned locally
        -- print(string.format("[ClientEntity] Received action '%s' for entity %s, but entity not spawned locally.", actionName, entityId))
    end
end)

-- Resource Stop Cleanup
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        for id, entityData in pairs(Entities) do
            Point.Remove(id) -- Clean up point registration
            RemoveEntity(entityData) -- Clean up spawned game entity
        end
        Entities = {} -- Clear local cache
    end
end)

return ClientEntity
