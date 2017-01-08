--TODO: DELET THIS

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
	Homebr3w Bootstrap Test

	This file is purely there to test the bootstrap code
	from index.lua and will be removed in the release
]]


--[[
	Poor Man's Breakpoint
	This function makes debugging a lot easier
	since this can be used as a makeshift
	breakpoint to halt execution anywhere in the
	Script
]]--
function STOP()
	while true do
		pad = Controls.read()
		if Controls.check(pad, KEY_A) and not Controls.check(oldpad, KEY_A) then
			System.exit()
		end
		oldpad = pad
	end
end

--[[
	This function just presents an error to
	the user. Overriding the keypressFunction
	allows changing behavior of the error
]]--
function showError(errorMsg, keypressFunction)
	keypressFunction = keypressFunction or function()
		pad = Controls.read()
		if Controls.check(pad, KEY_A) and not Controls.check(oldpad, KEY_A) then
			Screen.waitVblankStart()
			Screen.flip()
			System.exit()
		end
		oldpad = pad
	end
	Screen.refresh()
	Screen.clear(TOP_SCREEN)
	Screen.clear(BOTTOM_SCREEN)
	Screen.waitVblankStart()
	Screen.flip()
	local splitString = errorMsg:split("\n")
	for k,v in pairs(splitString) do
		Screen.debugPrint(5, ((k-1)*15)+5, v, Color.new(255,0,0), TOP_SCREEN)
	end
	Screen.debugPrint(5, 95, "GitHub can be found at", Color.new(255,255,255), BOTTOM_SCREEN)
	Screen.debugPrint(5, 110, "https://github.com/Wolvan", Color.new(255,255,255), BOTTOM_SCREEN)
	Screen.debugPrint(5, 125, "/Homebr3w", Color.new(255,255,255), BOTTOM_SCREEN)
	while true do
		keypressFunction()
	end
end

showError("Test 1 2 3")
STOP()
