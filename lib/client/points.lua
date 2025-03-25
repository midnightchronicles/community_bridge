-- Grid-based point system
Point = {}
local ActivePoints = {}
local GridCells = {}
local LoopStarted = false

-- Grid configuration
local GRID_SIZE = 500.0 -- Size of each grid cell
local CELL_BUFFER = 1 -- Number of adjacent cells to check

-- Consider adding these optimizations
local ADAPTIVE_WAIT = true -- Adjust wait time based on player speed

---This is an internal function, do not call this externally
function Point.GetCellKey(coords)
    local cellX = math.floor(coords.x / GRID_SIZE)
    local cellY = math.floor(coords.y / GRID_SIZE)
    return cellX .. ":" .. cellY
end

---This is an internal function, do not call this externally
function Point.RegisterInGrid(point)
    local cellKey = Point.GetCellKey(point.coords)

    -- Initialize cell if it doesn't exist
    GridCells[cellKey] = GridCells[cellKey] or {
        points = {},
        count = 0
    }

    -- Add point to cell
    GridCells[cellKey].points[point.id] = point
    GridCells[cellKey].count = GridCells[cellKey].count + 1

    -- Store cell reference in point
    point.cellKey = cellKey
end

---This is an internal function, do not call this externally
function Point.UpdateInGrid(point, oldCellKey)
    -- Remove from old cell if cell key changed
    if oldCellKey and oldCellKey ~= point.cellKey then
        if GridCells[oldCellKey] and GridCells[oldCellKey].points[point.id] then
            GridCells[oldCellKey].points[point.id] = nil
            GridCells[oldCellKey].count = GridCells[oldCellKey].count - 1

            -- Clean up empty cells
            if GridCells[oldCellKey].count <= 0 then
                GridCells[oldCellKey] = nil
            end
        end

        -- Add to new cell
        Point.RegisterInGrid(point)
    end
end

---Gets nearby cells based on the coords
---@param coords table
---@return table
function Point.GetNearbyCells(coords)
    local cellX = math.floor(coords.x / GRID_SIZE)
    local cellY = math.floor(coords.y / GRID_SIZE)
    local nearbyCells = {}

    -- Get current and adjacent cells
    for x = cellX - CELL_BUFFER, cellX + CELL_BUFFER do
        for y = cellY - CELL_BUFFER, cellY + CELL_BUFFER do
            local key = x .. ":" .. y
            if GridCells[key] then
                table.insert(nearbyCells, key)
            end
        end
    end

    return nearbyCells
end

---Returns all points in the same cell as the given point
---This will require you to pass the point object
---@param point table
---@return table
function Point.CheckPointsInSameCell(point)
    local cellKey = point.cellKey
    if not GridCells[cellKey] then return {} end

    local nearbyPoints = {}
    for id, otherPoint in pairs(GridCells[cellKey].points) do
        if id ~= point.id then
            local distance = #(point.coords - otherPoint.coords)
            if distance < (point.distance + otherPoint.distance) then
                nearbyPoints[id] = otherPoint
            end
        end
    end

    return nearbyPoints
end

local insidePoints = {}
---Internal function that starts the loop. Do not call this function directly.
function Point.StartLoop()
    if LoopStarted then return false end
    LoopStarted = true

    CreateThread(function()
        while LoopStarted do
            local playerPed = PlayerPedId()
            while playerPed == -1 do
                Wait(100)
                playerPed = PlayerPedId()
            end
            local playerCoords = GetEntityCoords(playerPed)
            local targetsExist = false
            local playerCellKey = Point.GetCellKey(playerCoords)
            local nearbyCells = Point.GetNearbyCells(playerCoords)

            local playerSpeed = GetEntitySpeed(playerPed)
            local maxWeight = 1000
            local waitTime = ADAPTIVE_WAIT and math.max(maxWeight/10, maxWeight - playerSpeed * maxWeight/10) or maxWeight
            -- Process only points in nearby cells
            for _, cellKey in ipairs(nearbyCells) do
                if GridCells[cellKey] then
                    for id, point in pairs(GridCells[cellKey].points) do
                        targetsExist = true

                        -- Update entity position if needed
                        local oldCellKey = point.cellKey
                        if point.isEntity then
                            point.coords = GetEntityCoords(point.target)
                            point.cellKey = Point.GetCellKey(point.coords)
                            Point.UpdateInGrid(point, oldCellKey)
                        end
                        local coords = point.coords and vector3(point.coords.x, point.coords.y, point.coords.z) or vector3(0, 0, 0)
                        local distance = #(playerCoords - coords)
                        --local distance = #(playerCoords - point.coords)

                        -- Check if player entered/exited the point
                        if distance < point.distance then
                            if not point.inside then
                                print("Entered point: ", point.distance)
                                point.inside = true
                                point.onEnter(point)
                                insidePoints[point.id] = point
                            end
                        elseif point.inside then
                            print("Exited point: ", point.id)
                            point.inside = false
                            point.onExit(point)
                            insidePoints[point.id] = nil
                        end
                        
                        if point.onNearby then
                            point.onNearby(GridCells[cellKey]?.points, waitTime)
                        end
                    end
                end
            end

            for id, insidepoint in pairs(insidePoints) do
                local pos = insidepoint.coords and vector3(insidepoint.coords.x, insidepoint.coords.y, insidepoint.coords.z) or vector3(0, 0, 0)
                local dist = #(playerCoords - pos)
                if dist > insidepoint.distance then
                    print("Exited point: ", insidepoint.id)
                    insidepoint.inside = false
                    insidepoint.onExit(insidepoint)
                    insidePoints[insidepoint.id] = nil
                end
            end
            --kills the loop if no targets exist
            --[[
            if not targetsExist then
                LoopStarted = false
                break
            end
            --]]

            Wait(waitTime) -- Faster updates when moving quickly
        end
    end)
    return true
end

---Create a point based on a vector or entityID
---@param id string
---@param target number || vector3
---@param distance number
---@param _onEnter function
---@param _onExit function
---@param _onNearby function
---@param data self
---@return table
function Point.Register(id, target, distance, _onEnter, _onExit, _onNearby, data)
    local isEntity = type(target) == "number"
    local coords = isEntity and GetEntityCoords(target) or target

    local self = data or {}
    self.id = id
    self.target = target -- Store entity ID or Vector3
    self.isEntity = isEntity
    self.coords = coords
    self.distance = distance
    self.onEnter = _onEnter or function() end
    self.onExit = _onExit or function() end
    self.onNearby = _onNearby or function() end
    self.inside = false -- Track if player is inside

    ActivePoints[id] = self
    Point.RegisterInGrid(self)
    Point.StartLoop()
    return self
end

---Remove an exsisting point by its id
---@param id string
function Point.Remove(id)
    local point = ActivePoints[id]
    if point then
        local cellKey = point.cellKey
        if GridCells[cellKey] and GridCells[cellKey].points[id] then
            GridCells[cellKey].points[id] = nil
            GridCells[cellKey].count = GridCells[cellKey].count - 1

            if GridCells[cellKey].count <= 0 then
                GridCells[cellKey] = nil
            end
        end

        ActivePoints[id] = nil
    end
end

---Returnes a point by its id
---@param id string
---@return table
function Point.Get(id)
    return ActivePoints[id]
end

---Returns all points
---@return table
function Point.GetAll()
    return ActivePoints
end

-- Usage example for checking nearby points
-- -- 
-- ▀█▀ █▄█ █ ▄▀▀    █ ▄▀▀    █▀ █ █ ▄▀▀ █▄▀ █ █▄ █ ▄▀     █▄█ ▄▀▄ ▀█▀       █▀▄ ▄▀▄ █ █▄ █ ▀█▀ ▄▀▀    █▀ ▄▀▄ █▀▄    ▄▀▀ █▀▄ ▄▀▄ █   █ █   ██▀ ▀▄▀ 
--  █  █ █ █ ▄█▀    █ ▄█▀    █▀ ▀▄█ ▀▄▄ █ █ █ █ ▀█ ▀▄█    █ █ ▀▄▀  █        █▀  ▀▄▀ █ █ ▀█  █  ▄█▀    █▀ ▀▄▀ █▀▄    ▀▄▄ █▀▄ ▀▄▀ ▀▄▀▄▀ █▄▄ █▄▄  █  
--[[
Point.Register("point1", vector3(100, 100, 30), 5.0, 
    function(point)
        print("Entered point1")
    end,
    function(point)
        print("Exited point1")
    end,
    function(nearbyPoints)
        print("Point1 has nearby points:")
        for id, point in pairs(nearbyPoints) do
            print("- " .. id .. " at distance: " .. #(point.coords - ActivePoints["point1"].coords))
        end
    end
)
--]]

return Point