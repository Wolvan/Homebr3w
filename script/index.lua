--[[
	Homebr3w
	
	A Homebrew Application to download other Homebrew
	Apps based on TitleDB.com's database
	
	Homebr3w is licensed under GPL 3.0, the full license
	can be found in the root of this repository inside of
	the LICENSE or LICENSE.md file.
	
	Copyright (C) 2016 https://github.com/Wolvan
]]--


-- START OF PROGRAM

-- BEGIN UTILITY CODE DECLARATION
--[[
	Define some constants for easier usage
	later on
]]--
local WHITE = Color.new(255,255,255)
local YELLOW = Color.new(255,205,66)
local RED = Color.new(255,0,0)
local GREEN = Color.new(55,255,0)
local BLUE = Color.new(70,50,250)

local APP_VERSION = "1.2.0"
local APP_DIR = "/Homebr3w"
local APP_CACHE = APP_DIR.."/Cache"
local APP_CONFIG = APP_DIR.."/config.json"
local APP_CIA_DIR = APP_DIR.."/CIAs"
local APP_LIBS_DIR = APP_DIR.."/Libraries"
local APP_TEMP_DIR = APP_DIR.."/tmp"
local INSTALLED_STATE = {
	NOT_INSTALLED = 4,
	LATEST_VERSION = 3,
	OUTDATED_VERSION = 1,
	VERSION_UNKNOWN = 2
}

local API_URL = "https://api.titledb.com/"

local LIB_TYPES = {
	LIBRARY = 1,
	ARCHIVE = 2
}

--[[
	Defined libraries that the tool needs here. There are 2 formats for libraries available:
	Both types share the following key/value pairs:
		name			--Defined the name the library is going to be available as later. Also gets shown when downloading library
		filename		--Name the file will be saved as under APP_DIR/Libraries. Can be any name
		downloadPath	--The URL the library's package will be downloaded from
		type			--The type of library that can be used. Can either be LIB_TYPES.LIBRARY for unzipped or LIB_TYPES.ARCHIVE for zipped libraries
	Zipped libraries also has 1 more key/value pair that needs to be defined:
		fileToExtract	--The filename of the file inside of the archive that needs to be extracted to APP_DIR/Libraries
	
	Example library definitions:
	{
		name = "dkjson",
		filename = "dklibraries["dkjson"].lua",
		downloadPath = "http://dkolf.de/src/dkjson-lua.fsl/raw/dklibraries["dkjson"].lua?name=16cbc26080996d9da827df42cb0844a25518eeb3",
		type = LIB_TYPES.LIBRARY
	},
	{
		name = "luaqrcode",
		filename = "qrencode.lua",
		downloadPath = "https://github.com/speedata/luaqrcode/zipball/master",
		type = LIB_TYPES.ARCHIVE,
		fileToExtract = "speedata-luaqrcode-726a866/qrencode.lua"
	}
]]--
local REQUIRED_LIBRARIES = {
	{
		name = "dkjson",
		filename = "dkjson.lua",
		downloadPath = "http://dkolf.de/src/dkjson-lua.fsl/raw/dkjson.lua?name=16cbc26080996d9da827df42cb0844a25518eeb3",
		type = LIB_TYPES.LIBRARY
	},
	{
		name = "luaqrcode",
		filename = "qrencode.lua",
		downloadPath = "https://raw.githubusercontent.com/speedata/luaqrcode/master/qrencode.lua",
		type = LIB_TYPES.LIBRARY
	}
}

--[[
	Modes to sort the Applist
]]--
local sortModes = {
	{
		text = "ID (ascending)",
		sortFunction = function(a, b)
			return a.id < b.id
		end
	},
	{
		text = "ID (descending)",
		sortFunction = function(a, b)
			return a.id > b.id
		end
	},
	{
		text = "Alphabet (ascending)",
		sortFunction = function(a, b)
			local aName = a.name
			local bName = b.name
			aName = aName:sub(1,1):upper()..aName:sub(2)
			bName = bName:sub(1,1):upper()..bName:sub(2)
			return aName < bName
		end
	},
	{
		text = "Alphabet (descending)",
		sortFunction = function(a, b)
			local aName = a.name
			local bName = b.name
			aName = aName:sub(1,1):upper()..aName:sub(2)
			bName = bName:sub(1,1):upper()..bName:sub(2)
			return aName > bName
		end
	},
	{
		text = "Size (ascending)",
		sortFunction = function(a, b)
			return a.size < b.size
		end
	},
	{
		text = "Size (descending)",
		sortFunction = function(a, b)
			return a.size > b.size
		end
	}
}

--[[
	Define various variables for later
	use in the application
]]--
local config = {
	enableUpdateCheck = {
		text = "Enable Update Check",
		value = true
	},
	deleteCIAAfterInstall = {
		text = "Delete CIA after install",
		value = true
	},
	downloadRetryCount = {
		text = "Download Retries",
		value = 3,
		minValue = 1,
		maxValue = 10
	},
	defaultSortMode = {
		text = "Default sorting mode",
		value = 3,
		minValue = 1,
		maxValue = #sortModes
	},
	leftRightJump = {
		text = "Left/Right Jump",
		value = 10,
		minValue = 1,
		maxValue = 15
	},
	groupInstalledApps = {
		text = "Group installed apps",
		value = true
	}
}
local config_backup = {}
local libraries = {}

local parsedApplist = {}
local fullApplist = {}
local installed = {}
local blacklistedApps = {}

local remVer = nil
local locVer = nil
local canUpdate = nil

local imageCache = {}
local mtimeCache = {}

local selectedCIA = 1
local menuOffset = 0
local selection = 1
local screenHeightVar = 13
local menu_selection = 1
local options_selection = 1
local sortMode = 3
local currentFilter = ""

local home = "Homemenu"
if System.checkBuild() ~= 1 then
	home = "Homebrew Launcher"
end

local pad = Controls.read()
local oldpad = pad
local kbState = nil
local scrollTimer = Timer.new()
local isScrolling = false

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
	Function for different data types that Lua doesn't
	come with natively.
]]--
--[[
	String manipulation functions
	split() takes a string and returns a table of substrings
	split at the separator.
	startsWith() returns true if the string starts with
	a given string.
]]--
function string.split(self, sep)
	local sep, fields = sep or ":", {}
	local pattern = string.format("([^%s]+)", sep)
	self:gsub(pattern, function(c) fields[#fields+1] = c end)
	return fields
end
function string.startsWith(String, Start)
	return string.sub(String,1,string.len(Start))==Start
end
--[[
	Table manipulation functions
	deepcopy() is a  way to copy tables without
	linking them through references.
	countTableElements() returns the actual number
	if elements a table contains instead of only
	the highest number index like # does.
	table.filter is a Lua implementation of JS'
	Array.filter() function.
	table.dump is a debugging tool that allows
	dumping contents of a table to file for later
	inspection quickly.
]]--
function deepcopy(orig)
	local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end
function countTableElements(tbl)
	local i = 0
	for k,v in pairs(tbl) do
		i = i + 1
	end
	return i
end
table.filter = function(workingTable, filterIter)
	local out = {}
	for index, value in pairs(workingTable) do
		if filterIter(value, index, workingTable) then out[index] = value end
	end
	return out
end
table.dump = function(tbl, filename)
	if not filename then filename = "tbl_dump.json" end
	local jsonString = libraries["dkjson"].encode(tbl, { indent = true })
	local file = io.open("/"..filename, FCREATE)
	io.write(file, 0, jsonString, jsonString:len())
	io.close(file)
end

--[[
	Functions to save and load any table to or from
	a JSON encoded file somewhere on the SD card
]]--
function saveTable(filename, tbl)
	if not tbl then tbl = {} end
	if not filename then filename = APP_DIR.."/tbl.json" end
	local jsonString = libraries["dkjson"].encode(tbl, { indent = true })
	local currentPath = ""
	local splitPath = filename:split("/")
	for i = 1, #splitPath - 1 do
		if splitPath[i] then
			currentPath = currentPath.."/"..splitPath[i]
			System.createDirectory(currentPath)
		end
	end
	local file = io.open(filename, FCREATE)
	io.write(file, 0, jsonString, jsonString:len())
	io.close(file)
end
function loadTable(filename, defaulttbl)
	if not filename then filename = APP_DIR.."/tbl.json" end
	if not defaulttbl then defaulttbl = {} end
	if not System.doesFileExist(filename) then
		saveTable(filename, defaulttbl)
	end
	local file = io.open(filename, FREAD)
	
	local filesize = 0
	filesize = tonumber(io.size(file))
	if filesize == 0 then
		io.close(file)
		saveTable(filename, defaulttbl)
		file = io.open(filename, FREAD)
	end
	
	local file_contents = io.read(file, 0, tonumber(io.size(file)))
	io.close(file)
	local loaded_config = libraries["dkjson"].decode(file_contents)
	if type(loaded_config) == "table" then
		return loaded_config
	else
		return nil
	end
end

--[[
	Functions to save and load config from a config
	file. The config table gets encoded as JSON file
	and saved to the SD.
	Loading reads that file (or creates it if it 
	doesn't exist before reading), decodes the JSON
	and then overwrites each value of the config
	table that is defined in the decoded JSON Object.
	This way, settings that are not stored in the config
	yet just use the default value set in the config table.
]]--
function saveConfig()
	saveTable(APP_CONFIG, config)
end
function loadConfig()
	local loaded_config = loadTable(APP_CONFIG, config)
	if type(loaded_config) == "table" then
		for k,v in pairs(loaded_config) do
			config[k] = v
		end
	else
		return false
	end
	return true
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
			main()
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
		Screen.debugPrint(5, ((k-1)*15)+5, v, RED, TOP_SCREEN)
	end
	Screen.debugPrint(5, 95, "GitHub can be found at", WHITE, BOTTOM_SCREEN)
	Screen.debugPrint(5, 110, "https://github.com/Wolvan", WHITE, BOTTOM_SCREEN)
	Screen.debugPrint(5, 125, "/Homebr3w", WHITE, BOTTOM_SCREEN)
	while true do
		keypressFunction()
	end
end

--[[
	Functions to parse and compare SemVer compliant
	versions. parseVersion accepts and parses Strings
	in the format MAJOR.MINOR.PATCH and returns a table
	{major, minor, version} which can be used by
	isUpdateAvailable
]]--
function parseVersion(verString)
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
function isUpdateAvailable(localVersion, remoteVersion)
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

--[[
	Check if the User has Wi-Fi disabled and an
	Internet connection is available
]]--
function checkWifi()
	if not Network.isWifiEnabled() then
		showError("Wi-Fi is disabled. Restart and try again.\nPress A to go back to "..home..".", function()
			pad = Controls.read()
			if Controls.check(pad, KEY_A) and not Controls.check(oldpad, KEY_A) then
				System.exit()
			end
			oldpad = pad
		end)
	end
end

--[[
	Check App State to close the App in case
	of exitting from home menu. 
	Function should be used in every while
	loop that allows going to Homemenu by
	pressing HOME!
]]--
function checkForExit()
	if System.checkStatus() == APP_EXITING then
		System.exit()
	end
end

--[[
	Function to download File from Internet
]]--
function getFile(path, downloadURL, method, data)
	if not method or (method ~= "GET" and method ~= "POST" and method ~= "HEAD") then method = "GET" end
	if not data then data = {} end
	System.deleteFile(path)
	local jsondata = "[]"
	if libraries["dkjson"] then
		jsondata = libraries["dkjson"].encode(data)
	end
	Network.downloadFile(downloadURL, path, "User-Agent: Homebr3w/"..APP_VERSION, method, jsondata)
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
function getJSON(url, method, data)
	if not method or (method ~= "GET" and method ~= "POST" and method ~= "HEAD") then method = "POST" end
	if not data then
		data = {
			action = "list",
			fields = { "id", "titleid", "author", "description", "name", "create_time", "update_time", "size", "mtime" }
		}
	end
	local tbl = {}
	local remoteData = Network.requestString(url, "User-Agent: Homebr3w/"..APP_VERSION, method, libraries["dkjson"].encode(data))
	if remoteData ~= "" and remoteData ~= nil and type(remoteData) == "string" then
		tbl = libraries["dkjson"].decode(remoteData)
	else
		return false, tbl
	end
	return true, tbl
end

--[[
	Get a title from the Applist by titleid
]]--
function getTitleByID(titleid)
	for k,v in pairs(parsedApplist) do
		if v.titleid == titleid then
			return v
		end
	end
end

--[[
	Take a Title ID and generate a
	Download QR Code Image for it
]]--
function drawQRToTopScreen(tid)
	local multiplier = 7
	local offset_x, offset_y = 75, 5
	local screen = TOP_SCREEN
	local function drawSquare(a,b,color)
		local x, y = (a + 1) * multiplier, (b + 1) * multiplier
		for i = 0, multiplier do
			for j = 0, multiplier do
				Screen.drawPixel(x + i + offset_x, y + j + offset_y, color, screen)
			end
		end
	end
	oldpad = pad
	local ok, data = libraries["luaqrcode"].qrcode(API_URL.."v0/proxy/"..tid)
	if ok then
		local qr = Screen.createImage((#data[1]+4) * multiplier, (#data+4) * multiplier, WHITE)
		Screen.drawImage(offset_x,offset_y,qr,screen)
		local color = WHITE
		for k,v in pairs(data) do
			for a,b in pairs(v) do
				if b < 0 then color = WHITE
				elseif b > 0 then color = Color.new(0,0,0) end
				drawSquare(k, a, color)
			end
		end
		while true do
			pad = Controls.read()
			if Controls.check(pad, KEY_A) and not Controls.check(oldpad, KEY_A) then
				Screen.freeImage(qr)
				main()
			elseif Controls.check(pad, KEY_B) and not Controls.check(oldpad, KEY_B) then
				Screen.freeImage(qr)
				main()
			elseif Controls.check(pad, KEY_X) and not Controls.check(oldpad, KEY_X) then
				Screen.freeImage(qr)
				main()
			elseif Controls.check(pad, KEY_Y) and not Controls.check(oldpad, KEY_Y) then
				Screen.freeImage(qr)
				main()
			end
			oldpad = pad
		end
	end
end
-- END UTILITY CODE DECLARATION

-- BEGIN MAIN PROGRAM CODE
--[[
	Go through all of the icon files in the
	Cache directory and download icons that
	are missing.
]]--
function checkLibraries()
	local function getLib(lib)
		System.createDirectory(APP_LIBS_DIR)
		local path = APP_LIBS_DIR.."/"..lib.filename
		if lib.type == LIB_TYPES.ARCHIVE then
			System.createDirectory(APP_TEMP_DIR)
			path = APP_TEMP_DIR.."/"..lib.filename..".zip"
		end
		local downloadURL = lib.downloadPath
		local success = getFile(path, downloadURL)
		local tries = 0
		while (tries < config.downloadRetryCount.value) and (not success) do
			success = getFile(path, downloadURL)
			tries = tries + 1
		end
		if success then
			if lib.type == LIB_TYPES.ARCHIVE then
				System.extractFromZIP(path, lib.fileToExtract, APP_LIBS_DIR.."/"..lib.filename)
				System.deleteFile(path)
				System.deleteDirectory(APP_TEMP_DIR)
			end
		end
		return success
	end
	for k,v in pairs(REQUIRED_LIBRARIES) do
		Screen.clear(BOTTOM_SCREEN)
		Screen.debugPrint(5, 5, "Checking library "..k.." of "..#REQUIRED_LIBRARIES.."...", WHITE, BOTTOM_SCREEN)
		if not System.doesFileExist(APP_LIBS_DIR.."/"..v.filename) then
			Screen.debugPrint(5, 20, "Downloading "..v.name, WHITE, BOTTOM_SCREEN)
			if not getLib(v) then
				showError("Failed to download library!\nUnable to continue, please\ntry restarting the app and\ntry again.\n \nPress A to go back to "..home..".", function()
					pad = Controls.read()
					if Controls.check(pad, KEY_A) and not Controls.check(oldpad, KEY_A) then
						System.exit()
					end
					oldpad = pad
				end)
			end
		end
	end
	Screen.clear(BOTTOM_SCREEN)
end

--[[
	Go through all of the icon files in the
	Cache directory and download icons that
	are missing.
]]--
function checkCache(tbl)
	local function cache(titleid)
		System.createDirectory(APP_CACHE)
		local path = APP_CACHE.."/"..titleid..".png"
		local downloadURL = API_URL.."images/"..titleid..".png"
		local success = getFile(path, downloadURL)
		local tries = 0
		while (tries < config.downloadRetryCount.value) and (not success) do
			success = getFile(path, downloadURL)
			tries = tries + 1
		end
		return success
	end
	local tid = "0004000000130800"
	local failed = 0
	for k,v in pairs(tbl) do
		Screen.clear(BOTTOM_SCREEN)
		tid = v.titleid
		Screen.debugPrint(5, 5, "Checking Icon "..k.." of "..#tbl.."...", WHITE, BOTTOM_SCREEN)
		if not System.doesFileExist(APP_CACHE.."/"..tid..".png") then
			Screen.debugPrint(5, 20, "Downloading "..tid, WHITE, BOTTOM_SCREEN)
			if not cache(tid) then failed = failed + 1 end
		end
		if failed > 0 then Screen.debugPrint(5, 35, "Failed downloading "..failed.." Icons", WHITE, BOTTOM_SCREEN) end
	end
	Screen.clear(BOTTOM_SCREEN)
end

--[[
	Return a subset of the applist that
	contains all titleIDs of apps that
	are installed on the 3ds in a lookup
	table kind of way
	isInstalled[TITLEID] = true or nil(false)
]]--
function checkInstalled()
	local sysapps = System.listCIA()
	local installed = table.filter(parsedApplist, function (item)
		local dectid = tonumber(item.titleid:gsub("0004000", ""), 16)
		for k,v in pairs(sysapps) do
			if dectid == v.unique_id then
				return true
			end
		end
		return false
	end)
	local tbl = {}
	for k,v in pairs(installed) do
		tbl[v.titleid] = true
	end
	return tbl
end

--[[
	Return the install state of an application
	All values come from
	INSTALLED_STATE =
	{
		VERSION_UNKNOWN,
		OUTDATED_VERSION,
		LATEST_VERSION,
		NOT_INSTALLED
	}
]]--
function getInstalledState(tid)
	local title = getTitleByID(tid)
	if installed[title.titleid] and not mtimeCache[title.titleid] then
		return INSTALLED_STATE.VERSION_UNKNOWN
	elseif installed[title.titleid] and mtimeCache[title.titleid] < title.mtime then
		return INSTALLED_STATE.OUTDATED_VERSION
	elseif installed[title.titleid] and mtimeCache[title.titleid] >= title.mtime then
		return INSTALLED_STATE.LATEST_VERSION
	end
	return INSTALLED_STATE.NOT_INSTALLED
end

--[[
	Sort app list with selected sorting mode
	and then group them by install state if
	the config option is enabled
]]
function sortAppList()
	local parsedApplistFiltered = table.filter(fullApplist, function(item)
		return item.name:lower():find(currentFilter:lower())
	end)
	local parsedApplistKeyFixed = {}
	for k,v in pairs(parsedApplistFiltered) do
		table.insert(parsedApplistKeyFixed, v)
	end
	parsedApplist = parsedApplistKeyFixed
	table.sort(parsedApplist, sortModes[sortMode].sortFunction)
	if config.groupInstalledApps.value then
		local appsByState = {}
		local iS = INSTALLED_STATE.NOT_INSTALLED
		for k,v in pairs(parsedApplist) do
			iS = getInstalledState(v.titleid)
			if not appsByState[iS] then appsByState[iS] = {} end
			table.insert(appsByState[iS], v)
		end
		local tbl = {}
		local debugTBL = {}
		for i = 1, 4 do
			if appsByState[i] then
				for i,j in pairs(appsByState[i]) do
					table.insert(tbl, j)
				end
			end
		end
		parsedApplist = tbl
	end
end

--[[
	Take a title ID, parse it into it's
	hexadecimal value and launch it from
	SD Card
]]--
function launchByTitleId(titleid)
	System.launchCIA(tonumber(titleid:gsub("0004000", ""), 16), SDMC)
end

--[[
	Clear the image cache that is being
	created in RAM for showing the icons
	on the details page
]]--
function clearImageCache()
	for k,v in pairs(imageCache) do
		Screen.freeImage(v)
		imageCache[k] = nil
	end
end

--[[
	Take a TitleID, download the corresponding
	.cia from TitleDB.com and then install it
	to SD
]]--
function downloadAndInstall(titleid)
	
	oldpad = pad
	Screen.waitVblankStart()
	Screen.refresh()
	Screen.clear(BOTTOM_SCREEN)
	Screen.clear(TOP_SCREEN)
	Screen.flip()
	System.createDirectory(APP_CIA_DIR)
	local title = getTitleByID(titleid)
	if title then
		Screen.debugPrint(5, 5, title.name, WHITE, TOP_SCREEN)
		local line = 20
		Screen.debugPrint(5, line, "Downloading...", WHITE, TOP_SCREEN)
		local path = APP_CIA_DIR.."/"..title.titleid.."_"..title.name..".cia"
		local downloadURL = API_URL.."v0/proxy/"..title.titleid
		local success = getFile(path, downloadURL)
		local tries = 0
		while (tries < config.downloadRetryCount.value) and (not success) do
			success = getFile(path, downloadURL)
			tries = tries + 1
		end
		
		if success then
			Screen.debugPrint(270, line, "[OK]", GREEN, TOP_SCREEN)
			if System.checkBuild() == 1 then
				line = 35
				Screen.debugPrint(5, line, "Installing...", WHITE, TOP_SCREEN)
				System.installCIA(path, SDMC)
				if config.deleteCIAAfterInstall.value then System.deleteFile(path) end
				installed[titleid] = true
				Screen.debugPrint(270, line, "[OK]", GREEN, TOP_SCREEN)
				mtimeCache[title.titleid] = title.mtime
				saveTable(APP_DIR.."/mtime.json", mtimeCache)
				Screen.debugPrint(5, 180, "Press A to launch the title", WHITE, BOTTOM_SCREEN)
			else
				mtimeCache[title.titleid] = title.mtime
				saveTable(APP_DIR.."/mtime.json", mtimeCache)
				Screen.debugPrint(5, 5, "Download finished! Unfortunately,", WHITE, BOTTOM_SCREEN)
				Screen.debugPrint(5, 20, "the Ninjhax build of Homebr3w", WHITE, BOTTOM_SCREEN)
				Screen.debugPrint(5, 35, "can not install the App", WHITE, BOTTOM_SCREEN)
				Screen.debugPrint(5, 50, "automatically. Please use a", WHITE, BOTTOM_SCREEN)
				Screen.debugPrint(5, 65, "titlemanager (like FBI) and ", WHITE, BOTTOM_SCREEN)
				Screen.debugPrint(5, 80, "install the .cia manually, it's", WHITE, BOTTOM_SCREEN)
				Screen.debugPrint(5, 95, "saved in the '/Homebr3w/CIAs'", WHITE, BOTTOM_SCREEN)
				Screen.debugPrint(5, 110, "directory.", WHITE, BOTTOM_SCREEN)
			end
			
			Screen.debugPrint(5, 195, "Press B to go to title list", WHITE, BOTTOM_SCREEN)
			Screen.debugPrint(5, 210, "Press Start to go to "..home, WHITE, BOTTOM_SCREEN)
			
			while true do
				pad = Controls.read()
				if Controls.check(pad, KEY_A) and not Controls.check(oldpad, KEY_A) then
					oldpad = pad
					if System.checkBuild() == 1 then launchByTitleId(parsedApplist[selectedCIA].titleid) end
				elseif Controls.check(pad, KEY_START) and not Controls.check(oldpad, KEY_START) then
					System.exit()
				elseif Controls.check(pad, KEY_B) and not Controls.check(oldpad, KEY_B) then
					oldpad = pad
					main()
				end
				oldpad = pad
			end
		else
			Screen.debugPrint(270, line, "[FAILED]", RED, TOP_SCREEN)
			Screen.debugPrint(5, 195, "Press B to go to title list", WHITE, BOTTOM_SCREEN)
			Screen.debugPrint(5, 210, "Press Start to go to "..home, WHITE, BOTTOM_SCREEN)
			
			while true do
				pad = Controls.read()
				if Controls.check(pad, KEY_B) and not Controls.check(oldpad, KEY_B) then
					oldpad = pad
					main()
				elseif Controls.check(pad, KEY_START) and not Controls.check(oldpad, KEY_START) then
					System.exit()
				end
				oldpad = pad
			end
			return false
		end
	end
	return false
end

function optionsMenu()
	oldpad = pad
	Screen.waitVblankStart()
	Screen.refresh()
	
	Screen.clear(TOP_SCREEN)
	Screen.debugPrint(5, 5, "Options", YELLOW, TOP_SCREEN)
	Screen.debugPrint(20, (options_selection * 15) + 5, ">", WHITE, TOP_SCREEN)
	local config_keys = {}
	local i = 1
	for k,v in pairs(config) do
		Screen.debugPrint(30, (i * 15) + 5, v.text, WHITE, TOP_SCREEN)
		if type(v.value) == "boolean" then
			if v.value then
				Screen.debugPrint(350, (i * 15) + 5, "On", GREEN, TOP_SCREEN)
			else
				Screen.debugPrint(350, (i * 15) + 5, "Off", RED, TOP_SCREEN)
			end
		elseif type(v.value) == "number" then
			Screen.debugPrint(350, (i * 15) + 5, v.value, YELLOW, TOP_SCREEN)
		end
		
		config_keys[#config_keys+1] = k
		i = i + 1
	end
	
	Screen.clear(BOTTOM_SCREEN)
	Screen.debugPrint(5, 110, "up/down - Select option", WHITE, BOTTOM_SCREEN)
	Screen.debugPrint(5, 125, "left/right - Change setting", WHITE, BOTTOM_SCREEN)
	Screen.debugPrint(5, 140, "A - Save", WHITE, BOTTOM_SCREEN)
	Screen.debugPrint(5, 155, "B - Cancel", WHITE, BOTTOM_SCREEN)
	Screen.flip()
	
	while true do
		pad = Controls.read()
		if Controls.check(pad, KEY_DDOWN) and not Controls.check(oldpad, KEY_DDOWN) then
			options_selection = options_selection + 1
			if (options_selection > #config_keys) then
				options_selection = 1
			end
		elseif Controls.check(pad, KEY_DUP) and not Controls.check(oldpad, KEY_DUP) then
			options_selection = options_selection - 1
			if (options_selection < 1) then
				options_selection = #config_keys
			end
		elseif Controls.check(pad, KEY_DLEFT) and not Controls.check(oldpad, KEY_DLEFT) then
			local currentSetting = config[config_keys[options_selection]]
			if type(currentSetting.value) == "boolean" then
				currentSetting.value = not currentSetting.value
			elseif type(currentSetting.value) == "number" then
				currentSetting.value = currentSetting.value - 1
				if currentSetting.minValue then
					if currentSetting.value < currentSetting.minValue then currentSetting.value = currentSetting.minValue end
				end
				config[config_keys[options_selection]].value = currentSetting.value
			end
		elseif Controls.check(pad, KEY_DRIGHT) and not Controls.check(oldpad, KEY_DRIGHT) then
			local currentSetting = config[config_keys[options_selection]]
			if type(currentSetting.value) == "boolean" then
				currentSetting.value = not currentSetting.value
			elseif type(currentSetting.value) == "number" then
				currentSetting.value = currentSetting.value + 1
				if currentSetting.maxValue then
					if currentSetting.value > currentSetting.maxValue then currentSetting.value = currentSetting.maxValue end
				end
				config[config_keys[options_selection]].value = currentSetting.value
			end
		elseif Controls.check(pad, KEY_A) and not Controls.check(oldpad, KEY_A) then
			oldpad = pad
			config_backup = deepcopy(config)
			saveConfig()
			sortAppList()
			menu()
		elseif Controls.check(pad, KEY_B) and not Controls.check(oldpad, KEY_B) then
			oldpad = pad
			config = deepcopy(config_backup)
			menu()
		end
		oldpad = pad
		optionsMenu()
	end
end

function searchApp()
	Screen.waitVblankStart()
	Screen.refresh()
	Screen.clear(TOP_SCREEN)
	Screen.debugPrint(5, 5, "Filter apps by name", WHITE, TOP_SCREEN)
	Screen.debugPrint(5, 20, "Current Filter:", WHITE, TOP_SCREEN)
	Screen.debugPrint(5, 35, Keyboard.getInput(), WHITE, TOP_SCREEN)
	Screen.clear(BOTTOM_SCREEN)
	if kbState ~= FINISHED then
		kbState = Keyboard.getState()
		Keyboard.show()
		if kbState ~= NOT_PRESSED then
			if kbState == CLEANED then
				currentFilter = ""
				sortAppList()
				menu()
			end
		end
	else
		currentFilter = Keyboard.getInput()
		selectedCIA = 1
		selection = 1
		menuOffset = 0
		sortAppList()
		menu()
	end
	Screen.flip()
	searchApp()
end

function markAsLatest()
	oldpad = pad
	Screen.waitVblankStart()
	Screen.refresh()
	Screen.clear(TOP_SCREEN)
	Screen.debugPrint(5, 5, "Marking all installed Apps as latest...", WHITE, TOP_SCREEN)
	Screen.clear(BOTTOM_SCREEN)
	Screen.flip()
	
	for k,v in pairs(checkInstalled()) do
		if v and not mtimeCache[k] then
			mtimeCache[k] = getTitleByID(k).mtime
		end
	end
	saveTable(APP_DIR.."/mtime.json", mtimeCache)
	Screen.debugPrint(5, 20, "Done! Press A to continue.", WHITE, TOP_SCREEN)
	
	while true do
		pad = Controls.read()
		if Controls.check(pad, KEY_A) and not Controls.check(oldpad, KEY_A) then
			menu()
		end
		oldpad = pad
	end
end

function menu()
	local menu_options = {
		{
			text = "Set search filter",
			callback = function() 
				kbState = nil
				Keyboard.show()
				searchApp()
			end
		},{
			text = "Settings",
			callback = function() optionsMenu() end
		},
		{
			text = "Mark unknown versions as latest",
			callback = function() markAsLatest() end
		},
		{
			text = "Back to Applist",
			callback = function() main() end
		},
		{
			text = "Exit App",
			callback = System.exit
		}
	}
	local function printBottomScreen()
		Screen.clear(BOTTOM_SCREEN)
		if canUpdate then
			Screen.debugPrint(5, 220, "Update version "..remVer.major.."."..remVer.minor.."."..remVer.patch.." now available!", RED, TOP_SCREEN)
		end
		Screen.debugPrint(5, 50, "Thanks to the following people:", WHITE, BOTTOM_SCREEN)
		Screen.debugPrint(5, 65, "ksanislo - For TitleDB.com", WHITE, BOTTOM_SCREEN)
		Screen.debugPrint(5, 80, "yellows8 - For icon and banner", WHITE, BOTTOM_SCREEN)
		Screen.debugPrint(5, 95, "Rinnegatamante - For LPP3DS", WHITE, BOTTOM_SCREEN)
		Screen.debugPrint(5, 110, "3DSGuy - Banner Sound", WHITE, BOTTOM_SCREEN)
		Screen.debugPrint(5, 125, "You - For using this tool at all", WHITE, BOTTOM_SCREEN)
		Screen.debugPrint(5, 140, "AFgt - For testing this tool", WHITE, BOTTOM_SCREEN)
		Screen.debugPrint(5, 155, "Nai - For testing this tool", WHITE, BOTTOM_SCREEN)
		Screen.debugPrint(5, 205, "v"..APP_VERSION, WHITE, BOTTOM_SCREEN)
		Screen.debugPrint(5, 220, "Homebr3w by Wolvan", WHITE, BOTTOM_SCREEN)
	end
	local function printTopScreen()
		Screen.clear(TOP_SCREEN)
		Screen.debugPrint(5, 5, "Homebr3w v"..APP_VERSION, YELLOW, TOP_SCREEN)
		Screen.debugPrint(20, (menu_selection * 15) + 5, ">", WHITE, TOP_SCREEN)
		for k,v in pairs(menu_options) do
			Screen.debugPrint(30, (k * 15) + 5, v.text, WHITE, TOP_SCREEN)
		end
	end
	
	oldpad = pad
	Screen.refresh()
	Screen.waitVblankStart()
	printTopScreen()
	printBottomScreen()
	Screen.flip()
	
	while true do
		pad = Controls.read()
		if Controls.check(pad, KEY_DDOWN) and not Controls.check(oldpad, KEY_DDOWN) then
			menu_selection = menu_selection + 1
			if (menu_selection > #menu_options) then
				menu_selection = 1
			end
		elseif Controls.check(pad, KEY_DUP) and not Controls.check(oldpad, KEY_DUP) then
			menu_selection = menu_selection - 1
			if (menu_selection < 1) then
				menu_selection = #menu_options
			end
		elseif Controls.check(pad, KEY_A) and not Controls.check(oldpad, KEY_A) then
			oldpad = pad
			menu_options[menu_selection].callback()
		elseif Controls.check(pad, KEY_B) and not Controls.check(oldpad, KEY_B) then
			oldpad = pad
			sortAppList()
			main()
		elseif Controls.check(pad, KEY_HOME) and System.checkBuild() ~= 1 then
			System.exit()
		elseif Controls.check(pad, KEY_HOME) and System.checkBuild() == 1 then
			System.showHomeMenu()
		end
		checkForExit()
		oldpad = pad
		menu()
	end
end

--[[
	Print a title's info to the Bottom Screen
]]--
function printTitleInfo(titleid)
	Screen.clear(BOTTOM_SCREEN)
	local title = getTitleByID(titleid)
	if title then
		if not imageCache[title.titleid] and System.doesFileExist(APP_CACHE.."/"..titleid..".png") then
			imageCache[title.titleid] = Screen.loadImage(APP_CACHE.."/"..titleid..".png")
		end
		if imageCache[title.titleid] then Screen.drawImage(5, 5, imageCache[title.titleid], BOTTOM_SCREEN) end
		Screen.debugPrint(58, 5, title.name, WHITE, BOTTOM_SCREEN)
		if #title.author < 24 then
			Screen.debugPrint(58, 20, "by "..title.author, WHITE, BOTTOM_SCREEN)
		else
			Screen.debugPrint(58, 20, "by "..title.author:sub(1, 24), WHITE, BOTTOM_SCREEN)
			Screen.debugPrint(58, 35, title.author:sub(25), WHITE, BOTTOM_SCREEN)
		end
		
		if #title.description < 33 then
			Screen.debugPrint(5, 60, title.description, WHITE, BOTTOM_SCREEN)
		else
			Screen.debugPrint(5, 60, title.description:sub(1, 33), WHITE, BOTTOM_SCREEN)
			Screen.debugPrint(5, 75, title.description:sub(34), WHITE, BOTTOM_SCREEN)
		end
		
		Screen.debugPrint(5, 100, "TID: "..title.titleid, WHITE, BOTTOM_SCREEN)
		local lastUpdated = title.create_time
		if title.update_time then lastUpdated = title.update_time end
		Screen.debugPrint(5, 115, "Last update: "..lastUpdated, WHITE, BOTTOM_SCREEN)
		local size = title.size
		local unit = "B"
		if size >  1024 then -- Byte -> Kilobyte
			size = size / 1024
			unit = "KB"
		end
		if size > 1024 then -- Kilobyte -> Megabyte
			size = size / 1024
			unit = "MB"
		end
		if size > 1024 then -- Megabyte -> Gigabyte
			size = size / 1024
			unit = "GB"
		end
		Screen.debugPrint(5, 130, string.format("Size: %.2f%s", size, unit), WHITE, BOTTOM_SCREEN)
		local installedState = getInstalledState(title.titleid)
		if installedState == INSTALLED_STATE.VERSION_UNKNOWN then
			Screen.debugPrint(5, 145, "Version unknown! Install to fix this.", YELLOW, BOTTOM_SCREEN)
		elseif installedState == INSTALLED_STATE.OUTDATED_VERSION then
			Screen.debugPrint(5, 145, "App Update available!", RED, BOTTOM_SCREEN)
		elseif installedState == INSTALLED_STATE.LATEST_VERSION then
			Screen.debugPrint(5, 145, "Latest version installed!", GREEN, BOTTOM_SCREEN)
		end
		
		if System.checkBuild() == 1 and installedState ~= INSTALLED_STATE.NOT_INSTALLED then Screen.debugPrint(5, 160, "Press X to start app", GREEN, BOTTOM_SCREEN) end
		
		Screen.debugPrint(5, 180, "Press Y to show QR Code", WHITE, BOTTOM_SCREEN)
		if System.checkBuild() ~= 1 then Screen.debugPrint(5, 195, "Press A to download", WHITE, BOTTOM_SCREEN)
		else Screen.debugPrint(5, 195, "Press A to download and install", WHITE, BOTTOM_SCREEN) end
	end
end

function printTitleList()
	Screen.clear(BOTTOM_SCREEN)
	if #parsedApplist < 0 then return end
	if #parsedApplist < screenHeightVar then
		menuOffset = 0
	end
	local color = WHITE
	local title = {}
	for i = 1, screenHeightVar, 1 do
		title = parsedApplist[i + menuOffset]
		if title then
			color = WHITE
			local installedState = getInstalledState(title.titleid)
			if installedState == INSTALLED_STATE.VERSION_UNKNOWN then
				color = YELLOW
			elseif installedState == INSTALLED_STATE.OUTDATED_VERSION then
				color = RED
			elseif installedState == INSTALLED_STATE.LATEST_VERSION then
				color = GREEN
			end
			if selection == i then
				color = BLUE
			end
			Screen.debugPrint(15, (i * 15) + 5, title.name, color, TOP_SCREEN)
			Screen.debugPrint(5, (selection * 15) + 5, ">", BLUE, TOP_SCREEN)
		end
	end
end

function printTopScreen()
	Screen.clear(TOP_SCREEN)
	if canUpdate then
		screenHeightVar = 12
	end
	Screen.debugPrint(5, 5, "Homebr3w v"..APP_VERSION.." - A homebrew browser", RED, TOP_SCREEN)
	printTitleList()
	if canUpdate then Screen.debugPrint(5, 205, "Update version "..remVer.major.."."..remVer.minor.."."..remVer.patch.." now available!", RED, TOP_SCREEN) end
	Screen.debugPrint(5, 220, "Sort mode "..sortMode..": "..sortModes[sortMode].text, RED, TOP_SCREEN)
end

function main()
	oldpad = pad
	Screen.waitVblankStart()
	Screen.refresh()
	printTopScreen()
	if #parsedApplist > 0 then printTitleInfo(parsedApplist[selectedCIA].titleid) end
	Screen.debugPrint(5, 210, "Press L/R to sort list", WHITE, BOTTOM_SCREEN)
	Screen.debugPrint(5, 225, "Press Start to access menu", WHITE, BOTTOM_SCREEN)
	Screen.flip()
	
	local scrollDelay = 50
	local timeUntilScrolling = scrollDelay + 550
	while true do
		pad = Controls.read()
		if #parsedApplist > 0 then
			if Controls.check(pad, KEY_DDOWN) then
				if Timer.getTime(scrollTimer) > timeUntilScrolling then
					isScrolling = true
					Timer.reset(scrollTimer)
				end
				if (Timer.getTime(scrollTimer) > scrollDelay and isScrolling) or not Controls.check(oldpad, KEY_DDOWN) then
					Timer.reset(scrollTimer)
					selectedCIA = selectedCIA + 1
					selection = selection + 1
					if (selectedCIA > #parsedApplist) then
						selectedCIA = 1
						menuOffset = 0
						selection = 1
					end
					if selection > screenHeightVar then
						selection = screenHeightVar
						menuOffset = menuOffset + 1
					elseif selection > #parsedApplist then
						selection = 1
					end
				end
			elseif Controls.check(pad, KEY_DUP) then
				if Timer.getTime(scrollTimer) > timeUntilScrolling then
					isScrolling = true
					Timer.reset(scrollTimer)
				end
				if (Timer.getTime(scrollTimer) > scrollDelay and isScrolling) or not Controls.check(oldpad, KEY_DUP) then
					Timer.reset(scrollTimer)
					selectedCIA = selectedCIA - 1
					selection = selection - 1
					if (selectedCIA < 1) then
						selectedCIA = #parsedApplist
						if #parsedApplist < screenHeightVar then
							selection = #parsedApplist
						else
							selection = screenHeightVar
						end
						menuOffset = #parsedApplist - screenHeightVar
					end
					if selection < 1 then
						selection = 1
						menuOffset = menuOffset - 1
					end
				end
			elseif Controls.check(pad, KEY_DRIGHT) and not Controls.check(oldpad, KEY_DRIGHT) then
				selectedCIA = selectedCIA + config.leftRightJump.value
				selection = selection + config.leftRightJump.value
				if (selectedCIA > #parsedApplist) then
					selectedCIA = 1
					menuOffset = 0
					selection = 1
				end
				if selection > screenHeightVar then
					menuOffset = menuOffset + (selection - screenHeightVar)
					selection = screenHeightVar
				end
			elseif Controls.check(pad, KEY_DLEFT) and not Controls.check(oldpad, KEY_DLEFT) then
				selectedCIA = selectedCIA - config.leftRightJump.value
				selection = selection - config.leftRightJump.value
				if (selectedCIA < 1) then
					selectedCIA = #parsedApplist
					selection = screenHeightVar
					menuOffset = #parsedApplist - screenHeightVar
				end
				if selection < 1 then
					menuOffset = menuOffset + (selection - 1)
					if menuOffset < 0 then
						menuOffset = 0
					end
					selection = 1
				end
			elseif Controls.check(pad, KEY_L) and not Controls.check(oldpad, KEY_L) then
				sortMode = sortMode - 1
				if sortMode < 1 then sortMode = #sortModes end
				sortAppList()
			elseif Controls.check(pad, KEY_R) and not Controls.check(oldpad, KEY_R) then
				sortMode = sortMode + 1
				if sortMode > #sortModes then sortMode = 1 end
				sortAppList()
			elseif Controls.check(pad, KEY_A) and not Controls.check(oldpad, KEY_A) then
				oldpad = pad
				downloadAndInstall(parsedApplist[selectedCIA].titleid)
			elseif Controls.check(pad, KEY_X) and not Controls.check(oldpad, KEY_X) and getInstalledState(parsedApplist[selectedCIA].titleid) ~= INSTALLED_STATE.NOT_INSTALLED and System.checkBuild() == 1 then
				oldpad = pad
				launchByTitleId(parsedApplist[selectedCIA].titleid)
			elseif Controls.check(pad, KEY_Y) and not Controls.check(oldpad, KEY_Y) then
				drawQRToTopScreen(parsedApplist[selectedCIA].titleid)
			elseif Controls.check(pad, KEY_START) and not Controls.check(oldpad, KEY_START) then
				oldpad = pad
				menu()
			elseif Controls.check(pad, KEY_SELECT) and not Controls.check(oldpad, KEY_SELECT) then
				System.exit()
			elseif Controls.check(pad, KEY_HOME) and System.checkBuild() ~= 1 then
				System.exit()
			elseif Controls.check(pad, KEY_HOME) and System.checkBuild() == 1 then
				System.showHomeMenu()
			else
				isScrolling = false
				Timer.reset(scrollTimer)
			end
		else
			if Controls.check(pad, KEY_L) and not Controls.check(oldpad, KEY_L) then
				sortMode = sortMode - 1
				if sortMode < 1 then sortMode = #sortModes end
				sortAppList()
			elseif Controls.check(pad, KEY_R) and not Controls.check(oldpad, KEY_R) then
				sortMode = sortMode + 1
				if sortMode > #sortModes then sortMode = 1 end
				sortAppList()
			elseif Controls.check(pad, KEY_START) and not Controls.check(oldpad, KEY_START) then
				oldpad = pad
				menu()
			elseif Controls.check(pad, KEY_SELECT) and not Controls.check(oldpad, KEY_SELECT) then
				System.exit()
			elseif Controls.check(pad, KEY_HOME) and System.checkBuild() ~= 1 then
				System.exit()
			elseif Controls.check(pad, KEY_HOME) and System.checkBuild() == 1 then
				System.showHomeMenu()
			end
		end
		checkForExit()
		oldpad = pad
		main()
	end
end

function init()
	Screen.refresh()
	Screen.clear(TOP_SCREEN)
	Screen.clear(BOTTOM_SCREEN)
	Screen.waitVblankStart()
	Screen.flip()
	
	local line = 5
	Screen.debugPrint(5, line, "Initialising Homebr3w, please wait...", WHITE, TOP_SCREEN)
	
	line = 20
	Screen.debugPrint(5, line, "Checking Wi-Fi...", WHITE, TOP_SCREEN)
	checkWifi()
	Screen.debugPrint(270, line, "[OK]", GREEN, TOP_SCREEN)
	
	line = 35
	Screen.debugPrint(5, line, "Checking Libraries...", WHITE, TOP_SCREEN)
	checkLibraries()
	for k,v in pairs(REQUIRED_LIBRARIES) do
		libraries[v.name] = dofile(APP_LIBS_DIR.."/"..v.filename)
	end
	Screen.debugPrint(270, line, "[OK]", GREEN, TOP_SCREEN)
	
	line = 50
	Screen.debugPrint(5, line, "Loading config...", WHITE, TOP_SCREEN)
	if loadConfig() then
		config_backup = deepcopy(config)
		sortMode = config.defaultSortMode.value
		Screen.debugPrint(270, line, "[OK]", GREEN, TOP_SCREEN)
	else
		Screen.debugPrint(270, line, "[FAILED]", RED, TOP_SCREEN)
	end
	
	line = 65
	Screen.debugPrint(5, line, "Retrieving Applist...", WHITE, TOP_SCREEN)
	local tries = 0
	local success, tbl = false, {}
	while (tries < config.downloadRetryCount.value) and (not success) do
		tries = tries + 1
		success, tbl = getJSON(API_URL.."v0/")
	end
	
	if not success then
		showError("Error occured while fetching remote data\nPress A to try again\nPress B to return to "..home..".", function()
			pad = Controls.read()
			if Controls.check(pad, KEY_A) and not Controls.check(oldpad, KEY_A) then
				init()
			elseif Controls.check(pad, KEY_B) and not Controls.check(oldpad, KEY_B) then
				System.exit()
			end
			oldpad = pad
		end)
	end
	parsedApplist = tbl
	Screen.debugPrint(270, line, "[OK]", GREEN, TOP_SCREEN)
	
	line = 80
	Screen.debugPrint(5, line, "Retrieving Homebr3w info...", WHITE, TOP_SCREEN)
	tries = 0
	success, tbl = false, {}
	while (tries < config.downloadRetryCount.value) and (not success) do
		tries = tries + 1
		success, tbl = getJSON("https://raw.githubusercontent.com/Wolvan/Homebr3w/master/data/blacklist.json")
	end
	
	if not success then
		blacklistedApps = nil
		Screen.debugPrint(270, line, "[FAILED]", RED, TOP_SCREEN)
	else
		blacklistedApps = tbl.blacklisted
		saveTable(APP_DIR.."/blacklist.json", blacklistedApps)
		Screen.debugPrint(270, line, "[OK]", GREEN, TOP_SCREEN)
	end
	
	line = 95
	Screen.debugPrint(5, line, "Checking for Updates...", WHITE, TOP_SCREEN)
	if config.enableUpdateCheck.value then
		tries = 0
		success, tbl = false, {}
		while (tries < config.downloadRetryCount.value) and (not success) do
			tries = tries + 1
			success, tbl = getJSON("https://api.github.com/repos/Wolvan/Homebr3w/releases/latest")
		end
		
		if not success then
			Screen.debugPrint(270, line, "[FAILED]", RED, TOP_SCREEN)
		else
			locVer = parseVersion(APP_VERSION)
			remVer = parseVersion(tbl.tag_name)
			canUpdate = isUpdateAvailable(locVer, remVer)
			Screen.debugPrint(270, line, "[OK]", GREEN, TOP_SCREEN)
		end
	else
		Screen.debugPrint(270, line, "[SKIPPED]", YELLOW, TOP_SCREEN)
	end
	
	line = 110
	Screen.debugPrint(5, line, "Checking cache...", WHITE, TOP_SCREEN)
	checkCache(parsedApplist)
	if not blacklistedApps then
		local loadedBlacklist = loadTable(APP_DIR.."/blacklist.json", {})
		if loadedBlacklist then blacklistedApps = loadedBlacklist 
		else blacklistedApps = {} end
	end
	mtimeCache = loadTable(APP_DIR.."/mtime.json", {}) or {}
	Screen.debugPrint(270, line, "[OK]", GREEN, TOP_SCREEN)
	
	line = 125
	Screen.debugPrint(5, line, "Checking installed CIAs...", WHITE, TOP_SCREEN)
	installed = checkInstalled()
	Screen.debugPrint(270, line, "[OK]", GREEN, TOP_SCREEN)
	
	line = 140
	Screen.debugPrint(5, line, "Finishing init process...", WHITE, TOP_SCREEN)
	parsedApplist = table.filter(parsedApplist, function (item)
		for k,v in pairs(blacklistedApps) do
			if item.titleid == v then
				return false
			end
		end
		return true
	end)
	if not parsedApplist[1] then table.remove(parsedApplist, 1) end
	fullApplist = deepcopy(parsedApplist)
	sortAppList()
	Screen.debugPrint(270, line, "[OK]", GREEN, TOP_SCREEN)
	
	Screen.clear(TOP_SCREEN)
	Screen.clear(BOTTOM_SCREEN)
	main()
end

-- END MAIN PROGRAM CODE
init()
