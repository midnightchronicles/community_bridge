local NDCore = exports["ND_Core"]:GetCoreObject()

Framework = {}

-- Framework.GetPlayerIdentifier(src)
-- Returns the citizen ID of the player.
Framework.GetPlayerIdentifier = function(src)
    local player = NDCore.getPlayer(src)
    return player.id
end

-- Framework.GetPlayerName(src)
-- Returns the first and last name of the player.
Framework.GetPlayerName = function(src)
    local player = NDCore.getPlayer(src)
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
    local player = NDCore.getPlayer(src)
    player.setMetadata(metadata, value)
    return true
end

-- Framework.GetMetadata(src, metadata)
-- Gets the specified metadata key to the player's data.
Framework.GetPlayerMetadata = function(src, metadata)
    local player = NDCore.getPlayer(src)
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
    local player = NDCore.getPlayer(src)
    local oldHunger = player.getMetadata("hunger").status
    local newHunger = (oldHunger or 0) + value
    player.setMetadata('hunger', Math.Clamp(newHunger, 0, 100))
    return newHunger
end

-- Framework.AddThirst(src, value)
-- Adds the specified value from the player's thirst level.
Framework.AddThirst = function(src, value)
    local player = NDCore.getPlayer(src)
    local oldThirst = player.getMetadata("thirst").status
    local newThirst = (oldThirst or 0) + value
    player.setMetadata('thirst', Math.Clamp(newThirst, 0, 100))
    return newThirst
end

Framework.GetHunger = function(src)
    local player = NDCore.getPlayer(src)
    local hunger = player.getMetadata("hunger")
    return hunger.status
end

Framework.GetThirst = function(src)
    local player = NDCore.getPlayer(src)
    local thirst = player.getMetadata("thirst")
    return thirst.status
end

-- Framework.GetPlayerPhone(src)
-- Returns the phone number of the player.
Framework.GetPlayerPhone = function(src)
    local player = NDCore.getPlayer(src)
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
    local players = NDCore.getPlayers("job", job, false)
    for playerSource, _ in pairs(players) do
        table.insert(playerList, playerSource)
    end
    return playerList
end

-- Framework.GetPlayerJob(src)
-- Returns the job name, label, grade name, and grade level of the player.
Framework.GetPlayerJob = function(src)
    local player = NDCore.getPlayer(src)
    local jobName, jobInfo = player.getJob()
    return jobInfo.name, jobInfo.label, jobInfo.rankName, jobInfo.rank
end

-- Framework.SetPlayerJob(src, name, grade)
-- Sets the player's job to the specified name and grade.
Framework.SetPlayerJob = function(src, name, grade)
    local player = NDCore.getPlayer(src)
    return player.setJob(name, grade)
end

Framework.ToggleDuty = function(src, status)
    print("Not Bridged Yet")
    return false
end

-- Framework.AddAccountBalance(src, _type, amount)
-- Adds the specified amount to the player's account balance of the specified type.
Framework.AddAccountBalance = function(src, _type, amount)
    local player = NDCore.getPlayer(src)
    if _type == 'money' then _type = 'cash' end
    return player.addMoney(_type, amount, "")
end

-- Framework.RemoveAccountBalance(src, _type, amount)
-- Removes the specified amount from the player's account balance of the specified type.
Framework.RemoveAccountBalance = function(src, _type, amount)
    local player = NDCore.getPlayer(src)
    if _type == 'money' then _type = 'cash' end
    return player.deductMoney(_type, amount, "")
end

-- Framework.GetAccountBalance(src, _type)
-- Returns the player's account balance of the specified type.
Framework.GetAccountBalance = function(src, _type)
    local player = NDCore.getPlayer(src)
    if _type == 'money' then _type = 'cash' end
    return player.getAccount(_type)
end

Framework.RegisterUsableItem = function(itemName, cb)
    exports(itemName, function(event, item, inventory, slot, data)
        local slotData = exports.ox_inventory:GetSlot(inventory.id, slot)
        if event == 'usingItem' then
            cb(inventory.id, item, slotData)
        end
    end)
end

Citizen.CreateThread(function()
    Wait(1000)
    local player = NDCore.getPlayer(1)
    print(json.encode(player))
end)

-- local otherdata = NDCore.Functions.GetSelectedCharacter() and NDCore:getPlayer() are the same shit?


--[[
{"metadata":{
    "status":{"armor":{"max":100.0,"reversed":true,"type":"armor","status":0.0},
    "hunger":{"status":99.97333333333333,"type":"hunger","max":100.0},
    "thirst":{"status":99.97777777777778,"type":"thirst","max":100.0},
    "health":{"status":100.0,"type":"health","max":100.0},
    "stamina":{"status":100.0,"type":"stamina","max":100.0},
    "alcohol":{"max":100.0,"reversed":true,"type":"alcohol","status":0}}
,"clothing":{"tattoos":[],"eyeColor":0,"props":[{"prop_id":0,"drawable":-1,"texture":-1},{"prop_id":1,"drawable":-1,"texture":-1},{"prop_id":2,"drawable":-1,"texture":-1},{"prop_id":6,"drawable":-1,"texture":-1},{"prop_id":7,"drawable":-1,"texture":-1}],"hair":{"style":0,"color":0,"highlight":0},"model":"mp_m_freemode_01","headOverlays":{"complexion":{"style":0,"color":0,"opacity":0},"bodyBlemishes":{"style":0,"color":0,"opacity":0},"lipstick":{"style":0,"color":0,"opacity":0},"blemishes":{"style":0,"color":0,"opacity":0},"beard":{"style":0,"color":0,"opacity":0},"blush":{"style":0,"color":0,"opacity":0},"moleAndFreckles":{"style":0,"color":0,"opacity":0},"chestHair":{"style":0,"color":0,"opacity":0},"makeUp":{"style":0,"color":0,"opacity":0},"eyebrows":{"style":0,"color":0,"opacity":0},"ageing":{"style":0,"color":0,"opacity":0},"sunDamage":{"style":0,"color":0,"opacity":0}},"headBlend":{"shapeSecond":0,"skinMix":0,"skinFirst":0,"skinSecond":0,"shapeMix":0,"shapeFirst":0},"components":[{"component_id":0,"drawable":0,"texture":0},{"component_id":1,"drawable":0,"texture":0},{"component_id":2,"drawable":0,"texture":0},{"component_id":3,"drawable":0,"texture":0},{"component_id":4,"drawable":0,"texture":0},{"component_id":5,"drawable":0,"texture":0},{"component_id":6,"drawable":0,"texture":0},{"component_id":7,"drawable":0,"texture":0},{"component_id":8,"drawable":0,"texture":0},{"component_id":9,"drawable":0,"texture":0},{"component_id":10,"drawable":0,"texture":0},{"component_id":11,"drawable":0,"texture":0}],"faceFeatures":{"jawBoneBackSize":0,"chinBoneSize":0,"eyeBrownHigh":0,"noseBoneHigh":0,"eyeBrownForward":0,"chinBoneLenght":0,"nosePeakHigh":0,"noseBoneTwist":0,"chinHole":0,"noseWidth":0,"eyesOpening":0,"chinBoneLowering":0,"jawBoneWidth":0,"lipsThickness":0,"nosePeakLowering":0,"cheeksBoneHigh":0,"neckThickness":0,"nosePeakSize":0,"cheeksBoneWidth":0,"cheeksWidth":0}},"ethnicity":"wgggggggg"},
"groups":{"lsfd":{"isJob":true,"isBoss":false,"label":"LSFD","name":"lsfd","metadata":[],"rank":1,"rankName":"Volunteer"}},
"dob":"1993-09-22",
"bank":8800,
"lastname":"Wood",
"fullname":"Charles Wood",
"firstname":"Charles",
"cash":2500,
"discord":[],
"inventory":[],
"source":1,
"job":"lsfd",
"jobInfo":{"isJob":true,"isBoss":false,"label":"LSFD","name":"lsfd","metadata":[],"rank":1,"rankName":"Volunteer"},
"gender":"Male",
"name":"MrNewb",
"id":1,
"identifiers":{"ip":"ip:192.168.0.248","license":"license:4348f174860e7f066756f8057ad7a1d8406e7624","discord":"discord:299410129982455808","live":"live:985156709508143","fivem":"fivem:627480","xbl":"xbl:2533274909557009"},
"identifier":"license:4348f174860e7f066756f8057ad7a1d8406e7624"}
--]]


--[[
{"id":1,
"setData":{"__cfx_functionReference":"ND_Core:931:12157"},
"name":"MrNewb",
"job":"lsfd",
"inventory":[],
"triggerEvent":{"__cfx_functionReference":"ND_Core:931:12149"},
"cash":2520,
"setCoords":{"__cfx_functionReference":"ND_Core:931:12143"},
"jobInfo":{"label":"LSFD","metadata":[],"isBoss":false,"isJob":true,"name":"lsfd","rankName":"Volunteer","rank":1},
"identifiers":{"license":"license:4348f174860e7f066756f8057ad7a1d8406e7624","discord":"discord:299410129982455808","fivem":"fivem:627480","xbl":"xbl:2533274909557009","live":"live:985156709508143","ip":"ip:192.168.0.248"},
"source":1,
"getLicense":{"__cfx_functionReference":"ND_Core:931:12141"},
"setJob":{"__cfx_functionReference":"ND_Core:931:12150"},
"firstname":"Charles",
"depositMoney":{"__cfx_functionReference":"ND_Core:931:12142"},
"fullname":"Charles Wood",
"groups":{"lsfd":{"label":"LSFD","metadata":[],"isBoss":false,"isJob":true,"name":"lsfd","rankName":"Volunteer","rank":1}},
"unload":{"__cfx_functionReference":"ND_Core:931:12159"},"getData":{"__cfx_functionReference":"ND_Core:931:12158"},
"bank":9999777780,
"gender":"Male",
"metadata":{"PlateCarrier":{"name":"fib_specops_carrier","metadata":{"PlateCarrier":true,"Clothing":{"drawable":{"male":11,"female":1},"texture":{"male":0,"female":0}},"Condition":70,"SerialNumber":"Y8TYAW175174I8","description":"\n\n Condition :70\n\n Strength:7\n\n Serial Number:Y8TYAW175174I8","Strength":7}},"deathInfo":false,"clothing":{"eyeColor":0,"props":[{"prop_id":0,"texture":-1,"drawable":-1},{"prop_id":1,"texture":-1,"drawable":-1},{"prop_id":2,"texture":-1,"drawable":-1},{"prop_id":6,"texture":-1,"drawable":-1},{"prop_id":7,"texture":-1,"drawable":-1}],"headBlend":{"shapeFirst":0,"skinSecond":0,"shapeMix":0,"shapeSecond":0,"skinMix":0,"skinFirst":0},"tattoos":[],"hair":{"style":0,"color":0,"highlight":0},"faceFeatures":{"eyeBrownForward":0,"cheeksBoneWidth":0,"neckThickness":0,"noseBoneTwist":0,"chinBoneSize":0,"lipsThickness":0,"cheeksBoneHigh":0,"chinHole":0,"cheeksWidth":0,"chinBoneLenght":0,"chinBoneLowering":0,"nosePeakLowering":0,"nosePeakSize":0,"nosePeakHigh":0,"jawBoneBackSize":0,"jawBoneWidth":0,"noseBoneHigh":0,"eyeBrownHigh":0,"eyesOpening":0,"noseWidth":0},"model":"mp_m_freemode_01","headOverlays":{"beard":{"opacity":0,"color":0,"style":0},"makeUp":{"opacity":0,"color":0,"style":0},"ageing":{"opacity":0,"color":0,"style":0},"moleAndFreckles":{"opacity":0,"color":0,"style":0},"lipstick":{"opacity":0,"color":0,"style":0},"bodyBlemishes":{"opacity":0,"color":0,"style":0},"complexion":{"opacity":0,"color":0,"style":0},"chestHair":{"opacity":0,"color":0,"style":0},"eyebrows":{"opacity":0,"color":0,"style":0},"blush":{"opacity":0,"color":0,"style":0},"blemishes":{"opacity":0,"color":0,"style":0},"sunDamage":{"opacity":0,"color":0,"style":0}},"components":[{"drawable":0,"component_id":0,"texture":0},{"drawable":0,"component_id":1,"texture":0},{"drawable":0,"component_id":2,"texture":0},{"drawable":0,"component_id":3,"texture":0},{"drawable":0,"component_id":4,"texture":0},{"drawable":0,"component_id":5,"texture":0},{"drawable":0,"component_id":6,"texture":0},{"drawable":0,"component_id":7,"texture":0},{"drawable":0,"component_id":8,"texture":0},{"drawable":0,"component_id":9,"texture":0},{"drawable":0,"component_id":10,"texture":0},{"drawable":0,"component_id":11,"texture":0}]},"dead":false,"status":{"health":{"max":100.0,"status":88.09523809523809,"type":"health"},"alcohol":{"max":100.0,"reversed":true,"type":"alcohol","status":0},"armor":{"max":100.0,"reversed":true,"type":"armor","status":58.33333333333333},"stamina":{"max":100.0,"status":100.0,"type":"stamina"},"thirst":{"max":100.0,"status":37.88333333332389,"type":"thirst"},"hunger":{"max":100.0,"status":27.03999999999778,"type":"hunger"}},"ethnicity":"wgggggggg"},
"updateLicense":{"__cfx_functionReference":"ND_Core:931:12146"},
"revive":{"__cfx_functionReference":"ND_Core:931:12154"},
"save":{"__cfx_functionReference":"ND_Core:931:12153"},
"getJob":{"__cfx_functionReference":"ND_Core:931:12135"},
"active":{"__cfx_functionReference":"ND_Core:931:12152"},
"removeGroup":{"__cfx_functionReference":"ND_Core:931:12151"},
"dob":"1993-09-22",
"identifier":"license:4348f174860e7f066756f8057ad7a1d8406e7624",
"notify":{"__cfx_functionReference":"ND_Core:931:12137"},
"createLicense":{"__cfx_functionReference":"ND_Core:931:12144"},
"lastname":"Wood",
"deductMoney":{"__cfx_functionReference":"ND_Core:931:12138"},
"setMetadata":{"__cfx_functionReference":"ND_Core:931:12136"},
"withdrawMoney":{"__cfx_functionReference":"ND_Core:931:12139"},
"drop":{"__cfx_functionReference":"ND_Core:931:12155"},
"delete":{"__cfx_functionReference":"ND_Core:931:12145"},
"getMetadata":{"__cfx_functionReference":"ND_Core:931:12140"},
"addGroup":{"__cfx_functionReference":"ND_Core:931:12156"},
"getGroup":{"__cfx_functionReference":"ND_Core:931:12148"},
"addMoney":{"__cfx_functionReference":"ND_Core:931:12147"},
"discord":[]}

]]--