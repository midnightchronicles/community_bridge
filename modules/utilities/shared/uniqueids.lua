Utility = Utility or {}
-- for unique ids
Utility.CreateUniqueId = function(tbl, len, pattern) -- both optional
    tbl = tbl or {} -- table to check uniqueness. Ids to check against must be the key to the tables value
    len = len or 8

    local id = ""
    for i = 1, len do
        local char = ""
        if pattern then
            char = pattern:sub(math.random(1, #pattern), math.random(1, #pattern))
        else
            char = math.random(1, 2) == 1 and string.char(math.random(65, 90)) or math.random(0, 9) -- CAP letter and number
        end
        id = id .. char
    end
    if tbl[id] then
        return Utility.CreateUniqueId(tbl, len, pattern)
    end
    return id
end

Utility.RandomString = function()
    return Utility.CreateUniqueId(nil, 14, nil)
end