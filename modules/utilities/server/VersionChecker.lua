VersionCheck = {}

function VersionCheck.VersionChecker(repoPath)
    local resource = repoPath:match("([^/]+)$")
    if not resource then return print('^1Invalid repository format. Expected format: "username/reponame"^0') end

    local version = GetResourceMetadata(resource, "version", 0)
    if not version then return print(('^1Unable to determine current resource version for %s ^0'):format(resource)) end

    version = version:match('%d+%.%d+%.%d+')
    if not version then return print(('^1Invalid version format for %s ^0'):format(resource)) end

    local username, reponame = repoPath:match("([^/]+)/([^/]+)")
    if not username or not reponame then return print('^1Invalid repository format. Expected format: "username/reponame"^0') end
    PerformHttpRequest(('https://api.github.com/repos/%s/%s/releases/latest'):format(username, reponame), function(status, response)
        local failure = ('^1Unable locate github repo for resource %s ^0'):format(resource)

        if status ~= 200 then return print(failure) end
        response = json.decode(response)

        if response.prerelease then return print(failure) end

        local latest = response.tag_name:match('%d+%.%d+%.%d+')
        if not latest then return print(failure) end

        if latest == version then return print(('^2 %s is on the latest version.^0'):format(resource)) end
        local currentVersion, latestVersion = version:gsub('%D', ''), latest:gsub('%D', '')

        if currentVersion < latestVersion then
            return print(('^1An update is available for %s (current version: %s)\r\n - ^5Please download the latest version from the GitHub release page.^7\r\n%s'):format(resource, version, response.html_url))
        end
    end, 'GET')
end

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    VersionCheck.VersionChecker("The-Order-Of-The-Sacred-Framework/community_bridge")
end)