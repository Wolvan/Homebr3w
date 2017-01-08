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
		filepath = System.currentDirectory().."views/"..filepath
	else
		filepath = "romfs:/views/"..filepath
	end
    dofile(filepath)
end

local VIEWS = {
    "hbcias.lua"
}

for k,v in pairs(VIEWS) do
    lScript(v)
end
