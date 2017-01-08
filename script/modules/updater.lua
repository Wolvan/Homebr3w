--[[
    Homebr3w

	A Homebrew Application to download other Homebrew
	Apps based on TitleDB.com's database

    Copyright (c) Wolvan

    All rights reserved. Licensed under the MIT license.
    See LICENSE in the project root for license information.

    Source available at https://github.com/Wolvan/Homebr3w
]]--

--[[
    Module to check for updates from Github
    Requires dkjson to be loaded
]]--

--Updater namespace with variable that broadcasts update state
updater = {
    canUpdate = false
}

--[[
    Function to parse SemVer compliant
    versions. parseVersion accepts and parses Strings
    in the format MAJOR.MINOR.PATCH and returns a table
    {major, minor, version} which can be used by
    isUpdateAvailable
]]--
local function parseVersion(verString)
    if verString == nil or verString == "" then
        verString = "0.0.0"
    end

    verString = verString:gsub(" ", "")
    local version = {}
    local splitVersion = verString:split(".")
    if splitVersion[1]:lower():startsWith("v") then
        splitVersion[1] = splitVersion[1]:sub(2)
    end

    version.major = tonumber(splitVersion[1]) or 0
    version.minor = tonumber(splitVersion[2]) or 0
    version.patch = tonumber(splitVersion[3]) or 0

    return version
end
--[[
    Compare two version tables and check if one is older
    than the other and if an update is required
]]--
local function isUpdateAvailable(localVersion, remoteVersion)
    if remoteVersion.major > localVersion.major then
        return true
    end
    if (remoteVersion.minor > localVersion.minor) and (remoteVersion.major >= localVersion.major) then
        return true
    end
    if (remoteVersion.patch > localVersion.patch) and (remoteVersion.major >= localVersion.major) and (remoteVersion.minor >= localVersion.minor) then
        return true
    end
    return false
end

local function checkForUpdate()
    tries = 0
    success, tbl = false, {}
    while (tries < config.downloadRetryCount.value) and (not success) do
        tries = tries + 1
        success, tbl = utils.getJSON("https://api.github.com/repos/Wolvan/Homebr3w/releases/latest")
    end

    if not success then
        return false
    else
        local locVer = parseVersion(APP_VERSION)
        local remVer = parseVersion(tbl.tag_name)
        updater.canUpdate = isUpdateAvailable(locVer, remVer)
        return true
    end
end

updater.parseVersion = parseVersion
updater.isUpdateAvailable = isUpdateAvailable
updater.checkForUpdate = checkForUpdate