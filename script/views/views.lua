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
    This file is responsible for loading all the views
    and managing them
]]--

local Views = {}
local currentlyActiveView = ""
local lastActiveView = ""

View = {
    __type = "View",
    new = function (self, o) --Create Instance function. Override this in your custom menu instance only if necessary.
        o = o or {
            id = "unknown"
        }
        if Views[o.id] then
            return nil, "View is already defined"
        end
        setmetatable(o, self)
        self.__index = self
        Views[o.id] = o
        return o
    end,
    name = "Unknown view",
    listInViews = true,

    shutdown = function (self)
        -- Dummy shutdown function that should be overwritten when defining an adapter
    end,
    init = function (self, prevView)
        -- Dummy init function that should be overwritten when defining an adapter
    end,

    renderBottom = function (self)
        Screen.debugPrint(5, 205, "Default View Output", TEXT_COLORS.WHITE, BOTTOM_SCREEN)
        Screen.debugPrint(5, 220, "Override renderBottom", TEXT_COLORS.WHITE, BOTTOM_SCREEN)
    end,
    renderTop = function (self)
        Screen.debugPrint(5, 5, "Default View Output", TEXT_COLORS.WHITE, BOTTOM_SCREEN)
        Screen.debugPrint(5, 20, "Override renderBottom", TEXT_COLORS.WHITE, BOTTOM_SCREEN)
    end,
    keyPress = function (self, pad, oldPad)
        -- Dummy keyPress function
    end,

    destroy = function (self)
        currentlyActiveView = lastActiveView
        Adapters[self.id] = nil
    end
}

local function changeView (adpt)
    if not Views[adpt] then
        return false
    end
    if Views[currentlyActiveView] then Views[currentlyActiveView]:shutdown() end
    lastActiveView = currentlyActiveView
    currentlyActiveView = adpt
    Views[currentlyActiveView]:init(lastActiveView)
    return true
end
local function listFullViews ()
    local t = {}
    for k,v in pairs(Adapters) do
        t.insert(k)
    end
    return t
end
local function listViews ()
    local t = {}
    for k,v in pairs(Adapters) do
        if v.listInViews then t.insert(k) end
    end
    return t
end

views = {}
views.listViews = listViews
views.listFullViews = listFullViews
views.changeView = changeView

local function lScript (filepath)
    if BUILD ~= BUILDS.CIA then
		filepath = System.currentDirectory().."views/"..filepath
	else
		filepath = "romfs:/views/"..filepath
	end
    dofile(filepath)
end

local VIEWS = {
    "init.lua",
    "hbcias.lua"
}

for k,v in pairs(VIEWS) do
    lScript(v)
end
