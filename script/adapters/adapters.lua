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
    This file is responsible for loading all the view
    and download adapters
]]--

local function lScript(filepath)
    if BUILD ~= BUILDS.CIA then
		filepath = System.currentDirectory().."adapters/"..filepath
	else
		filepath = "romfs:/adapters/"..filepath
	end
    dofile(filepath)
end

local DOWNLOAD_ADAPTERS = {
    "hbcias.lua"
}

for k,v in pairs(DOWNLOAD_ADAPTERS) do
    lScript(v)
end
