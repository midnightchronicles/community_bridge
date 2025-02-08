if GetResourceState('ox_core') ~= 'started' then return end

local Ox = require '@ox_core.lib.init'

Framework = {}

-- Framework.GetPlayerIdentifier(src)
-- Returns the citizen ID of the player.
Framework.GetPlayerIdentifier = function(src)
    -- wip
end

-- Framework.GetPlayerName(src)
-- Returns the first and last name of the player.
Framework.GetPlayerName = function(src)
    -- wip
end

-- Framework.GetItem(src, item, metadata)
-- Returns a table of items matching the specified name and if passed metadata from the player's inventory.
-- returns {name = v.name, count = v.amount, metadata = v.info, slot = v.slot}
Framework.GetItem = function(src, item, _)
    -- wip
end

-- Framework.GetItemCount(src, item, _)
-- Returns the count of items matching the specified name and if passed metadata from the player's inventory.
Framework.GetItemCount = function(src, item, _)
    -- wip
end

-- Framework.GetPlayerInventory(src)
-- Returns the entire inventory of the player as a table.
-- returns {name = v.name, count = v.amount, _, _}
Framework.GetPlayerInventory = function(src)
    -- wip
end

-- Framework.SetMetadata(src, metadata, value)
-- Adds the specified metadata key and number value to the player's data.
Framework.SetPlayerMetadata = function(src, metadata, value)
    -- wip
end

-- Framework.GetMetadata(src, metadata)
-- Gets the specified metadata key and value to the player's data.
Framework.GetPlayerMetadata = function(src, metadata)
    -- wip
end

-- defualt esx Available tables are
-- identifier, accounts, group, inventory, job, job_grade, loadout, 
-- metadata, position, firstname, lastname, dateofbirth, sex, height, 
-- skin, status, is_dead, id, disabled, last_property, created_at, last_seen, 
-- phone_number, pincode
Framework.GetStatus = function(src, column)
    -- wip
end

-- Framework.AddThirst(src, value)
-- Adds the specified value from the player's thirst level.
Framework.AddThirst = function(src, value)
    -- wip
end

-- Framework.AddHunger(src, value)
-- Adds the specified value from the player's hunger level.
Framework.AddHunger = function(src, value)
    -- wip
end

Framework.GetHunger = function(src)
    -- wip
end

Framework.GetThirst = function(src)
    -- wip
end

-- Framework.GetPlayerPhone(src)
-- Returns the phone number of the player.
Framework.GetPlayerPhone = function(src)
    -- wip
end

-- Framework.GetPlayerJob(src)
-- Returns the job name, label, grade name, and grade level of the player.
Framework.GetPlayerJob = function(src)
    -- wip
end

-- Framework.GetPlayersByJob(jobname)
-- returns a table of player sources that have the specified job name.
Framework.GetPlayersByJob = function(job)
    -- wip
end

-- Framework.SetPlayerJob(src, name, grade)
-- Sets the player's job to the specified name and grade.
Framework.SetPlayerJob = function(src, name, grade)
    -- wip
end

Framework.ToggleDuty = function(src, status)
    -- wip
end

-- Framework.AddAccountBalance(src, _type, amount)
-- Adds the specified amount to the player's account balance of the specified type.
Framework.AddAccountBalance = function(src, _type, amount)
    -- wip
end

-- Framework.RemoveAccountBalance(src, _type, amount)
-- Removes the specified amount from the player's account balance of the specified type.
Framework.RemoveAccountBalance = function(src, _type, amount)
    -- wip
end

-- Framework.GetAccountBalance(src, _type)
-- Returns the player's account balance of the specified type.
Framework.GetAccountBalance = function(src, _type)
    -- wip
end

-- Framework.AddItem(src, item, amount, _, _)
-- Adds the specified item to the player's inventory.
Framework.AddItem = function(src, item, amount, slot, metadata)
    -- wip
end

-- Framework.RemoveItem(src, item, amount, _, _)
-- Removes the specified item from the player's inventory.
Framework.RemoveItem = function(src, item, amount, slot, metadata)
    -- wip
end

-- Framework.RegisterUsableItem(item, cb)
-- Registers a usable item with a callback function.
Framework.RegisterUsableItem = function(itemName, cb)
    exports(itemName, function(event, item, inventory, slot, data)
        local slotData = exports.ox_inventory:GetSlot(inventory.id, slot)
        if event == 'usingItem' then
            cb(inventory.id, item, slotData)
        end
    end)
end