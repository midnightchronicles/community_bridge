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
---@param src number
---@param skillName string
---@return number
Skills.GetSkillLevel = function(src, skillName)
    warnUser()
    return 0
end

---This will add xp to the passed skill name.
---@param src number
---@param skillName string
---@param amount number
---@return boolean
Skills.AddXp = function(src, skillName, amount)
    warnUser()
    return false
end

---This will remove xp from the passed skill name.
---@param src number
---@param skillName string
---@param amount number
---@return boolean
Skills.RemoveXp = function(src, skillName, amount)
    warnUser()
    return false
end

return Skills