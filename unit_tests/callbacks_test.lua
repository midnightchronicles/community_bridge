-- ▄▀▀ ▄▀▄ █   █   ██▄ ▄▀▄ ▄▀▀ █▄▀ ▄▀▀    ▄▀▀ █▄█ ▄▀▄ █▀▄ ██▀ █▀▄    █ █ █▄ █ █ ▀█▀    ▀█▀ ██▀ ▄▀▀ ▀█▀ 
-- ▀▄▄ █▀█ █▄▄ █▄▄ █▄█ █▀█ ▀▄▄ █ █ ▄█▀    ▄█▀ █ █ █▀█ █▀▄ █▄▄ █▄▀    ▀▄█ █ ▀█ █  █      █  █▄▄ ▄█▀  █  

-- -- -- -- -- -- -- -- -- --
-- ▄▀▀ ██▀ █▀▄ █ █ ██▀ █▀▄ 
-- ▄█▀ █▄▄ █▀▄ ▀▄▀ █▄▄ █▀▄ 
-- -- -- -- -- -- -- -- -- --
if not IsDuplicityVersion() then goto client end

exports.community_bridge:RegisterCallback('callback_test1_name_here', function(src, var1)
    if var1 == "herpaderpa" then
        print("this is a test")
    end
    return 'some random string', "some other string"
end)

RegisterCommand('callback_test2', function(source)
    local someData, other = exports.community_bridge:TriggerCallback('callback_test2_name_here', source, "herpaderpa")
    print("Data From Client: ", someData, other)
end)

-- -- -- -- -- -- -- -- -- --
-- ▄▀▀ █   █ ██▀ █▄ █ ▀█▀ 
-- ▀▄▄ █▄▄ █ █▄▄ █ ▀█  █  
-- -- -- -- -- -- -- -- -- --
if IsDuplicityVersion() then return end
::client::

RegisterCommand('callback_test1', function()
    local somerandomstring, someotherrandomstring = exports.community_bridge:TriggerCallback('callback_test1_name_here', "herpaderpa")
    print("Data From Server: ", somerandomstring, someotherrandomstring)
end)

-- exports.community_bridge:RegisterRebound('callback_test1', function(src, cb, ftpcsftug)
--     print("this is a rebound to all players")
-- end)

exports.community_bridge:RegisterCallback('callback_test2_name_here', function(ftpcsftug)
    return ftpcsftug, 'TestyMcTesterton'
end)
