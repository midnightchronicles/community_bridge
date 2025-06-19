---@diagnostic disable: duplicate-set-field
Skills = Skills or {}

---This will get the name of the Skills system being being used.
---@return string
Skills.GetResourceName = function()
    return "community_bridge"
end


--92 is half way to 99 :P
local levelTable = {
    [1] = 0, [2] = 83, [3] = 174, [4] = 276, [5] = 388, [6] = 512, [7] = 650, [8] = 801, [9] = 969, [10] = 1154,
    [11] = 1358, [12] = 1584, [13] = 1833, [14] = 2107, [15] = 2411, [16] = 2746, [17] = 3115, [18] = 3523, [19] = 3973, [20] = 4470,
    [21] = 5018, [22] = 5624, [23] = 6291, [24] = 7028, [25] = 7842, [26] = 8740, [27] = 9730, [28] = 10824, [29] = 12031, [30] = 13363,
    [31] = 14833, [32] = 16456, [33] = 18247, [34] = 20224, [35] = 22406, [36] = 24815, [37] = 27473, [38] = 30408, [39] = 33648, [40] = 37224,
    [41] = 41171, [42] = 45529, [43] = 50339, [44] = 55649, [45] = 61512, [46] = 67983, [47] = 75127, [48] = 83014, [49] = 91721, [50] = 101333,
    [51] = 111945, [52] = 123660, [53] = 136594, [54] = 150872, [55] = 166636, [56] = 184040, [57] = 203254, [58] = 224466, [59] = 247886, [60] = 273742,
    [61] = 302288, [62] = 333804, [63] = 368599, [64] = 407015, [65] = 449428, [66] = 496254, [67] = 547953, [68] = 605032, [69] = 668051, [70] = 737627,
    [71] = 814445, [72] = 899257, [73] = 992895, [74] = 1096278, [75] = 1210421, [76] = 1336443, [77] = 1475581, [78] = 1629200, [79] = 1798808, [80] = 1986068,
    [81] = 2192818, [82] = 2421087, [83] = 2673114, [84] = 2951373, [85] = 3258594, [86] = 3597792, [87] = 3972294, [88] = 4385776, [89] = 4842295, [90] = 5346332,
    [91] = 5902831, [92] = 6517253, [93] = 7195629, [94] = 7944614, [95] = 8771558, [96] = 9684577, [97] = 10692629, [98] = 11805606, [99] = 13034431
}

---Calculate level from total XP
---@param xp number
---@return number
local function calculateLevelFromXp(xp)
    if xp <= 0 then return 1 end

    for level = #levelTable, 1, -1 do
        if levelTable[level] and xp >= levelTable[level] then return level end
    end

    return 1
end

---Get or create a specific skill for a player
---@param src number
---@param skillName string
---@return table
local function getOrCreateSkill(src, skillName)
    local playerSkills = Framework.GetPlayerMetadata(src, "community_bridge_skills") or {}

    if not playerSkills[skillName] then
        playerSkills[skillName] = { xp = 0, level = 1 }
        Framework.SetPlayerMetadata(src, "community_bridge_skills", playerSkills)
    end

    return playerSkills[skillName]
end

---This will get the skill level of the passed skill name.
---@param src number
---@param skillName string
---@return number
Skills.GetSkillLevel = function(src, skillName)
    local skill = getOrCreateSkill(src, skillName)
    return skill.level or 1
end

---This will get all skills for a player
---@param src number
---@return table
Skills.GetAllSkills = function(src)
    return Framework.GetPlayerMetadata(src, "community_bridge_skills") or {}
end

---This will add xp to the passed skill name.
---@param src number
---@param skillName string
---@param amount number
---@return boolean
Skills.AddXp = function(src, skillName, amount)
    if not src or not skillName or not amount or amount <= 0 then return false end

    local playerSkills = Framework.GetPlayerMetadata(src, "community_bridge_skills") or {}
    local skill = getOrCreateSkill(src, skillName)

    skill.xp = skill.xp + amount
    skill.level = calculateLevelFromXp(skill.xp)

    playerSkills[skillName] = skill
    Framework.SetPlayerMetadata(src, "community_bridge_skills", playerSkills)

    return true
end

---This will remove xp from the passed skill name.
---@param src number
---@param skillName string
---@param amount number
---@return boolean
Skills.RemoveXp = function(src, skillName, amount)
    if not src or not skillName or not amount or amount <= 0 then return false end

    local playerSkills = Framework.GetPlayerMetadata(src, "community_bridge_skills") or {}
    local skill = getOrCreateSkill(src, skillName)

    skill.xp = math.max(0, skill.xp - amount)
    skill.level = calculateLevelFromXp(skill.xp)

    playerSkills[skillName] = skill
    Framework.SetPlayerMetadata(src, "community_bridge_skills", playerSkills)

    return true
end

return Skills