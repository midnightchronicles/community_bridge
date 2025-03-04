Version = Version or {}

---Pass a github username and repo name to check for the latest version of the resource.
---
---
---Tebex is a optional boolean to determine if the message should be for a escrowed resource or not.
---
---
---Example Version.VersionChecker("The-Order-Of-The-Sacred-Framework/community_bridge")
---@param repoPath string
---@param tebex boolean | nil
---@return nil
function Version.VersionChecker(repoPath, tebex)
    local resource = repoPath:match("([^/]+)$")
    if not resource then return Prints.Error('^1Invalid repository format. Expected format: "username/reponame"^0') end

    local version = GetResourceMetadata(resource, "version", 0)
    if not version then return Prints.Error(('^1Unable to determine current resource version for %s ^0'):format(resource)) end

    version = version:match('%d+%.%d+%.%d+')
    if not version then return Prints.Error(('^1Invalid version format for %s ^0'):format(resource)) end

    local username, reponame = repoPath:match("([^/]+)/([^/]+)")
    if not username or not reponame then return Prints.Error('^1Invalid repository format. Expected format: "username/reponame"^0') end
    PerformHttpRequest(('https://api.github.com/repos/%s/%s/releases/latest'):format(username, reponame), function(status, response)
        local failure = ('^1Unable locate github repo for resource %s ^0'):format(resource)

        if status ~= 200 then return Prints.Error(failure) end
        response = json.decode(response)

        if response.prerelease then return Prints.Error(failure) end

        local latest = response.tag_name:match('%d+%.%d+%.%d+')
        if not latest then return Prints.Error(failure) end

        --if latest == version then return print(('^2 %s is on the latest version.^0'):format(resource)) end
        if latest == version then return end
        local currentVersion, latestVersion = version:gsub('%D', ''), latest:gsub('%D', '')

        if currentVersion < latestVersion then
            if tebex then return print(('^1An update is available for %s (current version: %s)\r\n - ^5Please download the latest version from the portal/keymaster.^7\r\n%s'):format(resource, version, "https://portal.cfx.re/assets/granted-assets")) end
            return print(('^1An update is available for %s (current version: %s)\r\n - ^5Please download the latest version from the GitHub release page.^7\r\n%s'):format(resource, version, response.html_url))
        end
    end, 'GET')
end

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    Version.VersionChecker("The-Order-Of-The-Sacred-Framework/community_bridge")
end)