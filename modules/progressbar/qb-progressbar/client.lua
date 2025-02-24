-- if BridgeClientConfig.ProgressBar ~= "qb" then return end
-- Progressbar = {}

-- local function convertOxToQB(disabledTable, animTable)
--     local repackedTable = { disabled = {}, animations = {}}
--     for _, v in pairs(disabledTable) do
--         if v.move then
--             repackedTable.disabled.disableMovement = v.move
--         end
--         if v.car then
--             repackedTable.disabled.disableCarMovement = v.car
--         end
--         if v.combat then
--             repackedTable.disabled.disableCombat = v.combat
--         end
--         if v.mouse then
--             repackedTable.disabled.disableMouse = v.mouse
--         end
--     end
--     for _, v in pairs(animTable) do
--         if v.dict then
--             repackedTable.animations.animDict = v.animDict
--         end
--         if v.clip then
--             repackedTable.animations.anim = v.anim
--         end
--     end
--     return repackedTable
-- end

-- Progressbar.StartProgressBar = function(time, label, whiledead, cancancel, disable, animTable, successAction, canceledAction)
--     local runTime = time or 10000
--     local textLabel = label or "Doing something"
--     local deadBool = whiledead or false
--     local cancelBool = cancancel or false
--     local success = successAction or function() Prints.Debug("Success") end
--     local canceled = canceledAction or function() Prints.Debug("Cancelled") end
--     local repackedTable = convertOxToQB(disable, animTable)
--     exports['progressbar']:Progress({
--         name = textLabel,
--         duration = runTime,
--         label = textLabel,
--         useWhileDead = deadBool,
--         canCancel = cancelBool,
--         controlDisables = repackedTable.disabled,
--         animation = repackedTable.animations,
--         prop = {},
--         propTwo = {}
--      }, function(cancelled)
--         if not cancelled then
--             success()
--         else
--             canceled()
--         end
--      end)
-- end

-- Progressbar.IsProgressBarActive = function()
--     return exports["progressbar"]:isDoingSomething()
-- end


if GetResourceState('progressbar') ~= 'started' or (BridgeClientConfig.ProgressBarSystem ~= "qb" and BridgeClientConfig.ProgressBarSystem ~= "auto") then return end
ProgressBar = ProgressBar or {}

local function convertFromOx(options)
    if not options then return options end
    local prop1 = options.prop?[1] or options.prop or {}
    local prop2 = options.prop?[2] or {}
    return {
        name = options.label,
        duration = options.duration,
        label = options.label,
        useWhileDead = options.useWhileDead,
        canCancel = options.canCancel,
        controlDisables = {
            disableMovement = options.disable?.move,
            disableCarMovement = options.disable?.car,
            disableMouse = options.disable?.mouse,
            disableCombat = options.disable?.combat
        },
        animation = {
            animDict = options.anim?.dict,
            anim = options.anim?.clip
        },
        prop = {
            model = prop1.model,
            bone = prop1.bone,
            coords = prop1.pos, 
            rotation = prop1.rot
        },
        propTwo = {
            model = prop2.model,
            bone = prop2.bone,
            coords = prop2.pos, 
            rotation = prop2.rot
        }
    }
end

function ProgressBar.Open(options, cb, qbFormat)
    if not exports['progressbar'] then return false end
    
    if not qbFormat then
        options = convertFromOx(options)
    end
    
    exports['progressbar']:Progress(options, cb)
end


-- Example usage:
RegisterCommand("progressbar", function()
    ProgressBar.Open({
        duration = 5000,
        label = "Searching",
        disable = {
            move = true,
            combat = true
        },
        anim = {
            dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            clip = "machinic_loop_mechandplayer"
        },
        prop = {
            model = "prop_ar_arrow_3",
            pos = vector3(0.0, 0.0, 0.0),
            rot = vector3(0.0, 0.0, 0.0)
        },
    }, function(cancelled)
        print(cancelled and "Cancelled" or "Complete")
    end)
end)
