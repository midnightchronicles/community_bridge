---@diagnostic disable: duplicate-set-field
Skills = Skills or {}
Skills.All = Skills.All or {}

-- Helper function to get or create a skill object
local function getOrCreateSkill(src, skillName)
    if not src or not skillName then return { totalXP = 0, xp = 0, level = 1, xpNeededForNextLevel = 0 } end

    -- Get player skills
    local playerSkills = Framework.GetPlayerMetadata(src, "community_bridge_skills") or {}
    if not playerSkills[skillName] then
        playerSkills[skillName] = { totalXP = 0, xp = 0, level = 1, xpNeededForNextLevel = 0 }
    end

    return playerSkills[skillName]
end

---This will get the name of the Skills system being being used.
---@return string
Skills.GetResourceName = function()
    return "community_bridge"
end

Skills.Create = function(name, maxLevel, baseXP)
    if not name then return end
    local self = Skills.All[name] or {}
    self.maxLevel = maxLevel or 99
    self.baseXP = baseXP or 50
    self.name = name
    Skills.All[name] = self
    Skills.GenerateCache(name, maxLevel)
    return self
end

Skills.GetTotalXPForLevel = function(skillName, level)
    if not skillName or not level or level < 1 then return 0 end
    local skill = Skills.All[skillName]
    if not skill then return 0 end
    local cache = skill.cache or {}
    if cache[level] then return cache[level] end
    local xp = 0
    for n = 1, level - 1 do
        xp = xp + (n + 300 * (2 ^ (n / 7)))
    end
    xp = math.floor(xp / 4)
    cache[level] = xp
    return xp
end

Skills.GetLevelFromXP = function(skillName, xp)
    if not skillName or not xp or xp < 0 then return 1 end
    local skill = Skills.All[skillName]
    if not skill then return 1 end
    for level = 1, skill.maxLevel do
        local requiredXp = Skills.GetTotalXPForLevel(skillName, level)
        if requiredXp > xp then
            return level - 1
        end
    end
    return skill.maxLevel
end

Skills.GenerateCache = function(skillName, maxLevel)
    if not skillName or not maxLevel or maxLevel < 1 then return {} end
    local cache = {}
    for level = 1, maxLevel do
        cache[level] = Skills.GetTotalXPForLevel(skillName, level)
    end
    return cache
end

Skills.GetScaledXP = function(baseXP, playerLevel)
    if not baseXP or baseXP <= 0 then return 0 end
    return math.floor(baseXP * (1 + playerLevel * 0.05))
end

-- Get skill level for a player
Skills.GetSkillLevel = function(src, skillName)
    if not src or not skillName then return 1 end
    local skill = getOrCreateSkill(src, skillName)
    return skill.level or 1
end

-- Set skill level directly (resets XP to start of level)
Skills.SetSkillLevel = function(src, skillName, level)
    if not src or not skillName or not level or level < 1 then return false end

    -- Create skill if it doesn't exist
    if not Skills.All[skillName] then
        Skills.All[skillName] = Skills.Create(skillName, 99, 50)
    end

    -- Get skill and metadata
    local playerSkills = Framework.GetPlayerMetadata(src, "community_bridge_skills") or {}
    local skill = playerSkills[skillName] or { totalXP = 0, xp = 0, level = 1 }

    -- Clamp the level to valid range
    level = math.min(math.max(1, level), Skills.All[skillName].maxLevel)

    -- Set the level and reset level XP
    local previousLevelXP = Skills.GetTotalXPForLevel(skillName, level - 1)
    skill.level = level
    skill.totalXP = previousLevelXP
    skill.xp = 0
    skill.xpNeededForNextLevel = Skills.GetTotalXPForLevel(skillName, level) - previousLevelXP

    -- Save changes
    playerSkills[skillName] = skill
    Framework.SetPlayerMetadata(src, "community_bridge_skills", playerSkills)
    return true
end

-- Add XP to a skill using the RuneScape algorithm
Skills.AddXP = function(src, skillName, xp)
    if not src or not skillName then return false end

    -- Create skill if it doesn't exist
    if not Skills.All[skillName] then
        Skills.All[skillName] = Skills.Create(skillName, 99, 50)
    end

    -- Default XP amount if not provided or invalid
    if not xp or xp < 0 then
        xp = Skills.GetScaledXP(Skills.All[skillName].baseXP, Skills.GetSkillLevel(src, skillName))
    end

    -- Get skill and metadata
    local playerSkills = Framework.GetPlayerMetadata(src, "community_bridge_skills") or {}
    local skill = playerSkills[skillName] or { totalXP = 0, xp = 0, level = 1 }

    -- Store old level for detecting level up
    local oldLevel = skill.level

    -- Add XP to total
    skill.totalXP = (skill.totalXP or 0) + math.max(0, xp)

    -- Calculate new level based on total XP
    skill.level = Skills.GetLevelFromXP(skillName, skill.totalXP)

    -- Update current level XP and XP needed for next level
    local previousLevelXP = Skills.GetTotalXPForLevel(skillName, skill.level - 1)
    local nextLevelXP = Skills.GetTotalXPForLevel(skillName, skill.level)

    skill.xp = skill.totalXP - previousLevelXP
    skill.xpNeededForNextLevel = nextLevelXP - previousLevelXP

    -- Handle level up
    if skill.level > oldLevel then
        -- You can uncomment this to trigger level-up events
        -- TriggerEvent("Skills:LevelUp", src, skillName, skill.level, oldLevel)
    end

    -- Save changes
    playerSkills[skillName] = skill
    Framework.SetPlayerMetadata(src, "community_bridge_skills", playerSkills)
    return true
end

-- Set total XP for a skill (recalculates level)
Skills.SetXP = function(src, skillName, xp)
    if not src or not skillName or not xp or xp < 0 then return false end

    -- Create skill if it doesn't exist
    if not Skills.All[skillName] then
        Skills.All[skillName] = Skills.Create(skillName, 99, 50)
    end

    -- Get skill and metadata
    local playerSkills = Framework.GetPlayerMetadata(src, "community_bridge_skills") or {}
    local skill = playerSkills[skillName] or { totalXP = 0, xp = 0, level = 1 }

    -- Set total XP
    skill.totalXP = math.max(0, xp)

    -- Recalculate level and XP values
    skill.level = Skills.GetLevelFromXP(skillName, skill.totalXP)

    -- Update current level XP and XP needed for next level
    local previousLevelXP = Skills.GetTotalXPForLevel(skillName, skill.level - 1)
    local nextLevelXP = Skills.GetTotalXPForLevel(skillName, skill.level)

    skill.xp = skill.totalXP - previousLevelXP
    skill.xpNeededForNextLevel = nextLevelXP - previousLevelXP

    -- Save changes
    playerSkills[skillName] = skill
    Framework.SetPlayerMetadata(src, "community_bridge_skills", playerSkills)
    return true
end


-- Calculate XP needed for next level (helper function)
local function calculateXPInfo(src, skillName, skill)
    -- Calculate XP needed for next level
    local currentLevel = skill.level or 1
    local nextLevel = math.min(currentLevel + 1, Skills.All[skillName].maxLevel)

    local currentLevelMinXP = Skills.GetTotalXPForLevel(skillName, currentLevel)
    local nextLevelMinXP = Skills.GetTotalXPForLevel(skillName, nextLevel)
    local previousLevelMinXP = Skills.GetTotalXPForLevel(skillName, currentLevel - 1)

    -- Current level XP
    skill.xp = skill.totalXP - previousLevelMinXP

    -- XP needed for next level
    skill.xpNeededForNextLevel = nextLevelMinXP - currentLevelMinXP

    -- Percentage to next level
    local xpInCurrentLevel = skill.totalXP - previousLevelMinXP
    local xpRequiredForNextLevel = nextLevelMinXP - previousLevelMinXP
    skill.percentToNextLevel = math.min(100, math.floor((xpInCurrentLevel / xpRequiredForNextLevel) * 100))

    return skill
end

-- Get all of a player's skill data
Skills.GetAll = function(src)
    if not src then return {} end
    return Framework.GetPlayerMetadata(src, "community_bridge_skills") or {}
end

-- Get a specific skill object with all properties
Skills.Get = function(src, skillName)
    if not src or not skillName then return nil end

    local skill = getOrCreateSkill(src, skillName)
    return calculateXPInfo(src, skillName, skill)
end

-- Get the current level XP value (not total XP)
Skills.GetXP = function(src, skillName)
    if not src or not skillName then return 0 end
    local skill = getOrCreateSkill(src, skillName)
    return skill.xp or 0
end

-- Get total accumulated XP
Skills.GetTotalXP = function(src, skillName)
    if not src or not skillName then return 0 end
    local skill = getOrCreateSkill(src, skillName)
    return skill.totalXP or 0
end

-- Get XP required for next level
Skills.GetXPNeededForNextLevel = function(src, skillName)
    if not src or not skillName then return 0 end
    local skill = getOrCreateSkill(src, skillName)
    return calculateXPInfo(src, skillName, skill).xpNeededForNextLevel or 0
end

-- if not BridgeSharedConfig.DebugLevel or BridgeSharedConfig.DebugLevel == 0 then return end

RegisterCommand('ClearSkills', function(source, args, rawCommand)
    if not source or source == 0 then return end
    local playerSkills = Framework.GetPlayerMetadata(source, "community_bridge_skills") or {}
    for skillName in pairs(playerSkills) do
        playerSkills[skillName] = { totalXP = 0, xp = 0, level = 1, xpNeededForNextLevel = 0 }
    end
    Framework.SetPlayerMetadata(source, "community_bridge_skills", playerSkills)
    print("Cleared all skills for player: " .. source)
end, true)

-- Skills.AddSkillLevel = function(src, skillName, amount)
--     if not src or not skillName then return false end
--     if not Skills.All[skillName] then
--         Skills.All[skillName] = Skills.Create(skillName, 99, 50)
--     end

--     local playerSkills = Framework.GetPlayerMetadata(src, "community_bridge_skills") or {}
--     local skill = playerSkills[skillName] or { xp = 0, level = 1 }
--     skill.level = math.min(Skills.All[skillName].maxLevel, skill.level + (amount or 1))
--     skill.xp = Skills.GetScaledXP(Skills.All[skillName].baseXP, skill.level)

--     playerSkills[skillName] = skill
--     Framework.SetPlayerMetadata(src, "community_bridge_skills", playerSkills)
--     return true
-- end



-- Skills.AddXp = function(src, skillName, amount)
--     if not src or not skillName then return false end
--     if not Skills.All[skillName] then
--        Skills.All[skillName] = Skills.Create(skillName, 99, 50)
--     end
--     if not amount or amount < 0 then
--         amount = Skills.GetScaledXP(Skills.All[skillName].baseXP, Skills.GetSkillLevel(src, skillName))
--     end

--     local playerSkills = Framework.GetPlayerMetadata(src, "community_bridge_skills") or {}
--     local skill = playerSkills[skillName] or { xp = 0, level = 1 }
--     skill.xp = skill.xp + amount
--     skill.level = Skills.GetLevelFromXP(skillName, skill.xp)

--     playerSkills[skillName] = skill
--     Framework.SetPlayerMetadata(src, "community_bridge_skills", playerSkills)
--     return true
-- end

-- Skills.RemoveXp = function(src, skillName, amount)
--     if not src or not skillName then return false end

--     if not amount or amount <= 0 then
--         amount = Skills.GetScaledXP(Skills.All[skillName].baseXP or 0, Skills.GetSkillLevel(src, skillName))
--     end

--     local playerSkills = Framework.GetPlayerMetadata(src, "community_bridge_skills") or {}
--     local skill = playerSkills[skillName] or { xp = 0, level = 1 }
--     skill.xp = math.max(0, skill.xp - amount)
--     skill.level = Skills.GetLevelFromXP(skillName, skill.xp)

--     playerSkills[skillName] = skill
--     Framework.SetPlayerMetadata(src, "community_bridge_skills", playerSkills)
--     return true
-- end




--92 is half way to 99 :P
-- local levelTable = {
--     [1] = 0, [2] = 83, [3] = 174, [4] = 276, [5] = 388, [6] = 512, [7] = 650, [8] = 801, [9] = 969, [10] = 1154,
--     [11] = 1358, [12] = 1584, [13] = 1833, [14] = 2107, [15] = 2411, [16] = 2746, [17] = 3115, [18] = 3523, [19] = 3973, [20] = 4470,
--     [21] = 5018, [22] = 5624, [23] = 6291, [24] = 7028, [25] = 7842, [26] = 8740, [27] = 9730, [28] = 10824, [29] = 12031, [30] = 13363,
--     [31] = 14833, [32] = 16456, [33] = 18247, [34] = 20224, [35] = 22406, [36] = 24815, [37] = 27473, [38] = 30408, [39] = 33648, [40] = 37224,
--     [41] = 41171, [42] = 45529, [43] = 50339, [44] = 55649, [45] = 61512, [46] = 67983, [47] = 75127, [48] = 83014, [49] = 91721, [50] = 101333,
--     [51] = 111945, [52] = 123660, [53] = 136594, [54] = 150872, [55] = 166636, [56] = 184040, [57] = 203254, [58] = 224466, [59] = 247886, [60] = 273742,
--     [61] = 302288, [62] = 333804, [63] = 368599, [64] = 407015, [65] = 449428, [66] = 496254, [67] = 547953, [68] = 605032, [69] = 668051, [70] = 737627,
--     [71] = 814445, [72] = 899257, [73] = 992895, [74] = 1096278, [75] = 1210421, [76] = 1336443, [77] = 1475581, [78] = 1629200, [79] = 1798808, [80] = 1986068,
--     [81] = 2192818, [82] = 2421087, [83] = 2673114, [84] = 2951373, [85] = 3258594, [86] = 3597792, [87] = 3972294, [88] = 4385776, [89] = 4842295, [90] = 5346332,
--     [91] = 5902831, [92] = 6517253, [93] = 7195629, [94] = 7944614, [95] = 8771558, [96] = 9684577, [97] = 10692629, [98] = 11805606, [99] = 13034431
-- }


-- local levelTable = {}

-- -- Calculate XP required for a specific level using the algorithm: xp(L) = ⌊(1/4) * Σ [n + 300 * 2^(n/7)]⌋
-- local function getXPForLevel(level)
--     if levelTable[level] then return levelTable[level] end
--     if level <= 1 then return 0 end

--     local xp = 0
--     for n = 1, level - 1 do
--         xp = xp + (n + 300 * (2 ^ (n / 7)))
--     end
--     xp = math.floor(xp / 4)
--     levelTable[level] = xp
--     return xp
-- end

-- ---Calculate level from total XP
-- ---@param xp number
-- ---@return number
-- local function calculateLevelFromXp(xp)
--     if xp <= 0 then return 1 end

--     for level = #levelTable, 1, -1 do
--         local requiredXp = getXPForLevel(level)
--         if requiredXp <= xp then
--             return level
--         end
--         if levelTable[level] and xp >= levelTable[level] then return level end
--     end

--     return 1
-- end

-- ---Get or create a specific skill for a player
-- ---@param src number
-- ---@param skillName string
-- ---@return table
-- local function getOrCreateSkill(src, skillName)
--     local playerSkills = Framework.GetPlayerMetadata(src, "community_bridge_skills") or {}
--     if not playerSkills[skillName] then
--         playerSkills[skillName] = { xp = 0, level = 1 }
--         Framework.SetPlayerMetadata(src, "community_bridge_skills", playerSkills)
--     end

--     return playerSkills[skillName]
-- end

-- ---This will get the skill level of the passed skill name.
-- ---@param src number
-- ---@param skillName string
-- ---@return number
-- Skills.GetSkillLevel = function(src, skillName)
--     local skill = getOrCreateSkill(src, skillName)
--     return skill.level or 1
-- end

-- ---This will get all skills for a player
-- ---@param src number
-- ---@return table
-- Skills.GetAllSkills = function(src)
--     return Framework.GetPlayerMetadata(src, "community_bridge_skills") or {}
-- end

-- ---This will add xp to the passed skill name.
-- ---@param src number
-- ---@param skillName string
-- ---@param amount number
-- ---@return boolean
-- Skills.AddXp = function(src, skillName, amount)
--     if not src or not skillName or not amount or amount <= 0 then return false end

--     local playerSkills = Framework.GetPlayerMetadata(src, "community_bridge_skills") or {}
--     local skill = getOrCreateSkill(src, skillName)

--     skill.xp = skill.xp + amount
--     skill.level = calculateLevelFromXp(skill.xp)

--     playerSkills[skillName] = skill
--     Framework.SetPlayerMetadata(src, "community_bridge_skills", playerSkills)

--     return true
-- end

-- ---This will remove xp from the passed skill name.
-- ---@param src number
-- ---@param skillName string
-- ---@param amount number
-- ---@return boolean
-- Skills.RemoveXp = function(src, skillName, amount)
--     if not src or not skillName or not amount or amount <= 0 then return false end

--     local playerSkills = Framework.GetPlayerMetadata(src, "community_bridge_skills") or {}
--     local skill = getOrCreateSkill(src, skillName)

--     skill.xp = math.max(0, skill.xp - amount)
--     skill.level = calculateLevelFromXp(skill.xp)

--     playerSkills[skillName] = skill
--     Framework.SetPlayerMetadata(src, "community_bridge_skills", playerSkills)

--     return true
-- end

-- return Skills