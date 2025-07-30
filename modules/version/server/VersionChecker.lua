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

function CompareVersions(v1, v2)
    local a, b = padVersion(v1), padVersion(v2)
    for i = 1, 3 do
        if a[i] < b[i] then return -1
        elseif a[i] > b[i] then return 1
        end
    end
    return 0
end

local function fetchPatchNotes(branch, resource, username, reponame, localVersion, tebex, actualRepoPath)
    local rawUrl = ('https://raw.githubusercontent.com/%s/%s/%s/resources.json'):format(username, reponame, branch)
    PerformHttpRequest(rawUrl, function(noteStatus, noteBody)
        if noteStatus == 200 then
            local patchData = json.decode(noteBody)
            if not patchData then return end

            local allVersions = patchData[resource]

            if allVersions and type(allVersions) == "table" then
                local notesToPrint = {}

                for versionStr, notes in pairs(allVersions) do
                    if CompareVersions(versionStr, localVersion) > 0 and type(notes) == "table" then
                        table.insert(notesToPrint, {version = versionStr, notes = notes})
                    end
                end

                table.sort(notesToPrint, function(a, b)
                    return CompareVersions(a.version, b.version) < 0
                end)

                if #notesToPrint > 0 then
                    if tebex then
                        rawUrl = "https://portal.cfx.re/assets/granted-assets"
                    elseif actualRepoPath then
                        local repoUser, repoName = actualRepoPath:match("([^/]+)/([^/]+)")
                        if repoUser and repoName then
                            rawUrl = ('https://github.com/%s/%s/releases/latest'):format(repoUser, repoName)
                        end
                    end
                    print(('^1An update is available for %s (current version: %s)\r\n - ^5Please download the latest version from %s^7'):format(reponame, localVersion, rawUrl))
                    print('^3Patch Notes:^7')
                    for _, entry in ipairs(notesToPrint) do
                        print(('^2Version %s:^7'):format(entry.version))
                        for _, line in ipairs(entry.notes) do
                            print((' - %s'):format(line))
                        end
                    end
                end

            end
        elseif branch == "main" then
            fetchPatchNotes("master", resource, username, reponame, localVersion, tebex)
        end
    end, 'GET')
end

--- Checks for updates to a resource by comparing the local version (from fxmanifest.lua) with the latest release on GitHub, and optionally prints patch notes if using the template.
--- Example - Version.VersionChecker("TheOrderFivem/patchnotes", true, true, "community_bridge", "TheOrderFivem/community_bridge")
---@param repoPath string
---@param tebex boolean
---@param showPatchNotes boolean
---@param actualResourceName string
---@param actualRepoPathIfGithub string this is the githubAccount/repoName if the resource is hosted on github, otherwise it will use the repoPath initially passed, this is not needed for tebex = true
---@return nil
function Version.VersionChecker(repoPath, tebex, showPatchNotes, actualResourceName, actualRepoPathIfGithub)
    local username, reponame = repoPath:match("([^/]+)/([^/]+)")
    if not username or not reponame then
        return Prints.Error('^1Invalid repository format. Expected format: "username/reponame"^0')
    end

    local resource = actualResourceName or reponame
    local localVersionRaw = GetResourceMetadata(resource, "version", 0)
    if not localVersionRaw then
        return print(('^1[ERROR]^7 No version metadata found for resource "%s". Ensure fxmanifest.lua contains a valid version string.'):format(resource))
    end
    local localVersion = localVersionRaw:match('%d+%.%d+%.%d+') or localVersionRaw

    if not showPatchNotes then
        PerformHttpRequest(('https://api.github.com/repos/%s/%s/releases/latest'):format(username, reponame), function(status, response)
            if status ~= 200 then return end
            local latest = json.decode(response).tag_name:match('%d+%.%d+%.%d+')
            if not latest or latest == localVersion or localVersion:gsub('%D', '') >= latest:gsub('%D', '') then return end

            local url = tebex and "https://portal.cfx.re/assets/granted-assets" or json.decode(response).html_url
            print(('^1An update is available for %s (current version: %s)\r\n - ^5Please download the latest version from %s^7'):format(reponame, localVersion, url))
        end, 'GET')
        return
    end

    fetchPatchNotes("main", resource, username, reponame, localVersion, tebex, actualRepoPathIfGithub)
end

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    Version.VersionChecker("TheOrderFivem/patchnotes", false, true, "community_bridge", "TheOrderFivem/community_bridge")
end)

return Version