local Menus = {}
Menu = {}

if GetResourceState('ox_lib') ~= 'started' and GetResourceState('qb-menu') ~= 'started' then return end

--- Converts a QB menu to an Ox menu.
---@param id string The menu ID.
---@param menu table The QB menu data.
---@return table The Ox menu data.
function QBToOxMenu(id, menu)
    local oxMenu = {
        id = id,
        title = "",
        canClose = true,
        options = {},
    }
    for i, v in pairs(menu) do
        if v.isMenuHeader then
            if oxMenu.title == "" then
                oxMenu.title = v.header
            end
        else
            local option = {
                title = v.header,
                description = v.txt,
                icon = v.icon,
                args = v.params.args,
                onSelect = function(selected, secondary, args)
                    local params = menu[id]?.options?[selected]?.params
                    if not params then return end
                    local event = params.event
                    local isServer = params.isServer
                    if not event then return end
                    if isServer then
                        return TriggerServerEvent(event, args)
                    end
                    return TriggerEvent(event, args)
                end

            }
            table.insert(oxMenu.options, option)
        end
    end
    return oxMenu
end

--- Converts an Ox menu to a QB menu.
---@param id string The menu ID.
---@param menu table The Ox menu data.
---@return table The QB menu data.
function OxToQBMenu(id, menu)
    local qbMenu = {
        {
            header = menu.title,
            isMenuHeader = true,
        }
    }
    for i, v in pairs(menu.options) do
        local button = {
            header = v.title,
            txt = v.description,
            icon = v.icon,
        }

        if v.onSelect and type(v.onSelect) == 'function' then
            button.params = {
                event = "community_bridge:client:MenuCallback",
                args = {id = id, selected = i, args = v.args, onSelect = v.onSelect},
            }
        end
        table.insert(qbMenu, button)
    end
    return qbMenu
end

--- Opens a menu based on the configuration.
---@param data table The menu data.
---@param useQb boolean Whether to use QB menu syntax.
---@return id string The menu ID.
function Menu.Open(data, useQb)
    --local id = data.id or CreateUniqueId(Menus)
    local id = data.id or Ids.CreateUniqueId(Menus, nil, nil)
    local menuExists = Menus[id]
    if useQb then
        if BridgeClientConfig.MenuSystem == "ox" then
            if not menuExists then
                Menus[id] = QBToOxMenu(id, data)
                lib.registerContext(Menus[id])
            end
            return lib.showContext(id)
        elseif BridgeClientConfig.MenuSystem == "qb" then
            Menus[id] = data
            return exports['qb-menu']:openMenu(Menus[id])
        end
    else
        if BridgeClientConfig.MenuSystem == "ox" then
            if not menuExists then
                Menus[id] = data
                lib.registerContext(Menus[id])
            end
            return lib.showContext(id)
        elseif BridgeClientConfig.MenuSystem == "qb" then
            Menus[id] = OxToQBMenu(id, data)
            return exports['qb-menu']:openMenu(Menus[id])
        end
    end
    return id
end

--- Event to handle callback from menu selection.
--- @param _args table The arguments passed to the callback.
--- @return nil
RegisterNetEvent('community_bridge:client:MenuCallback', function(_args)
    local id = _args.id
    local onSelect = _args.onSelect
    local args = _args.args
    if not Menus[id] then return end
    onSelect({number=_args.selected}, false, args)
end)


--[[

--Unit Tests
local qbMenu = {
    {
        header = 'QBCore Test Menu',
        icon = 'fas fa-code',
        isMenuHeader = true, -- Set to true to make a nonclickable title
    },
    {
        header = 'First Button',
        txt = 'Open a secondary menu!',
        icon = 'fas fa-code-pull-request',
        -- disabled = false, -- optional, non-clickable and grey scale
        -- hidden = true, -- optional, hides the button completely
        params = {
            -- isServer = false, -- optional, specify event type
            event = 'community_bridge:client:TestEvent',
            args = {
                number = 1,
            }
        }
    },
    {
        header = 'Second Button',
        txt = 'Open a secondary menu!',
        icon = 'fas fa-code-pull-request',
        params = {
            event = 'community_bridge:client:TestEvent',
            args = {
                number = 2,
            }
        }
    }
}

local oxMenu = {
    id = "test",
    title = "Test Menu",
    options = {
        {
            title = "First Button",
            description = "Open a secondary menu!",
            icon = "fas fa-code-pull-request",
            args = {
                number = 1,
            },
            onSelect = function(selected, secondary, args)
                print("Selected", json.encode(selected))
            end
        },
        {
            title = "Second Button",
            description = "Open a secondary menu!",
            icon = "fas fa-code-pull-request",
            args = {
                number = 2,
            },
            onSelect = function(selected, secondary, args)
                print("Selected", json.encode(selected))
            end
        }
    }
}

RegisterCommand("testmenu-qbtoox", function()
    Menu.Open(qbMenu, true)
end)

RegisterCommand("testmenu-oxtoqb", function()
    Menu.Open(oxMenu, false)
end)

RegisterCommand("testmenu-oxtoox", function()
    Menu.Open(oxMenu, false)
end)

RegisterCommand("testmenu-qbtoqb", function()
    Menu.Open(qbMenu, true)
end)

RegisterNetEvent('community_bridge:client:TestEvent', function(args)
    print("Test Event", json.encode(args))
end)

--]]