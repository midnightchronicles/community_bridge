Scaleform = Scaleform or Require("lib/scaleform/client/scaleform.lua")
Utility = Utility or Require("lib/utility/client/utility.lua")
Raycast = Raycast or Require("lib/raycast/client/raycast.lua")
Language = Language or Require("modules/locales/shared.lua")

PlaceableObject = PlaceableObject or {}

-- Local variables
local isPlacing = false
local currentEntity = nil
local currentMode = 'normal' -- 'normal' or 'movement'
local currentPromise = nil -- Store the current promise

-- Utility functions
local function eyetrace(depth, disableSphere)
    local screenX = GetDisabledControlNormal(0, 239)
    local screenY = GetDisabledControlNormal(0, 240)

    local world, normal = GetWorldCoordFromScreenCoord(screenX, screenY)
    local playerPos = GetEntityCoords(PlayerPedId())
    local target = playerPos + normal * depth
    if not disableSphere then
        DrawSphere(target.x, target.y, target.z, 0.5, 255, 0, 0, 0.5)
    end
    return target
end

local function inBoundary(pos, boundary)
    if not boundary then return true end
    local x, y, z = table.unpack(pos)
    local minX, minY, minZ = table.unpack(boundary.min)
    local maxX, maxY, maxZ = table.unpack(boundary.max)
    return x >= minX and x <= maxX and y >= minY and y <= maxY and z >= minZ and z <= maxZ
end

local function checkBoundaryAndMaterials(entity, settings)
    local inBounds = true
    if settings.allowedMats or settings.boundary then
        CreateThread(function()
            while isPlacing do
                local hit, _, coords, _, materialHash

                if currentMode == 'movement' then
                    local entityCoords = GetEntityCoords(entity)
                    local destination = entityCoords - vector3(0, 0, settings.maxDepth or 10)
                    hit, _, coords, _, materialHash = Raycast.ToCoords(entityCoords, destination, 1, 4)
                else
                    hit, _, coords, _, materialHash = Raycast.FromCamera(1, 4)
                end

                local validMaterial = not settings.allowedMats or settings.allowedMats[materialHash]
                local validBoundary = inBoundary(GetEntityCoords(entity), settings.boundary)

                if hit and hit ~= 1 and validMaterial and validBoundary then
                    if not inBounds then
                        inBounds = true
                        SetEntityDrawOutlineColor(0, 255, 0, 255)
                        SetEntityDrawOutline(entity, true)
                    end
                elseif inBounds then
                    inBounds = false
                    SetEntityDrawOutline(entity, false)
                end
                Wait(500)
            end
            SetEntityDrawOutline(entity, false)
        end)
    end
    return function() return inBounds end
end

local function setupInstructionalButtons(settings)
    local buttons = {
        {type = "CLEAR_ALL"},
        {type = "SET_CLEAR_SPACE", int = 200},
    }

    -- Common buttons
    table.insert(buttons, {type = "SET_DATA_SLOT", name = settings.config?.place_object?.name or 'Place Object:', keyIndex = settings.config?.place_object?.key or {223}, int = 5})
    table.insert(buttons, {type = "SET_DATA_SLOT", name = settings.config?.cancel_placement?.name or 'Cancel Placement:', keyIndex = settings.config?.cancel_placement?.key or {222}, int = 4})

    if currentMode == 'normal' then
        table.insert(buttons, {type = "SET_DATA_SLOT", name = settings.config?.snap_to_ground?.name or 'Snap to Ground:', keyIndex = settings.config?.snap_to_ground?.key or {19}, int = 1})
        table.insert(buttons, {type = "SET_DATA_SLOT", name = settings.config?.rotate?.name or 'Rotate:', keyIndex = settings.config?.rotate?.key or {14, 15}, int = 2})
        table.insert(buttons, {type = "SET_DATA_SLOT", name = settings.config?.distance?.name or 'Distance:', keyIndex = settings.config?.distance?.key or {14,15,36}, int = 3})
        table.insert(buttons, {type = "SET_DATA_SLOT", name = settings.config?.toggle_placement?.name or 'Toggle Placement:', keyIndex = settings.config?.toggle_placement?.key or {199}, int = 0})

        -- Add vertical controls if allowed
        if settings.allowVertical then
            table.insert(buttons, {type = "SET_DATA_SLOT", name = 'Move Up/Down:', keyIndex = {85, 48}, int = 8})
        end

        if settings.allowMovement then
            table.insert(buttons, {type = "SET_DATA_SLOT", name = settings.config?.movement?.name or 'Toggle Movement Mode:', keyIndex = settings.config?.movement?.key or {38}, int = 6})
        end
    elseif currentMode == 'movement' then
        table.insert(buttons, {type = "SET_DATA_SLOT", name = 'Move Forward/Back:', keyIndex = {32, 33}, int = 1})
        table.insert(buttons, {type = "SET_DATA_SLOT", name = 'Move Left/Right:', keyIndex = {34, 35}, int = 2})
        table.insert(buttons, {type = "SET_DATA_SLOT", name = 'Move Up/Down:', keyIndex = {85, 48}, int = 3})
        table.insert(buttons, {type = "SET_DATA_SLOT", name = 'Rotate Left/Right:', keyIndex = {174, 175}, int = 4})
        table.insert(buttons, {type = "SET_DATA_SLOT", name = 'Snap to Ground:', keyIndex = {19}, int = 5})
        table.insert(buttons, {type = "SET_DATA_SLOT", name = 'Confirm (Enter):', keyIndex = {191}, int = 6})

        if settings.allowNormal then
            table.insert(buttons, {type = "SET_DATA_SLOT", name = 'Normal Mode:', keyIndex = {38}, int = 7})
        end
    end

    table.insert(buttons, {type = "DRAW_INSTRUCTIONAL_BUTTONS"})
    table.insert(buttons, {type = "SET_BACKGROUND_COLOUR"})

    return Scaleform.SetupInstructionalButtons(buttons)
end

local function normalPlacementLoop(entity, settings, getBoundsStatus)
    -- Initialize or retrieve from settings to maintain state
    settings.currentDepth = settings.currentDepth or settings.depth or 10.0
    settings.currentHeading = settings.currentHeading or -GetEntityHeading(PlayerPedId())
    settings.currentHeight = settings.currentHeight or 0.0 -- Add height tracking
    settings.placeOnGround = settings.placeOnGround ~= nil and settings.placeOnGround or not settings.allowVertical -- Default based on allowVertical
    settings.paused = settings.paused or false

    local depth = settings.currentDepth
    local heading = settings.currentHeading
    local height = settings.currentHeight
    local placeOnGround = settings.placeOnGround
    local paused = settings.paused
    local pos

    -- Don't use while loop here, just process one frame
    if not isPlacing or currentMode ~= 'normal' then
        return
    end

    if paused then
        if IsControlJustPressed(0, 199) then -- home
            paused = not paused
            settings.paused = paused
        end
        return
    end

    -- Disable controls
    DisableControlAction(0, 24, true) -- Attack
    DisableControlAction(0, 25, true) -- Aim
    DisableControlAction(0, 36, true) -- INPUT_DUCK

    -- Place object (left click)
    if IsDisabledControlJustPressed(0, 223) then
        if not getBoundsStatus() then
            print(Language.Locale("placeable_object.cant_place_here"))
        else
            pos = GetEntityCoords(entity)
            isPlacing = false
            if currentPromise then
                currentPromise:resolve({
                    entity = entity,
                    position = pos,
                    heading = heading
                })
                currentPromise = nil
            end
            DeleteEntity(entity)
            return
        end
    end

    -- Cancel (right click)
    if IsDisabledControlJustPressed(0, 25) then
        isPlacing = false
        if currentPromise then
            currentPromise:resolve(nil) -- Return nil for cancel
            currentPromise = nil
        end
        DeleteEntity(entity)
        return
    end

    -- Toggle snap to ground (Alt)
    if IsControlJustPressed(0, 19) then
        if settings.allowVertical then
            placeOnGround = not placeOnGround
            settings.placeOnGround = placeOnGround
            if placeOnGround then
                height = 0.0 -- Reset height when snapping to ground
                settings.currentHeight = height
            end
        else
            -- Force snap to ground if vertical movement not allowed
            PlaceObjectOnGroundProperly(entity)
        end
    end

    -- Switch to movement mode
    if settings.allowMovement and IsControlJustPressed(0, 38) then
        currentMode = 'movement'
        return
    end

    -- Vertical controls (only if allowVertical is enabled and not snapped to ground)
    if settings.allowVertical and not placeOnGround then
        if IsControlPressed(0, 85) then -- Q - Move up
            height = height + (settings.heightStep or 0.1)
            settings.currentHeight = height
        elseif IsControlPressed(0, 48) then -- Z - Move down
            height = height - (settings.heightStep or 0.1)
            settings.currentHeight = height
        end
    end

    -- Depth and rotation controls
    if IsControlPressed(0, 224) then -- left ctrl
        if IsControlJustPressed(0, 15) then -- D key
            depth = math.min(depth + settings.depthStep, settings.depthMax)
        elseif IsControlJustPressed(0, 14) then -- A key
            depth = math.max(depth - settings.depthStep, settings.depthMin)
        end
    else
        if IsControlJustPressed(0, 15) then -- D key
            heading = (heading + settings.rotationStep) % 360
        elseif IsControlJustPressed(0, 14) then -- A key
            heading = (heading - settings.rotationStep) % 360
        end
    end

    -- Update position
    pos = eyetrace(depth, settings.disableSphere)

    -- Add height offset if not snapping to ground
    if settings.allowVertical and not placeOnGround then
        pos = pos + vector3(0, 0, height)
    end

    if entity then
        SetEntityCoords(entity, pos.x, pos.y, pos.z)
        SetEntityHeading(entity, heading)
        if placeOnGround then
            PlaceObjectOnGroundProperly(entity)
            pos = GetEntityCoords(entity)
        end
    end

    -- Store updated values back to settings
    settings.currentDepth = depth
    settings.currentHeading = heading
    settings.currentHeight = height
    settings.placeOnGround = placeOnGround
end

local function movementPlacementLoop(entity, settings, getBoundsStatus)
    -- Don't use while loop here, just process one frame
    if not isPlacing or currentMode ~= 'movement' or not DoesEntityExist(entity) then
        return
    end

    if IsEntityAPed(entity) then
        SetEntityAlpha(entity, 200)
    end

    -- Disable movement controls to prevent player from moving
    DisableControlAction(0, 30, true)  -- Move Left/Right
    DisableControlAction(0, 31, true)  -- Move Forward/Back
    DisableControlAction(0, 36, true)  -- INPUT_DUCK
    DisableControlAction(0, 21, true)  -- Sprint
    DisableControlAction(0, 22, true)  -- Jump

    SetEntityCollision(entity, false, false)
    FreezeEntityPosition(entity, false)

    -- Get current entity position and rotation
    local coords = GetEntityCoords(entity)
    local heading = GetEntityHeading(entity)
    local moved = false

    -- Movement speed settings
    local moveSpeed = 0.1
    local fastMoveSpeed = 0.5
    local rotateSpeed = 2.0

    -- Check if shift is held for faster movement
    local isFastMode = IsControlPressed(0, 21) -- Left Shift
    local currentMoveSpeed = isFastMode and fastMoveSpeed or moveSpeed

    -- Get camera rotation for relative movement
    local camRot = GetGameplayCamRot(2)
    local camHeading = math.rad(camRot.z)

    -- Calculate camera-relative directions
    local camForward = vector3(-math.sin(camHeading), math.cos(camHeading), 0)
    local camRight = vector3(math.cos(camHeading), math.sin(camHeading), 0)

    -- WASD movement (relative to camera direction)
    if IsControlPressed(0, 32) then -- W - Move forward relative to camera
        coords = coords + camForward * currentMoveSpeed
        moved = true
    elseif IsControlPressed(0, 33) then -- S - Move backward relative to camera
        coords = coords - camForward * currentMoveSpeed
        moved = true
    end

    if IsControlPressed(0, 34) then -- A - Move left relative to camera
        coords = coords - camRight * currentMoveSpeed
        moved = true
    elseif IsControlPressed(0, 35) then -- D - Move right relative to camera
        coords = coords + camRight * currentMoveSpeed
        moved = true
    end

    -- Up/Down movement (always world-relative)
    if settings.allowVertical and IsControlPressed(0, 85) then -- Q - Move up
        coords = coords + vector3(0, 0, currentMoveSpeed)
        moved = true
    elseif settings.allowVertical and IsControlPressed(0, 48) then -- Z - Move down
        coords = coords + vector3(0, 0, -currentMoveSpeed)
        moved = true
    end

    -- Rotation controls
    if IsControlPressed(0, 174) then -- Left Arrow - Rotate left
        heading = heading - rotateSpeed
        moved = true
    elseif IsControlPressed(0, 175) then -- Right Arrow - Rotate right
        heading = heading + rotateSpeed
        moved = true
    end

    -- Alternative rotation with mouse wheel
    if IsControlJustPressed(0, 241) then -- Mouse wheel up
        heading = heading + 15.0
        moved = true
    elseif IsControlJustPressed(0, 242) then -- Mouse wheel down
        heading = heading - 15.0
        moved = true
    end

    -- Apply movement if any occurred
    if moved then
        SetEntityCoords(entity, coords.x, coords.y, coords.z, false, false, false, false)
        SetEntityHeading(entity, heading)
    end

    -- Confirm placement (Enter)
    if IsControlJustPressed(0, 191) then
        if not getBoundsStatus() then
            print(Language.Locale("placeable_object.cant_place_here"))
            return
        end
        isPlacing = false
        if currentPromise then
            currentPromise:resolve({
                entity = entity,
                position = GetEntityCoords(entity),
                heading = GetEntityHeading(entity),
                rotation = GetEntityRotation(entity)
            })
            currentPromise = nil
        end
        DeleteEntity(entity)
        return
    end

    -- Cancel placement (Backspace)
    if IsControlJustPressed(0, 202) then
        isPlacing = false
        if currentPromise then
            currentPromise:resolve(nil) -- Return nil for cancel
            currentPromise = nil
        end
        DeleteEntity(entity)
        return
    end

    -- Switch to normal mode (E)
    if settings.allowNormal and IsControlJustPressed(0, 38) then
        currentMode = 'normal'
        local playerPos = GetEntityCoords(PlayerPedId())
        local entityPos = GetEntityCoords(entity)
        local depth = #(playerPos - entityPos)
        settings.currentDepth = depth
        return
    end

    -- Snap to ground (Alt)
    if IsControlJustPressed(0, 19) then
        PlaceObjectOnGroundProperly(entity)
    end

    FreezeEntityPosition(entity, false)
end

local function drawBoundaryBox(boundary)
    if not boundary then return end

    local min = boundary.min
    local max = boundary.max

    -- Define the 8 corners of the box
    local corners = {
        vector3(min.x, min.y, min.z), -- 1: bottom front left
        vector3(max.x, min.y, min.z), -- 2: bottom front right
        vector3(max.x, max.y, min.z), -- 3: bottom back right
        vector3(min.x, max.y, min.z), -- 4: bottom back left
        vector3(min.x, min.y, max.z), -- 5: top front left
        vector3(max.x, min.y, max.z), -- 6: top front right
        vector3(max.x, max.y, max.z), -- 7: top back right
        vector3(min.x, max.y, max.z), -- 8: top back left
    }

    -- Draw the box faces as triangles (2 triangles per face)
    local alpha = 50 -- Semi-transparent
    local r, g, b = 0, 255, 0 -- Green color

    -- Bottom face (looking up from below)
    DrawPoly(corners[1].x, corners[1].y, corners[1].z, corners[2].x, corners[2].y, corners[2].z, corners[3].x, corners[3].y, corners[3].z, r, g, b, alpha)
    DrawPoly(corners[1].x, corners[1].y, corners[1].z, corners[3].x, corners[3].y, corners[3].z, corners[4].x, corners[4].y, corners[4].z, r, g, b, alpha)

    -- Top face (looking down from above)
    DrawPoly(corners[5].x, corners[5].y, corners[5].z, corners[7].x, corners[7].y, corners[7].z, corners[6].x, corners[6].y, corners[6].z, r, g, b, alpha)
    DrawPoly(corners[5].x, corners[5].y, corners[5].z, corners[8].x, corners[8].y, corners[8].z, corners[7].x, corners[7].y, corners[7].z, r, g, b, alpha)

    -- Front face (min Y)
    DrawPoly(corners[1].x, corners[1].y, corners[1].z, corners[5].x, corners[5].y, corners[5].z, corners[6].x, corners[6].y, corners[6].z, r, g, b, alpha)
    DrawPoly(corners[1].x, corners[1].y, corners[1].z, corners[6].x, corners[6].y, corners[6].z, corners[2].x, corners[2].y, corners[2].z, r, g, b, alpha)

    -- Back face (max Y)
    DrawPoly(corners[4].x, corners[4].y, corners[4].z, corners[7].x, corners[7].y, corners[7].z, corners[8].x, corners[8].y, corners[8].z, r, g, b, alpha)
    DrawPoly(corners[4].x, corners[4].y, corners[4].z, corners[3].x, corners[3].y, corners[3].z, corners[7].x, corners[7].y, corners[7].z, r, g, b, alpha)

    -- Left face (min X)
    DrawPoly(corners[1].x, corners[1].y, corners[1].z, corners[4].x, corners[4].y, corners[4].z, corners[8].x, corners[8].y, corners[8].z, r, g, b, alpha)
    DrawPoly(corners[1].x, corners[1].y, corners[1].z, corners[8].x, corners[8].y, corners[8].z, corners[5].x, corners[5].y, corners[5].z, r, g, b, alpha)

    -- Right face (max X)
    DrawPoly(corners[2].x, corners[2].y, corners[2].z, corners[6].x, corners[6].y, corners[6].z, corners[7].x, corners[7].y, corners[7].z, r, g, b, alpha)
    DrawPoly(corners[2].x, corners[2].y, corners[2].z, corners[7].x, corners[7].y, corners[7].z, corners[3].x, corners[3].y, corners[3].z, r, g, b, alpha)
end

-- Main placement function - now uses proper promise pattern
function PlaceableObject.Create(model, settings)
    if isPlacing then
        return nil -- Already placing
    end

    settings = settings or {}

    -- Default settings
    local config = {
        depthMin = settings.depthMin or 2.0,
        depthMax = settings.depthMax or 10.0,
        rotationStep = settings.rotationStep or 15.0,
        depthStep = settings.depthStep or 1.0,
        heightStep = settings.heightStep or 0.1, -- New height step setting
        disableSphere = settings.useSphere and false or true,
        depth = settings.depth or 10.0,
        allowMovement = settings.allowMovement ~= false, -- default true
        allowNormal = settings.allowNormal ~= false, -- default true
        allowVertical = settings.allowVertical ~= false, -- default true - allow vertical movement in normal mode
        startMode = settings.startMode or 'normal', -- 'normal' or 'movement'
        allowedMats = settings.allowedMats,
        boundary = settings.boundary,
        config = settings.config or {},
        maxDepth = settings.maxDepth or 10,
        showInstructionalButtons = settings.showInstructionalButtons
    }

    -- Create the promise and store it globally
    currentPromise = promise.new()

    isPlacing = true
    currentMode = config.startMode

    -- Create entity if model provided
    if model then
        local heading = -GetEntityHeading(PlayerPedId())
        local pos = eyetrace(config.depth, config.disableSphere)
        local obj = Utility.CreateProp(model, pos, vector3(0, 0, heading), nil)
        currentEntity = obj
    else
        currentEntity = settings.entity
    end

    if not currentEntity then
        isPlacing = false
        if currentPromise then
            currentPromise:resolve(nil)
            currentPromise = nil
        end
        return nil
    end

    -- Setup entity
    SetEntityCollision(currentEntity, false, false)
    SetEntityAlpha(currentEntity, 150, false)
    SetPedConfigFlag(PlayerPedId(), 146, true)
    SetCanClimbOnEntity(currentEntity, false)
    SetEntityCompletelyDisableCollision(currentEntity, true, false)
    SetEntityNoCollisionEntity(PlayerPedId(), currentEntity, false)

    -- Setup boundary checking
    local getBoundsStatus = checkBoundaryAndMaterials(currentEntity, config)

    -- Setup instructional buttons only if enabled
    local scaleform = nil
    if config.showInstructionalButtons then
        scaleform = setupInstructionalButtons(config)
    end

    -- Main loop
    CreateThread(function()
        local lastMode = currentMode
        while isPlacing do
            -- Update instructional buttons if mode changed and buttons are enabled
            if config.showInstructionalButtons and (not lastMode or lastMode ~= currentMode) then
                scaleform = setupInstructionalButtons(config)
                lastMode = currentMode
            end

            -- Draw instructional buttons only if enabled
            if config.showInstructionalButtons and scaleform then
                DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
            end

            -- Draw boundary box if defined
            if config.boundary then
                drawBoundaryBox(config.boundary)
            end

            if currentMode == 'normal' and config.allowNormal then
                normalPlacementLoop(currentEntity, config, getBoundsStatus)
            elseif currentMode == 'movement' and config.allowMovement then
                movementPlacementLoop(currentEntity, config, getBoundsStatus)
            end

            Wait(0)
        end

        -- Cleanup
        if DoesEntityExist(currentEntity) then
            if IsEntityAPed(currentEntity) then
                SetEntityAlpha(currentEntity, 255)
            end
            SetEntityDrawOutline(currentEntity, false)
        end

        currentEntity = nil
    end)

    -- Return Citizen.Await on the promise
    return Citizen.Await(currentPromise)
end

-- Stop placement function
function PlaceableObject.Stop()
    if not isPlacing then return false end

    isPlacing = false
    if currentEntity and DoesEntityExist(currentEntity) then
        DeleteEntity(currentEntity)
    end

    return true
end

-- Get current status
function PlaceableObject.IsPlacing()
    return isPlacing
end

function PlaceableObject.GetCurrentEntity()
    return currentEntity
end

function PlaceableObject.GetCurrentMode()
    return currentMode
end



return PlaceableObject