if GetResourceState('qb-core') ~= 'started' then return end
if GetResourceState('qbx_core') == 'started' then return end

QBCore = exports['qb-core']:GetCoreObject()

Framework = {}

Framework.GetFrameworkName = function()
    return 'qb-core'
end

Framework.GetPlayerData = function()
    return QBCore.Functions.GetPlayerData()
end

Framework.GetPlayerMetaData = function(metadata)
    return QBCore.Functions.GetPlayerData().metadata[metadata]
end

Framework.Notify = function(message, type, time)
    TriggerEvent('QBCore:Notify', message, 'primary', time)
end

Framework.ShowHelpText = function(message, _position)
    return exports['qb-core']:DrawText(message, _position)
end

Framework.HideHelpText = function()
    return exports['qb-core']:HideText()
end

Framework.GetItemInfo = function(item)
    local itemData = QBCore.Shared.Items[item]
    if not itemData then return {} end
    local repackedTable = {
        name = itemData.name,
        label = itemData.label,
        stack = itemData.unique,
        weight = itemData.weight,
        description = itemData.description,
        image = itemData.image
    }
    return repackedTable
end

Framework.GetPlayerIdentifier = function()
    return QBCore.Functions.GetPlayerData().citizenid
end

Framework.GetPlayerName = function()
    local playerData = QBCore.Functions.GetPlayerData()
    return playerData.charinfo.firstname, playerData.charinfo.lastname
end

Framework.GetPlayerJob = function()
    local playerData = QBCore.Functions.GetPlayerData()
    return playerData.job.name, playerData.job.label, playerData.job.grade.name, playerData.job.grade.level
end

Framework.HasItem = function(item)
	return QBCore.Functions.HasItem(item)
end

Framework.GetPlayerInventory = function()
    local items = {}
    local frameworkInv = QBCore.Functions.GetPlayerData().items
    for _, v in pairs(frameworkInv) do
        table.insert(items, {
            name = v.name,
            label = v.label,
            count = v.amount,
            slot = v.slot,
            metadata = v.info,
            stack = v.unique,
            close = v.useable,
            weight = v.weight
        })
    end
    return items
end

Framework.GetIsPlayerDead = function()
    return QBCore.Functions.GetPlayerData().metadata["isdead"] or QBCore.GetPlayerData().metadata["inlaststand"]
end

Framework.Shared = QBCore.Shared

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
    TriggerEvent('community_bridge:Client:OnPlayerJobUpdate', PlayerJobName, PlayerJobLabel, PlayerJobGradeName, PlayerJobGradeLevel)
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate', function(data)
    -- Unsure what data is passed in this, but considering the gang data isnt updating I doubt this was tested.
    --[[
    PlayerJobName = data.name
    PlayerJobLabel = data.label
    PlayerJobGradeName = data.grade.name
    PlayerJobGradeLevel = data.grade.level
    TriggerEvent('community_bridge:Client:OnPlayerGangUpdate', PlayerGangName, PlayerGangLabel, PlayerGangGradeName, PlayerGangGradeLevel)
    --]]
end)
