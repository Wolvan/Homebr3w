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
    Module to download lua libraries from the internet
    Shipping with them is not always ideal and this makes
    for a nice way of loading them
]]--

--[[
    An enum for the type of library that is getting downloaded
    Defines how the file is processed after loading it from the
    internet
]]--
LIB_TYPES = {
	LIBRARY = 1,
	ZIP_ARCHIVE = 2
}

--[[
    The libraries table is used as a mountpoint for all the downloaded
    libraries
]]--
libraries = {}

--[[
	Format that gets passed to library loader functions is as follows:
	Both types share the following key/value pairs:
		name			--Defines the name/mountpoint the library is going to be available as later. Also gets shown when downloading library
		filename		--Name the file will be saved as under APP_DIR/Libraries. Can be any name
		downloadPath	--The URL the library's package will be downloaded from
		type			--The type of library that can be used. Can either be LIB_TYPES.LIBRARY for unzipped or LIB_TYPES.ZIP_ARCHIVE for zipped libraries
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

local queue = {}

local function getLib(lib)
    System.createDirectory(APP_DIR)
    System.createDirectory(APP_LIBS_DIR)
    local path = APP_LIBS_DIR.."/"..lib.filename
    if lib.type == LIB_TYPES.ARCHIVE then
        System.createDirectory(APP_TEMP_DIR)
        path = APP_TEMP_DIR.."/"..lib.filename..".zip"
    end
    local downloadURL = lib.downloadPath
    local success = utils.getFile(path, downloadURL)
    local tries = 0
    while (tries < config.downloadRetryCount.value) and (not success) do
        success = utils.getFile(path, downloadURL)
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

function loadLib(lib, dontCrashOnFail)
    if not System.doesFileExist(APP_LIBS_DIR.."/"..lib.filename) then
        if not getLib(lib) then
            if dontCrashOnFail then return false end
            showError("Failed to download library!\nUnable to continue, please\ntry restarting the app and\ntry again.\n \nPress A to go back to "..home..".", function()
                pad = Controls.read()
                if Controls.check(pad, KEY_A) and not Controls.check(oldpad, KEY_A) then
                    System.exit()
                end
                oldpad = pad
            end)
        end
    end
    libraries[lib.name] = dofile(APP_LIBS_DIR.."/"..lib.filename)
    return true
end

function queueLib(lib, dontCrashOnFail)
    table.insert(queue, {
        library = lib,
        dontCrash = dontCrashOnFail
    })
end

function doQueue()
    for k,v in pairs(queue) do
        loadLib(v.library, v.dontCrash)
    end
    queue = {}
end
