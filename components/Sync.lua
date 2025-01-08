local classModule = Require("components/class.lua")
local _, class = table.unpack(classModule)
local ids = Require("use/ids.lua")

local SyncObjects = {}

function GetSyncObject(syndId)
    return SyncObjects[syndId]
end

function GetSyncObjects()
    return SyncObjects
end

function SetSyncObject(syncId, sync)
    SyncObjects[syncId] = sync
end

--- @class Sync
local Sync = class("Sync")
--- Initializes the Sync object.
function Sync:Struct()
    self.syncId = ids.CreateUniqueId(SyncObjects)
    self.sync = {}
    self.updateWaitTime = 500
    SyncObjects[self.syncId] = self
    return self
end

--- Retrieves the value associated with the given key in the sync table.
--- @param key any: The key to retrieve the value for.
--- @return any: The value associated with the key.
function Sync:GetSyncKey(key)
    return self.sync[key]
end

--- Called when a sync key is initialized.
--- @param key any: The key being initialized.
--- @param value any: The value being set.
function Sync:OnSyncKeyInit(key, value) end

--- Called when a sync key is updated.
--- @param key any: The key being updated.
--- @param oldValue any: The old value of the key.
--- @param newValue any: The new value of the key.
function Sync:OnSyncKeyUpdate(key, oldValue, newValue) end

--- Called when a sync key is removed.
--- @param key any: The key being removed.
function Sync:OnSyncKeyRemove(key) end

-- Server
if not IsDuplicityVersion() then goto client end

--- Sets a sync key and triggers a client event to update the sync table.
--- @param key any: The key to set.
--- @param value any: The value to set for the key.
function Sync:SetSynckey(key, value)
    self.sync[key] = value
    CreateThread(function()
        SetTimeout(self.updateWaitTime, function()
            TriggerClientEvent("Sync:Setup", -1, self.syncId, self.sync)
        end)
    end)
end

-- Client
if IsDuplicityVersion() then return Sync end
::client::

--- Compares the current sync table with a new table and updates accordingly.
--- @param newTable table: The new sync table to compare with.
function Sync:_CompareAndUpdate(newTable)
    local oldTable = self.sync
    for key, oldValue in pairs(oldTable) do
        local newValue = newTable[key]
        if newValue == nil then
            self:OnSyncKeyRemove(key)
        elseif oldValue ~= newValue then
            self:OnSyncKeyUpdate(key, oldValue, newValue)
        end
    end

    for key, newValue in pairs(newTable) do
        if oldTable[key] == nil then
            self:OnSyncKeyInit(key, newValue)
        end
    end
    self.sync = newTable
end

RegisterNetEvent("Sync:Setup", function(syncId, sync)
    local syncObj = GetSyncObject(syncId)
    if not syncObj then
        syncObj = reconstruct(Sync)
        assert(syncObj, "Failed to sync: ", syncId)
        syncObj.syncId = syncId
        SetSyncObject(syncId, syncObj)
    end
    syncObj:_CompareAndUpdate(sync)
end)

return table.pack({Sync})
