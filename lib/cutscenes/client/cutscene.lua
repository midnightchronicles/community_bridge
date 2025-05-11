Cutscenes = Cutscenes or {}
Cutscene = Cutscene or {}
Cutscene.done = true

local names = {
    {male = 'MP_1'},
    {male = 'MP_2'},
    {male = 'MP_3'},
    {male = 'MP_4'},
    {male = 'MP_Male_Character', female = 'MP_Female_Character'},
    {male = 'MP_Male_Character_1', female = 'MP_Female_Character_1'},
    {male = 'MP_Male_Character_2', female = 'MP_Female_Character_2'},
    {male = 'MP_Male_Character_3', female = 'MP_Female_Character_3'},
    {male = 'MP_Male_Character_4', female = 'MP_Female_Character_4'},
    {male = 'MP_Plane_Passenger_1'},
    {male = 'MP_Plane_Passenger_2'},
    {male = 'MP_Plane_Passenger_3'},
    {male = 'MP_Plane_Passenger_4'},
    {male = 'MP_Plane_Passenger_5'},
    {male = 'MP_Plane_Passenger_6'},
    {male = 'MP_Plane_Passenger_7'},
    {male = 'MP_Plane_Passenger_8'},
    {male = 'MP_Plane_Passenger_9'},
}

function Cutscene.GetTags(cutscene)
    if not Cutscene.Load(cutscene) then return end
    StartCutscene(0)
    Wait(1000)
    local tags = {}
    for k, tag in pairs(names) do
        if DoesCutsceneEntityExist(tag.male, 0) or DoesCutsceneEntityExist(tag.female, 0) then
            table.insert(tags, tag)
        end
    end
    StopCutsceneImmediately()
    Wait(2000)
    return tags
end

function Cutscene.Load(cutscene)
    assert(cutscene, "Cutscene.Load called without a cutscene name.")
    if IsPedMale(PlayerPedId()) then
        RequestCutsceneWithPlaybackList(cutscene, 31, 8)
    else
        RequestCutsceneWithPlaybackList(cutscene, 103, 8) 
    end
    local timeout = GetGameTimer() + 10000
    while not (HasCutsceneLoaded()) and GetGameTimer() < timeout do
        Wait(0)
    end
    if not HasCutsceneLoaded() then
        print("Cutscene failed to load: ", cutscene)
        return false
    end
   
    return true
end

function Cutscene.SavePedOutfit(ped)
    local outfitData = {}
    local componentsToSave = {
        -- Components 
        { name = "head", id = 0, type = "drawable" },
        { name = "beard", id = 1, type = "drawable" },
        { name = "hair", id = 2, type = "drawable" },
        { name = "arms", id = 3, type = "drawable" },
        { name = "pants", id = 4, type = "drawable" },
        { name = "parachute", id = 5, type = "drawable" },
        { name = "feet", id = 6, type = "drawable" },
        { name = "accessories", id = 7, type = "drawable" },
        { name = "undershirt", id = 8, type = "drawable" },
        { name = "vest", id = 9, type = "drawable" },
        { name = "decals", id = 10, type = "drawable" },
        { name = "jacket", id = 11, type = "drawable" },

        -- Props
        { name = "hat", id = 0, type = "prop" },
        { name = "glasses", id = 1, type = "prop" },
        { name = "ears", id = 2, type = "prop" },
        { name = "watch", id = 3, type = "prop" },
        { name = "bracelet", id = 4, type = "prop" },
        { name = "misc", id = 5, type = "prop" },
        { name = "left_wrist", id = 6, type = "prop" },
        { name = "right_wrist", id = 7, type = "prop" },
        { name = "prop8", id = 8, type = "prop" },
        { name = "prop9", id = 9, type = "prop" },
    }

    for _, component in ipairs(componentsToSave) do
        if component.type == "drawable" then
            local drawable = GetPedDrawableVariation(ped, component.id)
            local texture = GetPedTextureVariation(ped, component.id)
            local palette = GetPedPaletteVariation(ped, component.id)
            outfitData[component.name] = {
                id = component.id,
                type = component.type,
                drawable = drawable,
                texture = texture,
                palette = palette,
            }
        elseif component.type == "prop" then
            local propIndex = GetPedPropIndex(ped, component.id)
            local propTexture = GetPedPropTextureIndex(ped, component.id)
            outfitData[component.name] = {
                id = component.id,
                type = component.type,
                propIndex = propIndex,
                propTexture = propTexture,
            }
        end
    end

    return outfitData
end

function Cutscene.ApplyPedOutfit(ped, outfitData)
    if not outfitData or type(outfitData) ~= "table" then
        print("ApplyPedOutfit: Invalid outfitData provided.")
        return
    end

    for componentName, data in pairs(outfitData) do
        if data.type == "drawable" then
            -- Ensure all values are present before applying
            local drawable = data.drawable or 0
            local texture = data.texture or 0
            local palette = data.palette or 0
            SetPedComponentVariation(ped, data.id, drawable, texture, palette)
        elseif data.type == "prop" then
            -- Clear prop if it's marked as not present (-1 index)
            if data.propIndex == -1 or data.propIndex == nil then
                ClearPedProp(ped, data.id)
            else
                local propTexture = data.propTexture or 0
                SetPedPropIndex(ped, data.id, data.propIndex, propTexture, true)
            end
        end
    end
end

function Cutscene.Create(cutscene, coords, srcs)
    local lastCoords = coords or GetEntityCoords(PlayerPedId())
    DoScreenFadeOut(0)
    local tagsFromCutscene = Cutscene.GetTags(cutscene)

    if not Cutscene.Load(cutscene) then
        print("Cutscene.Create: Failed to load cutscene", cutscene)
        DoScreenFadeIn(0)
        return false
    end

    srcs = srcs or {}
    local clothes = {}

    local localped = PlayerPedId()
    
    local playersToProcess = {}
    table.insert(playersToProcess, { ped = localped, identifier = "localplayer", coords = lastCoords})
    for i, src_raw in ipairs(srcs) do
        if type(src_raw) == 'number' then 
            if src_raw and not DoesEntityExist(src_raw) then       
                local playerPed = GetPlayerPed(GetPlayerFromServerId(src_raw)) -- Assuming GetPlayerPed takes server ID
                if DoesEntityExist(playerPed) then
                    local ped = ClonePed(playerPed, false, false, true)
                    table.insert(playersToProcess, { ped = ped, identifier = "player" })
                else
                    print("Cutscene.Create: Ped for src " .. src_raw .. " does not exist.")
                end
            else 
                table.insert(playersToProcess, { ped = src_raw, identifier = "user"}) --developer passed a ped
            end
        elseif type(src_raw) == 'string' then
            -- impliment creating a ped by model name
            local model = GetHashKey(src_raw)
            RequestModel(model)
            local timeout = GetGameTimer() + 10000
            while not HasModelLoaded(model) and GetGameTimer() < timeout do
                Wait(0)
            end
            if not HasModelLoaded(model) then
                print("Cutscene.Create: Failed to load model " .. src_raw)
                return false
            end
            local pos = GetEntityCoords(localped)
            local ped = CreatePed(0, model, pos.x, pos.y, pos.z, 0.0, true, false)

            if ped and DoesEntityExist(ped) then
                table.insert(playersToProcess, { ped = ped, identifier = 'script' })
            else
                print("Cutscene.Create: Failed to create ped for src " .. src_raw)
            end
        elseif type(src_raw) == 'boolean' and src_raw then
            print("Cutscene.Create: src_raw is a boolean, creating random ped currently not implimented.")
            -- local pos = GetEntityCoords(localped)
            -- local ped = CreateRandomPed(pos.x, pos.y, pos.z)
           
            -- if ped and DoesEntityExist(ped)then
            --     table.insert(playersToProcess, { ped = ped, identifier = 'script' })
            -- else
            --     print("Cutscene.Create: Failed to create random ped for src " )
            -- end
        end
    end

    local availableTags = {} -- Create a mutable copy of tags
    for _, tagName in ipairs(tagsFromCutscene or {}) do
        table.insert(availableTags, tagName)
    end

    local usedTags = {}
    local cleanupTags = {}

    for _, playerData in ipairs(playersToProcess) do
        local currentPed = playerData.ped
        local isPedMale = IsPedMale(currentPed)
        local tagTable = availableTags[1]
        if not tagTable then
            print("Cutscene.Create: No available tags for player", playerData.identifier)
            break
        end

        local tag = not isPedMale and tagTable.female or tagTable.male
        local unusedTag = nil
        if isPedMale and tagTable.female then 
            unusedTag = isPedMale and tagTable.female or tagTable.male
        end
        SetCutsceneEntityStreamingFlags(tag, 0, 1)
        RegisterEntityForCutscene(currentPed, tag, 0, GetEntityModel(currentPed), 64)
        SetCutscenePedComponentVariationFromPed(tag, currentPed, 0)           
        clothes[tag] = { clothing = Cutscene.SavePedOutfit(currentPed), ped = currentPed }
        table.insert(usedTags, tag) -- Track used tags
        table.insert(cleanupTags, unusedTag) -- Track tags to be cleaned up later
        table.remove(availableTags, 1) -- Remove used tag
    end
    for _, tag in ipairs(cleanupTags) do
        local ped = RegisterEntityForCutscene(0, tag, 3, 0, 64)
        NetworkSetEntityInvisibleToNetwork(ped, true)
    end

    for _, tag in ipairs(availableTags) do
        local ped1 = RegisterEntityForCutscene(0, tag.male, 3, 0, 64)
        NetworkSetEntityInvisibleToNetwork(ped1, true)
        local ped2 = RegisterEntityForCutscene(0, tag.female, 3, 0, 64)
        NetworkSetEntityInvisibleToNetwork(ped2, true)
    end

    local data = {
        cutscene = cutscene,
        coords = coords,
        tags = usedTags,
        srcs = srcs,
        peds = playersToProcess,
        clothes = clothes,
    }
    Cutscene.done = false
    return data
end

function Cutscene.Start(cutsceneData)
    DoScreenFadeIn(1000)
    Cutscene.done = false
    if not cutsceneData then
        print("Cutscene.Start: Cutscene data is nil.")
        return
    end
    local clothes = cutsceneData.clothes
    local coords = cutsceneData.coords
    if coords then 
        if type(coords) == 'boolean' then
            coords = GetEntityCoords(PlayerPedId())
        end
        StartCutsceneAtCoords(coords.x, coords.y, coords.z, 0 )
    else
        StartCutscene(0)
    end

    Wait(100)
    for k, datam in pairs(clothes) do
        local ped = datam.ped
        if DoesEntityExist(ped) then
            SetCutscenePedComponentVariationFromPed(k, ped, 0)
            Cutscene.ApplyPedOutfit(ped, datam.clothing)
        else
            print("Cutscene.Create: Ped " .. k .. " does not exist.")
        end
    end

    local lastCoords = nil
    CreateThread(function()
        while not Cutscene.done do 
            local coords = GetWorldCoordFromScreenCoord(0.5, 0.5)
            if not lastCoords or (lastCoords and #(lastCoords - coords) > 100) then
                NewLoadSceneStartSphere(coords.x, coords.y, coords.z, 2000, 0)
                lastCoords = coords
            end
            Wait(500)
        end
    end)

    CreateThread(function()
        while not Cutscene.done do
            DisableAllControlActions(0)
            DisableFrontendThisFrame()
            Wait(3)
        end
    end)

    while not HasCutsceneFinished() and not Cutscene.done do           
        Wait(0)
        if IsDisabledControlJustPressed(0, 200) then
            DoScreenFadeOut(1000)
            Wait(1000)
            StopCutsceneImmediately()
            Wait(500)            
            Cutscene.done = true
            break
        end
    end
    DoScreenFadeIn(1000)
    -- clean up any peds marked as 'script'
    for _, playerData in ipairs(cutsceneData.peds) do
        local ped = playerData.ped
        if ped and DoesEntityExist(ped) and playerData.identifier == 'script' then
            DeleteEntity(ped)
        end
        if ped and DoesEntityExist(ped) and playerData.identifier == 'localplayer' then
            SetEntityCoords(ped, playerData.coords.x, playerData.coords.y, playerData.coords.z)
        end
    end
    Cutscene.done = true
end

-- RegisterCommand('cutscene', function(source, args, rawCommand)
--     if not Cutscene.done then return end
--     local cutscene = args[1]
--     if not cutscene then return print("Usage: /cutscene <cutscene_name>") end


--     local cutsceneData = Cutscene.Create(cutscene, nil, {1, 1, 1 })
--     Cutscene.Start(cutsceneData)


-- end, false)



return Cutscene