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
	Homebr3w Bootstrap

	This file is responsible to bootstrap Homebr3w and
	load all required files to be usable
]]--

local function lScript(filepath)
    if System.checkBuild() ~= 1 then
		filepath = System.currentDirectory()..filepath
	else
		filepath = "romfs:/"..filepath
	end
    dofile(filepath)
end

local SCRIPTS_TO_LOAD = {
	"polyfills/string.lua",
	"polyfills/table.lua",
	"constants.lua",
	"default_config.lua",
	"modules/utils.lua",
	"modules/libloader.lua",
	"modules/updater.lua",
	"adapters/adapters.lua",
    "views/views.lua"
}

for k,v in pairs(SCRIPTS_TO_LOAD) do
	lScript(v)
end

showError("Work in progress!\nStill working on modularizing,\nplease be patient.")
