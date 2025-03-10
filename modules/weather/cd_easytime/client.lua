if GetResourceState('cd_easytime') ~= 'started' then return end
Weather = Weather or {}

Weather.ModuleName = "cd_easytime"

---comment
---@param toggle boolean
Weather.ToggleSync = function(toggle)
    TriggerEvent('cd_easytime:PauseSync', toggle)
end