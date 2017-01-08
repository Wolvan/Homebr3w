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
    This file's purpose is defining certain constants that
    are later used around the program. Centralization is nice.
]]--

-- App related constants
APP_VERSION = "1.4.0"
APP_DIR = "/3ds/data/Homebr3w"
APP_CACHE = APP_DIR.."/Cache"
APP_CONFIG = APP_DIR.."/config.json"
APP_LIBS_DIR = APP_DIR.."/Libraries"
APP_TEMP_DIR = APP_DIR.."/tmp"

-- Text Colors that can be passed to Lua Player Plus' Draw functions
TEXT_COLORS = {
    WHITE = Color.new(255,255,255),
    YELLOW = Color.new(255,205,66),
    RED = Color.new(255,0,0),
    GREEN = Color.new(55,255,0),
    BLUE = Color.new(70,50,250)
}

-- ENUM for installed state
INSTALLED_STATE = {
	NOT_INSTALLED = 8,
	LATEST_VERSION = 4,
	OUTDATED_VERSION = 1,
	VERSION_UNKNOWN = 2
}

-- ENUM for App build type
BUILDS = {
    UNKNOWN = 0,
    NINJHAX1 = 1,
    NINJHAX2 = 2,
    CIA = 4
}

-- Current build type
BUILD = System.checkBuild()
if BUILD == 0 then
    BUILD = BUILDS.NINJHAX1
elseif BUILD == 1 then
    BUILD = BUILDS.CIA
elseif BUILD == 2 then
    BUILD = BUILDS.NINJHAX2
else
    BUILD = BUILDS.UNKNOWN
end

--User agent that is being used for HTTP requests
USERAGENT = "Connection: keep-alive\nUser-Agent: Homebr3w/"..APP_VERSION
