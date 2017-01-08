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
