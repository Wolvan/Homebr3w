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

local Adapters = {}

Adapter = {
    __type = "Adapter",
    new = function (self, o) --Create Instance function. Override this in your custom menu instance only if necessary.
        o = o or {
            id = "unknown"
        }
        if Adapters[o.id] then
            return nil, "Adapter is already defined"
        end
        setmetatable(o, self)
        self.__index = self
        Adapters[o.id] = o
        return o
    end,
    name = "Unknown adapter",
    shutdown = function (self)
        -- Dummy shutdown function that should be overwritten when defining an adapter
    end,
    init = function (self)
        -- Dummy init function that should be overwritten when defining an adapter
    end,
    destroy = function (self)
        currentlyActiveAdapter = lastActiveAdapter
        Adapters[self.id] = nil
    end
}

local function listAdapters ()
    local t = {}
    for k,v in pairs(Adapters) do
        t.insert(k)
    end
    return t
end

local function getAdapter (adpt)
    if Adapters[adpt] then return Adapters[adpt] else return nil end
end

adapters = {}
adapters.listAdapters = listAdapters
adapters.getAdapter = getAdapter

local function lScript (filepath)
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
