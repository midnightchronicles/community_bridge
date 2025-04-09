if GetResourceState('qbx_core') ~= 'started' then return end

QBox = exports.qbx_core

Framework = {}

Framework.GetFrameworkName = function()
    return 'qbx_core'
end

Framework.GetPlayerData = function()
    return QBox.GetPlayerData()
end

Framework.GetFrameworkJobs = function()
    return QBox.GetJobs()
end

Framework.GetPlayerDob = function()
    local playerData = QBox.GetPlayerData()
    return playerData.charinfo.birthdate
end

Framework.GetPlayerMetaData = function(metadata)
    local playerData = QBox.GetPlayerData()
    return playerData.metadata[metadata]
end

Framework.GetPlayerIdentifier = function()
    return QBox.GetPlayerData().citizenid
end

Framework.GetPlayerName = function()
    local playerData = QBox.GetPlayerData()
    return playerData.charinfo.firstname, playerData.charinfo.lastname
end

Framework.GetPlayerJob = function()
    local playerData = QBox.GetPlayerData()
    return playerData.job.name, playerData.job.label, playerData.job.grade.name, playerData.job.grade.level
end

Framework.GetPlayerInventory = function()
    return QBox.GetPlayerData().items
end

---comment
---@param item string
---@return number
Framework.GetItemCount = function(item)
    -- This seems to be exclusively for ox_inventory, if other inventories are used, they need to be bridged in the inventory module. Until then we will return 0 and a print.
    return 0, print("Community_bridge:WARN: GetItemCount is not implemented for this framework, please use the inventory module to get the item count. If you are using a diffrent inventory please let us know so we can bridge it and have less nonsense.")
end

Framework.GetIsPlayerDead = function()
    local platerData = QBox.GetPlayerData()
    return platerData.metadata["isdead"] or platerData.metadata["inlaststand"]
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    Wait(1500)
    FillBridgeTables()
    TriggerEvent('community_bridge:Client:OnPlayerLoaded')
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    ClearClientSideVariables()
	TriggerEvent('community_bridge:Client:OnPlayerUnload')
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(data)
    PlayerJobName = data.name
    PlayerJobLabel = data.label
    PlayerJobGradeName = data.grade.name
    PlayerJobGradeLevel = data.grade.level
    TriggerEvent('community_bridge:Client:OnPlayerJobUpdate',PlayerJobName, PlayerJobLabel, PlayerJobGradeName, PlayerJobGradeLevel)
end)