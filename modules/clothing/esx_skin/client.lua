if GetResourceState('esx_skin') ~= 'started' then return end

Clothing = Clothing or {}

StoredOldClothing = {}

RegisterNetEvent('community_bridge:client:updateStoredClothing', function(skindata)
    StoredOldClothing = skindata
end)

local clothingData = {
    male = {
        components = {
            face = {component_id = 0, texture = 0, drawable = 2},
            mask = {component_id = 1, texture = 0, drawable = 2},
            hair = {component_id = 2, texture = 0, drawable = 2},
            arms = {component_id = 3, texture = 0, drawable = 2},
            pants = {component_id = 4, texture = 0, drawable = 22},
            bag = {component_id = 5, texture = 1, drawable = 33},
            shoes = {component_id = 6, texture = 1, drawable = 33},
            accessory = {component_id = 7, texture = 1, drawable = 33},
            shirt = {component_id = 8, texture = 1, drawable = 11},
            bodyarmor = {component_id = 9, texture = 1, drawable = 33},
            decals = {component_id = 10, texture = 1, drawable = 33},
            jacket = {component_id = 11, texture = 2, drawable = 4},
        },
        props = {
            hats = {prop_id = 0, texture = 2, drawable = 4},
            glasses = {prop_id = 1, texture = 2, drawable = 4},
            ears = {prop_id = 2, texture = 2, drawable = 4},
            watches = {prop_id = 6, texture = 2, drawable = 4},
            bracelets = {prop_id = 7, texture = 2, drawable = 4},
        }
    },
    female = {
        components = {
            face = {component_id = 0, texture = 0, drawable = 2},
            mask = {component_id = 1, texture = 0, drawable = 2},
            hair = {component_id = 2, texture = 0, drawable = 2},
            arms = {component_id = 3, texture = 0, drawable = 2},
            pants = {component_id = 4, texture = 0, drawable = 22},
            bag = {component_id = 5, texture = 1, drawable = 33},
            shoes = {component_id = 6, texture = 1, drawable = 33},
            accessory = {component_id = 7, texture = 1, drawable = 33},
            shirt = {component_id = 8, texture = 1, drawable = 11},
            bodyarmor = {component_id = 9, texture = 1, drawable = 33},
            decals = {component_id = 10, texture = 1, drawable = 33},
            jacket = {component_id = 11, texture = 2, drawable = 4},
        },
        props = {
            hats = {prop_id = 0, texture = 2, drawable = 4},
            glasses = {prop_id = 1, texture = 2, drawable = 4},
            ears = {prop_id = 2, texture = 2, drawable = 4},
            watches = {prop_id = 6, texture = 2, drawable = 4},
            bracelets = {prop_id = 7, texture = 2, drawable = 4},
        }
    },
}

local function convertDataToFormat(characterData)
    local gender = characterData.sex

    local repackedClothingData = {
        [gender] = {
            components = {},
            props = {}
        }
    }

    local componentMap = {
        tshirt_1 = 8,        -- shirt
        torso_1 = 11,        -- jacket
        decals_1 = 10,       -- decals
        arms = 3,            -- arms
        pants_1 = 4,         -- pants
        shoes_1 = 6,         -- shoes
        mask_1 = 1,          -- mask
        bproof_1 = 9,        -- body armor
        chain_1 = 7,         -- accessory (could be a necklace)
        bags_1 = 5,          -- bag
    }

    for componentName, componentId in pairs(componentMap) do
        if characterData[componentName] then
            repackedClothingData[gender].components[componentName] = {
                component_id = componentId,
                texture = characterData[componentName.."_2"],
                drawable = characterData[componentName.."_1"],
            }
        end
    end

    local propMap = {
        {"helmet_1", 0},   -- helmet
        {"glasses_1", 1},  -- glasses
        {"ears_1", 2},     -- ears
        {"watches_1", 6},  -- watches
        {"bracelets_1", 7} -- bracelets
    }

    for _, prop in ipairs(propMap) do
        local propName = prop[1]
        local propId = prop[2]

        if characterData[propName] then
            repackedClothingData[gender].props[propName] = {
                prop_id = propId,
                texture = characterData[propName.."_2"],
                drawable = characterData[propName.."_1"],
            }
        end
    end
    return repackedClothingData
end

Clothing.SetAppearance = function(clothingData)
    if GetEntityModel(cache.ped) == `mp_m_freemode_01` then
        clothingData = clothingData.male
        clothingData.sex = 0
    else
        clothingData = clothingData.female
        clothingData.sex = 1
    end
    local repackedClothingData = convertDataToFormat(clothingData)
    StoredOldClothing = Clothing.GetAppearance
    TriggerEvent('skinchanger:loadSkin', repackedClothingData)
    return true
end

Clothing.GetAppearance = function()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        StoredOldClothing = skin
    end)
    return true
end

Clothing.RestoreAppearance = function()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('skinchanger:loadSkin', skin)
    end)
    return true
end

Clothing.ReloadSkin = function()
    local tableCheck = Table.TableContains(StoredOldClothing, "sex")
    if not tableCheck then return Clothing.RestoreAppearance() end
    return TriggerEvent('skinchanger:loadSkin', StoredOldClothing)
end