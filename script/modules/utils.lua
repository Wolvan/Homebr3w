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
    A collection of utility functions that are being used
    in the app
]]--


--[[
	Poor Man's Breakpoint
	This function makes debugging a lot easier
	since this can be used as a makeshift
	breakpoint to halt execution anywhere in the
	Script
]]--
function STOP()
	while true do
		pad = Controls.read()
		if Controls.check(pad, KEY_A) and not Controls.check(oldpad, KEY_A) then
			System.exit()
		end
		oldpad = pad
	end
end

--[[
	This function just presents an error to
	the user. Overriding the keypressFunction
	allows changing behavior of the error
]]--
function showError(errorMsg, keypressFunction)
	keypressFunction = keypressFunction or function()
		pad = Controls.read()
		if Controls.check(pad, KEY_A) and not Controls.check(oldpad, KEY_A) then
			Screen.waitVblankStart()
			Screen.flip()
			System.exit()
		end
		oldpad = pad
	end
	Screen.refresh()
	Screen.clear(TOP_SCREEN)
	Screen.clear(BOTTOM_SCREEN)
	Screen.waitVblankStart()
	Screen.flip()
	local splitString = errorMsg:split("\n")
	for k,v in pairs(splitString) do
		Screen.debugPrint(5, ((k-1)*15)+5, v, TEXT_COLORS.RED, TOP_SCREEN)
	end
	Screen.debugPrint(5, 95, "GitHub can be found at", TEXT_COLORS.WHITE, BOTTOM_SCREEN)
	Screen.debugPrint(5, 110, "https://github.com/Wolvan", TEXT_COLORS.WHITE, BOTTOM_SCREEN)
	Screen.debugPrint(5, 125, "/Homebr3w", TEXT_COLORS.WHITE, BOTTOM_SCREEN)
	while true do
		keypressFunction()
	end
end

utils = {}

--[[
    Take a title ID, parse it into it's
    hexadecimal value and launch it from
    SD Card
]]--
utils.launchByTitleId = function(titleid)
    if BUILD ~= BUILDS.CIA then
        return false
    else
        System.launchCIA(tonumber(titleid:gsub("0004000", ""), 16), SDMC)
        return true
    end
end
--[[
    Check if the User has Wi-Fi disabled and an
    Internet connection is available. By default
    it shows an error message if wifi is not active,
    this can be disabled by passing 'true' to the function
]]--
checkWifi = function(dontErrorOnNoNetwork)
    if not Network.isWifiEnabled() then
        if dontErrorOnNoNetwork then
            showError("Wi-Fi is disabled. Restart and try again.\nPress A to go back to "..home..".", function()
                pad = Controls.read()
                if Controls.check(pad, KEY_A) and not Controls.check(oldpad, KEY_A) then
                    System.exit()
                end
                oldpad = pad
            end)
        else
            return false
        end
    end
    return true
end
--[[
	Take a Datestring in the format
	YYYY-MM-DD hh:mm:ss and turn it into
	a unix timestamp
]]--
function makeUnixTimestampFromTitle(datestr)
	local pattern = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
	local runyear, runmonth, runday, runhour, runminute, runseconds = datestr:match(pattern)
	return os.time({year = runyear, month = runmonth, day = runday, hour = runhour, min = runminute, sec = runseconds})
end

--[[
    Function to download File from Internet and
    save it to SD Card
]]--
utils.getFile = function(path, downloadURL, method, data)
    if not method or (method ~= "GET" and method ~= "POST" and method ~= "HEAD") then method = "GET" end
    if not data then data = {} end
    System.deleteFile(path)
    local jsondata = "[]"
    if config.enableAnalytics.value then
        local cUUID = dataStore.client_uuid or "00000000-0000-0000-0000-000000000000"
        if downloadURL:find("?") then
            if cUUID then downloadURL = downloadURL.."&homebr3wUUID="..cUUID end
        else
            if cUUID then downloadURL = downloadURL.."?homebr3wUUID="..cUUID end
        end
        jsondata = '{"homebr3wUUID":"'..cUUID..'"}'
        data.homebr3wUUID = cUUID
    end
    if libraries["dkjson"] then
        jsondata = libraries["dkjson"].encode(data)
    end
    Network.downloadFile(downloadURL, path, USERAGENT, method, jsondata)
    local filesize = 0
    if System.doesFileExist(path) then
        local encTitleKeys = io.open(path, FREAD)
        filesize = tonumber(io.size(encTitleKeys))
        io.close(encTitleKeys)
    end
    if filesize == 0 then
        System.deleteFile(path)
        return false
    end
    return true
end

--[[
    Function that gets a json string from
    the web and decodes it into a table
]]--
utils.getJSON = function(url, method, data)
    if not method or (method ~= "GET" and method ~= "POST" and method ~= "HEAD") then method = "POST" end
    if not data then
        data = {
            action = "list",
            fields = { "id", "titleid", "author", "description", "name", "create_time", "update_time", "size", "mtime" }
        }
    end
    local tbl = {}
    local jsondata = "[]"
    if config.enableAnalytics.value then
        local cUUID = dataStore.client_uuid or "00000000-0000-0000-0000-000000000000"
        if url:find("?") then
            if cUUID then url = url.."&homebr3wUUID="..cUUID end
        else
            if cUUID then url = url.."?homebr3wUUID="..cUUID end
        end
        jsondata = '{"homebr3wUUID":"'..cUUID..'"}'
        data.homebr3wUUID = cUUID
    end
    if libraries["dkjson"] then
        jsondata = libraries["dkjson"].encode(data)
    end
    local remoteData = Network.requestString(url, USERAGENT, method, jsondata)
    if remoteData ~= "" and remoteData ~= nil and type(remoteData) == "string" then
        tbl = libraries["dkjson"].decode(remoteData)
    else
        return false, tbl
    end
    return true, tbl
end
