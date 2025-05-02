local Cache = {}
Cache.Caches = Cache.Caches or {}
Cache.LoopRunning = Cache.LoopRunning or false

local max = 5000
local function StartLoop()
    if Cache.LoopRunning then return end
    Cache.LoopRunning = true
    CreateThread(function()
        while Cache.LoopRunning do
            local now = GetGameTimer()
            local minWait = nil
            local caches = Cache.Caches
            for name, cache in pairs(caches) do
                if cache.Compare then
                    cache.LastChecked = cache.LastChecked or now
                    cache.WaitTime = cache.WaitTime or max
                    local elapsed = now - cache.LastChecked
                    local remaining = cache.WaitTime - elapsed
                    if remaining <= 0 then
                        local oldValue = cache.Value
                        cache.Value = cache.Compare()
                        if cache.Value ~= oldValue and cache.OnChange then
                            for _, onChange in pairs(cache.OnChange) do
                                onChange(cache.Value, oldValue)
                            end
                        end
                        cache.LastChecked = now
                        remaining = cache.WaitTime
                    end
                    if not minWait or remaining < minWait then
                        minWait = remaining
                        if minWait <= 0 then break end
                    end
                end
            end
            if minWait then
                Wait(math.max(0, minWait))
            else
                Wait(max)
            end
        end
    end)
end

function Cache.Create(name, compare, waitTime)
    Cache.Caches[name] = Cache.Caches[name] or {}    
    Cache.Caches[name].WaitTime = waitTime or max
    Cache.Caches[name].Compare = compare
    Cache.Caches[name].OnChange = Cache.Caches[name].OnChange or {}
    Cache.Caches[name].Value = compare()
    print("Cache created: " .. name .. " with initial value: " .. tostring(Cache.Caches[name].Value))
    for _, onChange in pairs(Cache.Caches[name].OnChange) do
        onChange(Cache.Caches[name].Value, nil)
    end
    print("Cache created: " .. name .. " with initial value: " .. tostring(Cache.Caches[name].Value))
    return StartLoop()
end

function Cache.Get(name)
    local cache = Cache.Caches[name]
    return cache and cache.Value or nil
end

function Cache.OnChange(name, onChange)
    local cache = Cache.Caches[name]
    assert(cache, "Cache with name '" .. name .. "' does not exist.")
    table.insert(cache.OnChange, onChange)
end

return Cache


