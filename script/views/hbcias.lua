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
    Adapter to display TitleDB.com CIA database
    on the screen.
]]--

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
	},
	{
		text = "Newest updates first",
		sortFunction = function(a, b)
			local lastUpdated_a = a.create_time
			if a.update_time then lastUpdated_a = a.update_time end
			local lastUpdated_b = b.create_time
			if b.update_time then lastUpdated_b = b.update_time end
			return lastUpdated_a > lastUpdated_b
		end
	},
	{
		text = "Newest updates last",
		sortFunction = function(a, b)
			local lastUpdated_a = a.create_time
			if a.update_time then lastUpdated_a = a.update_time end
			local lastUpdated_b = b.create_time
			if b.update_time then lastUpdated_b = b.update_time end
			return lastUpdated_a < lastUpdated_b
		end
	}
}

--[[
    Register adapter config in the config object here
]]--
config.defaultSortMode = {
    text = "Default sorting mode",
    value = 3,
    minValue = 1,
    maxValue = #sortModes
}
config.leftRightJump = {
    text = "Left/Right Jump",
    value = 10,
    minValue = 1,
    maxValue = 15
}
config.groupInstalledApps = {
    text = "Group installed apps",
    value = true
}
config.deleteCIAAfterInstall = {
    text = "Delete CIA after install",
    value = true
}
config.hideUninstallWarning = {
    text = "Skip warning before uninstall",
    value = false
}
