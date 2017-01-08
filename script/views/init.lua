--[[
	Homebr3w

	A Homebrew Application to download other Homebrew
	Apps based on TitleDB.com's database

	Copyright (c) Wolvan

	All rights reserved. Licensed under the MIT license.
	See LICENSE in the project root for license information.

	Source available at https://github.com/Wolvan/Homebr3w
]]--

initLine = 5

View:new({
	id = "init",
	name = "Init",
	renderTop = function () end,
	renderBottom = function () end,
	init = function (self)
		Screen.refresh()
		Screen.clear(TOP_SCREEN)
		Screen.clear(BOTTOM_SCREEN)
		Screen.waitVblankStart()
		Screen.flip()

		Screen.debugPrint(5, initLine, "Initialising Homebr3w, please wait...", TEXT_COLORS.WHITE, TOP_SCREEN)

		-- Migrate Homebr3w Data Dir
		System.createDirectory("/3ds")
		System.createDirectory("/3ds/data")
		System.renameDirectory("/Homebr3w", APP_DIR)

		initLine = 20
		Screen.debugPrint(5, initLine, "Checking Wi-Fi...", TEXT_COLORS.WHITE, TOP_SCREEN)
		utils.checkWifi()
		Screen.debugPrint(270, initLine, "[OK]", TEXT_COLORS.GREEN, TOP_SCREEN)

		initLine = 35
		Screen.debugPrint(5, initLine, "Loading Libraries...", TEXT_COLORS.WHITE, TOP_SCREEN)
		libloader.doQueue()
		Screen.debugPrint(270, initLine, "[OK]", TEXT_COLORS.GREEN, TOP_SCREEN)

		initLine = 50
		Screen.debugPrint(5, initLine, "Loading config...", TEXT_COLORS.WHITE, TOP_SCREEN)
		if loadConfig() then
			Screen.debugPrint(270, initLine, "[OK]", TEXT_COLORS.GREEN, TOP_SCREEN)
		else
			Screen.debugPrint(270, initLine, "[FAILED]", TEXT_COLORS.RED, TOP_SCREEN)
		end

		initLine = 65
		Screen.debugPrint(5, initLine, "Checking for Updates...", TEXT_COLORS.WHITE, TOP_SCREEN)
		if config.enableUpdateCheck.value then
			if not updater.checkForUpdate() then
				Screen.debugPrint(270, initLine, "[FAILED]", TEXT_COLORS.RED, TOP_SCREEN)
			else
				Screen.debugPrint(270, initLine, "[OK]", TEXT_COLORS.GREEN, TOP_SCREEN)
			end
		else
			Screen.debugPrint(270, initLine, "[SKIPPED]", TEXT_COLORS.YELLOW, TOP_SCREEN)
		end

		STOP()
	end
})