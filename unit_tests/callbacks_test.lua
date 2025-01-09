-- ▄▀▀ ▄▀▄ █   █   ██▄ ▄▀▄ ▄▀▀ █▄▀ ▄▀▀    ▄▀▀ █▄█ ▄▀▄ █▀▄ ██▀ █▀▄    █ █ █▄ █ █ ▀█▀    ▀█▀ ██▀ ▄▀▀ ▀█▀ 
-- ▀▄▄ █▀█ █▄▄ █▄▄ █▄█ █▀█ ▀▄▄ █ █ ▄█▀    ▄█▀ █ █ █▀█ █▀▄ █▄▄ █▄▀    ▀▄█ █ ▀█ █  █      █  █▄▄ ▄█▀  █  

-- -- -- -- -- -- -- -- -- --
-- ▄▀▀ ██▀ █▀▄ █ █ ██▀ █▀▄ 
-- ▄█▀ █▄▄ █▀▄ ▀▄▀ █▄▄ █▀▄ 
-- -- -- -- -- -- -- -- -- --
if not IsDuplicityVersion() then goto client end
exports.community_bridge:RegisterCallback('ClientToServerToClient', function(src, cb, ftpcsftug)
    cb(ftpcsftug, 'some random string')
end)

RegisterCommand('cb_server_test', function(source)
    local someData = exports.community_bridge:TriggerCallback('ServerToClientToServer', source, function(ftpcsftug, derpa)
        print(ftpcsftug, derpa)
        return "This data gets passed up the chain"
    end,"herpaderpa")
    print("print", someData)
end)



-- -- -- -- -- -- -- -- -- --
-- ▄▀▀ █   █ ██▀ █▄ █ ▀█▀ 
-- ▀▄▄ █▄▄ █ █▄▄ █ ▀█  █  
-- -- -- -- -- -- -- -- -- --
if IsDuplicityVersion() then return end
::client::


RegisterCommand('cb_client_test', function()
    local someData = exports.community_bridge:TriggerCallback('ClientToServerToClient', function(ftpcsftug, derpa)
        print(ftpcsftug, derpa, "This will fire on the player who triggered the event")
    end,"herpaderpa")
    print(someData)
end)

exports.community_bridge:RegisterRebound('ClientToServerToClient', function(src, cb, ftpcsftug)
    print("this is a rebound from another player or himself")
end)

exports.community_bridge:RegisterCallback('ServerToClientToServer', function(cb, ftpcsftug)
    cb(ftpcsftug, 'TestyMcTesterton')
end)
