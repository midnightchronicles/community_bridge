---@diagnostic disable: duplicate-set-field
if GetResourceState('es_extended') ~= 'started' then return end

ESX = exports["es_extended"]:getSharedObject()

Framework = {}

Framework.GetFrameworkName = function()
    return 'es_extended'
end

---comment
---@return table
Framework.GetPlayerData = function()
    return ESX.PlayerData
end

Framework.GetFrameworkJobs = function()
    local jobs = lib.callback.await('community_bridge:Callback:GetFrameworkJobs', false)
    return jobs
end

---comment
---@return string
Framework.GetPlayerDob = function()
    local playerData = ESX.GetPlayerData()
    local dob = playerData.dateofbirth
    return dob
end

Framework.GetPlayerMetaData = function(metadata)
    return ESX.GetPlayerData().metadata[metadata]
end

---comment
---@param message string
---@param type string
---@param time number
---@return nil
Framework.Notify = function(message, type, time)
    return ESX.ShowNotification(message, type, time)
end

---comment
---@return string
Framework.GetPlayerIdentifier = function()
    local playerData = ESX.GetPlayerData()
    return playerData.identifier
end

---comment
---@return string
---@return string
Framework.GetPlayerName = function()
    local playerData = ESX.GetPlayerData()
    return playerData.firstName, playerData.lastName
end

---comment
---@return string
---@return string
---@return string
---@return string
Framework.GetPlayerJob = function()
    local playerData = ESX.GetPlayerData()
    return playerData.job.name, playerData.job.label, playerData.job.grade_label, playerData.job.grade
end

---comment
---@param item string
---@return boolean
Framework.HasItem = function(item)
	local hasItem = ESX.SearchInventory(item, true)
	return hasItem > 0 and true or false
end

---comment
---@return table
Framework.GetPlayerInventory = function()
    local playerData = ESX.GetPlayerData()
    return playerData.inventory
end

---comment
---@param item string
---@return number
Framework.GetItemCount = function(item)
    local inventory = Framework.GetPlayerInventory()
    if not inventory then return 0 end
    return inventory[item].count or 0
end

---comment
---@return boolean
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
