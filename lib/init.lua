loadedModules = {}
local cLib = {}

function Require(modulePath, resourceName)
    if resourceName and type(resourceName) ~= "string" then
        resourceName = GetCurrentResourceName()
    end

    if not resourceName then
        resourceName = "community_bridge"
    end

    local id = resourceName .. ":" .. modulePath
    if loadedModules[id] then
        if BridgeSharedConfig.DebugLevel ~= 0 then
            print("^2 Returning cached module [" .. id .. "] ^0")
        end
        return loadedModules[id]
    end

    local file = LoadResourceFile(resourceName, modulePath)
    if not file then
        error("Error loading file [" .. id .. "]")
    end

    local chunk, loadErr = load(file, id)
    if not chunk then
        error("Error wrapping module [" .. id .. "] Message: " .. loadErr)
    end

    local success, result = pcall(chunk)
    if not success then
        error("Error executing module [" .. id .. "] Message: " .. result)
    end
    loadedModules[id] = result
    return result
end

local function getServerLib()
    return {
        SQL = SQL or Require("lib/sql/server/sqlHandler.lua"),
        Logs = Logs or Require("lib/logs/server/logs.lua"),
        ItemsBuilder = ItemsBuilder or Require("lib/generators/server/ItemsBuilder.lua"),
        LootTables = LootTables or Require("lib/generators/server/lootTables.lua"),
        Cache = Cache or Require("lib/cache/shared/cache.lua"),
        ServerEntity = ServerEntity or Require("lib/entities/server/server_entity.lua"),
        Marker = Marker or Require("lib/markers/server/server.lua"),
        Particle = Particle or Require("lib/particles/server/particles.lua"),
    }
end

local function getClientLib()
    return {
        Require = Require,
        Gizmo = Gizmo or Require("lib/placers/client/gizmo.lua"),
        Scaleform = Scaleform or Require("lib/scaleform/client/scaleform.lua"),
        Placeable = Placeable or Require("lib/placers/client/object_placer.lua"),
        Utility = Utility or Require("lib/utility/client/utility.lua"),
        PlaceableObject = PlaceableObject or Require("lib/placers/client/placeable_object.lua"),
        Raycast = Raycast or Require("lib/raycast/client/raycast.lua"),
        Point = Point or Require("lib/points/client/points.lua"),
        Particle = Particle or Require("lib/particles/client/particles.lua"),
        Cache = Cache or Require("lib/cache/client/cache.lua"),
        ClientEntity = ClientEntity or Require("lib/entities/client/client_entity.lua"),
        ClientEntityActions = ClientEntityActions or Require("lib/entities/client/client_entity_actions.lua"),
        ClientStateBag = ClientStateBag or Require("lib/statebags/client/client.lua"),
        Marker = Marker or Require("lib/markers/client/markers.lua"),
        Anim = Anim or Require("lib/anim/client/client.lua"),
        Cutscene = Cutscene or Require("lib/cutscenes/client/cutscene.lua"),
        DUI = DUI or Require("lib/dui/client/dui.lua"),
    }
end

local function getSharedLib()
    return {
        Require = Require,
        Callback = Callback or Require("lib/utility/shared/callbacks.lua"),
        Ids = Ids or Require("lib/utility/shared/ids.lua"),
        ReboundEntities = ReboundEntities or Require("lib/utility/shared/rebound_entities.lua"),
        Tables = Tables or Require("lib/utility/shared/tables.lua"),
        Prints = Prints or Require("lib/utility/shared/prints.lua"),
        Math = Math or Require("lib/utility/shared/math.lua"),
        LA = LA or Require("lib/utility/shared/la.lua"),
        Perlin = Perlin or Require("lib/utility/shared/perlin.lua"),
        -- Action = Action or Require("lib/entities/shared/actions.lua"),
    }
end

cLib = setmetatable(getSharedLib(), { __index = IsDuplicityVersion() and getServerLib() or getClientLib() })
_ENV.cLib = cLib
_ENV.Require = Require
exports('cLib', function()
    return cLib
end)

--[[ _ENV.cLib = setmetatable({
    context = not IsDuplicityVersion() and "client" or "server",
    resource = GetCurrentResourceName(),
    loaded = {}
}, {
    __newindex = function(self, key, value)
        return error("Attempt to modify read-only table: " .. key)
    end,
    __index = function(self, key) -- modify the index function to load the library modules
        if self.context == "server" then
            return rawget(self.loaded, key)
        else
            return rawget(self.loaded, key)
        end
    end,
    __call = function(self) -- modify the call function to load the library modules
        if self.context == "server" then
            if not next(self.loaded) then
                self.loaded = getServerLib()
                return true
            end
        else
            if not next(self.loaded) then
                self.loaded = getClientLib()
                return true
            end
        end
    end,
})
cLib() -- load the library modules ]]

--[[
if not IsDuplicityVersion() then goto client end

cLib.SQL = SQL or Require("lib/sql/server/sqlHandler.lua")
cLib.Logs = Logs or Require("lib/logs/server/logs.lua")
cLib.ItemsBuilder = ItemsBuilder or Require("lib/generators/server/ItemsBuilder.lua")
cLib.LootTables = LootTables or Require("lib/generators/server/lootTables.lua")
cLib.Cache = Cache or Require("lib/cache/shared/cache.lua")
cLib.ServerEntity = ServerEntity or Require("lib/entities/server/server_entity.lua")
cLib.Marker = Marker or Require("lib/markers/server/server.lua")
cLib.Particle = Particle or Require("lib/particles/server/particles.lua")
if IsDuplicityVersion() then return cLib end
::client::

cLib.Gizmo = Gizmo or Require("lib/placers/client/gizmo.lua")
cLib.Scaleform = Scaleform or Require("lib/scaleform/client/scaleform.lua")
cLib.Placeable = Placeable or Require("lib/placers/client/object_placer.lua")
cLib.Utility = Utility or Require("lib/utility/client/utility.lua")
cLib.PlaceableObject = PlaceableObject or Require("lib/placers/client/placeable_object.lua")
cLib.Raycast = Raycast or Require("lib/raycast/client/raycast.lua")
cLib.Point = Point or Require("lib/points/client/points.lua")
cLib.Particle = Particle or Require("lib/particles/client/particles.lua")
cLib.Cache = Cache or Require("lib/cache/client/cache.lua")
cLib.ClientEntity = ClientEntity or Require("lib/entities/client/client_entity.lua")
cLib.ClientEntityActions = ClientEntityActions or Require("lib/entities/client/client_entity_actions.lua")
cLib.ClientStateBag = ClientStateBag or Require("lib/statebags/client/client.lua")
cLib.Marker = Marker or Require("lib/markers/client/markers.lua")
cLib.Anim = Anim or Require("lib/anim/client/client.lua")
cLib.Cutscene = Cutscene or Require("lib/cutscenes/client/cutscene.lua")
cLib.DUI = DUI or Require("lib/dui/client/dui.lua")
cLib.Particle = Particle or Require("lib/particles/client/particles.lua")

return cLib
 ]]
