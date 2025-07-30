Version = Version or {}

local function padVersion(v)
    local parts = {}
    for n in v:gmatch("%d+") do
        table.insert(parts, tonumber(n))
    end
    while #parts < 3 do
        table.insert(parts, 0)
    end
    return parts
end

local function compareVersions(v1, v2)
    local a, b = padVersion(v1), padVersion(v2)
    for i = 1, 3 do
        if a[i] < b[i] then
            return -1
        elseif a[i] > b[i] then
            return 1
        end
    end
    return 0
end

local function parseVersion(versionString)
    return versionString:match('%d+%.%d+%.%d+') or versionString
end

local function buildGithubApiUrl(repoPath)
    local username, reponame = repoPath:match("([^/]+)/([^/]+)")
    return ('https://api.github.com/repos/%s/%s/releases/latest'):format(username, reponame)
end

local function buildPatchNotesUrl(branch, repoPath)
    local username, reponame = repoPath:match("([^/]+)/([^/]+)")
    return ('https://raw.githubusercontent.com/%s/%s/%s/resources.json'):format(username, reponame, branch)
end

local function getDownloadUrl(repoPath, tebex, actualRepoPath)
    if tebex then
        return "https://portal.cfx.re/assets/granted-assets"
    elseif actualRepoPath and actualRepoPath ~= false then
        local repoUser, repoName = actualRepoPath:match("([^/]+)/([^/]+)")
        if repoUser and repoName then
            return ('https://github.com/%s/%s/releases/latest'):format(repoUser, repoName)
        end
    end
    return nil
end

local function printUpdateAvailable(resource, localVersion, downloadUrl)
    print(('^1An update is available for %s (current version: %s)\r\n - ^5Please download the latest version from %s^7'):format(resource, localVersion, downloadUrl))
end

local function printPatchNotes(notesToPrint)
    print('^3Patch Notes:^7')
    for _, entry in ipairs(notesToPrint) do
        print(('^2Version %s:^7'):format(entry.version))
        for _, line in ipairs(entry.notes) do
            print((' - %s'):format(line))
        end
    end
end

local function printError(message)
    print(('^1[ERROR]^7 %s'):format(message))
end

local function processVersions(allVersions, localVersion)
    local notesToPrint = {}

    for versionStr, notes in pairs(allVersions) do
        if compareVersions(versionStr, localVersion) > 0 and type(notes) == "table" then
            table.insert(notesToPrint, { version = versionStr, notes = notes })
        end
    end

    table.sort(notesToPrint, function(a, b)
        return compareVersions(a.version, b.version) < 0
    end)

    return notesToPrint
end

local function fetchPatchNotes(branch, resource, repoPath, localVersion, tebex, actualRepoPath)
    local url = buildPatchNotesUrl(branch, repoPath)

    PerformHttpRequest(url, function(noteStatus, noteBody)
        if noteStatus == 200 then
            local patchData = json.decode(noteBody)
            if not patchData then return end

            local allVersions = patchData[resource]
            if allVersions and type(allVersions) == "table" then
                local notesToPrint = processVersions(allVersions, localVersion)

                if #notesToPrint > 0 then
                    local downloadUrl = getDownloadUrl(repoPath, tebex, actualRepoPath) or url
                    printUpdateAvailable(resource, localVersion, downloadUrl)
                    printPatchNotes(notesToPrint)
                end
            end
        elseif branch == "main" then
            fetchPatchNotes("master", resource, repoPath, localVersion, tebex, actualRepoPath)
        end
    end, 'GET')
end

local function checkSimpleUpdate(repoPath, resource, localVersion, isTebex)
    local url = buildGithubApiUrl(repoPath)

    PerformHttpRequest(url, function(status, response)
        if status ~= 200 then return end

        local latest = parseVersion(json.decode(response).tag_name)
        if not latest or latest == localVersion or localVersion:gsub('%D', '') >= latest:gsub('%D', '') then
            return
        end

        local downloadUrl = isTebex and "https://portal.cfx.re/assets/granted-assets" or json.decode(response).html_url
        printUpdateAvailable(resource, localVersion, downloadUrl)
    end, 'GET')
end

local function validateRepoPath(repoPath)
    local username, reponame = repoPath:match("([^/]+)/([^/]+)")
    if not username or not reponame then
        return false, 'Invalid repository format. Expected format: "username/reponame"'
    end
    return true, username, reponame
end

local function getLocalVersion(resource)
    local localVersionRaw = GetResourceMetadata(resource, "version", 0)
    if not localVersionRaw then
        return nil, ('No version metadata found for resource "%s". Ensure fxmanifest.lua contains a valid version string.'):format(resource)
    end
    return parseVersion(localVersionRaw)
end

--- Checks for updates to a resource by comparing the local version (from fxmanifest.lua) with the latest release on GitHub, and optionally prints patch notes if using the template.
--- Example - Version.VersionChecker("TheOrderFivem/patchnotes", true, true, "community_bridge", "TheOrderFivem/community_bridge")
---@param repoPath string
---@param isTebex boolean
---@param showPatchNotes boolean
---@param actualResourceName string
---@param actualRepoPathIfGithub string this is the githubAccount/repoName if the resource is hosted on github, otherwise it will use the repoPath initially passed, this is not needed for tebex = true
---@return nil
function Version.VersionChecker(repoPath, isTebex, showPatchNotes, actualResourceName, actualRepoPathIfGithub)
    local isValid, username, reponame = validateRepoPath(repoPath)
    if not isValid then return printError(username) end

    local resource = actualResourceName or reponame
    local localVersion, errorMsg = getLocalVersion(resource)
    if not localVersion then return printError(errorMsg) end

    if not showPatchNotes then return checkSimpleUpdate(repoPath, resource, localVersion, isTebex) end

    fetchPatchNotes("main", resource, repoPath, localVersion, isTebex, actualRepoPathIfGithub)
end

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    Version.VersionChecker("TheOrderFivem/patchnotes", false, true, "community_bridge", "TheOrderFivem/community_bridge")
end)

return Version
