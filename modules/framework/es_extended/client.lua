if GetResourceState('es_extended') ~= 'started' then return end

ESX = exports["es_extended"]:getSharedObject()

Framework = {}

Framework.GetFrameworkName = function()
    return 'es_extended'
end

Framework.GetPlayerData = function()
    return ESX.PlayerData
end

Framework.GetPlayerMetaData = function(metadata)
    return ESX.GetPlayerData().metadata[metadata]
end

Framework.Notify = function(message, type, time)
    return ESX.ShowNotification(message, type, time)
end

Framework.GetPlayerIdentifier = function()
    local playerData = ESX.GetPlayerData()
    return playerData.identifier
end

Framework.GetPlayerName = function()
    local playerData = ESX.GetPlayerData()
    return playerData.firstName, playerData.lastName
end

Framework.GetPlayerJob = function()
    local playerData = ESX.GetPlayerData()
    return playerData.job.name, playerData.job.label, playerData.job.grade_label, playerData.job.grade
end

Framework.HasItem = function(item)
	local hasItem = ESX.SearchInventory(item, true)
	return hasItem > 0 and true or false
end

Framework.GetPlayerInventory = function()
    local playerData = ESX.GetPlayerData()
    return playerData.inventory
end

Framework.GetIsPlayerDead = function()
    local playerData = ESX.GetPlayerData()
    return playerData.dead
end

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    Wait(1500)
    FillBridgeTables()
	TriggerEvent('community_bridge:Client:OnPlayerLoaded')
end)

RegisterNetEvent('esx:onPlayerLogout', function()
    ClearClientSideVariables()
	TriggerEvent('community_bridge:Client:OnPlayerUnload')
end)

RegisterNetEvent('esx:setJob', function(data)
    PlayerJobName = data.name
    PlayerJobLabel = data.label
    PlayerJobGradeName = data.grade_label
    PlayerJobGradeLevel = data.grade
    TriggerEvent('community_bridge:Client:OnPlayerJobUpdate',PlayerJobName, PlayerJobLabel, PlayerJobGradeName, PlayerJobGradeLevel)
end)
