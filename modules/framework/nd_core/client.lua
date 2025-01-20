if GetResourceState('ND_Core') ~= 'started' then return end

local NDCore = exports["ND_Core"]:GetCoreObject()

Framework = {}

Framework.GetPlayerData = function()
    return NDCore:getPlayer()
end

Framework.GetPlayerMetaData = function(metadata)
    return NDCore:getPlayer().metadata[metadata]
end

--[[
-- Unused by this framework
Framework.GetItemInfo = function(item)

end

Framework.GetPlayerInventory = function()

end
--]]

Framework.GetPlayerIdentifier = function()
    return NDCore:getPlayer().id
end

Framework.GetPlayerName = function()
    return NDCore:getPlayer().fullname
end

Framework.GetPlayerJob = function()
    local player = NDCore:getPlayer().jobInfo
    return player.name, player.label, player.rankname, player.rank
end

Framework.GetIsPlayerDead = function()
    local playerState = LocalPlayer.state
    return playerState.dead
end

RegisterNetEvent("ND:characterLoaded",function(character)
    Wait(1500)
    FillBridgeTables()
    TriggerEvent('community_bridge:Client:OnPlayerLoaded')
end)

RegisterNetEvent("ND:characterUnloaded",function()
    ClearClientSideVariables()
	TriggerEvent('community_bridge:Client:OnPlayerUnload')
end)

RegisterNetEvent("ND:updateCharacter", function(character)
    PlayerJobName = character.jobInfo.name
    PlayerJobLabel = character.jobInfo.label
    PlayerJobGradeName = character.jobInfo.rankName
    PlayerJobGradeLevel = character.jobInfo.rank
    TriggerEvent('community_bridge:Client:OnPlayerJobUpdate', PlayerJobName, PlayerJobLabel, PlayerJobGradeName, PlayerJobGradeLevel)
end)