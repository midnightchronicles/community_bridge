local fileList = {
    "particles",
    "targets",
}

local path = "lib/entities/client/behaviors/"

local function loadAllResources()
    local modules = {}
    for _, fileName in ipairs(fileList) do
        local filePath = path .. fileName .. ".lua"
        local required = Require(filePath)        
        if required then
            table.insert(modules, required)
        end
    end
    return modules
end

return loadAllResources()