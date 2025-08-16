
local GRIDE_SIZE_X = 8968.83 / 2 
local GRIDE_SIZE_Y = 126200.40 / 2
local CELL_SIZE = 500

local Grid = {}
Grid.Generated = false
local Grids = {}
Point = {}
Point.All = {}

function Grid.Generate()
    if Grid.Generated then return end
    Grid.Generated = true
    local numOfCellsX = math.ceil(GRIDE_SIZE_X / CELL_SIZE)
    local numOfCellsY = math.ceil(GRIDE_SIZE_Y / CELL_SIZE)

    for x = -numOfCellsX, numOfCellsX do
        Grids[x] = {}
        for y = -numOfCellsY, numOfCellsY do
            Grids[x][y] = {}
        end
    end
end

function Grid.GetCellId(coords)
    local cellX = math.floor(coords.x / CELL_SIZE) + 1
    local cellY = math.floor(coords.y / CELL_SIZE) + 1
    return string.format("%d_%d", cellX, cellY)
end

function Grid.GetCellByCoords(coords)
    local cellX = math.floor(coords.x / CELL_SIZE) + 1
    local cellY = math.floor(coords.y / CELL_SIZE) + 1

    if Grids[cellX] and Grids[cellX][cellY] then
        return Grids[cellX][cellY]
    end

    return nil
end

local Points = {}
Points.Started = false
function Point.StartLoop()
    if Points.Started then return end
    Points.Started = true

    CreateThread(function()
        while Points.Started do
            local playerPed = PlayerPedId()
            if playerPed ~= -1 then
                local coords = GetEntityCoords(playerPed)
                local cell = Grid.GetCellByCoords(coords)
                for _, point in pairs(cell or {}) do
                    if point.isEntity then
                        local entity = point.target
                        if DoesEntityExist(entity) then
                            local entityCoords = GetEntityCoords(entity)
                            local distance = #(coords - entityCoords)
                            if distance < point.distance then
                                if not point.inside then
                                    point.inside = true
                                    point.args = point?.onEnter(point, point.args) or point.args
                                end
                            elseif point.inside then
                                point.inside = false
                                point.args = point?.onExit(point, point.args) or point.args
                            end
                        end
                    else
                        local distance = #(coords.xyz - point.coords.xyz)
                        if distance < point.distance then
                            if not point.inside then
                                point.inside = true
                                point.args = point?.onEnter(point, point.args) or point.args
                            end
                        elseif point.inside then
                            point.inside = false
                            point.args = point?.onExit(point, point.args) or point.args
                        end
                    end
                end
            end
            Wait(1000)
        end
    end)
end

function Point.Register(id, target, distance, args, _onEnter, _onExit)
    local isEntity = type(target) == "number"
    local coords = isEntity and GetEntityCoords(target) or target
    Grid.Generate()
    local self = {}
    self.id = id
    self.target = target -- Store entity ID or Vector3
    self.isEntity = isEntity
    self.coords = coords
    self.distance = distance
    self.onEnter = _onEnter or function() end
    self.onExit = _onExit or function() end
    self.inside = false -- Track if player is inside
    self.args = args or {}
    local grid = Grid.GetCellByCoords(coords)
    self.cellKey = Grid.GetCellId(coords)
    grid[self.cellKey] = self
    Point.All[id] = self
    Point.StartLoop()
    return self
end

function Point.Remove(id)
    local point = Point.All[id]
    if not point then return false end

    -- Remove from grid
    local grid = Grid.GetCellByCoords(point.coords)
    if grid then
        grid[point.cellKey] = nil
    end

    Point.All[id] = nil
    return true
end

function Point.Get(id)
    return Point.All[id]
end

function Point.UpdateCoords(id, coords)
    local point = Point.All[id]
    if not point then return end

    local newGrid = Grid.GetCellByCoords(coords)
    if not newGrid or newGrid[point.cellKey] then return end
    local oldGrid = Grid.GetCellByCoords(point.coords)
    if oldGrid then
        oldGrid[point.cellKey] = nil
    end
    -- Add to new grid
    point.coords = coords
    point.cellKey = string.format("%d_%d", newGrid.x, newGrid.y)
    newGrid[point.cellKey] = point
    return true
end

function Point.GetAll()
    return Point.All
end

return Point