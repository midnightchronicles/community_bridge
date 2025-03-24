ItemsBuilder = ItemsBuilder or {}

ItemsBuilder = {}


ItemsBuilder.Generate = function(invoking, itemsTable)
    if not invoking or not itemsTable then return end

    local resourcePath = GetResourcePath(GetCurrentResourceName()) .. "/generateditems/"

    local function fileExists(path)
        local file = io.open(path, "r")
        if file then
            file:close()
            return true
        else
            return false
        end
    end

    local qbOldFilePath = resourcePath .. invoking .. "_qb_core_old.lua"
    local qbNewFilePath = resourcePath .. invoking .. "_qb_core_new.lua"
    local oxInventoryFilePath = resourcePath .. invoking .. "_ox_inventory.lua"

    if fileExists(qbOldFilePath) or fileExists(qbNewFilePath) or fileExists(oxInventoryFilePath) then return end

    local qbOld = {}
    for key, item in pairs(itemsTable) do
        qbOld[key] = string.format(
            "['%s'] = {label = '%s', weight = %d, stack = %s, close = %s, description = '%s'}",
            key, item.label, item.weight, tostring(item.stack), tostring(item.close), item.description
        )
    end

    local qbNew = {}
    for key, item in pairs(itemsTable) do
        qbNew[key] = string.format(
            "%s = {label = '%s', weight = %d, stack = %s, close = %s, description = '%s'}",
            key, item.label, item.weight, tostring(item.stack), tostring(item.close), item.description
        )
    end

    local oxInventory = {}
    for key, item in pairs(itemsTable) do
        oxInventory[key] = {
            label = item.label,
            weight = item.weight,
            stack = item.stack,
            close = item.close
        }
    end

    local function writeInlineFile(fileName, content, useBrackets)
        local filePath = resourcePath .. fileName
        local file = io.open(filePath, "w")
        if file then
            for key, value in pairs(content) do
                if useBrackets then
                    -- For qb_core_old with brackets
                    file:write(string.format("['%s'] = %s,\n", key, value))
                else
                    -- For qb_core_new without brackets
                    file:write(string.format("%s = %s,\n", key, value))
                end
            end
            file:close()
            print("🌮 Items File Created: " .. filePath)
        else
            print("🌮 Something Broke for: " .. filePath)
        end
    end

    local function writeSimplifiedFile(fileName, content)
        local filePath = resourcePath .. fileName
        local file = io.open(filePath, "w")
        if file then
            for key, item in pairs(content) do
                file:write(string.format('["%s"] = {\n', key))
                for k, v in pairs(item) do
                    local formattedValue = type(v) == "string" and string.format('"%s"', v) or tostring(v)
                    file:write(string.format("    %s = %s,\n", k, formattedValue))
                end
                file:write("},\n")
            end
            file:close()
            print("🌮 Items File Created: " .. filePath)
        else
            print("🌮 Something Broke for: " .. filePath)
        end
    end

    writeInlineFile(invoking.."_".."qb_core_old.lua", qbOld, true)
    writeInlineFile(invoking.."_".."qb_core_new.lua", qbNew, false)
    writeSimplifiedFile(invoking.."_".."ox_inventory.lua", oxInventory)
end

exports('ItemsBuilder', ItemsBuilder)
return ItemsBuilder