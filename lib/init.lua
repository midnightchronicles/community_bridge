loadedModules = {}

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

cLib = {
    Require = Require,
    Callback = Callback or Require("lib/shared/callbacks.lua"),
    Ids = Ids or Require("lib/shared/ids.lua"),
    ReboundEntities = ReboundEntities or Require("lib/shared/rebound_entities.lua"),
    Tables = Tables or Require("lib/shared/tables.lua"),
    Prints = Prints or Require("lib/shared/prints.lua"),
    Math = Math or Require("lib/shared/math.lua"),
    LA = LA or Require("lib/shared/la.lua"),
    Perlin = Perlin or Require("lib/shared/perlin.lua"),
    Actions = Actions or Require("lib/shared/actions.lua"),
}

exports('cLib', cLib)

if not IsDuplicityVersion() then goto client end

cLib.SQL = SQL or Require("lib/server/sqlHandler.lua")
cLib.Logs = Logs or Require("lib/server/logs.lua")
cLib.LootTables = LootTables or Require("lib/server/lootTables.lua")

if IsDuplicityVersion() then return cLib end
::client::

-- cLib.Gizmo = Gizmo or Require("lib/client/gizmo.lua")
-- cLib.Scaleform = Scaleform or Require("lib/client/scaleform.lua")
cLib.Placeable = Placeable or Require("lib/client/object_placer.lua")
cLib.Utility = Utility or Require("lib/client/utility.lua")
-- cLib.PlaceableObject = PlaceableObject or Require("lib/client/object_placer.lua")


return cLib