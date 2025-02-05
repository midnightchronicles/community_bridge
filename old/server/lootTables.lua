Utility = Utility or {}

local lootTables = {}

Utility.RegisterLootTable = function(name, items)
    local repackedTable = {}
    for k, v in pairs(items) do
        table.insert(repackedTable, {
            name = k,
            min = v.min,
            max = v.max,
            chance = v.chance,
            tier = v.tier,
            item = v.item,
            metadata = v.metadata
        })
    end
    lootTables[name] = repackedTable
    return lootTables[name]
end

Utility.GetLootTable = function(name)
    assert(name, "No Name Passed For Loot Table")
    return lootTables[name] or {}
end

Utility.GetRandomItem = function(name, tier, randomNumber)
    assert(name, "No Name Passed For Loot Table")
    if tier == nil then tier = 1 end
    local lootTable = lootTables[name] or {}
    math.randomseed(GetGameTimer())
    local chance = randomNumber or math.random(1, 100)
    for _, v in pairs(lootTable) do
        if v.chance <= chance and tier == v.tier then
            return { item = v.item,  metadata = v.metadata, count = math.random(v.min, v.max), tier = v.tier, chance = v.chance}
        end
    end
end

Utility.GetRandomItems = function(name, tier, randomNumber)
    assert(name, "No Name Passed For Loot Table")
    if tier == nil then tier = 1 end
    local lootTable = Utility.GetLootTable(name)
    math.randomseed(GetGameTimer())
    local chance = randomNumber or math.random(1, 100)
    local items = {}
    for _, v in pairs(lootTable) do
        if v.chance <= chance and tier == v.tier then
            table.insert(items,{item = v.item, metadata = v.metadata, count = math.random(v.min, v.max), tier = v.tier, chance = v.chance})
        end
    end
    return items
end

Utility.GetRandomItemsWithLimit = function(name, tier, randomNumber)
    assert(name, "No Name Passed For Loot Table")
    if tier == nil then tier = 1 end
    local lootTable = Utility.GetLootTable(name)
    math.randomseed(GetGameTimer())
    local chance = randomNumber or math.random(1, 100)
    local items = {}
    for k = #lootTable, 1, -1 do
        local v = lootTable[k]
        if chance <= v.chance and tier == v.tier then
            table.insert(items, {v.item, v.metadata, math.random(v.min, v.max), v.tier, v.chance})
            table.remove(lootTable, k)
        end
    end
    return items
end