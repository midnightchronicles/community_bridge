---@diagnostic disable: duplicate-set-field
Skills = Skills or {}

local function warnUser()
    print("Currently only a few skill systems are supported by Community Bridge, you are using a resource that requires the skills module to be used.")
end

---This will get the name of the Skills system being being used.
---@return string
Skills.GetResourceName = function()
    return "none"
end

---This will get the skill level of the passed skill name.
---@param skillName string
---@return number
---@return nil
Skills.GetSkillLevel = function(skillName)
    warnUser()
    return 0
end

return Skills