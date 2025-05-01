Utility = Utility or {}
local blipIDs = {}
local spawnedPeds = {}

---commentThis will create a prop with the passed model string at the coords and heading specified optionally networked or not.
---@param model string | number
---@param coords table
---@param heading number
---@param networked boolean
---@return number | nil
Utility.CreateProp = function(model, coords, heading, networked)
    Utility.LoadModel(model)
    if not HasModelLoaded(model) then return nil, Prints.Error("Model Has Not Loaded") end
    local propEntity = CreateObject(model, coords.x, coords.y, coords.z, networked, false, false)
    SetEntityHeading(propEntity, heading)
    SetModelAsNoLongerNeeded(model)
    return propEntity
end

---This will get the street name and crossing name at the specified coordinates.
---@param coords table
---@return string
---@return string
Utility.GetStreetNameAtCoords = function(coords)
    local streetHash, crossingHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local streetName = GetStreetNameFromHashKey(streetHash)
    local crossingName = GetStreetNameFromHashKey(crossingHash)
    return streetName, crossingName
end

---This will create a vehicle with the passed model string at the coords and heading specified.
---@param model string
---@param coords table
---@param heading number
---@param networked boolean
---@return number| nil
---@return table
Utility.CreateVehicle = function(model, coords, heading, networked)
    Utility.LoadModel(model)
    if not HasModelLoaded(model) then return nil, {}, Prints.Error("Model Has Not Loaded") end
    local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, networked, false)
    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    SetVehicleNeedsToBeHotwired(vehicle, false)
    SetVehRadioStation(vehicle, "OFF")
    SetModelAsNoLongerNeeded(model)
    return vehicle, { networkid = NetworkGetNetworkIdFromEntity(vehicle) or 0, coords = GetEntityCoords(vehicle), heading = GetEntityHeading(vehicle), }
end

---This will create a ped with the passed model string at the coords and heading specified.
---@param model string
---@param coords table
---@param heading number
---@param networked boolean
---@return number| nil
Utility.CreatePed = function(model, coords, heading, networked, settings)
    Utility.LoadModel(model)
    if not HasModelLoaded(model) then return nil, Prints.Error("Model Has Not Loaded") end
    local spawnedEntity = CreatePed(0, model, coords.x, coords.y, coords.z, heading, networked, false)
    SetModelAsNoLongerNeeded(model)
    table.insert(spawnedPeds, spawnedEntity)
    return spawnedEntity
end

---This will display a busy spinner with the passed text.
---@param text string
---@return boolean
Utility.StartBusySpinner = function(text)
    AddTextEntry(text, text)
    BeginTextCommandBusyString(text)
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandBusyString(0)
    return true
end

---This will stop a busy spinner if one is currently active.
---@return boolean
Utility.StopBusySpinner = function()
    if BusyspinnerIsOn() then
        BusyspinnerOff()
        return true
    end
    return false
end

---comment Creates a blip at the specified coordinates with the specified parameters. If sprite/color/scale/label are not provided, default values will be used.
---@param coords table
---@param sprite number
---@param color number
---@param scale number
---@param label string
---@param shortRange boolean
---@param displayType number
---@return integer
Utility.CreateBlip = function(coords, sprite, color, scale, label, shortRange, displayType)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, sprite or 8)
    SetBlipColour(blip, color or 3)
    SetBlipScale(blip, scale or 0.8)
    SetBlipDisplay(blip, displayType or 2)
    SetBlipAsShortRange(blip, shortRange)
    AddTextEntry(label, label)
    BeginTextCommandSetBlipName(label)
    EndTextCommandSetBlipName(blip)
    table.insert(blipIDs, blip)
    return blip
end

---This will remove a blip if it exists in the blipIDs table.
---@param blip number
---@return boolean
Utility.RemoveBlip = function(blip)
    local success = false
    for i, storedBlip in ipairs(blipIDs) do
        if storedBlip == blip then
            RemoveBlip(storedBlip)
            table.remove(blipIDs, i)
            success = true
            break
        end
    end
    return success
end

---Loads a model into memory. If the model is not valid or not in the game files, it will return false.
---@param model string | number
---@return boolean
Utility.LoadModel = function(model)
    if type(model) ~= 'number' then model = joaat(model) end -- Use GetHashKey instead of joaat for client
    if not IsModelValid(model) and not IsModelInCdimage(model) then return false end
    RequestModel(model)
    local count = 0
    while not HasModelLoaded(model) and count < 30000 do
        Wait(0)
        count = count + 1
    end
    return HasModelLoaded(model)
end

---This function will request an animation dictionary and wait until it is loaded. If the dictionary is not valid, it will return false.
---@param dict string
---@return boolean
Utility.RequestAnimDict = function(dict)
    RequestAnimDict(dict)
    local count = 0
    while not HasAnimDictLoaded(dict) and count < 30000 do
        Wait(0)
        count = count + 1
    end
    return HasAnimDictLoaded(dict)
end

---This will remove a ped if it exists in the spawnedPeds table. It will also delete the entity if it exists.
---@param entity number
---@return boolean
Utility.RemovePed = function(entity)
    local success = false
    if DoesEntityExist(entity) then
        DeleteEntity(entity)
    end
    for i, storedEntity in ipairs(spawnedPeds) do
        if storedEntity == entity then
            table.remove(spawnedPeds, i)
            success = true
            break
        end
    end
    return success
end

---This will use a native text input menu to allow the user to enter text. It will return the entered text or false if cancelled.
---@param text string
---@param length number
---@return string
Utility.NativeInputMenu = function(text, length)
    local maxLength = Math.Clamp(length, 1, 50)
    local menutText = text or 'enter text'
    AddTextEntry(menutText, menutText)
    DisplayOnscreenKeyboard(1, menutText, "", "", "", "", "", maxLength)
    while(UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0)
        Wait(0)
    end
    if(GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
        return result
    end
    return false
end

---This will get the current skin data of the entity passed. It will return a table with the clothing and props data.
---@param entity number
---@return table
Utility.GetEntitySkinData = function(entity)
    local skinData = {}
    for i = 0, 11 do
        skinData.clothing[i] = {GetPedDrawableVariation(entity, i), GetPedTextureVariation(entity, i)}
    end
    for i = 0, 13 do
        skinData.props[i] = {GetPedPropIndex(entity, i), GetPedPropTextureIndex(entity, i)}
    end
    return skinData
end

---This will set the skin data of the entity passed. It will set the clothing and props data from the skinData table.
---@param entity number
---@param skinData table
---@return boolean
Utility.SetEntitySkinData = function(entity, skinData)
    for i = 0, 11 do
        SetPedComponentVariation(entity, i, skinData.clothing[i][1], skinData.clothing[i][2], 0)
    end
    for i = 0, 13 do
        SetPedPropIndex(entity, i, skinData.props[i][1], skinData.props[i][2], 0)
    end
    return true
end

---This will reload the skin data of the entity passed. It will set the clothing and props data from the skinData table and delete any attached objects.
---@return boolean
Utility.ReloadSkin = function()
    local skinData = Utility.GetEntitySkinData(cache.ped)
    Utility.SetEntitySkinData(cache.ped, skinData)
    for _, props in pairs(GetGamePool("CObject")) do
        if IsEntityAttachedToEntity(cache.ped, props) then
            SetEntityAsMissionEntity(props, true, true)
            DeleteObject(props)
            DeleteEntity(props)
        end
    end
    return true
end

---This will display a native help text on the screen. It will add a text entry and display it for the specified duration.
---@param text string
---@param duration number
Utility.HelpText = function(text, duration)
    AddTextEntry(text, text)
    BeginTextCommandDisplayHelp(text)
    EndTextCommandDisplayHelp(0, false, true, duration or 5000)
end

---This will display 3D help text at the specified coordinates.
---@param coords table
---@param text string
---@param scale number
Utility.Draw3DHelpText = function(coords, text, scale)
    local onScreen, x, y = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)
    if onScreen then
        SetTextScale(scale or 0.35, scale or 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(x, y)
        local factor = (string.len(text)) / 370
        DrawRect(x, y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 100)
    end
end

---This will display a native help text on the screen. It will add a text entry and display it for the specified duration.
---@param text string
Utility.NotifyText = function(text)
    AddTextEntry(text, text)
    SetNotificationTextEntry(text)
    DrawNotification(false, true)
end

---This will teleport a player to the specified coordinates. If a condition function is passed it will verify that condition is met and then it will fade the screen out and in, freeze the player during the teleport to allow for collisions to load, and call the afterTeleportFunction if provided.
---@param coords table
---@param conditionFunction function | optional
---@param afterTeleportFunction function | optional
Utility.TeleportPlayer = function(coords, conditionFunction, afterTeleportFunction)
    if conditionFunction ~= nil then
        if not conditionFunction() then
            return
        end
    end
    DoScreenFadeOut(2500)
    Wait(2500)
    SetEntityCoords(cache.ped, coords.x, coords.y, coords.z, false, false, false, false)
    if coords.w then
        SetEntityHeading(cache.ped, coords.w)
    end
    FreezeEntityPosition(cache.ped, true)
    local count = 0
    while not HasCollisionLoadedAroundEntity(cache.ped) and count <= 30000 do
        RequestCollisionAtCoord(coords.x, coords.y, coords.z)
        Wait(0)
        count = count + 1
    end
    FreezeEntityPosition(cache.ped, false)
    DoScreenFadeIn(1000)
    if afterTeleportFunction ~= nil then
        afterTeleportFunction()
    end
end

---This will get a model hash from a string or number.
---@param model string | number
---@return number
Utility.GetEntityHashFromModel = function(model)
    if type(model) ~= 'number' then model = joaat(model) end -- Use GetHashKey instead of joaat for client
    return model
end

---commentThis will get the closest player, the distance to that player from the coords and the server ID of that player.
---@param coords table
---@param distanceScope number
---@param includeMe boolean
---@return integer
---@return integer
---@return integer
Utility.GetClosestPlayer = function(coords, distanceScope, includeMe)
    local players = GetActivePlayers()
    local closestPlayer = 0
    local selfPed = cache.ped
    local selfCoords = coords or GetEntityCoords(cache.ped)
    local closestDistance = distanceScope or 5

    for _, player in ipairs(players) do
        local playerPed = GetPlayerPed(player)
        if includeMe or playerPed ~= selfPed then
            local playerCoords = GetEntityCoords(playerPed)
            local distance = #(selfCoords - playerCoords)
            if closestDistance == -1 or distance < closestDistance then
                closestPlayer = player
                closestDistance = distance
            end
        end
    end

    return closestPlayer, closestDistance, GetPlayerServerId(closestPlayer)
end

---This function is is deprecated and will be removed in the future. Please use Pont.Register instead.
---@param pointID string
---@param pointCoords table
---@param pointDistance number
---@param _onEnter function
---@param _onExit function
---@param _nearby function
Utility.RegisterPoint = function(pointID, pointCoords, pointDistance, _onEnter, _onExit, _nearby)
    return Point.Register(pointID, pointCoords, pointDistance, nil, _onEnter, _onExit, _nearby)
end

---This function is is deprecated and will be removed in the future. Please use Point.Get instead.
---@param pointID string
Utility.GetPointById = function(pointID)
    return Point.Get(pointID)
end

---This function is is deprecated and will be removed in the future. Please use Point.GetAll instead.
---@return table | nil
Utility.GetActivePoints = function()
    return Point.GetAll()
end

---This function is is deprecated and will be removed in the future. Please use Point.Remove instead.
---@param pointID string
---@return nil
Utility.RemovePoint = function(pointID)
    return Point.Remove(pointID)
end

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    for _, blip in pairs(blipIDs) do
        if blip and DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
    for _, ped in pairs(spawnedPeds) do
        if ped and DoesEntityExist(ped) then
            DeleteEntity(ped)
        end
    end
end)

exports('Utility', Utility)

return Utility