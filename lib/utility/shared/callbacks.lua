Callbacks = {}
cbData = {}
Callback = Callback or {}

--=======================================
-- ▀█▀ █▄█ █ █▄ █ █▄▀    ▄▀▄ ██▄ ▄▀▄ █ █ ▀█▀    ▄▀▄ █▀▄ █▀▄ █ █▄ █ ▄▀     █▀▄ █▀▄ ▄▀▄ █▄ ▄█ █ ▄▀▀ ██▀ ▄▀▀    ▀█▀ ▄▀▄    ▄▀▀ ▄▀▄ █   █   ██▄ ▄▀▄ ▄▀▀ █▄▀ ▄▀▀ 
--  █  █ █ █ █ ▀█ █ █    █▀█ █▄█ ▀▄▀ ▀▄█  █     █▀█ █▄▀ █▄▀ █ █ ▀█ ▀▄█    █▀  █▀▄ ▀▄▀ █ ▀ █ █ ▄█▀ █▄▄ ▄█▀     █  ▀▄▀    ▀▄▄ █▀█ █▄▄ █▄▄ █▄█ █▀█ ▀▄▄ █ █ ▄█▀ 
--=======================================

local resource = GetCurrentResourceName() or 'unknown'

local clientToServerName = resource .. ':server:CS:TriggerCallback'
local clientToServerBackToClientName = resource .. ':client:CSC:TriggerCallback'

local serverToClientName = resource .. ':client:SC:TriggerCallback'
local serverToClientBackToServerName = resource .. ':server:SCS:TriggerCallback'

exports('Callback', Callback)

if not IsDuplicityVersion() then goto client end

-- -- -- -- -- -- -- -- -- --
-- ▄▀▀ ██▀ █▀▄ █ █ ██▀ █▀▄ 
-- ▄█▀ █▄▄ █▀▄ ▀▄▀ █▄▄ █▀▄ 
-- -- -- -- -- -- -- -- -- --

-- client to server rebound
function Callback.Register(name, callback, all)
    Callback[name] = {
        callback = callback,
        toAll = all
    }
end

-- Handle client requests and send response back to client(s)
RegisterNetEvent(clientToServerName, function(name, cbId, ...)
    local src = source
    local data = Callback[name]
    if not data then return end   
    local func = data.callback
    if not func then return end
    local toAll = data.toAll and -1 or src

    -- Create response handler
    local packed = table.pack(func(src, ...))
    TriggerClientEvent(clientToServerBackToClientName, toAll, name, cbId, table.unpack(packed))
end)

-- Server to client trigger function - supports both callback and direct return
function Callback.Trigger(name, src, callbackOrArg, ...)
    if src == nil then src = -1 end

    -- Determine if the third parameter is a callback function or an argument
    local hasCallback = type(callbackOrArg) == 'function' or (type(callbackOrArg) == 'table' and rawget(callbackOrArg, '__cfx_functionReference'))
    local callback = hasCallback and callbackOrArg or nil
    -- Adjust args based on whether the callback is present
    local args = hasCallback and {...} or {callbackOrArg, ...}

    local cbId = name .. '_' .. math.random(1000000, 9999999)
    local p = promise.new()

    -- Store promise data
    cbData[cbId] = {
        cb = callback,
        p = p
    }

    -- Trigger for single player or multiple players
    if type(src) == 'table' then
        for i, d in pairs(src) do
            TriggerClientEvent(serverToClientName, tonumber(d), name, cbId, table.unpack(args))
        end
    else
        TriggerClientEvent(serverToClientName, tonumber(src), name, cbId, table.unpack(args))
    end

    -- If no callback was provided, wait for the promise and return directly

    local result = Citizen.Await(p)
    -- If there's only one value, return it directly
    if #result == 1 then
        return result[1]
    else
        return table.unpack(result or {})
    end

end

-- Handle responses to server requests
RegisterNetEvent(serverToClientBackToServerName, function(name, cbId, ...)
    local data = cbData[cbId]
    if not data then return end

    -- Process callback if provided

    if data.cb then
        data.cb({...})
    end
    -- Always resolve the promise with all args for direct returns
    data.p:resolve({...})
    cbData[cbId] = nil
end)

exports('RegisterCallback', Callback.Register)
exports('TriggerCallback', Callback.Trigger)

-- -- -- -- -- -- -- -- -- --
-- ▄▀▀ █   █ ██▀ █▄ █ ▀█▀ 
-- ▀▄▄ █▄▄ █ █▄▄ █ ▀█  █  
-- -- -- -- -- -- -- -- -- --
if IsDuplicityVersion() then return Callback end
::client::

cbRebounds = {}
function Callback.Register(name, callback)
    Callback[name] = {
        callback = callback,
    }
end

function Callback.RegisterRebound(name, callback)
    cbRebounds[name] = callback
end

-- Client to server trigger - supports both callback and direct return
function Callback.Trigger(name, callbackOrArg, ...)
    -- Determine if the second parameter is a callback function or an argument
    local hasCallback = type(callbackOrArg) == 'function' or (type(callbackOrArg) == 'table' and rawget(callbackOrArg, '__cfx_functionReference'))
    local callback = hasCallback and callbackOrArg or nil
    -- Adjust args based on whether the callback is present
    local args = hasCallback and {...} or {callbackOrArg, ...}

    local cbId = name .. '_' .. math.random(1000000, 9999999)
    local p = promise.new()

    -- Store promise data
    cbData[cbId] = {
        cb = callback,
        p = p
    }

    -- Trigger the server event
    TriggerServerEvent(clientToServerName, name, cbId, table.unpack(args))

    -- If no callback was provided, wait for the promise and return directly
    if not hasCallback then
        local result = Citizen.Await(p)
        -- If there's only one value, return it directly
        if #result == 1 then
            return result[1]
        else
            return table.unpack(result)
        end
    end

    -- Otherwise, return nothing (callback will handle it)
    return nil
end

-- Handle responses from server
RegisterNetEvent(clientToServerBackToClientName, function(name, cbId, ...)
    -- Check for global rebounding callbacks
    local clientRebound = cbRebounds[name]
    if clientRebound then
        clientRebound(...)
    end

    -- Handle the specific callback instance
    local data = cbData[cbId]
    if not data then return end

    -- Process callback if provided
    if data.cb then
        data.cb(...)
    end

    -- Always resolve the promise with all args for direct returns
    data.p:resolve({...})
    cbData[cbId] = nil
end)

-- Handle server requests to client
RegisterNetEvent(serverToClientName, function(name, cbId, ...)
    local data = Callback[name]
    if not data then return end
    local func = data.callback
    if not func then return end

    -- Create response handler
    TriggerServerEvent(serverToClientBackToServerName, name, cbId, func(...))
end)

exports('RegisterCallback', Callback.Register)
exports('RegisterRebound', Callback.RegisterRebound)
exports('TriggerCallback', Callback.Trigger)

return Callback