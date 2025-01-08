Points = {}
local ActivePoints = {}

Points.RegisterPoint = function(pointCoords, pointDistance, pointOnEnter, pointOnExit)
    local enterZone = lib.points.new({
        coords   = pointCoords,
        distance = pointDistance,
        onEnter  = function(self)
            pointOnEnter(self)
        end,
        onExit   = function(self)
            pointOnExit(self)
        end,
    })
    local pointID = Ids.CreateUniqueId(nil, 5, nil)
    ActivePoints[pointID] = enterZone
    return enterZone, pointID
end

-- Function to retrieve the enterZone using pointID
Points.GetPointById = function(pointID)
    return ActivePoints[pointID]
end

Points.RemovePoint = function(pointID)
    local point = ActivePoints[pointID]
    if point then
        print("Removing point with ID " .. pointID)
        point:remove()  -- Call the remove method on the point (ensure this method stops all event listeners)
        ActivePoints[pointID] = nil  -- Remove from ActivePoints table
        print("Point removed successfully.")
        return true
    else
        print("Point with ID " .. pointID .. " not found.")
        return false
    end
end
