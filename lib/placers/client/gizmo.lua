
-- CREDITS
-- Andyyy7666: https://github.com/overextended/ox_lib/pull/453
-- AvarianKnight: https://forum.cfx.re/t/allow-drawgizmo-to-be-used-outside-of-fxdk/5091845/8?u=demi-automatic
local dataview = Require("lib/placers/client/dataview.lua")
local enableScale = false -- allow scaling mode. doesnt scale collisions and resets when physics are applied it seems
local gizmoEnabled = false
local currentMode = 'translate'
local isRelative = false
local currentEntity

-- FUNCTIONS


local function normalize(x, y, z)
    local length = math.sqrt(x * x + y * y + z * z)
    if length == 0 then
        return 0, 0, 0
    end
    return x / length, y / length, z / length
end

local function makeEntityMatrix(entity)
    local f, r, u, a = GetEntityMatrix(entity)
    local view = dataview.ArrayBuffer(60)

    view:SetFloat32(0, r[1])
        :SetFloat32(4, r[2])
        :SetFloat32(8, r[3])
        :SetFloat32(12, 0)
        :SetFloat32(16, f[1])
        :SetFloat32(20, f[2])
        :SetFloat32(24, f[3])
        :SetFloat32(28, 0)
        :SetFloat32(32, u[1])
        :SetFloat32(36, u[2])
        :SetFloat32(40, u[3])
        :SetFloat32(44, 0)
        :SetFloat32(48, a[1])
        :SetFloat32(52, a[2])
        :SetFloat32(56, a[3])
        :SetFloat32(60, 1)

    return view
end

local function applyEntityMatrix(entity, view)
    local x1, y1, z1 = view:GetFloat32(16), view:GetFloat32(20), view:GetFloat32(24)
    local x2, y2, z2 = view:GetFloat32(0), view:GetFloat32(4), view:GetFloat32(8)
    local x3, y3, z3 = view:GetFloat32(32), view:GetFloat32(36), view:GetFloat32(40)
    local tx, ty, tz = view:GetFloat32(48), view:GetFloat32(52), view:GetFloat32(56)

    if not enableScale then
        x1, y1, z1 = normalize(x1, y1, z1)
        x2, y2, z2 = normalize(x2, y2, z2)
        x3, y3, z3 = normalize(x3, y3, z3)
    end

    SetEntityMatrix(entity,
        x1, y1, z1,
        x2, y2, z2,
        x3, y3, z3,
        tx, ty, tz
    )
end

function InBoundary(pos, boundary)
    if not boundary then return false end
    local x, y, z = table.unpack(pos)
    local minX, minY, minZ = table.unpack(boundary.min)
    local maxX, maxY, maxZ = table.unpack(boundary.max)
    return x >= minX and x <= maxX and y >= minY and y <= maxY and z >= minZ and z <= maxZ
end

-- LOOPS

function RegisterButtonHandler(button, onPressed, onReleased)
    onPressed = onPressed and type(onPressed) == 'function' and onPressed
    onReleased = onReleased and type(onReleased) == 'function' and onReleased
    DisableControlAction(0, button, true)
    local pressed = IsDisabledControlJustPressed(0, button)
    local released = IsDisabledControlJustReleased(0, button)
    return (pressed and onPressed and onPressed()) or (released and onReleased and onReleased())
end


local function gizmoLoop(entity, onConfirm, onUpdate, onCancel, settings)
    assert(entity, 'entity is required')
    entity = tonumber(entity)
    EnterCursorMode()
    settings = settings or {}
    local allowedMats = settings.allowedMats
    local maxDepth = settings.maxDepth or 10
    local outLine = false
    
    if IsEntityAPed(entity) then
        SetEntityAlpha(entity, 200)
    end

    if allowedMats or boundary then
        CreateThread(function()
            while gizmoEnabled do
                local coords = GetEntityCoords(entity)
                local destination = coords - vector3(0, 0, maxDepth)
                local hit, _, _, _, materialHash = Raycast.ToCoords(coords, destination, 1, 4)
                if hit and hit ~=1 and (allowedMats?[materialHash] or InBoundary(GetEntityCoords(entity), boundary)) then
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
        end)
    end

    while gizmoEnabled and DoesEntityExist(entity) do
        Wait(0)
        
        DisableControlAction(0, 24, true)  -- lmb
        DisableControlAction(0, 25, true)  -- rmb
        DisableControlAction(0, 140, true) -- r
        DisableControlAction(0, 245, true) --t
        DisablePlayerFiring(PlayerId(), true)
        SetEntityCollision(entity, false, false)
        FreezeEntityPosition(entity, false)
        local matrixBuffer = makeEntityMatrix(entity)
        local changed = Citizen.InvokeNative(0xEB2EDCA2, matrixBuffer:Buffer(), 'Editor1', Citizen.ReturnResultAnyway())
        if changed then
            applyEntityMatrix(entity, matrixBuffer)
            local coords = GetEntityCoords(entity)
            SetEntityCoords(entity, coords.x, coords.y, coords.z, false, false, false, false)
        end

        if onUpdate and type(onUpdate) == 'function' then onUpdate(entity, GetEntityCoords(entity), GetEntityRotation(entity)) end
        --controles
        --frontend confirm 18 [ENTER]
        RegisterButtonHandler(191, function()
            if not gizmoEnabled then return end
            gizmoEnabled = false
            if onConfirm and type(onConfirm) == 'function' then onConfirm(entity, GetEntityCoords(entity), GetEntityRotation(entity)) end
        end)
        --frontend cancel 202 [BACKSPACE]
        RegisterButtonHandler(202, function()
            if not gizmoEnabled then return end
            gizmoEnabled = false
            if onCancel and type(onCancel) == 'function' then onCancel(entity, GetEntityCoords(entity), GetEntityRotation(entity)) end
            CreateThread(function()
                local timeout = 100
                while timeout > 0 do
                    DisableFrontendThisFrame()
                    timeout = timeout - 1
                    Wait(1)
                end
            end)
        end)
        --register e
        RegisterButtonHandler(38, function()
            if not gizmoEnabled then return end
            gizmoEnabled = false      
            local playerPos = GetEntityCoords(PlayerPedId())
            local entityPos = GetFinalRenderedCamCoord()
            local depth = #(playerPos - entityPos) -- Vector3 distance
            settings.depth = depth
            PlaceableObject.Create({spawned = entity}, nil, onConfirm, onUpdate, onCancel, settings)
        end)

        --ctrl
        RegisterButtonHandler(36, function()
            if not gizmoEnabled then return end
            LeaveCursorMode()
        end, function()
            EnterCursorMode()
        end)

        RegisterButtonHandler(19, function()
            if not gizmoEnabled then return end
            PlaceObjectOnGroundProperly_2(currentEntity)
        end)
        FreezeEntityPosition(entity, false)
    end

    LeaveCursorMode()

    if DoesEntityExist(entity) then
        if IsEntityAPed(entity) then SetEntityAlpha(entity, 255) end
        SetEntityDrawOutline(entity, false)
    end

    gizmoEnabled = false
    currentEntity = nil
    return true
end

--===================================================
-- █▀ █ █ ▄▀▀ █▄▀    ▀▄▀ ▄▀▄ █ █    █▄ █ ██▀ █   █ ██▄ 
-- █▀ ▀▄█ ▀▄▄ █ █     █  ▀▄▀ ▀▄█    █ ▀█ █▄▄ ▀▄▀▄▀ █▄█
--=================================================== 
--   .--------.
--   | taktak | 
--   |/-------' 
--   .-.  ,-.
--   ;oo  oo;
--  / \|  |/ \
-- |. `.  .' .|
-- `;.;'  `;.;'
-- .-^-.  .-^-.      ko1

-- local function textUILoop()
--     CreateThread(function()
--         while gizmoEnabled do
--             Wait(100)
--             local scaleText = (enableScale and '[S]     - Scale Mode  \n') or ''
--             lib.showTextUI(
--                 ('Current Mode: %s | %s  \n'):format(currentMode, (isRelative and 'Relative') or 'World') ..
--                 '[W]     - Translate Mode  \n' ..
--                 '[R]     - Rotate Mode  \n' ..
--                 scaleText ..
--                 '[Q]     - Relative/World  \n' ..
--                 '[LALT]  - Snap To Ground  \n' ..
--                 '[ENTER] - Done Editing  \n'
--             )
--         end
--         lib.hideTextUI()
--     end)
-- end

-- EXPORTS


local function useGizmo(entity, onConfirm, onUpdate, onCancel, settings)
    gizmoEnabled = true
    currentEntity = entity
    -- textUILoop()
    gizmoLoop(entity, onConfirm, onUpdate, onCancel, settings)

    return {
        handle = entity,
        position = GetEntityCoords(entity),
        rotation = GetEntityRotation(entity)
    }
end

exports("useGizmo", useGizmo)

Gizmo = {}
local running = false
function Gizmo.UseGizmo(obj, onConfirm, onUpdate, onCancel, settings)
    if running then return end
    running = true

    --instructional buttons
    local scaleform = Scaleform.SetupInstructionalButtons({
        {type = "CLEAR_ALL"},
        {type = "SET_CLEAR_SPACE", int = 200},
        {type = "SET_DATA_SLOT", name = 'Translate:', keyIndex = {245}, int = 1},
        {type = "SET_DATA_SLOT", name = 'Scale:', keyIndex = {33}, int = 2},
        {type = "SET_DATA_SLOT", name = 'Rotate:', keyIndex = {45}, int = 3},
        {type = "SET_DATA_SLOT", name = 'Snap to Ground:', keyIndex = {19}, int = 4},
        {type = "SET_DATA_SLOT", name = 'Toggle Camera:', keyIndex = {36}, int = 5},
        {type = "SET_DATA_SLOT", name = 'Cancel Placement:', keyIndex = {202}, int = 6},
        {type = "SET_DATA_SLOT", name = 'Toggle Gizmo:', keyIndex = {38}, int = 7},
        {type = "DRAW_INSTRUCTIONAL_BUTTONS"},
        {type = "SET_BACKGROUND_COLOUR"},
    })
    local quit = false
    CreateThread(function()
        while not quit do
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
            Wait(0)
        end
        running = false
    end)

    quit = useGizmo(obj, onConfirm, onUpdate, onCancel, settings)
    running = false
end
exports("UseGizmo", Gizmo.UseGizmo)


--got rid of the cancer
-- lib.addKeybind({
--     name = '_gizmoLocal',
--     description = 'toggle gizmo to be local to the entity instead of world',
--     defaultKey = 'Q',
--     onPressed = function(self)
--         if not gizmoEnabled then return end
--         isRelative = not isRelative
--         ExecuteCommand('+gizmoLocal')
--     end,
--     onReleased = function (self)
--         ExecuteCommand('-gizmoLocal')
--     end
-- })

-- lib.addKeybind({
--     name = 'gizmoclose',
--     description = 'close gizmo',
--     defaultKey = 'RETURN',
--     onPressed = function(self)
--         if not gizmoEnabled then return end
--         gizmoEnabled = false
--     end,
-- })

-- lib.addKeybind({
--     name = 'gizmoSnapToGround',
--     description = 'snap current gizmo object to floor/surface',
--     defaultKey = 'LMENU',
--     onPressed = function(self)
--         if not gizmoEnabled then return end
--         PlaceObjectOnGroundProperly_2(currentEntity)
--     end,
-- })

-- if enableScale then
--     lib.addKeybind({
--         name = '_gizmoScale',
--         description = 'Sets mode for the gizmo to scale',
--         defaultKey = 'S',
--         onPressed = function(self)
--             if not gizmoEnabled then return end
--             currentMode = 'Scale'
--             ExecuteCommand('+gizmoScale')
--         end,
--         onReleased = function (self)
--             ExecuteCommand('-gizmoScale')
--         end
--     })
-- end


--onreousrcestop

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if not gizmoEnabled then return end
        gizmoEnabled = false
        LeaveCursorMode()
    end
end)

return Gizmo