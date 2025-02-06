Bridge = {}

function Bridge.RegisterModule(moduleName, moduleTable)
    if not moduleTable then
        if BridgeSharedConfig.DebugLevel ~= 0 then
            print("^6 No moduleTable provided for module: ", moduleName, "^0")
        end
        return
    end
    if Bridge[moduleName] then
        if BridgeSharedConfig.DebugLevel ~= 0 then
            print("^6Module already registered:", moduleName, "^0")
        end
        return
    end

    local wrappedModule = {}
    if type(moduleTable) == 'function' then
        Bridge[moduleName] = wrappedModule
        return
    end
    for functionName, func in pairs(moduleTable) do
        wrappedModule[functionName] = func
    end
    if BridgeSharedConfig.DebugLevel ~= 0 then
        print("^2 Registering module:", moduleName, "^0")
    end
    Bridge[moduleName] = wrappedModule
    --trigger update object event
    TriggerEvent("Bridge:Refresh", moduleName, wrappedModule)
end
exports("RegisterModule", Bridge.RegisterModule)

--TODO: Create a way to overide functions or create a new functions for module

function Bridge.RegisterModuleFunction(moduleName, functionName, func)
    assert(moduleName and functionName and func, string.format("Bridge.RegisterModuleFunction(%s, %s, %s) - Invalid arguments", moduleName, functionName, func))
    Bridge[moduleName] = Bridge[moduleName] or {}
    Bridge[moduleName][functionName] = func
    --trigger update object event
    TriggerEvent("Bridge:Refresh", moduleName, Bridge[moduleName])
end


--Bridge
Bridge.RegisterModule("Framework", Framework)
Bridge.RegisterModule("Inventory", Inventory)
Bridge.RegisterModule("Notify", Notify)
Bridge.RegisterModule("Clothing", Clothing)
Bridge.RegisterModule("Language", Language)
Bridge.RegisterModule("Doorlock", Doorlock)
Bridge.RegisterModule("Phone", Phone)
Bridge.RegisterModule("Dispatch", Dispatch)
Bridge.RegisterModule("VehicleKey", VehicleKey)
Bridge.RegisterModule("Weather", Weather)
--lib
Bridge.RegisterModule("Tables", cLib.Tables)
Bridge.RegisterModule("Math", cLib.Math)
Bridge.RegisterModule("Prints", cLib.Prints)
Bridge.RegisterModule("Callback", cLib.Callback)

--new
Bridge.RegisterModule("Require", Require)
Bridge.RegisterModule("Ids", cLib.Ids)
Bridge.RegisterModule("ReboundEntities", cLib.ReboundEntities)
Bridge.RegisterModule("LA", cLib.LA)
Bridge.RegisterModule("Perlin", cLib.Perlin)
Bridge.RegisterModule("Actions", cLib.Actions)


CreateThread(function()
    Wait(100)
    for moduleName, moduleFunction in pairs(Bridge) do
        if type(moduleFunction) == 'table' then
            exports(moduleName, function()
                return moduleFunction
            end)
        else
            exports(moduleName, moduleFunction)
        end
    end
end)

exports('Bridge', function()
    return Bridge
end)

-- ▄▀▀ ██▀ █▀▄ █ █ ██▀ █▀▄ 
-- ▄█▀ █▄▄ █▀▄ ▀▄▀ █▄▄ █▀▄ 
if not IsDuplicityVersion() then goto client end

Bridge.RegisterModule("SQL", cLib.SQL)
Bridge.RegisterModule("Logs", cLib.Logs)
Bridge.RegisterModule("LootTables", cLib.LootTables)


--    ▄▀▀ █   █ ██▀ █▄ █ ▀█▀ 
--    ▀▄▄ █▄▄ █ █▄▄ █ ▀█  █  
if IsDuplicityVersion() then return end
::client::


Bridge.RegisterModule("Fuel", Fuel)
Bridge.RegisterModule("Input", Input)
Bridge.RegisterModule("Progressbar", Progressbar)

Bridge.RegisterModule("Target", Target)
Bridge.RegisterModule("Menu", Menu)
Bridge.RegisterModule("Utility", cLib.Utility)
Bridge.RegisterModule("Placeable", cLib.Placeable)
--new
-- Bridge.RegisterModule("Gizmo", cLib.Gizmo)
-- Bridge.RegisterModule("Scaleform", cLib.Scaleform)
-- Bridge.RegisterModule("PlaceableObject", cLib.PlaceableObject)
--


-- Fill the bridge tables with player data.
function FillBridgeTables()
    PlayerLoaded = true
    PlayerIdentifier = Framework.GetPlayerIdentifier()
    PlayerJobName, PlayerJobLabel, PlayerJobGradeName, PlayerJobGradeLevel = Framework.GetPlayerJob()
end

-- Clean the bridge tables.
function ClearClientSideVariables()
    PlayerLoaded = false
    PlayerIdentifier = nil
    PlayerJobName = nil
    PlayerJobLabel = nil
    PlayerJobGradeName = nil
    PlayerJobGradeLevel = nil
    StoredOldClothing = {}
end
