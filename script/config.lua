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
    The default config that gets loaded and later overwritten
    when the config is loaded from SD
]]--

config = {
	enableUpdateCheck = {
		text = "Enable Update Check",
		value = true
	},
	downloadRetryCount = {
		text = "Download Retries",
		value = 3,
		minValue = 1,
		maxValue = 10
	},
	enableAnalytics = {
		text = "Enable analytics",
		value = true
	}
}

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
	utils.saveTable(APP_CONFIG, config)
end
function loadConfig()
	local loaded_config = utils.loadTable(APP_CONFIG, config)
	if type(loaded_config) == "table" then
		for k,v in pairs(loaded_config) do
			config[k] = v
		end
	else
		return false
	end
	return true
end
