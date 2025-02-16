if GetResourceState('ox_core') ~= 'started' then return end

local Ox = require '@ox_core.lib.init'

Framework = {}

Framework.GetPlayerData = function()
    -- wip
end

Framework.GetPlayerMetaData = function(metadata)
    -- wip
end

Framework.GetPlayerIdentifier = function()
    local player = Ox.GetPlayer()
    return player.stateId
end

Framework.GetPlayerName = function()
    local player = Ox.GetPlayer()
    local first = player.get('firstName')
    local last = player.get('lastName')
    return first, last
end

Framework.GetPlayerJob = function()
    local group, grade, title = Ox.getGroupInfo()
    return group, title, title, grade
end

Framework.GetPlayerInventory = function()
    return exports.ox_inventory:GetPlayerItems()
end

Framework.GetIsPlayerDead = function()
    -- wip
end

RegisterNetEvent('ox:playerLoaded', function()
    Wait(1500)
    FillBridgeTables()
	TriggerEvent('community_bridge:Client:OnPlayerLoaded')
end)


RegisterNetEvent('ox:playerLogout', function()
    ClearClientSideVariables()
	TriggerEvent('community_bridge:Client:OnPlayerUnload')
end)

RegisterNetEvent('ox:setGroup', function(name, grade)
    PlayerJobName = name
    PlayerJobLabel = name
    PlayerJobGradeName = grade
    PlayerJobGradeLevel = grade
    TriggerEvent('community_bridge:Client:OnPlayerJobUpdate',PlayerJobName, PlayerJobLabel, PlayerJobGradeName, PlayerJobGradeLevel)
end)