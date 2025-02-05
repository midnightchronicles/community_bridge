local ReboundEntities = ReboundEntities or Require("shared/rebound_entities.lua")
local Actions = Actions or Require("shared/actions.lua")
local LA = LA or Require("shared/la.lua")

REA = {}

if not IsDuplicityVersion() then goto client end



if IsDuplicityVersion() then return end
::client::

local ActionsInProgress = {}


Action.Create("LerpToPosition", function(reboundId, start, position, duration, shouldRepeat, overrideStartTime)
    local re = ReboundEntities.Get(reboundId)
    assert(re, "Rebound entity not found")
    local entity = re and re.entity
    if not entity then return end
    local startTime = GetGameTimer()
    local endTime = overrideStartTime or startTime + duration
    ActionsInProgress[reboundId] = {reboundId, start, position, duration, shouldRepeat, startTime}
    local t = 0
    CreateThread(function()
        while shouldRepeat or t < 1 do
            t = (GetGameTimer() - startTime) / duration
            local lerpPosition = LA.LerpVector(start, position, t)
            SetEntityCoords(entity, lerpPosition)
            Wait(0)

        end        
    end)
end)
