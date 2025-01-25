--local NDCore = exports["ND_Core"]:GetCoreObject()
if GetResourceState('ND_Core') ~= 'started' then return end
local NDCore = exports["ND_Core"]

Framework = {}

-- Framework.GetPlayerIdentifier(src)
-- Returns the citizen ID of the player.
Framework.GetPlayerIdentifier = function(src)
    local player = NDCore:getPlayer(src)
    return player.id
end

-- Framework.GetPlayerName(src)
-- Returns the first and last name of the player.
Framework.GetPlayerName = function(src)
    local player = NDCore:getPlayer(src)
    return player.fullname
end

--[[
-- Unused by this framework
Framework.GetItem = function(src, item, metadata)

end

Framework.GetItemCount = function(src, item, metadata)

end

Framework.GetPlayerInventory = function(src)

end

Framework.AddItem = function(src, item, amount, slot, metadata)

end

Framework.RemoveItem = function(src, item, amount, slot, metadata)

end

Framework.SetMetadata = function(src, item, slot, metadata)

end


Framework.Commands = {}
Framework.Commands.Add = function(name, help, arguments, argsrequired, callback, permission, ...)

end

--]]

-- Framework.SetMetadata(src, metadata, value)
-- Adds the specified metadata key and number value to the player's data.
Framework.SetPlayerMetadata = function(src, metadata, value)
    local player = NDCore:getPlayer(src)
    player.setMetadata(metadata, value)
    return true
end

-- Framework.GetMetadata(src, metadata)
-- Gets the specified metadata key to the player's data.
Framework.GetPlayerMetadata = function(src, metadata)
    local player = NDCore:getPlayer(src)
    local playerData = player.getMetadata(metadata)
    return playerData or false
end

-- Framework.AddStress(src, value)
-- Adds the specified value to the player's stress level and updates the client HUD.
Framework.AddStress = function(src, value)
    print("Not Bridged Yet")
    return 0
end

-- Framework.RemoveStress(src, value)
-- Removes the specified value from the player's stress level and updates the client HUD.
Framework.RemoveStress = function(src, value)
    print("Not Bridged Yet")
    return 0
end

-- Framework.AddHunger(src, value)
-- Adds the specified value from the player's hunger level.
Framework.AddHunger = function(src, value)
    -- Im stuck
end

-- Framework.AddThirst(src, value)
-- Adds the specified value from the player's thirst level.
Framework.AddThirst = function(src, value)
    -- Im stuck
end

Framework.GetHunger = function(src)
    local player = NDCore:getPlayer(src)
    local metaData = player.metadata
    local hunger = metaData.status.hunger.status
    return hunger
end

Framework.GetThirst = function(src)
    local player = NDCore:getPlayer(src)
    local metaData = player.metadata
    local thirst = metaData.status.thirst.status
    return thirst
end

-- Framework.GetPlayerPhone(src)
-- Returns the phone number of the player.
Framework.GetPlayerPhone = function(src)
    local player = NDCore:getPlayer(src)
    return player.phonenumber
end

-- Framework.GetPlayerGang(src)
-- Returns the gang name of the player.
Framework.GetPlayerGang = function(src)
    print("Not Bridged Yet")
    return "none"
end

-- Framework.GetPlayersByJob(jobname)
-- returns a table of player sources that have the specified job name.
Framework.GetPlayersByJob = function(job)
    local playerList = {}
    local players = NDCore:getPlayers("job", job, false)
    for playerSource, _ in pairs(players) do
        table.insert(playerList, playerSource)
    end
    return playerList
end

-- Framework.GetPlayerJob(src)
-- Returns the job name, label, grade name, and grade level of the player.
Framework.GetPlayerJob = function(src)
    local player = NDCore:getPlayer(src)
    local jobName, jobInfo = player.getJob()
    return jobInfo.name, jobInfo.label, jobInfo.rankName, jobInfo.rank
end

-- Framework.SetPlayerJob(src, name, grade)
-- Sets the player's job to the specified name and grade.
Framework.SetPlayerJob = function(src, name, grade)
    local player = NDCore:getPlayer(src)
    return player.setJob(name, grade)
end

Framework.ToggleDuty = function(src, status)
    print("Not Bridged Yet")
    return false
end

-- Framework.AddAccountBalance(src, _type, amount)
-- Adds the specified amount to the player's account balance of the specified type.
Framework.AddAccountBalance = function(src, _type, amount)
    local player = NDCore:getPlayer(src)
    if _type == 'money' then _type = 'cash' end
    return player.addMoney(_type, amount, "")
end

-- Framework.RemoveAccountBalance(src, _type, amount)
-- Removes the specified amount from the player's account balance of the specified type.
Framework.RemoveAccountBalance = function(src, _type, amount)
    local player = NDCore:getPlayer(src)
    if _type == 'money' then _type = 'cash' end
    return player.deductMoney(_type, amount, "")
end

-- Framework.GetAccountBalance(src, _type)
-- Returns the player's account balance of the specified type.
Framework.GetAccountBalance = function(src, _type)
    local player = NDCore:getPlayer(src)
    if _type == 'money' then _type = 'cash' end
    return player.getData(_type)
end

Framework.RegisterUsableItem = function(itemName, cb)
    exports(itemName, function(event, item, inventory, slot, data)
        local slotData = exports.ox_inventory:GetSlot(inventory.id, slot)
        if event == 'usingItem' then
            cb(inventory.id, item, slotData)
            return false
        end
    end)
end